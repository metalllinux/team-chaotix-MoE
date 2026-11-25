# TASK-0043 — Dispatch gate, the dispatcher's context ceiling made mechanical

> **Section order below is fixed.** Each agent writes to its own section and no other. `Robotnik`
> reads only `## Status` and `## Next Actions`. Do not reorder, rename, or remove sections.

- **Created:** 2026-11-15
- **Requested by:** the operator, directly, after TASK-0042 lost two dispatches to a context-size error.

---

## Status

**Roster note, `Robotnik` 2026-11-22 22:05 UTC (2026-11-23 07:05 JST).** The fifth reviewer `Flicky` was retired by operator instruction under TASK-0044, and `Charmy` is now the team's single licence owner holding the audit and the machine gate. The `G1` to `G5` chain for this task is now four dispatches, `Shadow`, `Omega`, `Big`, `Charmy`, and `G4` carries the audit scope written in TASK-0044 `## Next Actions`. Do not dispatch `G5`. See `planning/docs/TASK-0044-flicky-into-charmy.md`.

**Now:** Implemented, selftest green at 61 checks (baseline 56), committed on branch `task-0043-dispatch-gate`, merged to `main` as pull request #1, merge commit `44a017e`, pushed. Verified on `origin/main`, `scripts/dispatch-gate`, the selftest block, the AGENTS.md rule and the robotnik.md section are all present. The review chain is **not** run yet and is owed by a fresh `Robotnik` session.

**Gate defect found in live use (2026-11-20, `Robotnik`), owed to the review chain and to a fix dispatch.** The gate returned `PASS` for a dispatch that then failed outright. Gate output at the time was peak 86393 over 20 calls, worst jump 2533, dispatcher projection 88926, child projection 142281 of 262144, verdict `PASS`, 54.3 percent. The next dispatch failed with `request (262242 tokens) exceeds the available context size (262144 tokens)`. The real child request was 1.85 times the projection and 3.04 times the measured peak. Cause, stated as reasoning rather than as a measured fact about the code. The estimator extrapolates a peak prompt over a recent call window and multiplies by an inherit ratio fitted to one earlier incident, while a child appears to inherit the dispatcher's whole transcript, so the error grows with session length and a PASS late in a long session is the least trustworthy reading the instrument gives. A fix should measure cumulative transcript size, or read the dispatcher's own last request size from the session store, instead of extrapolating from a peak. Until that lands the gate is necessary and not sufficient, and this is the second occurrence of the failure mode the gate exists to catch.

**Second gate defect found the same day (2026-11-20, `Robotnik`).** With two `robotnik` sessions in the store, the default invocation measured the wrong one. `scripts/dispatch-gate` with no arguments reported `session_id: ses_e0c0d016cffeZr080AD75CfFSf`, `seq: 932`, peak 105107, which is the dead overflowed session from earlier in the day, while the live session was `ses_e093d9411ffe5CT32IitB2R8cO` with 4 assistant messages and `tokens_input` 42559. Run explicitly, `scripts/dispatch-gate --session ses_e093d9411ffe5CT32IitB2R8cO`, it answered peak 40546 over 6 calls, child projection 87220 of 262144, `PASS`, 33.3 percent. So `--latest-agent robotnik` does not select the newest session by `time_created`, and a dispatcher following the documented instruction can be green-lit or blocked on the context of a session it is not running in. The fix should resolve the caller's own session id rather than guess from agent name, and every dispatcher should pass `--session` explicitly until it does.

**Third data point, a correct reading (2026-11-20 18:20, `Robotnik` session `ses_e08628942ffeuU24D8rsQXCBy4`).** Run explicitly against the caller's own session, `scripts/dispatch-gate --session ses_e08628942ffeuU24D8rsQXCBy4`, the gate returned `BLOCK`, exit 4, peak 86611 over 20 calls, worst jump 74135, dispatcher projection 160746, child projection 257193 of 262144, 98.1 percent. Two things follow for the fix dispatch. The `--session` form selected the right session, so the second defect's workaround is confirmed working, and the same session that read `PASS` at 0 percent at 16:20 read 98.1 percent at 18:20, which is the honest direction of travel but with a 74135 worst jump contributed by this session's own large planning-doc reads, so the jump term is doing work it was not designed for. Note also what the gate cannot see, two duplicate subagent dispatches ran concurrently in the same task on 2026-11-20 from two different dispatcher sessions and neither reading warned about it, which the fix should treat as a second missing signal, alongside a per-request input size that this store does not appear to record per message (`session_message.data` carries `content`, `finish`, `cost` and no token counts, measured on this session).

**Why this task exists.** In TASK-0042 two subagent dispatches failed in a row with `request (262191 tokens) exceeds the available context size (262144 tokens)`, the identical figure both times, while every brief was two or three sentences. A child session inherits the dispatcher's own context, so the limit belongs to the dispatcher, not to the brief. Learned rule r001 named the symptom. Nothing in the repo made it detectable before a dispatch failed, which is the gap this task closes.

**What changed.**
| File | Change |
|---|---|
| `scripts/dispatch-gate` | New. Reads `~/.local/share/opencode/opencode.db` read-only, takes the peak prompt across a window of recent assistant calls, adds the worst single jump, multiplies by an inherit ratio to estimate what a child would inherit, and answers `PASS`, `WARN`, `BLOCK` with exit codes 0, 3, 4. `--dry-run` proves the interface with no database read, so CI never depends on a session store. |
| `tests/selftest.sh` | Four asserted checks, executable bit, `--help`, `--dry-run`, and a real read when the session store exists. Verdict exits 0, 3, 4 are all a working gate, only 2 is a broken one. Check count 56 to 61. |
| `.opencode/agents/robotnik.md` | New `## The dispatch ceiling` section, gate before every dispatch, what to do on `BLOCK`, no follow-ups into long-running children. |
| `AGENTS.md` | Section 14 item 4 added, Detection renumbered to 5. |

**Calibration, stated as measured rather than derived.** Against this session the gate reported peak 168307, worst jump 9993, dispatcher projection 178300, child projection 285280 against 262144, which is 108.8 percent, `BLOCK`. The real failures were at 262191. The inherit ratio 1.6 came from those two numbers, 262191 against 160824 measured by the same code. The estimate is therefore fitted to one incident and is an early-warning instrument, not a precise predictor.

**agentsmd initialized (2026-11-19, `Robotnik`).** `agentsmd init` needs a template and the hand-written AGENTS.md is not a template, so the store was created with `agentsmd commit`, which produced `.agentsmd/{config.yaml,pending,runs,versions}` and left `AGENTS.md` byte-identical (`git diff --stat AGENTS.md` empty). `.agentsmd/` is gitignored, so nothing was committed. Four rules are now pending operator promotion, proposed with `--task`: TASK-0041 gnome-remote-desktop TLS certificate location and stdin-only credentials, TASK-0041 injected clicks never working on Delphi dialog buttons, TASK-0042 the independent-reader legibility gate as a false-completion guard, TASK-0043 run the gate before every dispatch and give each implementation item a fresh child session. Ids `p1795094347076479955`, `p1795094347080274089`, `p1795094347082757430`, `p1795094347085128711`. Promotion is the operator's action per AGENTS.md section 16 and is not done by the team.

**Deviation recorded.** The implementation was done by `Robotnik` rather than `Tails`. Delegation was impossible at the time, the session was already at the ceiling this task is about, and the operator asked for the change, commit, merge and push in the same turn. That is a departure from AGENTS.md section 1 and it is recorded rather than glossed.

---

## Definition of Done

*Owner: `Robotnik`, written before the work started.*

- [x] A gate exists that estimates the dispatcher context a child would inherit and answers `PASS`, `WARN`, `BLOCK` with distinct exit codes.
- [x] The gate has a `--dry-run` that needs no database and no network, so CI never depends on a session store.
- [x] The gate is asserted in `tests/selftest.sh`, and the check count rises from the recorded baseline of 56.
- [x] `Robotnik`'s agent instructions require the gate before every dispatch and define what `BLOCK` obliges the dispatcher to do.
- [x] `AGENTS.md` carries the rule in the hand-written rules, not only in a learned block.
- [x] `tests/selftest.sh` passes, 61 checks, before push.
- [x] No credential appears in the diff. Verified with `grep -R -F -f ~/AI/secrets/scm_draft_pass.md .` and the same for the RDP secret, both no match.
- [x] Committed, PR opened, merged to `main`, pushed.
- [ ] `Shadow`, `Omega`, `Big`, `Charmy` each review the change. Owed by a fresh `Robotnik` session, this row stays open until they run. Restated in place 2026-11-23 00:10 UTC by `Robotnik` per `Shadow`'s TASK-0044 `F2` finding 2, the fifth reviewer named in the original row was retired under TASK-0044 and no agent can satisfy her row. `G4` carries her audit scope.
- [ ] `agentsmd learn` proposes the lesson once the project is initialized for agentsmd, which it is not. Recorded in TASK-0042 `## Next Actions`.

---

## Next Actions

- [ ] `Robotnik`, fresh session, run the gate as `scripts/dispatch-gate --session <the caller's own session id>`, never the bare invocation, that is defect 2. Then dispatch the review chain for this change, `Shadow` → `Omega` → `Big` → `Charmy`, four dispatches, one at a time, `G5` void per TASK-0044. Amended in place 2026-11-23 00:10 UTC by `Robotnik` per `Shadow`'s TASK-0044 `F2` finding 2, the row as originally written tells a verbatim reader to dispatch a reviewer the roster no longer has, which contradicts this doc's own roster note at `## Status`.
- [ ] `Tails`, if any reviewer finds a fault, fix it in a follow-up commit on `main`.
- [x] Initialize agentsmd for this project, done 2026-11-19 by `Robotnik`, four rules proposed and pending. `agentsmd promote` is the operator's action.

---

## Plan

*Owner: `Amy`.* Not run. The task was a single instrument requested directly by the operator, and the session that received it could no longer delegate.

---

## Implementation

*Owner: `Tails`.* Done by `Robotnik`, reason recorded in `## Status`. Design notes, peak over a window rather than the newest message, because the newest assistant row is often partial with zero tokens recorded; worst jump rather than average growth, because one large tool result is what breaks a dispatch; inherit ratio 1.6 as a fitted constant from the observed failure. Retained as the record of the first implementation; superseded by the fix below.

### Fix dispatch, `Tails`, 2026-11-25 13:58 UTC (2026-11-25 22:58 JST)

The review chain's four-part fix set (`## Review` findings 1-4, `## Security` "what the fix must land", `## Test Results` FAIL 2 and FAIL 3) landed in one signed commit on `main`, three files.

**Changes**

| File | Change | Why |
|---|---|---|
| `scripts/dispatch-gate` | Rewritten. Measure is now the cumulative in-flight prompt, `max(input + cache.read + cache.write)` over every assistant row of the named session (`measure_session`), numeric fields only. `--session` is required for real reads; a bare invocation is a usage error (exit 2). `--inherit-ratio`, `--window`, `--warn-fraction`, `--block-fraction`, the peak-window sampler and the worst-jump term are gone. Thresholds are absolute margins, `warn_at = limit - 16384` (245760) and `block_at = limit - 4096` (258048) at the default limit. Two new signals floor the verdict at WARN: a `parent_id` child whose own measured peak is at or above `warn_at`, and other sessions in the same project, not this session's children, updated within 300 s (concurrent dispatcher chains). Malformed rows are counted and reported by `id:seq` only. Header comment rewritten, so the finding-5 contradiction is gone. | Findings 1, 2, 3, 4, 5. |
| `tests/selftest.sh` | The dispatch-gate block went from 4 asserts to 8. New: a no-argument real read must exit 2. The real read resolves a session id itself (read-only SQL) and passes `--session`; exit 1 (crash) and exit 2 (broken store or usage) now fail instead of satisfying `-le 4`; the JSON verdict and `peak_prompt` are cross-checked against an independent read-only recomputation of the same quantity and against the verdict the thresholds require. Also corrected this file's own header count comment (81 fixed asserts, total 110), which understated the suite by one before this fix (`## Test Results`, named-drop narration). | Test Results FAIL 1 (M3/M6 ran the suite green). |
| `.opencode/agents/robotnik.md` | `## The dispatch ceiling` rewritten: the gate command carries `--session <your own session id>`; what the gate measures is stated; the stop line is written here as the same two numbers the code uses, WARN 245760, BLOCK 258048; signal-raised WARN explained; the no-follow-ups rule tied to the measured child-side ceiling; margins labelled provisional and operator-owned. | Finding 2 and finding 4: one control, one number, written in both places. |

**Alternatives considered.** (A) `session_v2.tokens_input` as the cumulative field, versus per-row sums. Chose per-row sums: `tokens_input` disagrees with the sum of its own rows in 280 of 282 sessions I measured (it excludes cache reads), so switching to it would change the quantity, not just the method. (B) Thresholds as fractions of the limit versus absolute margins. Chose margins, per `## Test Results` assertion 6, because the store's proven-successful maximum (262113) and its recorded failure (262242) are 129 tokens apart and no fraction can be honest inside that window. (C) Rework the jump term into a sustained slope, versus drop it. Chose drop: under a cumulative measure a large read is already counted once, and a slope would only re-add noise from the dispatcher's own planning-doc reads. (D) Auto-resolve the caller's session id, versus require `--session`. Auto-resolution is not possible today, nothing in the toolchain exposes the calling opencode session id to a script (`## Test Results`, checks that did not run), so the bare form is now an error and `robotnik.md` says how to pass the id.

**What I measured (my own read-only census, `/tmp/opencode/t0043-harness/census.py`, 2026-11-25, numeric fields only).** 10792 assistant rows, 10728 with a nonzero prompt, 0 unparseable, 282 sessions with assistant rows. Inherit ratio, child's first-request prompt over the parent's measured peak, `robotnik` parents only, n=231: min 0.07, median 0.09, p90 0.17, max 0.29, and zero of 231 above the fitted 1.6. `## Test Results` measured the same population against the parent's *last request* (n=229, median 0.18, max 0.54); my denominator is the parent's peak, which is larger, so my ratios run lower. Both readings agree on the point that matters, and neither supports 1.6, so no inherit multiplier is used anywhere in the fix. Store reach under the new lines: 7 sessions at or above 245760, 6 at or above 258048, all `tails` children with a `parent_id`; the highest `robotnik` dispatcher peak is 186176 (71.0%). Under the new measure the two 2026-11-20 dispatcher readings (peaks 86393 and 86611) read PASS at 33% of the limit, which is the honest consequence of the cumulative measure: that dispatcher was not near the ceiling, and the recorded 262242 failure was child-side. What the gate now does with that fact is surface it, the six sessions that actually crossed the line are all children, and a dispatcher holding one of them as a child gets a WARN with an explicit fresh-child instruction rather than a wrong projection.

**Threshold provenance, stated as provisional.** 16384 and 4096 tokens of headroom were written from the store evidence above, not fitted to one incident. The accepted tradeoff, named: six store-proven sessions (peaks 258705 to 262113) completed successfully at or above `block_at`, so a follow-up dispatch into one of them is now blocked. That costs a handoff to prevent a failed dispatch costing a whole turn, which is the direction Shadow's finding 4 argued for. **Re-fitting these margins against measured child request sizes is operator-owned**, as is the AGENTS.md section 14 wording; neither is changed here. The AGENTS.md rule text itself is untouched by this dispatch.

**Selftest before and after, both against the 106 baseline.** Before, on the tree as it stood at `3db919d` with the review sections uncommitted, `bash tests/selftest.sh` reported `SELFTEST: 106 checks passed (floor 100)`, exit 0. After, same host, same command, `SELFTEST: 110 checks passed (floor 100)`, exit 0. Delta +4, all four in the dispatch-gate block (bare-usage assert 1, real-read exit assert 1, cross-check asserts 3, less the 1 assert the old block contributed).

**Negative controls, all proven (`/tmp/opencode/t0043-harness/negative_controls.sh`, 12 controls, pass 12 fail 0).** Synthetic stores built from the real `session_v2`/`session_message` DDL, gate run under a substituted HOME, gate never modified. Threshold boundaries inclusive to the token: peak 245759 PASS exit 0, 245760 WARN exit 3, 258047 WARN exit 3, 258048 BLOCK exit 4. Defect 2 closed: one store holding a live and a dead `robotnik` session reads PASS for `--session s_live` and WARN for `--session s_dead`, and the bare invocation exits 2 instead of choosing. Concurrency signal fires on a second live session in the project and raises PASS to WARN. Child signal fires on a child peaking at 250000 and raises PASS to WARN with the fresh-child text. A malformed row is reported by id with no content, a planted `CANARY` string in row data is absent from all gate output. Assert falsifiability, replaying the real selftest block verbatim against mutated gates with a copy of the real store plus an injected 260000-peak session: `M0_pristine` control green (8 asserts fired, harness sound); `M_blind` (token fields read as zero) caught by the peak cross-check; `M_toothless` (never WARN, never BLOCK) caught by the verdict-vs-threshold cross-check, which is exactly the M3 hole `## Test Results` recorded; `M_guess` (bare invocation guesses again) caught by the new usage assert; `M_crash` (unhandled exception, exit 1) caught by the tightened exit `case`. All four Big's load-bearing mutant classes from 2026-11-25 are now caught, and the two that ran his suite green no longer do.

**Checks that did not run, named.** The `Team Selftest`, `Licence Check`, `Static Checks`, `Secret Scan`, `Secret Scan (self)`, `Planning Doc Gate`, `Deploy` and `Test Runner` CI workflows, none executed, the self-hosted runner cannot register on a public repo (AGENTS.md section 6); the local pre-push hook ran the same suite instead. Sparky and Raku, not run, Raku is not installed. Podman container tests, not run, `rpm -q podman podman-docker` reports both absent on this host, contradicting AGENTS.md section 13, a claim `Big` already recorded and which is not mine to fix here. A checked-in synthetic store fixture asserted against known values inside the suite, not added; `## Test Results` names that as Big's harness change to land, not a code change. Automatic resolution of the calling dispatcher's own session id, not implemented and not implementable today, no toolchain surface exposes it. Re-fit of the margins against measured child sizes, deliberately left to the operator. The gate has not been run against this dispatch's own calling session id, because nothing hands that id to a child session; `## Status` defect-2 workaround (pass `--session` explicitly) is the standing rule until it does.

**Standing ruling carried.** `R4`'s verdict stands FAIL on the booth repo as published at `7c4fa16`; it stays private. Nothing from `/home/howard/AI/booth-2026/` was committed or published by this dispatch, and the verification tooling there was left in place per learned rule r002. No credential appears in the diff, the commit message, or this record. The unrelated uncommitted edit to `planning/docs/TASK-0042-...md` in the working tree belongs to another agent and was left untouched.

---

## Review

*Owner: `Shadow`.* Run 2026-11-25 12:22 UTC (2026-11-25 21:22 JST), dispatch `G1`. Verdict: the gate is not shippable as a safety gate in its current form. It is a necessary instrument and not sufficient, and the four data points below compound, so a single reading today is close to noise. AGENTS.md r001 and the `necessary and not sufficient` language in `## Status` stand as the interim rule until a fix lands. Read-only on code, no edits made; schema facts below were read from `~/.local/share/opencode/opencode.db` in read-only mode on 2026-11-25.

### The inherit model is a fitted multiplier, not a transcript measure. This is the false PASS.
**Severity:** blocker
**Where:** `scripts/dispatch-gate:70-72` (`peak + growth`) and `scripts/dispatch-gate:135` (`* inherit_ratio`, default 1.6 at `:97`)
**Problem:** `child_projection` is `(peak + one jump) * 1.6`, a linear extrapolation of the largest single call in a 20-call window, scaled by a constant fitted to one TASK-0042 incident.
**Failure scenario:** the live case. Gate read peak 86393, worst jump 2533, dispatcher projection 88926, child projection 142281, verdict `PASS` at 54.3 percent. The very next dispatch failed at a real child request of 262242 against the 262144 limit. The real request was 1.85 times the projection and 3.04 times the measured peak. A 1.6 ratio fitted to one incident cannot hold across a session of different length, because a child inherits the whole transcript and the transcript keeps growing while the peak stays a noisy sample.
**Suggested direction:** stop extrapolating a peak, measure the cumulative transcript. `session_v2.tokens_input` is already a cumulative per-session sum the store records (verified in the schema on 2026-11-25) and the gate ignores it entirely. Use that, or an explicit sum over `session_message`, and read the dispatcher's own last request size. Retire `--inherit-ratio` as a fitted constant once the cumulative measure lands.

### The bare invocation can select a dead session, so the gate measures the wrong context.
**Severity:** blocker
**Where:** `scripts/dispatch-gate:36-45` (`pick_session`, `ORDER BY time_updated DESC`), default wired at `scripts/dispatch-gate:94` (`--latest-agent` defaults to robotnik, `--session` optional at `:93`)
**Problem:** session selection is by agent name plus `time_updated`, not by the caller's own session. `time_updated` is bumped by record mutations (status writes, idle transitions), so a completed or overflowed session can outrank the live one.
**Failure scenario:** verified 2026-11-20. Bare `scripts/dispatch-gate` reported `ses_e0c0d016cffeZr080AD75CfFSf`, the dead overflowed session, seq 932, peak 105107, while the live session was `ses_e093d9411ffe5CT32IitB2R8cO` with 4 assistant messages and `tokens_input` 42559. A dispatcher following the documented instruction is green-lit or blocked on a context it is not running in.
**Suggested direction:** resolve the caller's own session id. There is no reliable way today to discover the calling opencode session from inside the script, so until that exists make `--session` required rather than optional, make the bare invocation a usage error instead of a guess, and update `robotnik.md` to pass it explicitly. `session_v2.parent_id` shows the store already has parent linkage the gate does not use.

### The worst-jump term is a spike term and it inflates the projection with legitimate large reads.
**Severity:** blocker
**Where:** `scripts/dispatch-gate:71-74` (`growth = max(deltas + [0])`), consumed as `projected_prompt = peak + growth` at `:82`
**Problem:** the term is meant to capture accelerating growth, but `max(deltas)` records the single largest gap between consecutive calls, which a large legitimate planning-doc read produces. Adding it on top of the peak double-counts the same burst, because the peak already contains the big read in its prompt and the next delta re-adds the read's token count.
**Failure scenario:** two verified cases. 2026-11-20: `BLOCK` at 98.1 percent with peak 86611 but worst jump 74135, and that 74135 came from the session's own large planning-doc reads, not from dispatch-driven growth. 2026-11-25 10:15: a handing-off dispatcher read child projection 144968 with a 15553 worst jump from its own planning-doc reads, above the 142281 stop line the team dispatches against. The gate blocks a dispatcher whose only growth was reading the very doc it must write its handoff into.
**Suggested direction:** the max-jump term as designed does not belong in the projection. If a forward-looking term is wanted, use a sustained slope (linear fit over the window, or the mean of deltas), not the single max. Under a cumulative transcript measure the spike problem largely disappears, because the sum already reflects the read once.

### The 142281 "stop line" is not the code's threshold, so the instrument and the operating rule disagree.
**Severity:** should-fix
**Where:** `## Status` (the 142281 figure); `scripts/dispatch-gate:98` (`block_fraction` default 0.95) and `:96` (`warn_fraction` default 0.85)
**Problem:** the team has adopted 142281 as a de facto dispatch line because that is what the false-PASS case projected. That number is an artifact of a wrong projection, not a threshold the gate emits. The code's real BLOCK line is 249036 and its WARN line is 222822.
**Failure scenario:** the 2026-11-25 handoff. Child projection 144968 sits above the team's 142281 line but below the code's WARN (222822) and BLOCK (249036) lines, so the gate itself reads `PASS` while the dispatch rule says stop. A dispatcher following the gate and a dispatcher following the written line make opposite decisions on the same reading.
**Suggested direction:** after the cumulative measure lands, recompute the WARN and BLOCK fractions against measured true child-request sizes, and write the resulting single number into both the code and `robotnik.md` so the gate's threshold and the dispatch stop line are one figure.

### The header comment contradicts the implementation.
**Severity:** nit
**Where:** `scripts/dispatch-gate:12-17`
**Problem:** "How the number is obtained" states the most recent assistant message is the best estimate, but `prompt_estimate` deliberately uses the peak over a window, not the most recent (`:70`). Fix while touching the file.

**What a fix dispatch must land, in order:** (1) replace peak + worst-jump + inherit-ratio with a cumulative transcript measure, using `session_v2.tokens_input` or an explicit `session_message` sum, and re-fit WARN/BLOCK against measured true child sizes. (2) Require `--session` and make the bare invocation an error until the caller's own session id can be resolved; update `robotnik.md` to pass it. (3) Drop or rework the max-jump term so a large read does not inflate the projection. (4) Make the gate's BLOCK line and `robotnik.md`'s dispatch stop line the same number. All four belong in one follow-up commit on `main`.

---

## Security

*Owner: `Omega`.* Run 2026-11-25 12:28 UTC (2026-11-25 21:28 JST), dispatch `G2`. Read-only on code, no edits made. Verdict below.

### The gate is safe to read and safe to run. No injection, no credential exposure, no network.
**Severity:** none (confirmatory)
**Vector:** injection / secrets / supply-chain
**Where:** `scripts/dispatch-gate` (full file)
**Attack:** none identified.
**Impact:** none.
**Fix:** none required for these vectors.

All SQL uses `?` parameterized placeholders (`:41`, `:54`). The `--session` and `--latest-agent` values bind as parameters, not as interpolated SQL. No `eval`, no `subprocess`, no `os.system`, no shell invocation anywhere in the file. `db_path()` at `:33` is a hardcoded `os.path.expanduser` of a fixed path; no user input reaches it. The `sqlite3.connect(f"file:{path}?mode=ro", uri=True)` at `:119` builds a SQLite URI from that fixed path, not a shell command, and `mode=ro` is enforced by SQLite itself, not by the script's own guard. No network access: no `urllib`, `http`, `requests`, or socket import. No read of `~/AI/secrets/`. `--dry-run` bypasses the database entirely. CLI arguments are typed (`int`, `float`) at `:95-99`, so no path traversal or argument injection is reachable through them. The supply chain is Python standard library only (`argparse`, `json`, `os`, `sqlite3`, `sys`), no third-party imports, no `pip install` in any dependency file for this script. Clean.

### The session store read exposes no transcripts or credentials today, but the fix must keep it that way.
**Severity:** low
**Vector:** secrets
**Where:** `scripts/dispatch-gate:54` (`SELECT id, seq, data FROM session_message`)
**Attack:** the `data` column is a JSON blob containing `content` (the full message text), `finish`, `cost`, and `tokens`. The current code parses `data` at `:66` and extracts only `tokens.input`, `tokens.cache.read`, `tokens.cache.write` at `:69`, discarding `content`. Output is numeric counts, session IDs, and verdicts. No message content is printed, logged, or returned in the `--json` payload. Session IDs are opaque identifiers, not credentials. The gate never opens `~/AI/secrets/`. No credential is reachable through the current implementation.
**Impact:** none today. The residual risk is in the fix. A cumulative-transcript fix that estimates size by reading or measuring `content` (rather than summing numeric `tokens_input` from `session_v2` or summing `tokens.*` from `session_message`) would pass message text through the gate's process memory. If the fix also gains a `--debug` or error path that prints a malformed row, a secret that an agent accidentally leaked into a session transcript could appear in the gate's stderr. That is a stretch behind two preconditions (a leaked secret in a transcript, a debug path that prints raw rows), so `low`, but the fix should stay on numeric fields.
**Fix:** the cumulative measure must use `session_v2.tokens_input` or sum `tokens.input + tokens.cache.read + tokens.cache.write` per `session_message` row, never `json.loads(data)["content"]`. If a malformed-row error path is added, it should print the row `id` and `seq`, not the raw `data`.

### The gate cannot be relied on as a security boundary. It is an advisory early-warning instrument and the honest failure mode is operational.
**Severity:** informational (gate reliability, not a vulnerability)
**Vector:** authz (operational control trust)
**Where:** `scripts/dispatch-gate` (whole file), `tests/selftest.sh:144` (CI reads the real store with `--latest-agent robotnik`, exit ≤ 4 accepted)
**Attack:** the trust model is self-trust. The gate runs on the same machine as the dispatcher, under the same user, on the same session store. Anyone who can invoke the script can pass `--inherit-ratio 0.01` or `--limit 999999999` to force a `PASS`, or `--inherit-ratio 100` to force a `BLOCK`. There is no authentication, no signing, no separation between the gate and the gated. The gate is a guardrail the dispatcher chooses to consult, not a wall. This is by design and appropriate for a single-operator self-hosted runner.
**Impact:** the false-PASS case (54.3 percent projection, real child 262242) is an operational failure, not a security breach. The false-BLOCK case (98.1 percent, 74135 spike from planning-doc reads) forces an unnecessary handoff. Neither grants access, leaks data, or escalates privilege. The cost of a wrong reading is a wasted turn or a forced handoff, which Shadow's `## Review` covers as blockers for correctness. From a security standpoint, the instrument is advisory and must be treated as such in `robotnik.md` and AGENTS.md until the cumulative measure lands. The `necessary and not sufficient` language at `## Status` is the correct security posture for the interim.
**Fix:** none in code. The fix dispatch must not add authentication or signing to the gate (there is no adversary to authenticate against on a single-user machine), but it must not weaken the read-only guarantee (see finding 2) and it must land the cumulative measure so the advisory signal is actually useful.

### Threshold override through CLI flags is intentional and not a finding, but the 142281 de facto line is not enforceable by the gate.
**Severity:** low
**Vector:** authz (operational control)
**Where:** `scripts/dispatch-gate:96-98` (`--warn-fraction`, `--inherit-ratio`, `--block-fraction`), `## Status` (142281 as the dispatch stop line)
**Attack:** the team has adopted 142281 as the dispatch stop line, but the code's real BLOCK threshold is `int(262144 * 0.95) = 249036` and the WARN threshold is `int(262144 * 0.85) = 222822`. A dispatcher following the gate's verdict and a dispatcher following the written 142281 line make opposite decisions on any reading between 142281 and 222822. Shadow's fourth finding covers the disagreement. From a security perspective the concern is that the written rule and the gate's output are two different controls pointing in different directions, and a dispatcher who follows one and not the other has no consistent safety posture.
**Impact:** a dispatch that should have been blocked is dispatched (if following the gate) or a dispatch that was safe is blocked (if following the written line). Both are operational, not security failures.
**Fix:** after the cumulative measure lands, the fix dispatch must write the gate's threshold and the dispatch stop line as the same single number in both the code and `robotnik.md`. Shadow's `## Review` finding 4 states this. From a security standpoint the requirement is that there is one control, not two, so a dispatcher following the instrument and a dispatcher following the written rule arrive at the same decision.

### What the fix dispatch must land from a security standpoint.
The four items Shadow lists in `## Review` are the correctness fix set. Security adds one constraint to each:

1. **Cumulative transcript measure.** Must read numeric token fields (`session_v2.tokens_input` or per-row `tokens.*` sums). Must not read or log `session_message.data["content"]`. This keeps the transcript-blind property the current implementation has.
2. **Require `--session` and make the bare invocation a usage error.** Security-relevant because measuring a session the dispatcher is not running in means the gate's verdict describes a context that does not gate this dispatch. The fix should use `session_v2.parent_id` linkage if available, which Shadow noted. Until the caller's own session id can be resolved automatically, `--session` is required.
3. **Drop the max-jump spike term.** No security dimension. Correctness fix per Shadow.
4. **Unify the gate threshold and the dispatch stop line.** Security-relevant because two controls that disagree give a dispatcher no consistent safety posture. One number, written in both places.

### What stays operator-owned.
- The context limit itself (262144) and the `CHAOTIX_CONTEXT_LIMIT` environment override at `:95`. The limit is a model configuration fact the operator sets. The gate reads it, does not define it.
- The inherit ratio (or its replacement once the cumulative measure is validated against measured true child request sizes). The calibration constant is fitted to real failures the operator observes. The fix should re-fit it from evidence, not from a single incident.
- `agentsmd promote` for the four pending rules (already noted in `## Status`). Per AGENTS.md section 16, promotion is the operator's action.
- The decision to keep or change the trust model (self-trust, no authentication, no signing). On a single-user self-hosted runner this is correct. If the team ever runs on shared infrastructure, that decision needs revisiting. It is not a finding today.

**Summary.** The gate is clean against every injection, secrets, and supply-chain vector. It reads the session store read-only, extracts only numeric token counts, writes nothing, opens no network connections, uses parameterized SQL, imports only the Python standard library. The security concern is not vulnerability but trust: the instrument is advisory, its verdict is tunable by any invocation of the script, and until the cumulative measure lands, a single reading is an early-warning signal, not a gate. The honest failure mode when the gate is wrong is a wasted turn or an unnecessary handoff. No credential, no transcript content, and no privilege is exposed by the current implementation. The fix must preserve those properties while landing Shadow's four corrections. Selftest baseline 106 checks is consistent with the four dispatch-gate checks already in `tests/selftest.sh:132-151` against a broader suite. No finding blocks the fix dispatch.

---

## License (Charmy)

*Owner: `Charmy`.* Run 2026-11-25 13:19 UTC (2026-11-25 22:19 JST), dispatch `G4`. Read-only on code, no edits made. This section carries the audit scope written for the retired fifth reviewer in TASK-0044 `## Next Actions`. The `## License Audit (Flicky)` heading below is retained history per AGENTS.md section 2 rule 7; it is not renamed, not deleted, and it is superseded here.

**Gate:** `scripts/licence-check . --json` (exit 0). Output readable in full: `outcome: PASS`, `reasons: []`, 7 findings, `repo_license MIT` at `LICENSE`, `attribution ATTRIBUTION` at `NOTICE`, five `header MIT` findings (`planning/docs/TASK-0039-...md`, `scripts/rdp-input.c`, `scripts/rdp-pointer.c`, `scripts/remote/uinput-inject.c`, `tests/test_licence.py`). The same gate also runs as one assert in `tests/selftest.sh:123`.

**Outcome:** PASS

**Project license:** MIT (`LICENSE` at repo root, `Copyright (c) 2026 Howard`), with the `NOTICE` licence record at repo root. Appropriate. The change adds team-originated code to a tree already declared MIT, inherits no copyleft, and touches no declaration, so the `NOTICE` statement that the declaration reads MIT everywhere still holds at commit `418e8b2`.

**Imported code**

| Component | Source (repo @ ref) | License (verified at) | Obligations met | Status |
|---|---|---|---|---|
| `scripts/dispatch-gate`, 168 lines, new | this repo, commit `418e8b2` | MIT (root `LICENSE`, read at repo root) | n/a, team-authored. MIT's notice clause attaches to copies of MIT-licensed third-party code, not to the author's own new file | pass |
| stdlib imports `argparse`, `json`, `os`, `sqlite3`, `sys` (`scripts/dispatch-gate:21-25`) | CPython @ tag `v3.12.16`; host `python3-3.12.16-2.el10_3`, `python3-libs-3.12.16-2.el10_3` | Python Software Foundation License Version 2 (SPDX `Python-2.0`), read at `raw.githubusercontent.com/python/cpython/v3.12.16/LICENSE` 2026-11-25. RPM metadata declares `licence=Python-2.0.1 AND CC0-1.0` | yes. PSF clauses 2 and 3 attach to copies of, or derivative works prepared from, Python itself. The repo copies no Python source and prepares no derivative of it; importing the stdlib is use, not a derivative work. No distribution obligation arises | pass |
| SQLite engine behind `sqlite3` | distro `sqlite-libs-3.46.1-6.el10_2` (SQLite 3.46.1) | Public Domain, read at `sqlite.org/copyright.html` 2026-11-25 ("SQLite is in the Public Domain", "does not require a license"). RPM metadata declares `licence=blessing` | yes, none required. No header, no licence text, no NOTICE entry is owed for a public-domain component | pass |
| OpenCode, the writer of the session store the gate reads (`~/.local/share/opencode/opencode.db`) | `sst/opencode` @ `v2.4.1` (`opencode --version` prints `v2.4.1`; binary `/home/howard/.opencode/bin/opencode`) | MIT (`Copyright (c) 2025 opencode`), read at `raw.githubusercontent.com/sst/opencode/v2.4.1/LICENSE` 2026-11-25 | yes. The repo vendors none of opencode's source, so MIT's notice clause is not engaged. What the change consumes is data opencode writes: table names `session_v2`/`session_message` and numeric `tokens.*` fields. Reading data a program produces is not a copy of that program's code | pass |
| selftest block `tests/selftest.sh:132-152` | this repo | MIT (root `LICENSE`) | n/a. Invokes only the in-repo script and the shell. Adds no dependency: no `pip install` in the block, `team/requirements.txt` unchanged in `418e8b2` (`git show --stat 418e8b2`) | pass |
| AGENTS.md section 14 item 4, `.opencode/agents/robotnik.md` `## The dispatch ceiling` | this repo | MIT (root `LICENSE`) | n/a, team-authored prose. The only external string in either is the opencode runtime diagnostic `request (262191 tokens) exceeds the available context size (262144 tokens)`, quoted from the team's own log as a factual error message, not source code | pass |

**Derivation check, the specific question this dispatch carries.** Three facts, all read from the file. First, the script imports only the Python standard library (`scripts/dispatch-gate:21-25`), no third-party module, and `## Security` confirms the same by a different route (no `urllib`, `http`, `requests`, socket, subprocess, eval). Second, the code reads numeric fields only: `scripts/dispatch-gate:66-69` parses `data` and keeps `tokens.input`, `tokens.cache.read`, `tokens.cache.write`, and discards `content`. Output at `:150-158` is verdict text, session id, and integers. Third, every constant in the file is the team's own (`LIMIT_DEFAULT`, `WARN_FRACTION` at `:27-28`, the `--inherit-ratio`, `--block-fraction`, `--window` defaults at `:95-99`), and none was taken from opencode or from the store. The SQL in the file is three `SELECT` statements written here; no DDL, no source text, and no schema dump from opencode is committed anywhere in the tree (`grep -rn "CREATE TABLE\|session_v2"` over `*.py`, `*.sh`, `*.sql` outside `planning/`: no match). So no licence-obligated code is derived from session store contents. One forward constraint on the fix dispatch, aligned with `## Security` finding 2 and stated here because it is mine to state: a cumulative measure that reads `session_message.data["content"]` puts message text through the gate's output path, and a transcript can contain verbatim third-party source that the team did not author. A gate that prints such text would distribute it without its notice. Stay on numeric fields.

**Exceptions recorded:** none. No avoid-list licence appears in the change or in the tree. The gate's seven findings are MIT declarations plus the root `NOTICE` attribution entry. `team/licenses/policy.yaml` was not modified in this task.

**What I could not read.** Stated because an unreadable gate or sweep reads as FAIL, and these are the limits of what I did read.
- The scanner's header sweep is suffix-gated at `team/licenses/core.py:224`, so it never opens a file without a suffix. `scripts/dispatch-gate` and `scripts/licence-check` have no suffix and are not read by the gate at all. I read `scripts/dispatch-gate` in full myself to establish the import list, so the sweep gap is covered for this review. It is a coverage gap in my own tooling (`scripts/licence-check` has the same blind spot as the file it is gating), not a finding against this change, and it is mine to open in a separate task rather than to hand to Tails here.
- The CI `Licence Check` workflow did not run. The runner is not registered on a public repo (AGENTS.md section 6) and `## Test Results` records it NOT RUN. The local gate run above is the effective gate run for this change.
- The verification tooling Big wrote for this change (`t0043_gate_probe.py`, `t0043_block_probe.sh`, `t0043-work/` synthetic stores, `t0043-mutants/`) lives at `/home/howard/AI/booth-2026/t0042/`, which is not a git tree (`git -C /home/howard/AI/booth-2026 log` exits 128; the booth git repo is the sibling `booth-2026/repo`, head `b56d1df`), and `git ls-files` in that repo lists none of it. The synthetic stores built from `sqlite_master` DDL are therefore unpublished, so they create no distribution obligation for any published artefact. I did not re-audit the booth repo's own licence posture here; `R4`'s FAIL verdict on `7c4fa16` stands, the booth repo stays private, and the public flip is the operator's ruling on `C2` and `C3`.
- I read CPython's own LICENSE at `v3.12.16` and the distro's declared licence from RPM metadata, but I did not audit the Rocky patch set applied to `python3-3.12.16-2.el10_3`. Nothing in this change links against the interpreter build beyond importing the standard library, so the patch set is not in scope for this change.

**Verdict:** pass. The change imports no third-party code. The Python standard library (PSF License Version 2, permissive, GPL-compatible per the compatibility table in the upstream LICENSE) and SQLite (public domain) raise no distribution obligation for a script that imports the stdlib and links the distro engine. No copyleft is inherited, no avoid-list licence is present, no attribution obligation is unmet, and the project's own MIT declaration covers the new files. The `## Review`, `## Security` and `## Test Results` findings are correctness, harness, and reliability findings; none of them is licence-shaped, and none of them changes this verdict.

VERDICT: PASS

---

## License Audit (Flicky)

*Owner: `Flicky`.* Owed, not run. The licence gate ran inside `tests/selftest.sh` and passed.

---

## Test Results

*Owner: `Big`.* Run 2026-11-25 13:03 UTC (2026-11-25 22:03 JST), dispatch `G3`. Read-only on the
repo: no file, workflow, or VM was modified. Verification tooling is durable at
`/home/howard/AI/booth-2026/t0042/` (`t0043_gate_probe.py`, `t0043_block_probe.sh`,
`t0043_store_census.py`, `t0043_ratio_census.py`, `t0043_ratio_census_by_agent.py`, fixtures under
`t0043-work/`, mutants under `t0043-mutants/`), left in place per learned rule r002. All store reads
used `sqlite3.connect("file:...?mode=ro", uri=True)`; no message content was read or printed, only
numeric token fields, per `## Security` finding 2.

**Workflow run:**

| Check | What it exercises | Result | Notes |
|---|---|---|---|
| `tests/selftest.sh` | the whole local gate, 106 asserts | PASS | `SELFTEST: 106 checks passed (floor 100)`, exit 0 |
| dispatch-gate assert 1 (`selftest.sh:132`) | executable bit | PASS, falsifiable | mutant `M1_not_executable` fires it (see below) |
| dispatch-gate assert 2 (`:134`) | `--help` really runs | PASS, falsifiable | mutant `M2_syntax_error` fires it |
| dispatch-gate assert 3 (`:136`) | `--dry-run` really runs | PASS, falsifiable | mutant `M5_no_dry_run` fires it |
| dispatch-gate assert 4 (`:144-148`) | real read of the session store | PASS as written, **not falsifiable for a broken instrument** | ran, exit 0; the assertion is `[ "${DG_RC}" -le 4 ]` |
| estimator behavior, 30 synthetic scenarios | peak window, worst jump, inherit ratio, boundaries, empty and corrupt input | PASS, 30/30 as predicted | `python3 t0043_gate_probe.py`, `PROBE_RC=0` |
| assert falsifiability, 6 mutants of a copy | whether the four asserts can see a damaged gate | FAIL for assert 4 | `bash t0043_block_probe.sh`, `BLOCK_RC=0` (the probe itself passed; it records which asserts fire) |
| real-store census | which cumulative measure a fix could use | ran, produced evidence below | `t0043_store_census.py`, `t0043_ratio_census*.py` |
| CI `Team Selftest` workflow | the 106-assert gate on the self-hosted runner | NOT RUN | runner is not registered, the repo is public (AGENTS.md section 6). The workflow was read, not executed |
| Sparky / libvirt tests | Rocky 10 environment | NOT RUN, not applicable | `rpm -q raku` reports `package raku is not installed`; this change installs no package |
| Docker/podman tests | containerized component | NOT RUN, and blocked | `rpm -q podman podman-docker` reports both `not installed` on this host, which contradicts AGENTS.md section 13 ("Podman with podman-docker is installed"). Recorded here for whoever owns that claim |

**Checks requested vs run:** 8 verification layers requested for this brief, 6 executed, 2 did not run
(CI workflow, Sparky; the podman layer is additionally blocked by podman being absent). 30 synthetic
scenarios, 6 mutants, 3 store censuses, 1 full selftest, all executed.

**The four selftest checks do execute, and three of them are falsifiable.** `t0043_block_probe.sh`
replays `tests/selftest.sh:132-152` line for line against copies of the script under
`t0043-mutants/`. It records every assert that fires rather than stopping at the first.

| Mutant | What it breaks | exit of the real read | asserts that fired |
|---|---|---|---|
| `M0_pristine` | nothing (control) | 3 WARN | none |
| `M1_not_executable` | mode 0644 | 126 | 1, 2, 3, 4 |
| `M2_syntax_error` | the file no longer parses | 1 | 2, 3 |
| `M3_always_pass` | `used = est["child_projection"]` replaced by `used = 0`, so the gate can never WARN or BLOCK | 0 PASS | **none** |
| `M4_jump_inflated_x3` (`max(deltas + [0]) * 3`) | estimator regression, jump term tripled | 4 BLOCK | **none** |
| `M5_no_dry_run` | `--dry-run` renamed, so the flag is a usage error | 1 | 3 |
| `M6_blind_estimator` | all three token fields read as 0, peak always 0, gate blind to any store | 0 PASS | **none** |

`M3` and `M6` are the load-bearing results. A gate that has been made toothless (can never block) and
a gate that is blind (reads zero from every store) both run the full 106-assert suite green, because
assert 4 accepts any exit in 0..4 and discards stdout (`> /dev/null 2>&1`). Assert 4 can fire on
exactly one condition, a signal death (`128+n > 4`). Exit 1 (Python crash, proven by a malformed
`session_message.data` row: `json.decoder.JSONDecodeError`, exit 1) and exit 2 (database unavailable,
no session found, no assistant rows) both satisfy `[ "${DG_RC}" -le 4 ]`. The comment at `:140-141`
says "only a 2 is a broken one"; the assertion accepts the 2. That comment is not enforced by the
check next to it.

**Exit codes 0, 3, 4 are each reachable through a real database read, not only through `--dry-run`.**
Proven against synthetic stores in `t0043-work/`, each fixture built from the real
`session_v2`/`session_message` DDL dumped from `sqlite_master` on 2026-11-25, the gate invoked with a
substituted `HOME` (it has no `--db` flag) and never modified. Boundaries measured to the token:

| Fixture | peak | jump | projection | child | verdict | exit |
|---|---|---|---|---|---|---|
| flat 139263 | 139263 | 0 | 139263 | 222820 | PASS | 0 |
| flat 139264 | 139264 | 0 | 139264 | 222822 | WARN | 3 |
| flat 155647 | 155647 | 0 | 155647 | 249035 | WARN | 3 |
| flat 155648 | 155648 | 0 | 155648 | 249036 | BLOCK | 4 |

`>=` is inclusive at both lines, and `int(262144*0.85)=222822`, `int(262144*0.95)=249036` are the real
thresholds, confirming `## Review` finding 4 and `## Security` finding 4: the team's written 142281
line is 80541 tokens below the gate's own WARN line.

**What each term contributes, isolated.**

*Peak window.* A store whose oldest call is 250000 and whose newest 20 calls peak at 25000 reads
PASS (child 41600). The same store at `--window 30` reads BLOCK (peak 250000, child 401600). The
window is the only thing hiding a 250000-token call. A window of 20 or more is not a conservative
choice, it is a sampler.

*Peak is not newest, and the header comment at `scripts/dispatch-gate:12-17` is wrong.* A store with
rows 150000, 0, 0 (the partial-row case the code comments describe) reports `seq=1`, peak 150000,
samples 3. `--window 0` and `--window -5` are clamped by `max(1, a.window)` to 1 row, which selects
the newest partial row and reports peak 0, so a dispatcher who mistypes the window gets a confident
PASS on zero samples. `--window 1000` on a 3-row store returns samples 3, no off-by-one.

*Worst jump.* Two stores with an identical peak of 80000. A ramp (20 rows, +4000 each) reads PASS,
child 134400, 51.3%. A single spike (19 rows at 5865, last row 80000, jump 74135) reads WARN, child
246616, 94.1%. Same peak, opposite verdicts, the jump term alone moved 112216 tokens. Shadow's
`## Review` finding 3 is reproduced exactly from a fixture: peak 86611, jump 74135, projection 160746,
child 257193, 98.1%, exit 4, which is the 2026-11-20 18:20 reading. In that reading the jump term
contributes 46.1% of the projection (74135/160746).

*Inherit ratio, on the false-PASS fixture.* Peak 86393, jump 2533, projection 88926. At the shipped
ratio 1.6: child 142281, 54.3%, PASS, exit 0, the exact reading that preceded a real child request of
262242. At ratio 2.80: 248992, WARN. At 2.81: 249882, BLOCK. The flip point is 2.8002. At 2.949 the
projection reproduces 262242, the real failed request, exactly. The fitted 1.6 is 1.84 times too small
for the one incident it was fitted to. `--inherit-ratio 0.01` turns the 98.1% BLOCK store into a PASS
(child 889) and `--inherit-ratio 250` turns a peak of 1000 into a BLOCK (child 250000), which confirms
`## Security` finding 4 mechanically. `--limit 0` makes every reading BLOCK with no crash.

**The ratio constant models a quantity the store does not support, and this is the largest finding.**
`t0043_ratio_census_by_agent.py` measures real dispatches from `session_v2.parent_id`, which the gate
never reads. Of 280 sessions, 230 have a parent. For 229 `robotnik` to worker dispatches where both
sides recorded a prompt:

| parent agent | child agent | n | ratio median | ratio max | child first prompt median | dispatcher prompt median |
|---|---|---|---|---|---|---|
| robotnik | tails | 107 | 0.17 | 0.45 | 13646 | 77629 |
| robotnik | shadow | 35 | 0.17 | 0.37 | 13666 | 80619 |
| robotnik | omega | 20 | 0.20 | 0.54 | 13803 | 71782 |
| robotnik | big | 19 | 0.21 | 0.42 | 14670 | 73341 |
| robotnik | charmy | 13 | 0.19 | 0.38 | 13371 | 75951 |
| robotnik | knuckles | 13 | 0.13 | 0.30 | 13287 | 101249 |

All 229 together: min 0.08, median 0.18, p90 0.32, max 0.54. Zero of 229 have a true ratio above the
fitted 1.6. A child's first request is consistently *smaller* than its dispatcher's own last request,
median 18%, so `child_projection = projection * 1.6` is not an inherit ratio measured against the same
quantity on both sides. Two readings fit the data and I cannot separate them from the store alone. The
first is that children start fresh with the brief and grow their own context during their own run. The
second is that the TASK-0042 failures are missing from this census by construction, because a request
that is rejected before the model answers creates no `assistant` row, so the population this census can
see is only the dispatches that survived, which is precisely the population where a false PASS is
cheapest. Either way the 1.6 is not fitted to the measured quantity, and the census cannot calibrate
it because the failures are invisible in the schema.

**Where the ceiling is actually reached, measured.** Across 276 sessions with a recorded prompt, the
largest in-flight prompt values are 262113, 262015, 261895, 261507, 260198, 258705, 251876, 238522.
Eleven sessions reached the WARN line on their own measured peak, seven reached the BLOCK line, and
all seven are `tails` sessions with a `parent_id`. No `robotnik` session reached even the WARN line,
and the highest robotnik peak in the store is 186176 (71.0%). The ceiling is being touched inside
long-running children (the 262113 session has 131 assistant rows), not at the dispatcher boundary the
gate measures. Today's default invocation reads peak 65646, jump 3543, child projection 110702, PASS,
42.2%, while the measured median child first request for a robotnik dispatch is about 13600, so the
instrument overstates a typical child by roughly 8 times and its BLOCK line at 249036 would have
flagged three sessions that completed successfully. The margin between the largest recorded successful
request (262113) and the recorded failure (262242) is 129 tokens, so no fraction of the limit at 85%
or 95% can be honest about the boundary; the useful gate quantity is a measured in-flight prompt with
a margin, not a fraction.

**The per-row token data a fix needs does exist, and one earlier claim in this doc is wrong.**
Census of the real store on 2026-11-25: 10719 assistant rows, 10655 carry a `tokens` object with a
non-zero prompt, 64 carry no `tokens` key, 0 are unparseable. `## Status` (2026-11-20, `Robotnik`)
states that `session_message.data` "carries content, `finish`, `cost` and no token counts", and
`## Security` finding 2 states the rows carry `tokens`. The measurement supports Security and
contradicts the Status sentence for 99.4% of rows. Per-row `input + cache.read + cache.write` sums are
available, so the cumulative measure `## Review` finding 1 asks for is implementable without reading
`content`. Note also that `session_v2.tokens_input` is *not* the same quantity: it disagrees with the
sum of its own rows in 278 of 280 sessions (it excludes cache reads), so switching to `tokens_input`
alone would change what is being measured, not merely how it is measured.

**Defect 2 reproduced deterministically.** A fixture with two `robotnik` sessions, `dead` at
`time_updated=999` and `live` at 500, shows the bare `--latest-agent robotnik` form selecting `dead`
(child 249036, BLOCK) while `--session live` on the same store reads PASS (child 19200). The store's
own cumulative column for `dead` is 900000 against 42559 for `live`, a field the gate never reads.
Opposite verdicts from the same store, decided only by the selector. On today's real store the two
orders agree (newest `robotnik` by `time_updated` and by `time_created` are the same session), so the
defect did not bite today by luck of the ordering, not by design.

**Read-only and idempotence proven.** Three invocations against one fixture produced byte-identical
stdout, and the fixture DB sha256 was identical before and after (`12b33da58450...`), with no `-wal`
or `-shm` file created. Re-running the gate is a no-op.

**Check-count delta I measured, not inherited.** `bash tests/selftest.sh` on 2026-11-25 reports
106 checks, floor 100, exit 0. Against the stated baseline of 106 the delta is **0**. Attribution by
instrumenting `PASS()` in a `git ls-files` copy at `/tmp/opencode/t0043/repo` (that copy reports 108
because it adds two bash-shebang files to the syntax loop; the real repo numbers are below): bash
syntax 17, python syntax 4, YAML 21, JSON 0, no-turn-caps 1, roster 2, config gate 1, pytest 29,
licence 1, dispatch-gate 3 + 1, gateway 1, remote inventory 1, remote executable bits 1, remote
`--help` 8, remote dry runs 3, remote build 1 + 4, credential scan 2, host key pinning 1, skill 1,
run-body interpolation 1. Fixed asserts 77, pytest 29, total 106. The header comment at
`tests/selftest.sh:22-23` still says "76 fixed PASS asserts ... total 105", so the suite is
understated by one check in its own documentation.

**Named drops, none of them caught by the floor.** Slack between the count and the floor is 6
(106 against 100).
1. shellcheck block `tests/selftest.sh:48-60` contributed **0** asserts on this host (`rpm -q
   shellcheck`: not installed). 17 bash-shebang files exist, so 17 asserts (16% of the suite) are
   currently absent, and 17 > 6, so the floor structurally cannot see this drop. The count would be
   123 with shellcheck installed.
2. JSON parse block `:70-74` contributes **0** asserts permanently: `find team .github -name '*.json'`
   returns 0 files. The block, its note, and its floor contribution are decorative.
3. dispatch-gate real read `:142-152` is guarded by store presence and contributes 1 here, 0 on a
   machine without `~/.local/share/opencode/opencode.db`, taking the suite to 105, still green.
4. gateway selftest `:157-163` contributes 1 here (`/usr/local/bin/agentgateway` present), 0 if the
   binary moves, taking the suite to 105, still green.
5. pytest contributes 29 measured through `grep -Eo '[0-9]+ passed'` at `:117`. A deselected or
   skipped test lowers that number, and 29 dropped to 23 or below would breach the floor; a drop of
   6 or fewer is invisible. This is the same class of silent reduction AGENTS.md section 18 says the
   CI count assertion guards, and the guard has slack in it.
6. No matrix exists in any workflow (`grep -c matrix` returns 0 for all eight files under
   `.github/workflows/`), so AGENTS.md section 6's `fail-fast: false` rule has nothing to apply to,
   and no matrix silently dropped because none was requested. The `Team Selftest` job runs the whole
   suite twice (its count step re-runs `tests/selftest.sh`), so CI asserts the count of a second run
   rather than the run that produced the tick.

**Checks that did not run, named.** The `Team Selftest`, `Licence Check`, `Static Checks`,
`Secret Scan`, `Secret Scan (self)`, `Planning Doc Gate`, `Deploy`, and `Test Runner` workflows: none
executed, the runner is not registered on a public repo. Sparky: not run, Raku absent. Podman
container tests: not run, podman absent from the host. The gate against the *calling dispatcher's own*
session id: not run, and not runnable, because nothing in the toolchain exposes the caller's session
id to the script (`## Review` finding 2, `## Next Actions` row 1 both require it). The `--dry-run`
path was run, but it asserts nothing about the estimator, so it is not evidence the estimator works.

**Is `--dry-run` load-bearing for CI.** Yes for the suite, no for the instrument. Load-bearing in two
narrow senses: removing the flag trips assert 3 (`M5_no_dry_run` fired it, exit 2), and it is the only
dispatch-gate assert that does not need a session store, so in an environment without
`~/.local/share/opencode/opencode.db` it is the only dispatch-gate coverage left after the guarded
real read vanishes. Not load-bearing in the sense that matters: it fabricates
`peak_prompt: 0, samples: 0, projected_prompt: 0` at `scripts/dispatch-gate:106-108` and returns PASS,
so `M3_always_pass` and `M6_blind_estimator`, a toothless gate and a blind one, pass it and pass the
whole 106-check suite. For CI today the point is latent anyway, since CI does not run at all, and on
the self-hosted runner the store exists. Recommendation, harness side and mine to fix: add a
checked-in synthetic store fixture and assert a known peak, jump, projection, and verdict against it,
so CI's dispatch-gate coverage becomes falsifiable without the live session store. That is a Big
change, not a code change.

**What a dispatcher-day reading would have to assert for the instrument to prove itself.** Today a
dispatcher-day record is a list of verdicts with no truth values attached. Six assertions would make
the instrument testable, all computable from `opencode.db` with the tooling already written:
1. Session identity. For every gate reading in the day, the measured `session_id` must equal the
   dispatcher's own session id. Currently unsatisfiable by design (`--session` is optional), and
   measured here to be satisfiable by luck on one day only.
2. Prediction against measured truth. For every dispatch, record the gate's `child_projection` next to
   the child's own first-request prompt read from the store. The instrument's claim is
   `projection * 1.6`; on 229 dispatches the measured ratio distribution is 0.08 to 0.54 with median
   0.18, so this assertion fails today and defines what a corrected instrument must satisfy.
3. Miss detection. Any session in the day whose own measured peak in-flight prompt reaches 249036 must
   have had a WARN or BLOCK reading before it. Today the store contains seven such sessions (all
   `tails` children) and the gate never measured any of them, because it measures the dispatcher.
4. False-PASS accounting. Every request that failed with `exceeds the available context size` must
   have had a preceding BLOCK or WARN on the same session. TASK-0042's two failures, and the
   2026-11-20 false PASS at 54.3%, are the counter-examples on the record.
5. Term-share guard. For each reading, publish `per_call_growth / projected_prompt` and require a cap.
   The 2026-11-20 BLOCK reading had a 46.1% jump contribution; the false PASS had 2.8%. A reading
   dominated by a spike from the dispatcher's own planning-doc reads is a different event from a
   session that is genuinely growing, and the current output cannot tell them apart.
6. Threshold honesty. The BLOCK line must sit between the largest request the store proves succeeded
   (262113) and the smallest that failed (262242). That window is 129 tokens wide, so the line has to
   be stated as a measured in-flight prompt plus a declared margin for the next tool result, not as a
   fraction of 262144. A day whose gate never read WARN while the store contains a session above the
   line is a day the instrument missed, and that is the day-level pass condition.

**Verdict:** the four dispatch-gate checks execute, and three of the four are falsifiable; the fourth
is not, and that is a harness bug that stays with Big. FAIL 1, harness: `tests/selftest.sh:147`
asserts `[ "${DG_RC}" -le 4 ]`, which accepts exit 2 (the code the adjacent comment names as a broken
instrument) and exit 1 (an unhandled crash, proven with a malformed `data` row), and discards stdout,
so no number the gate produced is ever checked. Proven by `M3_always_pass` and `M6_blind_estimator`,
which run the full suite green. Fix is mine: a checked-in synthetic store fixture with an expected
peak, jump, projection, and verdict, plus a `case` on the exit code that treats 2 as a failure and
treats the verdict string as data. FAIL 2, code, goes to Tails: the inherit ratio is not a ratio of
the quantity it names. Measured on 229 real `robotnik` to worker dispatches the child's first request
is 0.08 to 0.54 of the dispatcher's own last request, median 0.18, and zero of 229 exceed 1.6, while
the one incident the constant was fitted to implies 2.949. `## Review` finding 1 stands, and my
measurement adds the direction: the fix should gate on the dispatcher's own measured in-flight prompt
(per-row `input + cache.read + cache.write`, available on 10655 of 10719 rows) rather than on a
multiplier of a child that this store shows starting small. FAIL 3, code, goes to Tails: the jump term
moves 112216 tokens between two stores with the same peak, contributing 46.1% of the projection in the
recorded 98.1% BLOCK reading, and `--window` is a sampler that makes a 250000-token call invisible at
the shipped window. `## Review` findings 3 and 5 are confirmed by measurement. PASS, with evidence:
exit codes 0, 3, 4 each reachable through a real store read, boundaries inclusive to the token
(222820 PASS, 222822 WARN, 249035 WARN, 249036 BLOCK), exit 2 reachable through three distinct broken
states, read-only and idempotence proven, `--dry-run` load-bearing for the suite and not for the
instrument. Two contradictions with earlier sections, stated rather than smoothed: the `## Status`
claim that `session_message.data` carries no token counts is wrong on 99.4% of rows, and the store
shows the ceiling reached in `tails` children, never in a `robotnik` dispatcher, which is a different
failure boundary from the one AGENTS.md r001 and `robotnik.md` describe. Both explanations of the
TASK-0042 failures remain open, because a rejected request writes no assistant row and is invisible to
this census. The instrument remains necessary and not sufficient, and `## Review`'s four-part fix set
is the right one, with my addition that assert 4 must become falsifiable before any follow-up is
called tested.

---

## Docs

*Owner: `Vector`.* `AGENTS.md` section 14 item 4 and `.opencode/agents/robotnik.md` were updated as part of the change. README does not yet describe the gate.

---

## Release

*Owner: `Knuckles`.* Branch `task-0043-dispatch-gate`, commits `418e8b2` and the earlier record commit, GPG-verified with `git log --show-signature` as Team Chaotix. PR #1 opened and merged with `merge_method=merge`, merge commit `44a017e`. Pushed through the pre-push hook, which ran `tests/selftest.sh` and reported 61 checks. GitHub writes used the token at `~/AI/secrets/token.md` read at run time, no token in any remote URL, commit message, log, or committed file. DONE is not fully ticked, the review chain is open, recorded above.

---

## Archive

*Owner: `Espio`, the only agent that deletes.*

**Pruning log**

| Date | What was pruned or compressed | Rough size |
|---|---|---|
