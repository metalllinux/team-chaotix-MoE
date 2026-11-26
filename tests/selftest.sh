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
# 93 fixed PASS asserts plus the pytest count (29 at the 2026-11-26 baseline,
# total 122 after the TASK-0042 dispatch T8 assert-hygiene fix; the chain is
# 106 before the gate fix f1907ab, 110 after it, 120 after the certificate-pin
# commit b56be2b, 122 after T8). pytest is the only component that varies
# run to run, so 100 leaves 10 checks of slack for skipped or deselected tests
# while failing the moment any meaningful block of asserts disappears. The
# previous floor was 70, 35 below the real count, and it lived only in a CI job
# that has never run.
MIN_CHECKS=100

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
for probe in "rt-shot --dry-run" "rt-status --dry-run" "rt-tunnel --dry-run start"; do
  out="$(RT_SSH_PASS_FILE="$RT_NO_SSH_PASS" RT_RDP_PASS_FILE="$RT_NO_RDP_PASS" $RT/$probe 2>&1)" \
    || fail "dry run of $probe exits non-zero with both credential files absent, so it reads a credential or contacts the host"
  if grep -q "$RT_DEMO_HOST" <<< "$out"; then fail "dry run of $probe names the real demo target host in its output"; fi
  grep -q '<host>' <<< "$out" || fail "dry run of $probe used a real host instead of the placeholder"
  PASS
done
# rt-ocr never contacts a target: its dry run must print the local OCR command
# and nothing remote, under the same credential tripwire as every other tool.
out="$(RT_SSH_PASS_FILE="$RT_NO_SSH_PASS" RT_RDP_PASS_FILE="$RT_NO_RDP_PASS" $RT/rt-ocr --dry-run "$RT_TMP/absent.png" 2>&1)" \
  || fail "dry run of rt-ocr exits non-zero with both credential files absent"
if grep -q "$RT_DEMO_HOST" <<< "$out"; then fail "dry run of rt-ocr names the real demo target host in its output"; fi
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
    grep -q '<rdp argument lines on stdin>' <<< "$out" \
      || fail "dry run of $probe prints live RDP argument lines instead of the named placeholder"
    PASS
  done
  out="$(RT_BUILD_DIR="$RT_TMP" RT_SSH_PASS_FILE="$RT_NO_SSH_PASS" RT_RDP_PASS_FILE="$RT_NO_RDP_PASS" $RT/rt-uinput --dry-run --probe 2>&1)" \
    || fail "dry run of rt-uinput exits non-zero with both credential files absent, so it reads a credential or contacts the host"
  if grep -q "$RT_DEMO_HOST" <<< "$out"; then fail "dry run of rt-uinput names the real demo target host in its output"; fi
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
# 00:06 UTC: `/cert:ignore` accepts any server certificate, so no file under scripts/ may carry it, and
# the credential-bearing argument generator must instead pin the SHA-256 fingerprint of the target
# daemon's TLS certificate and dial the loopback end of the host-key-pinned SSH forward. String match
# only, no target contact, no credential read, same shape as the host-key assert above. The pin is a
# public certificate fingerprint, not secret material.
if grep -rn 'cert:ignore' scripts/ >/dev/null 2>&1; then
  fail "a file under scripts/ carries /cert:ignore, which accepts any RDP server certificate (finding 2)"
fi
PASS
note "no /cert:ignore anywhere under scripts/ OK"

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
if printf '%s\n' "$RDP_ARGS_FORM" | grep -q 'cert:ignore'; then
  fail "the RDP argument lines still emit /cert:ignore"
fi
PASS

# A real run has to refuse before the endpoint is decided: rt_rdp_args must not hand a credential to a
# channel no one chose. The host below is 192.0.2.1, RFC 5737 documentation space, contacted by nobody.
if bash -c "source '$RT/rt-lib'; rt_rdp_args '192.0.2.1'" >/dev/null 2>&1; then
  fail "rt_rdp_args would build a credential-bearing argument set with no decided RDP channel"
fi
PASS
note "RDP certificate posture asserts OK (pin present, no cert:ignore, channel refused when undecided)"

# The remote-desktop skill page exists where opencode discovers project
# skills (.opencode/skills, verified 2026-11-22 with
# `opencode api get '/api/skill?location[directory]=<cwd>'`, which lists
# the remote-desktop id for this project) and it carries the secrets rule.
SK=".opencode/skills/remote-desktop/SKILL.md"
[ -f "$SK" ] || fail "remote-desktop skill page missing at $SK"
grep -q 'never echoed' "$SK" || fail "remote-desktop skill lost the secrets rule wording"
grep -q 'scripts/remote' "$SK" || fail "remote-desktop skill lost the tooling reference"
PASS
note "remote-desktop skill OK"

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
