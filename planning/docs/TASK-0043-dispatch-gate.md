# TASK-0043 — Dispatch gate, the dispatcher's context ceiling made mechanical

> **Section order below is fixed.** Each agent writes to its own section and no other. `Robotnik`
> reads only `## Status` and `## Next Actions`. Do not reorder, rename, or remove sections.

- **Created:** 2026-11-15
- **Requested by:** the operator, directly, after TASK-0042 lost two dispatches to a context-size error.

---

## Status

**Now:** Implemented, selftest green at 61 checks (baseline 56), committed on branch `task-0043-dispatch-gate`, merged to `main` as pull request #1, merge commit `44a017e`, pushed. Verified on `origin/main`, `scripts/dispatch-gate`, the selftest block, the AGENTS.md rule and the robotnik.md section are all present. The review chain is **not** run yet and is owed by a fresh `Robotnik` session.

**Gate defect found in live use (2026-11-20, `Robotnik`), owed to the review chain and to a fix dispatch.** The gate returned `PASS` for a dispatch that then failed outright. Gate output at the time was peak 86393 over 20 calls, worst jump 2533, dispatcher projection 88926, child projection 142281 of 262144, verdict `PASS`, 54.3 percent. The next dispatch failed with `request (262242 tokens) exceeds the available context size (262144 tokens)`. The real child request was 1.85 times the projection and 3.04 times the measured peak. Cause, stated as reasoning rather than as a measured fact about the code. The estimator extrapolates a peak prompt over a recent call window and multiplies by an inherit ratio fitted to one earlier incident, while a child appears to inherit the dispatcher's whole transcript, so the error grows with session length and a PASS late in a long session is the least trustworthy reading the instrument gives. A fix should measure cumulative transcript size, or read the dispatcher's own last request size from the session store, instead of extrapolating from a peak. Until that lands the gate is necessary and not sufficient, and this is the second occurrence of the failure mode the gate exists to catch.

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
- [ ] `Shadow`, `Omega`, `Big`, `Charmy`, `Flicky` each review the change. Owed by a fresh `Robotnik` session, this row stays open until they run.
- [ ] `agentsmd learn` proposes the lesson once the project is initialized for agentsmd, which it is not. Recorded in TASK-0042 `## Next Actions`.

---

## Next Actions

- [ ] `Robotnik`, fresh session, run the gate: `scripts/dispatch-gate`. Then dispatch the review chain for this change, `Shadow` → `Omega` → `Big` → `Charmy` → `Flicky`, one at a time.
- [ ] `Tails`, if any reviewer finds a fault, fix it in a follow-up commit on `main`.
- [x] Initialize agentsmd for this project, done 2026-11-19 by `Robotnik`, four rules proposed and pending. `agentsmd promote` is the operator's action.

---

## Plan

*Owner: `Amy`.* Not run. The task was a single instrument requested directly by the operator, and the session that received it could no longer delegate.

---

## Implementation

*Owner: `Tails`.* Done by `Robotnik`, reason recorded in `## Status`. Design notes, peak over a window rather than the newest message, because the newest assistant row is often partial with zero tokens recorded; worst jump rather than average growth, because one large tool result is what breaks a dispatch; inherit ratio 1.6 as a fitted constant from the observed failure.

---

## Review

*Owner: `Shadow`.* Owed, not run.

---

## Security

*Owner: `Omega`.* Owed, not run. The gate reads the session store read-only and writes nothing, and it never prints message contents, only counts.

---

## License (Charmy)

*Owner: `Charmy`.* Owed, not run. No third-party code is imported, the gate uses only the Python standard library.

---

## License Audit (Flicky)

*Owner: `Flicky`.* Owed, not run. The licence gate ran inside `tests/selftest.sh` and passed.

---

## Test Results

*Owner: `Big`.* Owed, not run. `bash tests/selftest.sh` printed `SELFTEST: 61 checks passed` on 2026-11-15 against the recorded baseline of 56.

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
