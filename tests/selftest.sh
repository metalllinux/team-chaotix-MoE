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
# A subagent inherits the dispatcher's own session context. TASK-0042 lost two
# dispatches to "request (262191 tokens) exceeds the available context size
# (262144 tokens)" while every brief was short, so the ceiling is checked here
# rather than rediscovered by a failed dispatch.
[ -x scripts/dispatch-gate ] || fail "scripts/dispatch-gate missing or not executable"
PASS
scripts/dispatch-gate --help > /dev/null || fail "dispatch-gate --help"
PASS
scripts/dispatch-gate --dry-run > /dev/null || fail "dispatch-gate --dry-run"
PASS
note "dispatch-gate interface OK"

# The real read is optional, the session store may not exist in CI. Verdict exits
# 0 PASS, 3 WARN, 4 BLOCK are all a working gate; only a 2 is a broken one.
if [ -f "${HOME}/.local/share/opencode/opencode.db" ]; then
  set +e
  scripts/dispatch-gate --latest-agent robotnik --json > /dev/null 2>&1
  DG_RC=$?
  set -e
  [ "${DG_RC}" -le 4 ] || fail "dispatch-gate real read returned ${DG_RC}"
  PASS
  note "dispatch-gate real read OK (exit ${DG_RC})"
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
RT_TOOLS=(rt-shot rt-ocr rt-type rt-key rt-click rt-status rt-uinput rt-build)

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

# Dry runs exit 0, name no real host, and state that no credential was read.
RT_TMP="$(mktemp -d)"
trap 'rm -rf "$RT_TMP"' EXIT
for probe in "rt-shot --dry-run" "rt-status --dry-run"; do
  out="$($RT/$probe 2>&1)" || fail "dry run failed: $probe"
  grep -q '<host>' <<< "$out" || fail "dry run of $probe used a real host instead of the placeholder"
  PASS
done
# rt-ocr never contacts a target, so its dry run only has to confirm that.
out="$($RT/rt-ocr --dry-run "$RT_TMP/absent.png" 2>&1)" || fail "dry run failed: rt-ocr"
grep -qi 'dry run' <<< "$out" || fail "rt-ocr dry run did not confirm it touched nothing"
PASS
note "scripts/remote dry runs OK (target offline)"

# The capture path must wrap the tool proven accepted by gnome-shell 49,
# not a raw gdbus call (TASK-0042 DEMO-LOG 2026-11-20 01:40-02:10).
grep -q 'gnome-screenshot-tool' "$RT/rt-lib" || fail "rt-lib no longer defaults to gnome-screenshot-tool"
PASS

# The uinput wrapper carries the proven settle fact: events emitted in the
# same millisecond as UI_DEV_CREATE are dropped (TASK-0042 dispatch P1).
grep -Eq 'UI_DEV_CREATE|1800' "$RT/uinput-inject.c" \
  || fail "uinput-inject.c lost the UI_DEV_CREATE settle handling"
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
  # Input-tool dry runs resolve their binaries through RT_BUILD_DIR.
  for probe in \
    "rt-type --dry-run --text CHAOTIX41" \
    "rt-key --dry-run --chord ctrl+t" \
    "rt-click --dry-run --click 960 14" \
    "rt-uinput --dry-run --probe"; do
    out="$(RT_BUILD_DIR="$RT_TMP" $RT/$probe 2>&1)" || fail "dry run failed: $probe"
    grep -qi 'dry run' <<< "$out" || fail "dry run of $probe did not confirm it touched nothing"
    PASS
  done
  note "scripts/remote input-tool dry runs OK"
else
  note "gcc or freerdp-client3 absent, remote build asserts skipped"
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

printf 'SELFTEST: %s checks passed\n' "${CHECKS}"
