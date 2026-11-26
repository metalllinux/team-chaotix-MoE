#!/usr/bin/env bash
# selftest -- the team's local and CI test entry point.
#
# Everything here is deterministic: no model is invoked, nothing is pushed,
# nothing outside the checkout is touched (pytest uses temp dirs). Run it
# locally before pushing; CI runs the same script.
#
# Exit non-zero on the first failure. Prints a check count on success;
# the CI workflow asserts a minimum so a suite that stopped asserting
# cannot read as green.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"
CHECKS=0
PASS() { CHECKS=$((CHECKS+1)); }

# Minimum meaningful assertion count, the single home of the selftest floor
# (TASK-0042 R3 harness fix; scripts/hooks/pre-push and the Team Selftest CI
# job both read this constant rather than carrying their own). The suite is
# 122 fixed PASS asserts plus the pytest count (29 at the 2026-11-26 baseline,
# total 151 after the TASK-0042 dispatch B2; the chain is 106 before the gate fix
# f1907ab, 110 after it, 120 after the certificate-pin commit b56be2b, 122 after
# T8 70aa1dd, 137 after TF1 625ce8a, 151 after B2). B2 adds 14 asserts, 4 of them
# the completed-borrow path TF1 named as proved by construction and not by
# control, 10 of them the licence and README wording gate that C2, TF3 and D2 each
# named as missing. B2 raises the floor from 100 to 140. A floor 47 checks below
# the real count is a collapse detector for a whole block only: it absorbs the
# quiet loss of any single section (the skill block is 5 asserts, the dry-run block
# 4, the credential scan 2). 140 leaves 11 checks of slack for the asserts that are
# genuinely machine-conditional, 3 dispatch-gate real-read asserts when the
# session store has no assistant rows, 1 gateway selftest when the agentgateway
# binary is absent, plus pytest deselection. The guarded remote-build block is
# NOT inside that slack: it hard-fails when gcc or freerdp-client3 is absent
# (Big T3 finding 1, closed by K9). shellcheck, when present, only adds checks.
MIN_CHECKS=140

note() { printf 'selftest: %s\n' "$*"; }
fail() { printf 'selftest FAIL: %s\n' "$*" >&2; exit 1; }

# --- syntax gates (by shebang, not by extension) -------------------------
for f in $(find scripts team tests -type f | sort); do
  first="$(head -1 "$f")"
  case "$first" in
    *"/bin/bash"* | *"/usr/bin/env bash"*)
      bash -n "$f" || fail "bash syntax: $f"
      PASS
      ;;
    *"/usr/bin/env python3"*)
      python3 -m py_compile "$f" || fail "python syntax: $f"
      PASS
      ;;
  esac
done
note "bash + python syntax OK"

# --- shellcheck (warn-only when absent; the runner may not have it) ------
if command -v shellcheck >/dev/null 2>&1; then
  for f in $(find scripts team tests -type f | sort); do
    case "$(head -1 "$f")" in
      *"/bin/bash"* | *"/usr/bin/env bash"*)
        shellcheck -S warning "$f" || fail "shellcheck: $f"
        PASS
        ;;
    esac
  done
  note "shellcheck OK"
else
  note "shellcheck absent, skipped"
fi

# --- YAML parse -----------------------------------------------------------
for f in $(find team .github planning \( -name "*.yml" -o -name "*.yaml" \) -not -path "*/node_modules/*" | sort) team/gateway/agentgateway.yaml.template; do
  python3 -c "import yaml,sys; yaml.safe_load(open('$f'))" || fail "yaml: $f"
  PASS
done
note "yaml OK"

# --- JSON parse -----------------------------------------------------------
for f in $(find team .github -name "*.json" -not -path "*/node_modules/*" | sort); do
  python3 -m json.tool "$f" > /dev/null || fail "json: $f"
  PASS
done
note "json OK"

# --- the no-turn-caps rule ------------------------------------------------
# The operator's standing requirement: the max-turns key does not exist on
# this team. If the string shows up in tracked source, that is a
# regression. The pattern is written [m]axTurns so this file does not
# match itself, and the gate files build the key by concatenation.
if grep -rIl "[m]axTurns\|[m]ax_turns" team scripts tests .github AGENTS.md \
    .opencode/agents planning/templates 2>/dev/null; then
  fail "turn caps found in team source (no-turn-caps rule)"
fi
PASS
note "no turn caps OK"

# --- agent roster -----------------------------------------------------------
# Eleven agent files: the delegator plus ten workers. The licence agent that
# used to sit fifth was retired on 2026-11-23, and its name is built here by
# concatenation (the same trick as the [m]axTurns pattern above) so the file
# does not match a plain text sweep for the retired name.
AGENT_FILES=$(find .opencode/agents -maxdepth 1 -name "*.md" | wc -l)
if [ "${AGENT_FILES}" -ne 11 ]; then
  fail "agent roster is ${AGENT_FILES} files, expected 11"
fi
PASS
if [ -e ".opencode/agents/fli""cky.md" ]; then
  fail "retired licence agent file is back in .opencode/agents"
fi
PASS
note "agent roster OK (${AGENT_FILES} agent files)"

# --- agent configuration gate ----------------------------------------------
python3 tests/config_gate.py || fail "config gate"
PASS
note "config gate OK"

# --- the test suite --------------------------------------------------------
if command -v pytest >/dev/null 2>&1; then
  PYTEST="pytest"
else
  PYTEST="python3 -m pytest"
fi
note "pytest"
SUITE_OUT="$($PYTEST tests/ -q 2>&1)" || { printf '%s\n' "$SUITE_OUT"; fail "pytest"; }
TESTS=$(printf '%s\n' "$SUITE_OUT" | grep -Eo '[0-9]+ passed' | grep -Eo '^[0-9]+' | head -1 || true)
CHECKS=$((CHECKS + ${TESTS:-0}))
note "pytest OK (${TESTS:-?} tests)"

# --- licence gate on this repo ---------------------------------------------
# The repo itself must pass its own gate (MIT root).
scripts/licence-check > /dev/null || fail "licence-check on this repo"
PASS
note "licence-check OK"

# --- dispatch gate (dispatcher context ceiling) ---------------------------
# A subagent dispatch is built on the dispatcher's own session context.
# TASK-0042 lost two dispatches to "request (262191 tokens) exceeds the
# available context size (262144 tokens)" while every brief was short, so the
# ceiling is checked here rather than rediscovered by a failed dispatch.
# TASK-0043 review-chain fix: the gate measures the cumulative in-flight prompt
# (--session required, no inherit ratio, no window, no jump term), and the real
# read assert treats exit 1 (crash) and exit 2 (broken store/usage) as failures
# and checks the verdict and the measured peak as data, so a toothless or blind
# gate can no longer run this suite green (Test Results FAIL 1, M3/M6).
[ -x scripts/dispatch-gate ] || fail "scripts/dispatch-gate missing or not executable"
PASS
scripts/dispatch-gate --help > /dev/null || fail "dispatch-gate --help"
PASS
scripts/dispatch-gate --dry-run > /dev/null || fail "dispatch-gate --dry-run"
PASS
note "dispatch-gate interface OK"

# Finding 2 negative control, this assert is its own control: a real read with
# no --session must be a usage error (exit 2), not a guess at the caller's
# session. A gate that still guesses returns a verdict, exit 0/3/4, and fails.
set +e
scripts/dispatch-gate --json > /dev/null 2>&1
DG_BARE_RC=$?
set -e
[ "${DG_BARE_RC}" -eq 2 ] || fail "dispatch-gate real read without --session must exit 2 (usage error), got ${DG_BARE_RC}"
PASS

# The real read is optional, the session store may not exist in CI.
if [ -f "${HOME}/.local/share/opencode/opencode.db" ]; then
  # Resolve a session id with assistant rows, read-only, so --session can be
  # passed explicitly (the form the fix requires; nothing here relies on the
  # gate selecting a session itself).
  DG_SESSION="$(python3 - <<'PY'
import os, sqlite3
con = sqlite3.connect(f"file:{os.path.expanduser('~/.local/share/opencode/opencode.db')}?mode=ro", uri=True)
row = con.execute("SELECT s.id FROM session_v2 s JOIN session_message m ON m.session_id=s.id AND m.type='assistant' GROUP BY s.id ORDER BY MAX(m.time_updated) DESC LIMIT 1").fetchone()
print(row[0] if row else "")
PY
)"
  if [ -n "${DG_SESSION}" ]; then
    set +e
    DG_OUT="$(scripts/dispatch-gate --session "${DG_SESSION}" --json 2>/dev/null)"
    DG_RC=$?
    set -e
    # Exit 0/3/4 are a working gate. 1 is an unhandled crash, 2 a broken store
    # or usage error: both fail here, which the old `-le 4` accepted.
    case "${DG_RC}" in
      0|3|4) PASS ;;
      *) fail "dispatch-gate real read returned ${DG_RC} (1 crash, 2 broken store or usage error)" ;;
    esac
    # The verdict is data, not noise, and the measured peak must equal an
    # independent read-only recomputation of the same quantity from the store.
    # A blind gate (reads zero) or a toothless one (verdict never BLOCK/WARN
    # against a peak above the line) trips one of these three asserts.
    set +e
    DG_JSON="${DG_OUT}" python3 - <<'PY'
import json, os, sqlite3, sys
out = json.loads(os.environ["DG_JSON"])
sid = out["session_id"]
db = os.path.expanduser("~/.local/share/opencode/opencode.db")
con = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
peak = 0
for (raw,) in con.execute("SELECT data FROM session_message WHERE session_id=? AND type='assistant'", (sid,)):
    try:
        d = json.loads(raw or "{}")
    except (json.JSONDecodeError, TypeError):
        continue
    t = d.get("tokens") or {}
    c = t.get("cache") or {}
    try:
        p = int(t.get("input") or 0) + int(c.get("read") or 0) + int(c.get("write") or 0)
    except (TypeError, ValueError):
        continue
    peak = max(peak, p)
if out["peak_prompt"] != peak:
    print(f"peak_prompt {out['peak_prompt']} != store recomputation {peak}", file=sys.stderr)
    sys.exit(1)
v, warn_at, block_at = out["verdict"], out["warn_at"], out["block_at"]
if peak >= block_at and v != "BLOCK":
    print(f"verdict {v} with peak {peak} >= block_at {block_at} must be BLOCK", file=sys.stderr)
    sys.exit(1)
if warn_at <= peak < block_at and v not in ("WARN", "BLOCK"):
    print(f"verdict {v} with peak {peak} >= warn_at {warn_at} must be WARN or BLOCK", file=sys.stderr)
    sys.exit(1)
if v not in ("PASS", "WARN", "BLOCK"):
    print(f"verdict {v} is not a working verdict", file=sys.stderr)
    sys.exit(1)
PY
    DG_XC_RC=$?
    set -e
    if [ "${DG_XC_RC}" -eq 0 ]; then
      PASS
      PASS
      PASS
      note "dispatch-gate real read OK (exit ${DG_RC}, verdict $(printf '%s' "${DG_OUT}" | python3 -c 'import json,sys; print(json.load(sys.stdin)["verdict"])'), peak cross-checked against the store)"
    else
      fail "dispatch-gate verdict/peak cross-check failed against an independent store recomputation"
    fi
  else
    note "session store has no assistant rows, dispatch-gate real read skipped"
  fi
else
  note "no session store, dispatch-gate real read skipped"
fi

# --- gateway selftest (boot the real binary on ephemeral ports) ------------
# The template must not merely parse: the gateway has to boot with it.
# Skipped when the binary is absent (same rule as shellcheck above).
if [ -x "${AGENTGATEWAY_BIN:-/usr/local/bin/agentgateway}" ]; then
  GW_OUT="$(bash team/gateway/gateway.sh selftest 2>&1)" || { printf '%s\n' "$GW_OUT"; fail "gateway selftest"; }
  PASS
  note "gateway selftest OK"
else
  note "agentgateway binary absent, gateway selftest skipped"
fi

# --- remote visual-control tooling (TASK-0041 items 9 to 11) --------------
# All asserts here run with the target offline: no target contact, no
# credential read. Dry runs only print the commands the real run would use,
# with a <host> placeholder in place of any host.
RT="scripts/remote"
RT_TOOLS=(rt-shot rt-ocr rt-type rt-key rt-click rt-status rt-uinput rt-build rt-tunnel)

# The packaged inventory: every helper plus the shared lib, the licence
# record referenced by rt-build, and the target-side injector source.
for f in "${RT_TOOLS[@]}" rt-lib NOTICE uinput-inject.c; do
  [ -f "$RT/$f" ] || fail "scripts/remote/$f missing"
done
PASS
note "scripts/remote inventory OK"

# Every callable tool is executable (git keeps the mode bit).
for f in "${RT_TOOLS[@]}"; do
  [ -x "$RT/$f" ] || fail "scripts/remote/$f is not executable"
done
PASS
note "scripts/remote executable bits OK"

# Every tool documents the shared options, including --dry-run, on --help.
# Output is captured first: under pipefail a grep -q that exits early would
# otherwise kill the tool with SIGPIPE and read as a failure.
for f in "${RT_TOOLS[@]}"; do
  rt_help="$("$RT/$f" --help)"
  printf '%s\n' "$rt_help" | grep -q -- '--dry-run' || fail "scripts/remote/$f --help lacks --dry-run"
  PASS
done
note "scripts/remote --help OK"

# Dry runs are verified independently of the tool's own claim (T8, closing Big
# T3 finding 4: four of six dry-run asserts relied on `grep -qi 'dry run'`, a
# line every tool prints unconditionally). Two independent checks per probe:
#   1. Credential tripwire. RT_SSH_PASS_FILE and RT_RDP_PASS_FILE point at
#      paths that do not exist. A real run, or a "dry run" that secretly dials
#      out, reaches rt_require_secret_file or sshpass and exits non-zero; only
#      a path that reads no credential and contacts no host exits 0 with both
#      files absent.
#   2. Real-host token scan. No dry-run output may name the demo target
#      192.168.1.99. Big T3 ran that scan by hand over seven outputs and found
#      zero hits; this makes the scan a permanent assert over every probe, not
#      the two that carried it.
# The <host> placeholder assert stays for every tool that prints an ssh line.
RT_TMP="$(mktemp -d)"
trap 'rm -rf "$RT_TMP"' EXIT
RT_NO_SSH_PASS="$RT_TMP/no-ssh-credential"     # deliberately nonexistent
RT_NO_RDP_PASS="$RT_TMP/no-rdp-credential"     # deliberately nonexistent
RT_DEMO_HOST='192\.168\.1\.99'
# B2 adds a second, address-independent version of the same guard. The token scan above only has teeth
# while the demo target keeps the address 192.168.1.99, and `Big`'s own T3 read named a re-addressed
# venue target as the first thing to fail on 2026-11-28. The guard below has teeth whatever the address
# is: a dry run may print the loopback end of its own forward and nothing that looks routable. Folded
# into each probe rather than counted separately, so a probe stays one ledger line and a stronger check.
rt_only_loopback_ips() { # $1 probe name, $2 the output to scan
  local found
  found="$(grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' <<< "$2" | sort -u \
           | grep -vE '^(127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|0\.0\.0\.0)$' || true)"
  [ -z "$found" ] || fail "dry run of $1 names a routable IPv4 address in its output: ${found}"
}
for probe in "rt-shot --dry-run" "rt-status --dry-run" "rt-tunnel --dry-run start"; do
  out="$(RT_SSH_PASS_FILE="$RT_NO_SSH_PASS" RT_RDP_PASS_FILE="$RT_NO_RDP_PASS" $RT/$probe 2>&1)" \
    || fail "dry run of $probe exits non-zero with both credential files absent, so it reads a credential or contacts the host"
  if grep -q "$RT_DEMO_HOST" <<< "$out"; then fail "dry run of $probe names the real demo target host in its output"; fi
  rt_only_loopback_ips "$probe" "$out"
  grep -q '<host>' <<< "$out" || fail "dry run of $probe used a real host instead of the placeholder"
  PASS
done
# rt-ocr never contacts a target: its dry run must print the local OCR command
# and nothing remote, under the same credential tripwire as every other tool.
out="$(RT_SSH_PASS_FILE="$RT_NO_SSH_PASS" RT_RDP_PASS_FILE="$RT_NO_RDP_PASS" $RT/rt-ocr --dry-run "$RT_TMP/absent.png" 2>&1)" \
  || fail "dry run of rt-ocr exits non-zero with both credential files absent"
if grep -q "$RT_DEMO_HOST" <<< "$out"; then fail "dry run of rt-ocr names the real demo target host in its output"; fi
rt_only_loopback_ips "rt-ocr" "$out"
if grep -qE 'sshpass|ssh |howard@' <<< "$out"; then fail "dry run of rt-ocr prints a remote command; rt-ocr never contacts a target"; fi
grep -q 'tesseract' <<< "$out" || fail "rt-ocr dry run does not print the local command it would run"
PASS
note "scripts/remote dry runs OK (target offline, credential tripwire, real-host token scan)"

# The capture path must wrap the tool proven accepted by gnome-shell 49,
# not a raw gdbus call (TASK-0042 DEMO-LOG 2026-11-20 01:40-02:10).
grep -q 'gnome-screenshot-tool' "$RT/rt-lib" || fail "rt-lib no longer defaults to gnome-screenshot-tool"
PASS

# The uinput wrapper carries the proven settle fact: events emitted in the
# same millisecond as UI_DEV_CREATE are dropped on the target (TASK-0042
# dispatch P1). T8 closes Big T3 finding 5. The old assert was
# `grep -Eq 'UI_DEV_CREATE|1800'`: a bare 1800 anywhere in the file satisfied
# it, and the settle sleep the wrapper documents was in fact absent from the
# helper. Three asserts now, each falsifiable on its own: the settle delay is
# a named 1800 ms constant, the constant is used in a sleep call, and that
# call sits between UI_DEV_CREATE and the first event emit.
grep -qE '^#define SETTLE_MS 1800$' "$RT/uinput-inject.c" \
  || fail "uinput-inject.c no longer names the settle delay SETTLE_MS 1800"
PASS
grep -q 'sleep_ms(SETTLE_MS)' "$RT/uinput-inject.c" \
  || fail "uinput-inject.c no longer sleeps SETTLE_MS before its first event"
PASS
SETTLE_LINE="$(grep -n 'sleep_ms(SETTLE_MS)' "$RT/uinput-inject.c" | head -1 | cut -d: -f1)"
CREATE_LINE="$(grep -n 'ioctl(fd, UI_DEV_CREATE)' "$RT/uinput-inject.c" | head -1 | cut -d: -f1)"
FIRST_EMIT_LINE="$(grep -n 'emit(fds\[' "$RT/uinput-inject.c" | head -1 | cut -d: -f1)"
if [ -z "$SETTLE_LINE" ] || [ -z "$CREATE_LINE" ] || [ -z "$FIRST_EMIT_LINE" ] \
   || [ "$CREATE_LINE" -ge "$SETTLE_LINE" ] || [ "$SETTLE_LINE" -ge "$FIRST_EMIT_LINE" ]; then
  fail "the SETTLE_MS sleep (line ${SETTLE_LINE:-none}) is not between UI_DEV_CREATE (line ${CREATE_LINE:-none}) and the first event emit (line ${FIRST_EMIT_LINE:-none})"
fi
PASS

# The real build compiles the three C tools offline into a scratch dir.
# Guarded like shellcheck above: skipped when the toolchain is absent.
if command -v gcc >/dev/null 2>&1 && pkg-config --exists freerdp-client3 2>/dev/null; then
  RT_BUILD_DIR="$RT_TMP" "$RT/rt-build" > /dev/null || fail "scripts/remote/rt-build failed"
  for bin in rdp-input rdp-pointer rt-uinput-inject; do
    [ -x "$RT_TMP/$bin" ] || fail "rt-build did not produce $bin"
  done
  PASS
  note "scripts/remote build OK (offline compile, scratch dir)"
  # Input-tool dry runs resolve their binaries through RT_BUILD_DIR, and are
  # verified the same independent way as the tools above: credential tripwire,
  # real-host token scan, and the named placeholder standing in for whatever
  # would otherwise have left this machine (T8; the old assert was
  # `grep -qi 'dry run'`).
  for probe in \
    "rt-type --dry-run --text CHAOTIX41" \
    "rt-key --dry-run --chord ctrl+t" \
    "rt-click --dry-run --click 960 14"; do
    out="$(RT_BUILD_DIR="$RT_TMP" RT_SSH_PASS_FILE="$RT_NO_SSH_PASS" RT_RDP_PASS_FILE="$RT_NO_RDP_PASS" $RT/$probe 2>&1)" \
      || fail "dry run of $probe exits non-zero with both credential files absent, so it reads a credential or contacts the host"
    if grep -q "$RT_DEMO_HOST" <<< "$out"; then fail "dry run of $probe names the real demo target host in its output"; fi
    rt_only_loopback_ips "$probe" "$out"
    grep -q '<rdp argument lines on stdin>' <<< "$out" \
      || fail "dry run of $probe prints live RDP argument lines instead of the named placeholder"
    PASS
  done
  out="$(RT_BUILD_DIR="$RT_TMP" RT_SSH_PASS_FILE="$RT_NO_SSH_PASS" RT_RDP_PASS_FILE="$RT_NO_RDP_PASS" $RT/rt-uinput --dry-run --probe 2>&1)" \
    || fail "dry run of rt-uinput exits non-zero with both credential files absent, so it reads a credential or contacts the host"
  if grep -q "$RT_DEMO_HOST" <<< "$out"; then fail "dry run of rt-uinput names the real demo target host in its output"; fi
  rt_only_loopback_ips "rt-uinput" "$out"
  grep -q '<host>' <<< "$out" || fail "dry run of rt-uinput used a real host instead of the placeholder"
  PASS
  note "scripts/remote input-tool dry runs OK (tripwire, host scan, placeholders)"
  # The C tools fopen argv[1] directly (scripts/rdp-input.c:202, scripts/rdp-pointer.c:83), so the
  # argument lines that arrive down a pipe have to be named as /dev/stdin. Dispatch T7 found the
  # packaged input tools passing `-`, which the tools cannot open, and found it only against the live
  # target because no offline assert covered it.
  for probe in \
    "rt-type --dry-run --text CHAOTIX41" \
    "rt-key --dry-run --chord ctrl+t" \
    "rt-click --dry-run --click 960 14"; do
    out="$(RT_BUILD_DIR="$RT_TMP" $RT/$probe 2>&1)" || fail "dry run failed: $probe"
    rt_only_loopback_ips "$probe (/dev/stdin form)" "$out"
    grep -q '/dev/stdin' <<< "$out" \
      || fail "$probe does not name an argument path the C tools can open"
    PASS
  done
  note "scripts/remote rdp argument plumbing OK (/dev/stdin)"
else
  fail "gcc or freerdp-client3 absent; the 5 remote-build asserts cannot run (Big T3 finding 1)"
fi

# Credential leak scan: neither target credential may appear anywhere in the
# checkout. Both secret files are read from ~/AI/secrets at run time as a grep
# pattern only; their content is never printed. Blank lines are stripped so an
# empty pattern cannot match everything, and a file that yields no pattern is a
# failure rather than a silent pass. An absent secret file FAILS the gate: a
# scan that skips is the state Omega recorded in `## Security` finding 14, where
# the effective local gate would pass a real leak by not running.
for secret in scm_draft_pass.md scm_draft_rdp_pass.md; do
  secret_file="${HOME}/AI/secrets/${secret}"
  [ -f "$secret_file" ] \
    || fail "secret file absent, the credential scan cannot run: $secret_file"
  [ -n "$(grep -v '^[[:space:]]*$' "$secret_file")" ] \
    || fail "secret file holds no non-blank line to scan for: $secret_file"
  if grep -RIF --exclude-dir=.git -f <(grep -v '^[[:space:]]*$' "$secret_file") . \
       >/dev/null 2>&1; then
    fail "target credential from ${secret} found in repository contents (AGENTS.md section 4)"
  fi
  PASS
done
note "credential leak scan OK (both target credentials)"

# Host key pinning: no tool under scripts/ may ask for a connection whose host
# key is unpinned, and the demo target's pinned keys must be published where
# rt-lib reads them. `## Security` R2 finding 1: with verification switched off,
# sshpass hands the target password to whoever answers for 192.168.1.99.
if grep -rn 'StrictHostKeyChecking' scripts/ \
     | grep -qvE 'StrictHostKeyChecking=(yes|accept-new)'; then
  fail "a file under scripts/ requests an SSH connection with an unpinned host key"
fi
grep -q 'StrictHostKeyChecking=yes' "$RT/rt-lib" \
  || fail "rt-lib no longer requires a verified host key"
grep -q 'UserKnownHostsFile' "$RT/rt-lib" \
  || fail "rt-lib no longer names a known-hosts file to verify against"
[ -f "$RT/known_hosts" ] || fail "scripts/remote/known_hosts missing (pinned target host keys)"
[ "$(grep -cE '^192\.168\.1\.99 (ssh-ed25519|ecdsa-sha2-nistp256|ssh-rsa) AAAA' "$RT/known_hosts")" -eq 3 ] \
  || fail "scripts/remote/known_hosts does not carry all three pinned keys for 192.168.1.99"
PASS
note "host key pinning asserts OK (no unpinned SSH posture under scripts/)"

# RDP certificate posture. `TASK-0042 ## Security` finding 2, `Omega`'s `O1` ruling 2026-11-26
# 00:06 UTC: the accept-any certificate option accepts any server certificate, so no shipped or loaded
# file may carry it, and the credential-bearing argument generator must instead pin the SHA-256
# fingerprint of the target daemon's TLS certificate and dial the loopback end of the host-key-pinned SSH
# forward. String match only, no target contact, no credential read, same shape as the host-key assert
# above. The pin is a public certificate fingerprint, not secret material.
#
# Scope widened by dispatch `TF1`, closing `S2` blocker 1 (TASK-0041 `## Review:1474-1481`). The scan used
# to cover scripts/ only, which meant the page every dispatched agent actually loads,
# .opencode/skills/remote-desktop/SKILL.md, could keep teaching the accept-any option with no gate able to
# see it. The trees listed below are the ones this team ships or an agent loads. planning/ and DEMO-LOG.md
# are allow-listed as record history: they carry the words of the finding being closed and they are not
# instructions. The pattern is written with a bracket so this file never matches its own pattern text (the
# same trick the no-turn-caps assert near the head of this file uses), which keeps the scanner's own file
# inside the scanned scope instead of excluding it.
# `B2` adds NOTICE to the list. The root NOTICE is a shipped file and it was outside the scanned set:
# the only licence record the gate read was the one scripts/licence-check opens, and this scan saw the
# rest. Same shape as the S2 blocker, a gate whose scope is narrower than the files it claims.
RT_CERT_SCAN_PATHS=(scripts .opencode team tests .github NOTICE README.md AGENTS.md)
if grep -rn 'cert:[i]gnore' "${RT_CERT_SCAN_PATHS[@]}" >/dev/null 2>&1; then
  fail "the accept-any RDP certificate option appears in a shipped or loaded file (TASK-0042 finding 2, S2 blocker 1): $(grep -rnl 'cert:[i]gnore' "${RT_CERT_SCAN_PATHS[@]}" | tr '\n' ' ')"
fi
PASS
note "no accept-any RDP certificate option in ${RT_CERT_SCAN_PATHS[*]} OK"

# The trust-on-first-use form of the same hole (B2). The scan above matches one spelling of one option.
# `xfreerdp /?` on the installed client (freerdp-3.32.2-1.el10_2, read in dispatch B2) lists the values
# of /cert: as deny, ignore, name:<name>, tofu and fingerprint. `tofu` accepts a certificate on first
# contact and re-opens the endpoint substitution `Omega` finding 2 is about, while carrying none of the
# words the scan above matches, so an edit that "tightens" the option from ignore to tofu passes the
# gate unchanged. The 2.x spelling `ignore-cert` was measured against the same client and is rejected at
# parse ("Unexpected keyword"), so it cannot re-enter through a tool's own argument lines.
if grep -rn 'cert:[t]ofu' "${RT_CERT_SCAN_PATHS[@]}" >/dev/null 2>&1; then
  fail "the trust-on-first-use RDP certificate option appears in a shipped or loaded file (TASK-0042 finding 2, B2): $(grep -rnl 'cert:[t]ofu' "${RT_CERT_SCAN_PATHS[@]}" | tr '\n' ' ')"
fi
PASS
note "no trust-on-first-use RDP certificate option in ${RT_CERT_SCAN_PATHS[*]} OK"

grep -qE 'RT_RDP_CERT_PIN="\$\{RT_RDP_CERT_PIN:-[0-9a-f]{64}\}"' "$RT/rt-lib" \
  || fail "rt-lib no longer holds the RDP certificate pin in one named 64-hex variable"
grep -qE 'cert_line="/cert:fingerprint:sha256:\$\{RT_RDP_CERT_PIN\}"' "$RT/rt-lib" \
  || fail "rt-lib's rdp argument lines no longer pin the server certificate fingerprint"
grep -qE 'RT_RDP_TUNNEL_PORT="\$\{RT_RDP_TUNNEL_PORT:-[0-9]+\}"' "$RT/rt-lib" \
  || fail "rt-lib no longer names the loopback port the pinned SSH forward listens on"
grep -q 'ExitOnForwardFailure=yes' "$RT/rt-lib" \
  || fail "rt-lib no longer requires the SSH forward to fail rather than run unforwarded"
PASS

# The argument lines a real run would emit, produced offline through the dry-run form.
RDP_ARGS_FORM="$(bash -c "source '$RT/rt-lib'; RT_DRY=1; rt_rdp_args '<host>'")" \
  || fail "rt_rdp_args dry form could not be produced"
printf '%s\n' "$RDP_ARGS_FORM" | grep -qE '^/v:127\.0\.0\.1:[0-9]+$' \
  || fail "the default RDP /v: is not the loopback end of the pinned SSH forward"
printf '%s\n' "$RDP_ARGS_FORM" | grep -qE '^/cert:fingerprint:sha256:[0-9a-f]{64}$' \
  || fail "the RDP argument lines do not carry a 64-hex certificate fingerprint"
if printf '%s\n' "$RDP_ARGS_FORM" | grep -q 'cert:[i]gnore'; then
  fail "the RDP argument lines still emit the accept-any certificate option"
fi
PASS

# A real run has to refuse before the endpoint is decided: rt_rdp_args must not hand a credential to a
# channel no one chose. The host below is 192.0.2.1, RFC 5737 documentation space, contacted by nobody.
if bash -c "source '$RT/rt-lib'; rt_rdp_args '192.0.2.1'" >/dev/null 2>&1; then
  fail "rt_rdp_args would build a credential-bearing argument set with no decided RDP channel"
fi
PASS
note "RDP certificate posture asserts OK (pin present, no accept-any option, channel refused when undecided)"

# The remote-desktop skill page exists where opencode discovers project
# skills (.opencode/skills, verified 2026-11-22 with
# `opencode api get '/api/skill?location[directory]=<cwd>'`, which lists
# the remote-desktop id for this project) and it carries the secrets rule.
# Since `TF1` it also has to teach the posture that actually landed, because this page is what a
# dispatched agent loads at run time: a skill page is an instruction, not documentation.
SK=".opencode/skills/remote-desktop/SKILL.md"
[ -f "$SK" ] || fail "remote-desktop skill page missing at $SK"
grep -q 'never echoed' "$SK" || fail "remote-desktop skill lost the secrets rule wording"
grep -q 'scripts/remote' "$SK" || fail "remote-desktop skill lost the tooling reference"
PASS
grep -q 'rt-tunnel' "$SK" || fail "remote-desktop skill does not name scripts/remote/rt-tunnel, the pinned SSH forward the RDP channel runs inside"
PASS
grep -q 'RT_RDP_CERT_PIN' "$SK" || fail "remote-desktop skill does not name RT_RDP_CERT_PIN, the pinned daemon certificate fingerprint"
PASS
grep -q '/cert:fingerprint:sha256:' "$SK" || fail "remote-desktop skill does not name the certificate identity line the tools emit"
PASS
grep -q 'RT_RDP_TUNNEL=0' "$SK" || fail "remote-desktop skill does not name the RT_RDP_TUNNEL=0 direct-dial fallback"
PASS
note "remote-desktop skill OK (secrets rule, tooling reference, pin plus tunnel posture)"

# --- forward lifecycle: the borrow wait and the claim count (TASK-0041 `## Review` S2) ---------------
# The two `rt-lib` should-fixes `S2` named, both measured offline. Host is 192.0.2.1 (RFC 5737, contacted
# by nobody), both credential files are deliberately absent, and nothing dials: every "forward" here is a
# real `sleep` whose argv[0] carries the exact forward spec, so rt_tunnel_pid_is_ours recognises it while
# no connection exists. The port is never the default 3401, so a forward a real run left up cannot skew
# these asserts, and the port being free is itself asserted rather than assumed.
RT_FWD_PORT=3417
RT_FWD_HOST='192.0.2.1'
RT_FWD_SPEC="127.0.0.1:${RT_FWD_PORT}:127.0.0.1:3389"
RT_FWD_RECORD() { printf '%s/tunnel-%s-%s.pid' "$1" "$RT_FWD_HOST" "$RT_FWD_PORT"; }
rt_fake_forward() {
  exec -a "ssh -N -L ${RT_FWD_SPEC} howard@${RT_FWD_HOST}" sleep 30 >/dev/null 2>&1 &
  printf '%s' "$!"
}
if ss -tln 2>/dev/null | grep -qE "127\.0\.0\.1:${RT_FWD_PORT}([[:space:]]|$)"; then
  fail "127.0.0.1:${RT_FWD_PORT} is already listening, so the borrowed-forward asserts below cannot mean anything"
fi
PASS

# Finding 1, the borrow race. A forward another caller started that is still coming up used to be a hard
# failure whose advice was `rt-tunnel stop`, the command that kills a healthy forward. `AGENTS.md`
# section 17 batching is the real trigger: `rt-tunnel start` and an input tool launched in one message
# race the ~0.5 s the forward needs (dispatch `T7` measured 0.54 s). The fixed call polls the same window
# it uses for a forward it opened itself, then fails naming `rt-tunnel status` first.
RT_FWD_DIR="$RT_TMP/fake-race"; mkdir -p "$RT_FWD_DIR"
RT_FAKE="$(rt_fake_forward)"
printf '%s\n' "$RT_FAKE" > "$(RT_FWD_RECORD "$RT_FWD_DIR")"
RT_T0=$SECONDS
set +e
RT_OUT="$(RT_STATE_DIR="$RT_FWD_DIR" RT_RDP_TUNNEL_PORT="$RT_FWD_PORT" RT_BUILD_DIR="$RT_TMP" \
  RT_TUNNEL_WAIT_TRIALS=4 RT_TUNNEL_WAIT_MS=0.5 \
  RT_SSH_PASS_FILE="$RT_NO_SSH_PASS" RT_RDP_PASS_FILE="$RT_NO_RDP_PASS" \
  "$RT/rt-click" --host "$RT_FWD_HOST" --click 1 1 2>&1)"
RT_RC=$?
set -e
RT_WAITED=$((SECONDS - RT_T0))
RT_ACTION="$(grep -o "rt-tunnel --host ${RT_FWD_HOST} [a-z]*" <<< "$RT_OUT" | head -1 || true)"
if [ "$RT_RC" -eq 0 ]; then
  fail "rt-click accepted a forward record whose pid is alive while the loopback port is not listening"
fi
PASS
if [ "$RT_WAITED" -lt 1 ]; then
  fail "rt-click gave a borrowed forward no wait window before failing (it waited ${RT_WAITED}s of a 4 x 0.5s window), which is the S2 borrow race"
fi
PASS
if [ "$RT_ACTION" != "rt-tunnel --host ${RT_FWD_HOST} status" ]; then
  fail "the half-open forward error names '${RT_ACTION:-nothing}' as its first action, not scripts/remote/rt-tunnel --host ${RT_FWD_HOST} status; naming stop first advises killing a healthy forward"
fi
PASS
if ! kill -0 "$RT_FAKE" 2>/dev/null || [ ! -f "$(RT_FWD_RECORD "$RT_FWD_DIR")" ]; then
  fail "the call that only wanted to borrow the forward killed it or removed its record"
fi
kill "$RT_FAKE" 2>/dev/null || true
PASS

# Finding 2, reference counting. Four cases, each on its own state directory.
RT_FWD_DIR="$RT_TMP/fake-claims"
# own releases while a live borrower holds a claim: the forward survives and the borrower's claim survives.
rm -rf "$RT_FWD_DIR"; mkdir -p "$RT_FWD_DIR"
RT_OWN="$(rt_fake_forward)"; RT_USE="$(rt_fake_forward)"
set +e
RT_OUT="$(RT_STATE_DIR="$RT_FWD_DIR" RT_RDP_TUNNEL_PORT="$RT_FWD_PORT" bash -c "
  source '$RT/rt-lib'
  RT_TUNNEL_HOST='$RT_FWD_HOST'; RT_TUNNEL_PID=$RT_OWN; RT_TUNNEL_CLAIM_ROLE=own
  rt_tunnel_claims_write '$RT_FWD_HOST' add own \$\$ $RT_OWN && RT_TUNNEL_CLAIMED=1
  rt_tunnel_claims_write '$RT_FWD_HOST' add use $RT_USE && RT_TUNNEL_CLAIMED=1
  RT_TUNNEL_OWNED=1
  rt_rdp_channel_release
" 2>&1)"
RT_RC=$?
set -e
if [ "$RT_RC" -ne 0 ]; then fail "an owner releasing a shared forward exited non-zero: ${RT_OUT}"; fi
if ! kill -0 "$RT_OWN" 2>/dev/null; then
  fail "the tool that opened the forward reaped it while another live process still held a claim on it (S2 reference counting)"
fi
if ! grep -q "^use ${RT_USE}$" "$(RT_FWD_RECORD "$RT_FWD_DIR")"; then
  fail "the surviving forward record lost the borrower's claim: $(tr '\n' ';' < "$(RT_FWD_RECORD "$RT_FWD_DIR")")"
fi
kill "$RT_OWN" 2>/dev/null || true; kill "$RT_USE" 2>/dev/null || true
PASS
note "borrowed forward survives the owner's exit OK"

# the last live holder reaps: a forward must not sit on the loopback port with nobody left to stop it.
rm -rf "$RT_FWD_DIR"; mkdir -p "$RT_FWD_DIR"
RT_OWN="$(rt_fake_forward)"
RT_OUT="$(RT_STATE_DIR="$RT_FWD_DIR" RT_RDP_TUNNEL_PORT="$RT_FWD_PORT" bash -c "
  source '$RT/rt-lib'
  RT_TUNNEL_HOST='$RT_FWD_HOST'; RT_TUNNEL_PID=$RT_OWN; RT_TUNNEL_CLAIM_ROLE=own
  rt_tunnel_claims_write '$RT_FWD_HOST' add own \$\$ $RT_OWN && RT_TUNNEL_CLAIMED=1
  RT_TUNNEL_OWNED=1
  rt_rdp_channel_release
" 2>&1)"
sleep 0.5
if kill -0 "$RT_OWN" 2>/dev/null; then
  fail "the last live holder left the forward running with no claim on it: ${RT_OUT}"
fi
if [ -f "$(RT_FWD_RECORD "$RT_FWD_DIR")" ]; then fail "the reap left the forward record at $(RT_FWD_RECORD "$RT_FWD_DIR")"; fi
PASS

# a detached starter (scripts/remote/rt-tunnel start) hands the keeper claim to the forward itself, so the
# forward outlives the tool that opened it and a later borrower cannot reap it. This is the booth pattern:
# booth code/booth_loop.py opens one forward and makes many input calls against it.
rm -rf "$RT_FWD_DIR"; mkdir -p "$RT_FWD_DIR"
RT_OWN="$(rt_fake_forward)"
RT_OUT="$(RT_STATE_DIR="$RT_FWD_DIR" RT_RDP_TUNNEL_PORT="$RT_FWD_PORT" bash -c "
  source '$RT/rt-lib'
  RT_TUNNEL_HOST='$RT_FWD_HOST'; RT_TUNNEL_PID=$RT_OWN; RT_TUNNEL_CLAIM_ROLE=own
  rt_tunnel_claims_write '$RT_FWD_HOST' add own \$\$ $RT_OWN && RT_TUNNEL_CLAIMED=1
  RT_TUNNEL_OWNED=0
  rt_rdp_channel_release
  RT_TUNNEL_CLAIM_ROLE=use
  rt_tunnel_claims_write '$RT_FWD_HOST' add use \$\$ && RT_TUNNEL_CLAIMED=1
  RT_TUNNEL_OWNED=0
  rt_rdp_channel_release
" 2>&1)"
sleep 0.5
if ! kill -0 "$RT_OWN" 2>/dev/null; then
  fail "a borrowed forward was reaped even though its starter detached on purpose and left a keeper claim: ${RT_OUT}"
fi
if ! grep -q "^keep ${RT_OWN}$" "$(RT_FWD_RECORD "$RT_FWD_DIR")"; then
  fail "the detached starter left no keeper claim in $(RT_FWD_RECORD "$RT_FWD_DIR"): $(tr '\n' ';' < "$(RT_FWD_RECORD "$RT_FWD_DIR")")"
fi
kill "$RT_OWN" 2>/dev/null || true
PASS
note "forward claims OK (owner leaves a shared forward, last holder reaps, a detached forward keeps its keeper)"

# Finding 2 continued, the path `TF1` could not control (TASK-0041 `## Review` C7, named as owed to `B2`).
# TF1's C7 plant, the borrow path taking RT_TUNNEL_OWNED=1, ran green because every offline borrow above
# fails before it completes: with no listener on the loopback port the borrow never reaches the release, so
# a change to ownership inside the borrow is unobservable. This block completes a borrow instead of failing
# one, by putting a real listener on a port that is never 3401 and never the demo target's, and it is the
# only place the successful-borrow-then-release path is asserted. Still no target contact: the host is
# 192.0.2.1 (RFC 5737), both credential files are absent, and the "forward" is a sleep whose argv[0] carries
# the forward spec while a local python socket holds the port.
RT_FWD2_PORT=3419
RT_FWD2_SPEC="127.0.0.1:${RT_FWD2_PORT}:127.0.0.1:3389"
RT_FWD2_DIR="$RT_TMP/fake-borrow"; rm -rf "$RT_FWD2_DIR"; mkdir -p "$RT_FWD2_DIR"
RT_FWD2_RECORD="$RT_FWD2_DIR/tunnel-${RT_FWD_HOST}-${RT_FWD2_PORT}.pid"
if ss -tln 2>/dev/null | grep -qE "127\.0\.0\.1:${RT_FWD2_PORT}([[:space:]]|$)"; then
  fail "127.0.0.1:${RT_FWD2_PORT} is already listening, so the completed-borrow assert below cannot mean anything"
fi
PASS
python3 -c "import socket,time; s=socket.socket(); s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1); s.bind(('127.0.0.1', ${RT_FWD2_PORT})); s.listen(8); time.sleep(25)" >/dev/null 2>&1 &
RT_FWD2_LISTENER=$!
RT_FWD_SPEC_KEEP="$RT_FWD_SPEC"
RT_FWD_SPEC="$RT_FWD2_SPEC"                       # the keeper's argv[0] must carry the spec this port maps to
RT_FWD2_KEEPER="$(rt_fake_forward)"               # the forward a previous call detached, with a keeper claim
RT_FWD_SPEC="$RT_FWD_SPEC_KEEP"
printf '%s\nkeep %s\n' "$RT_FWD2_KEEPER" "$RT_FWD2_KEEPER" > "$RT_FWD2_RECORD"
for _ in 1 2 3 4 5 6 7 8 9 10; do
  ss -tln 2>/dev/null | grep -qE "127\.0\.0\.1:${RT_FWD2_PORT}([[:space:]]|$)" && break
  sleep 0.2
done
if ! ss -tln 2>/dev/null | grep -qE "127\.0\.0\.1:${RT_FWD2_PORT}([[:space:]]|$)"; then
  fail "the local listener for the completed-borrow assert never came up on 127.0.0.1:${RT_FWD2_PORT}"
fi
PASS
set +e
RT_OUT="$(RT_STATE_DIR="$RT_FWD2_DIR" RT_RDP_TUNNEL_PORT="$RT_FWD2_PORT" RT_BUILD_DIR="$RT_TMP" \
  RT_SSH_PASS_FILE="$RT_NO_SSH_PASS" RT_RDP_PASS_FILE="$RT_NO_RDP_PASS" \
  "$RT/rt-click" --host "$RT_FWD_HOST" --click 1 1 2>&1)"
RT_RC=$?
set -e
# The borrow has to have completed for this to mean anything: it completed when the tool got as far as
# asking for the RDP credential, which is a stage only a decided endpoint reaches.
if [ "$RT_RC" -eq 0 ]; then
  fail "rt-click completed against a forward it did not own with both credential files absent"
fi
if ! grep -qE 'credential file not found|not built yet' <<< "$RT_OUT"; then
  fail "rt-click did not reach the credential stage, so the borrow never completed and this assert proves nothing: $(head -3 <<< "$RT_OUT" | tr '\n' '; ')"
fi
PASS
if ! kill -0 "$RT_FWD2_KEEPER" 2>/dev/null; then
  fail "a completed borrow reaped the forward it borrowed (TASK-0041 Review C7, the path TF1 proved by construction and not by control)"
fi
if ! grep -q "^keep ${RT_FWD2_KEEPER}$" "$RT_FWD2_RECORD"; then
  fail "the completed borrow left no keeper claim on the forward it borrowed"
fi
PASS
kill "$RT_FWD2_KEEPER" 2>/dev/null || true
kill "$RT_FWD2_LISTENER" 2>/dev/null || true
note "completed borrow leaves the forward and its keeper claim OK (C7 gap closed)"

# Plumbing asserts: one shared wait window used by both channel paths, and a reap that consults the claims.
grep -q 'rt_tunnel_wait()' "$RT/rt-lib" \
  || fail "rt-lib no longer has one shared wait window for a forward that is coming up"
PASS
RT_WAIT_CALLS="$(grep -c 'rt_tunnel_wait "' "$RT/rt-lib" || true)"
if [ "${RT_WAIT_CALLS}" -lt 2 ]; then
  fail "only one channel path waits for a forward to come up, so the borrowed-forward race is back"
fi
PASS
grep -q 'flock 9' "$RT/rt-lib" || fail "rt-lib no longer serializes forward claims with flock"
grep -q 'RT_TUNNEL_KEEPERS' "$RT/rt-lib" \
  || fail "rt_rdp_channel_release no longer counts live claims before it decides to reap"
PASS


# --- licence and documentation wording (TASK-0042 `## License (Charmy)` F1, gap named by C2, TF3, D2) ---
# Three dispatches reached the same conclusion independently, which is why `B2` closes it rather than
# recording it again: the suite checked licence *files* through scripts/licence-check and certificate
# option *strings* through the scan above, and nothing checked the wording of a licence claim. C2 finding
# F1 is what that gap produced, four sentences across two trees offering a GPL option alongside the Apache
# option for FreeRDP at tag 3.32.2, when upstream at that ref publishes Apache-2.0 only. TF3 rewrote them.
# D2 named the same gap for README.md. With no assert here a later edit restates the withdrawn claim and
# every gate in this file stays green. The claim form is not written out in this comment, for the same
# reason the cert:[i]gnore assert names "the accept-any option" instead of the option: a scanner that
# quotes its own pattern text is a scanner that fails its own suite.
#
# Two halves. A negative scan for the withdrawn claim in the shape it was actually written, and a positive
# assert that each claim-bearing file states the reading Charmy verified, names the version, and cites the
# upstream LICENSE blob that reading rests on. The blob id is pinned here as text: this suite never
# touches the network (see the header), so re-resolving the id against upstream is a dispatch-time act,
# recorded by B2 at TASK-0041 `## Test Results` and not something CI can do.
#
# Scope mirrors the certificate scan above, the shipped and loaded trees plus the two NOTICE files and the
# two root pages a reader or an agent sees. planning/ stays out as record history for the same reason the
# certificate scan leaves it out: the record of the withdrawn claim quotes the withdrawn claim, and a gate
# must not rewrite history to satisfy itself. Patterns are bracketed so this file cannot match its own
# text, the same trick the [m]axTurns and cert:[i]gnore asserts use.
python3 - <<'PY'
import pathlib
import re
import sys

scope = ["scripts", ".opencode", "team", "tests", ".github", "NOTICE", "README.md", "AGENTS.md"]
# The scope ledger, the assert that keeps the scan as wide as the claims. Narrowing the list above trips
# here rather than quietly shrinking the gate, which is the S2 blocker-1 failure mode in a new form.
ledger = ["NOTICE", "scripts/remote/NOTICE", "README.md",
          ".opencode/skills/remote-desktop/SKILL.md", "AGENTS.md"]

files = []
for entry in scope:
    path = pathlib.Path(entry)
    if path.is_dir():
        files.extend(p for p in path.rglob("*") if p.is_file())
    elif path.is_file():
        files.append(path)
names = {str(p) for p in files}
missing = [item for item in ledger if item not in names]
if missing:
    print("selftest FAIL: the licence wording scan no longer reads %s, the scan scope narrowed"
          % ", ".join(missing), file=sys.stderr)
    sys.exit(1)
if len(files) < 100:
    print("selftest FAIL: the licence wording scan reads only %s files over %s"
          % (len(files), ", ".join(scope)), file=sys.stderr)
    sys.exit(1)

# F1 in the form it was written: an Apache option offered alongside a GPL option at the ref in use.
claims = [
    re.compile(r"[d]ual[- ]licen", re.I),
    re.compile(r"Apache-2\.0\s+(o[r]|/)\s+GPL-2\.0"),
]
bad = []
for path in sorted(files):
    try:
        text = path.read_text(encoding="utf-8")
    except (UnicodeDecodeError, OSError):
        continue
    for number, line in enumerate(text.splitlines(), 1):
        for pattern in claims:
            if pattern.search(line):
                bad.append("%s:%d matches %s" % (path, number, pattern.pattern))
if bad:
    print("selftest FAIL: a false upstream licence claim is back in a shipped or loaded file "
          "(TASK-0042 C2 finding F1): " + "; ".join(bad), file=sys.stderr)
    sys.exit(1)
PY
PASS
PASS
note "licence wording scan OK (no Apache-plus-GPL option claim inside the scan scope, scope ledger intact)"

# The claim each file makes, asserted where it is made. Proximity rather than a fixed sentence, so a
# wrapped line still passes and a claim separated from its own evidence does not.
for f in NOTICE scripts/remote/NOTICE README.md; do
  grep -q '3\.32\.2' "$f" \
    || fail "$f no longer names the FreeRDP version 3.32.2 its licence claim is about"
  if ! grep -A8 '3\.32\.2' "$f" | grep -q 'Apache-2\.0 only'; then
    fail "$f no longer states Apache-2.0 only at tag 3.32.2, the upstream reading Charmy verified (C2 finding F1)"
  fi
  if ! grep -A8 '3\.32\.2' "$f" | grep -q 'd645695673349e3947e8e5ae42332d0ac3164cd7'; then
    fail "$f states a FreeRDP licence claim without the upstream LICENSE blob id that claim rests on"
  fi
  PASS
done
note "licence claim wording OK (NOTICE, scripts/remote/NOTICE, README.md each state Apache-2.0 only at 3.32.2 with the blob id)"

# The README section D2 wrote has to keep teaching the posture that landed at b56be2b, or the next agent
# reads a page that describes a channel this repository no longer builds. Each token is its own assert so
# a dropped one names itself.
for token in 'gnome-screenshot-tool' 'RT_RDP_CERT_PIN' 'rt-tunnel' '/cert:fingerprint:sha256:'; do
  grep -qF -- "$token" README.md \
    || fail "README.md no longer names $token, part of the remote visual-control posture (D2 docs gap)"
  PASS
done
note "README posture wording OK (capture path, cert pin, tunnel, identity line)"

# --- no interpolation into run: bodies (Omega finding 12) -------------------
# AGENTS.md section 6 binds every untrusted input to env:. The planning-doc
# ruling on finding 12 asked for a gate on the class itself: no run: body in
# any workflow or composite action may carry a ${{ ... }} expression. The
# check parses the YAML and inspects only the run: keys, so env: bindings
# (the compliant form) pass and a raw interpolation in any run body fails.
python3 - <<'PYEOF'
import glob
import re
import sys

import yaml

bad = []
paths = sorted(
    glob.glob(".github/workflows/*.yml") + glob.glob(".github/actions/*/action.yml")
)
for path in paths:
    with open(path) as handle:
        data = yaml.safe_load(handle)
    steps = []
    for job in (data.get("jobs") or {}).values():
        steps.extend(job.get("steps") or [])
    steps.extend((data.get("runs") or {}).get("steps") or [])
    for step in steps:
        body = step.get("run") or ""
        if re.search(r"\$\{\{.*?\}\}", body, re.DOTALL):
            name = step.get("name") or step.get("id") or "unnamed step"
            bad.append("%s: step '%s' interpolates an expression into a run body" % (path, name))
if bad:
    print("selftest FAIL: " + "; ".join(bad), file=sys.stderr)
    sys.exit(1)
PYEOF
PASS
note "no run-body interpolation OK (workflows and composite actions)"

# The suite asserts its own floor so a suite that stopped asserting cannot
# read as green to any consumer, local hook or CI alike.
if [ "${CHECKS}" -lt "${MIN_CHECKS}" ]; then
  fail "selftest asserted only ${CHECKS} checks; the floor is ${MIN_CHECKS}"
fi

printf 'SELFTEST: %s checks passed (floor %s)\n' "${CHECKS}" "${MIN_CHECKS}"
