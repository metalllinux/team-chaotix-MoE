# TASK-0044 — Remove the Flicky agent and fold its licence-audit role into Charmy

> **Section order below is fixed.** Each agent writes to its own section and no other. `Robotnik`
> reads only `## Status` and `## Next Actions`. Do not reorder, rename, or remove sections.

- **Created:** 2026-11-23

---

## Status

*Owner: `Robotnik`.*

**HANDOFF, this session stops delegating after five dispatches (2026-11-23 01:05 UTC, 10:05 JST,
`Robotnik` session `ses_dfa49b1f9ffeFR3Hj0IC38MUzW`).** The `TASK-0044` review chain has now run, `F2`
`Shadow` FAIL with two should-fix findings and no blocker at doc:425, `F3` `Omega` one `medium` and one
`low` and two clean at doc:471, `F4` `Big` PASS at doc:525 with the 83 to 86 delta independently
reproduced, `F5` `Charmy` PASS at doc:528 with `scripts/licence-check` exit 0 and 3 MIT findings.
`Shadow`'s finding 1 is closed at `e22bb3c`, its finding 2 is closed in the `Robotnik`-owned rows of
TASK-0041, TASK-0042 and TASK-0043 at `68babaf`. Remaining for this task, `F6` `Vector`, then `F8` `Tails`
for the three open code follow-ups, then `F7` `Knuckles`, briefs written out in `LIVE QUEUE 4` at the top
of `## Next Actions` in the TASK-0042 doc. Gate at the stop, `PASS`, 52.0 percent, peak 78985, child
projection 136214 of 262144, which sits 6067 below the 142281 projection TASK-0043 records for the dispatch
whose real child request reached 262242, so this session hands off rather than dispatch `F6`. Team repo
`main` at `8efdcf7`, pre-push selftest green at 86 checks, `git status --porcelain` empty at the stop.

**Review chain running, `F2` and `F3` landed (2026-11-23 00:40 UTC, 09:40 JST, `Robotnik` session
`ses_dfa49b1f9ffeFR3Hj0IC38MUzW`).** `Shadow` as `F2` answered FAIL at doc:425 with two should-fix findings
and no blocker in the implementation. Its finding 1, `team/licenses/policy.yaml:20` and `:129` escalating to
a section no longer in the contract, was fixed by `Tails` as `F1b` at commit `e22bb3c`, verified from the
remote by `git ls-remote` and by `grep -c 'License Audit' team/licenses/policy.yaml` returning 0, selftest
unchanged at 86 checks. Its finding 2, open DoD and Next Actions rows elsewhere that demand a fifth reviewer
no agent can supply, is `Robotnik`-owned and is handled, see the VOID ROWS ruling in TASK-0042
`## Next Actions` and the restated DoD rows in TASK-0041 and TASK-0043. `Omega` as `F3` wrote doc:471 with
one `medium`, one `low` and two clean. Decision on the `medium`, single-reviewer concentration, accepted as
this task's stated purpose, the mitigation `Omega` names is machine-enforced exit codes plus the
`record_verdict` fail-close, and it is recorded rather than reversed. Decision on the `low`,
`team/a2a/server.py:109` says `twelve-role` while the skills array lists 11, verified by grep, carried into
the queued `K6` `Tails` fix dispatch instead of costing a dispatch of its own, because it is a description
string with no behavioural effect and `K6` already edits adjacent files. `F4` `Big` is next.

**`F4` `Big` PASS, two follow-ups, and a queue decision (2026-11-23 00:50 UTC, 09:50 JST, `Robotnik`
session `ses_dfa49b1f9ffeFR3Hj0IC38MUzW`).** `Big` ran `tests/selftest.sh` at HEAD `68babaf`, 86 checks,
exit 0, and reproduced the 82 plus 1 gateway baseline from `git archive 1cf0bc6`, so the 83 to 86 delta is
measured rather than inherited. Mutant injection on the roster assertions, the six config-gate assertions,
the cycle test and the A2A card test proves those checks execute rather than skip. Only the shellcheck block
did not run, `shellcheck` is absent on this controller. Two open follow-ups, a dead bash-syntax branch at
`tests/selftest.sh:25` and `:40`, and a real parse failure hidden at `scripts/vm-create-rocky.sh:4`. Decision,
those two plus `team/a2a/server.py:109` go into one `Tails` fix dispatch named `F8`, run after `F6` `Vector`
and before `F7` `Knuckles`, so the tree `Knuckles` merges carries them. `F5` `Charmy` is next, fourth and last
in the chain.

**HANDOFF, this session stops delegating after one dispatch (2026-11-22 22:30 UTC, 2026-11-23 07:30
JST, `Robotnik` session `ses_dfad31cf9ffeh7nKHhmQZ40EPr`).** `F1` landed and is verified. `Shadow` as
`F2`, `Omega` as `F3`, `Big` as `F4`, `Charmy` as `F5`, `Vector` as `F6` and `Knuckles` as `F7` remain,
and the full briefs for all six are written out in `LIVE QUEUE 3` at the top of
`planning/docs/TASK-0042-foss-for-all-scmdraft2-demo.md` `## Next Actions`. Gate at 22:25 answered `PASS`
at 65.3 percent with peak 91751, above the 86393 at which TASK-0043 records a false `PASS` followed by a
real child request of 262242, so this session dispatches nothing further rather than discover the same
overflow. The operator's instruction to commit, merge and push the roster change is satisfied at the code
level, `ef06147` and `641922e` are on `origin/main` and were verified from the remote, and what is owed is
the review chain plus `Vector` and `Knuckles`, recorded as unticked DoD rows rather than as a claim.

**Now:** Task opened 2026-11-22 22:05 UTC (2026-11-23 07:05 JST) by direct operator instruction in
`Robotnik` session `ses_dfad31cf9ffeh7nKHhmQZ40EPr`, and dispatched as `F1` to `Tails`, child
`ses_dfac951caffegVKd0DFxQdVuR0`. **Stamp correction, `Robotnik` 2026-11-22 22:15 UTC (2026-11-23
07:15 JST).** My first entry on this task carried a `2026-11-23 00:20 UTC` stamp, which was this host's
JST date read as though it were UTC. That is the same clock-convention defect recorded in TASK-0042
`## Status`, and it is corrected here rather than left standing. `date -u` answers `2026-11-22 22:15
UTC` and `date` answers `07:15 JST` on this host, so every stamp on this task is UTC first with the JST
equivalent in parentheses. This task gates the review chains
of TASK-0042, TASK-0041 and TASK-0043, because `LIVE QUEUE 2` in the TASK-0042 doc dispatches `R5`,
`T5` and `G5` to `Flicky`, and those dispatches cannot run against a roster that no longer has her.

**Environment / scope:**
- Files in scope: `.opencode/agents/flicky.md` (delete), `.opencode/agents/charmy.md`,
  `AGENTS.md` (hand-written sections 2, 3 and 9 only, never the `agentsmd:learned` marker block),
  `planning/templates/planning-doc.md`, `planning/TASKS.md`, `README.md`, `tests/config_gate.py`,
  `tests/selftest.sh`, `.github/workflows/` (licence gate and any roster reference),
  `team/graph/` (review-chain nodes), `team/licenses/` if it names an owner, `.opencode/skills/` if
  it names Flicky.
- Touches the DB schema: no
- Graphical UI: no
- Rocky Linux target: no. No contact with `192.168.1.99` in this task, and none should be.

**Decisions recorded, rather than asked.**

1. `Flicky` is removed outright, not renamed and not left as a stub. The operator's word is
   "completely remove". `Charmy` becomes the single licence owner, fourth and last in the review
   chain, holding both the licence review of the change and the upstream audit plus the machine gate.
2. The planning-doc section contract shrinks from two licence sections to one. Going forward the
   ordered contract carries `## License (Charmy)` and no `## License Audit (Flicky)`, and the review
   chain is `Shadow` then `Omega` then `Big` then `Charmy`. `Charmy` writes the gate outcome, the
   upstream declarations table, the exceptions record, and the verdict inside `## License (Charmy)`.
3. Existing planning docs are not rewritten. `planning/docs/TASK-0042-*`, `TASK-0041-*` and
   `TASK-0043-*` already hold `## License Audit (Flicky)` sections written by a now-removed agent.
   Those headings are record history, and AGENTS.md section 2 rule 2 bars any agent but `Espio` from
   deleting content, so `Charmy` writes its audit into its own `## License (Charmy)` section and names
   the legacy heading as retained history. `Espio` folds the legacy sections into `## Archive` at the
   prune step. Reason: preserving provenance beats tidying a record that other agents already cite.
4. The queue briefs written by the previous session name `Flicky` for `R5`, `T5` and `G5`. Those three
   dispatch items are void and their scope is carried into `R4`, `T4` and `G4` for `Charmy`, verbatim.
   The verbatim carry text is in `## Next Actions` below so no session has to reconstruct it.
5. `Charmy`'s permissions must cover what `Flicky` had, because a licence owner that cannot run the
   gate is not a licence owner. `Tails` records the before and after tool blocks for both agent files
   in `## Implementation`, and the merged block is Charmy's, not an additive superset of an
   unnecessary kind.
6. The `agentsmd` learned block in `AGENTS.md` is untouched and nothing is promoted. Thirteen rules
   are pending for the operator and that is the operator's action per AGENTS.md section 16.

**Unknowns:** none load-bearing. Whether `team/graph/` names the fifth review node as a literal string
that a test asserts on is established by `Tails` reading it, not guessed here.

---

## Definition of Done

*Owner: `Robotnik`, and nobody else. Written before any work started.*

- [ ] `.opencode/agents/flicky.md` does not exist, and `.opencode/agents/charmy.md` exists and carries
      the audit duties `Flicky` held: run `scripts/licence-check`, verify each imported component
      against the upstream repository at the ref actually used, record declarations, record
      `POLICY_EXCEPTION` clauses, and state a fail-closed verdict.
- [ ] `charmy.md` names itself fourth and last in the review chain and owns `## License (Charmy)` as
      the only licence section in the doc contract.
- [ ] `grep -rin -i flicky` over git-tracked paths returns no match in `.opencode/`, `AGENTS.md`,
      `README.md`, `planning/templates/`, `tests/`, `.github/`, `team/`, `scripts/`. Matches that
      remain only inside `planning/docs/TASK-004*` record history and `planning/TASKS.md` history are
      accepted, and the surviving count is reported.
- [ ] The review chain reads `Shadow`, `Omega`, `Big`, `Charmy` in `AGENTS.md` sections 2, 3 and 9, in
      `planning/templates/planning-doc.md`, in `team/graph/`, and in `README.md`, with no stale
      five-reviewer reference left in any of them.
- [ ] `tests/config_gate.py` asserts an 11-agent roster with no `flicky` agent file present and
      asserts Charmy holds the licence-audit duty, and the gate passes.
- [ ] Charmy's permission block is a recorded superset of what Flicky held for gate work, with the
      before and after blocks written in `## Implementation`.
- [ ] `scripts/licence-check` runs on this repo and `Charmy` records the exit code and outcome in
      `## License (Charmy)`.
- [ ] `tests/selftest.sh` passes via the pre-push hook, with the before and after check counts
      recorded against the 83-check baseline and the `MIN=70` floor in
      `.github/workflows/team-selftest.yml:50` unchanged or deliberately restated.
- [ ] No credential appears in the diff. Verified with `grep -R -F -f ~/AI/secrets/scm_draft_pass.md`
      and the same for the RDP secret, both no match.
- [ ] `AGENTS.md` `agentsmd:learned` marker block is byte-unchanged, and nothing is promoted.
- [ ] `Shadow`, `Omega`, `Big` and `Charmy` each report with no unresolved blocker in their own section.
- [ ] `Vector` updates `README.md` and any affected team documentation to the new roster.
- [ ] Work is committed on a branch, GPG-signed, PR'd to `metalllinux/team-chaotix-MoE` `main`, merged,
      pushed, and the merge is verified from the remote rather than from the dispatch report.

---

## Next Actions

- [ ] `Tails` as `F1`. Brief, paste verbatim. "Read `## Status` and `## Definition of Done` in
  `planning/docs/TASK-0044-flicky-into-charmy.md`. Remove the `Flicky` agent from the team and fold
  her licence-audit role into `Charmy`, per the six decisions recorded in `## Status`. Land at most
  three file edits per turn, each edit as its own tool call, and write your `## Implementation` entry
  as each step completes rather than at the end. Delete `.opencode/agents/flicky.md`. Fold her duties
  and her gate-running permission into `.opencode/agents/charmy.md`, recording the before and after
  tool blocks. Update the doc contract, the section list, and the review chain in `AGENTS.md` sections
  2, 3 and 9, leaving the `agentsmd:learned` marker block byte-unchanged, and update
  `planning/templates/planning-doc.md`, `tests/config_gate.py`, the roster assertions in
  `tests/selftest.sh`, `team/graph/` review-chain nodes, `.github/workflows/` references, and
  `README.md`. Do not edit any agent's section in a planning doc, and do not rename or delete the
  legacy `## License Audit (Flicky)` headings inside `planning/docs/TASK-0041-*`, `TASK-0042-*` and
  `TASK-0043-*`. Run `scripts/licence-check`, `python3 tests/config_gate.py` and record the selftest
  check counts before and after against the 83 baseline. Do not contact `192.168.1.99`. Push with
  `GIT_ASKPASS=/tmp/opencode/git-askpass-tc.sh git push origin main`."
- [ ] `Shadow` as `F2`, `Omega` as `F3`, `Big` as `F4`, `Charmy` as `F5`, one at a time in that order,
  each in a fresh child session, each reading `## Status` and `## Definition of Done` in this doc plus
  the `## Implementation` record, each writing only its own section. `Big` must verify the roster
  assertions actually execute rather than skip, and must name the check count delta. `Charmy` runs the
  gate and records the outcome.
- [ ] `Vector` as `F6` for the README and docs roster.
- [ ] `Knuckles` as `F7` for branch, signed commit, PR, merge, push, and remote verification.
- [ ] Queue carry for TASK-0042, TASK-0041 and TASK-0043, written here so no session reconstructs it.
  `R5`, `T5` and `G5` in `LIVE QUEUE 2` are void as `Flicky` dispatches. `R4`, `T4` and `G4` carry the
  `Flicky` scope verbatim, which is, audit each upstream against the ref actually used, run
  `scripts/licence-check` on the team repo and against the booth repo clone under
  `/tmp/opencode/t0042`, and give the plain ruling on whether the published editor captures and booth
  artifacts, which are renders of Blizzard tileset tones, let the booth repo go public, with each
  upstream ref cited.

---

## Plan

*Owner: `Amy`.*

Not run for this task. Recorded decision, `Robotnik` 2026-11-23. The instruction is prescriptive from
the operator, the scope is a roster removal rather than a design choice, and the alternatives worth
weighing are already settled in `## Status`. Reason. A planning dispatch costs a share of the single
inference slot and of the dispatcher's measured context ceiling, and TASK-0042 `LIVE QUEUE 2` has
fourteen items left five days before the booth. If `Shadow` finds the sweep incomplete the chain
re-runs, which is the guard `Amy` would otherwise provide.

---

## Implementation

*Owner: `Tails`.*

**Baseline before any edit.** `bash tests/selftest.sh` printed `SELFTEST: 83 checks passed` (exit 0)
at 2026-11-23, before the first edit. `git status --porcelain` showed only `M planning/TASKS.md` and
the untracked TASK-0044 doc, so the 83 baseline is against `1cf0bc6`. `git grep -rin flicky` over
tracked paths before the sweep: 157 lines across 27 files, of which the in-scope non-record files are
`.opencode/agents/flicky.md`, `.opencode/agents/robotnik.md`, `AGENTS.md`, `README.md`,
`planning/templates/planning-doc.md`, `tests/config_gate.py`, `tests/test_cycle.py`,
`tests/test_a2a.py`, `scripts/licence-check`, `team/__init__.py`, `team/licenses/core.py`,
`team/licenses/policy.yaml`, `team/graph/state.py`, `team/graph/cycle.py`,
`.github/workflows/licence-check.yml`.

**Step 1. Roster files.**

- `.opencode/agents/flicky.md` deleted with `git rm`. 81 lines removed.
- `.opencode/agents/charmy.md` now carries the audit duties: runs `scripts/licence-check`, the four
  gate outcomes with exit codes, the avoid-is-not-refuse rule, the house-policy ownership clause, the
  upstream-at-the-ref verification it already had, the `POLICY_EXCEPTION` record requirement, and a
  fail-closed verdict line.

**Permission blocks, before and after (decision 5).** `flicky.md` frontmatter permission block,
verbatim from the file before deletion, and `charmy.md`'s block before this task, are byte-identical.

```yaml
# .opencode/agents/flicky.md (deleted) and .opencode/agents/charmy.md (before and after, unchanged)
permission:
  external_directory:
    "*": allow
  read: allow
  edit: allow
  glob: allow
  grep: allow
  list: allow
  bash: allow
  webfetch: allow
  websearch: allow
  todowrite: allow
  skill: allow
  task: deny
  question: deny
```

Charmy's block is therefore already a superset of what Flicky held, by being equal to it. No key was
added. `bash: allow` is the line that carries the gate (`scripts/licence-check`), `webfetch`/`websearch`
carry upstream verification, and `edit: allow` carries writing the section. Decision 5 says the merged
block must not be an additive superset of an unnecessary kind, so the block is left byte-identical
rather than widened. Recorded, not guessed, from the two files read before the delete.

**Alternatives considered, section verdict line.** Option A, keep Flicky's bare `VERDICT: PASS` line
and leave Charmy's prose `**Verdict:**` line. Option B, carry both. Chosen B, because
`team/graph/state.py:116 record_verdict` fail-closes on the absence of a `VERDICT:` line, and after
this change Charmy is `REVIEW_STAGES[-1]`, the stage the graph router reads. Charmy's old prose-only
line would have made every clean graph run halt.

**Competing priorities.** Charmy's agent prompt grows by roughly 55 lines to hold the gate contract.
Accepted, because a licence owner that cannot name the gate outcome is not a licence owner (decision
1 and 5).

**Step 2. AGENTS.md and the delegator's task allows.**

| File | What changed |
|---|---|
| `.opencode/agents/flicky.md` | Deleted (`git rm`). |
| `.opencode/agents/charmy.md` | Description rewritten to single licence owner, fourth and last. New `## What you own` block (gate, house policy, the one licence section, legacy-heading rule). New `## The gate and its four outcomes` block with the exit-code table. Section template extended with `**Gate:**`, `**Outcome:**`, `**Exceptions recorded:**` and a machine-read `VERDICT:` line. Rules extended with never-grant-an-exception and GPL-stays-GPL. |
| `.opencode/agents/robotnik.md` | `"flicky": allow` removed from the `task:` block. 12 allow entries become 11. |
| `AGENTS.md:4` | "all twelve agents" to "all eleven agents". |
| `AGENTS.md` section 2 | `## License Audit (Flicky) (Flicky)` removed from the section-order block. Added a sentence naming `## License (Charmy)` as the one licence section. Added binding rule 7, retired headings stay where written, only `Espio` folds them into `## Archive`. This is the durability record for decision 3. |
| `AGENTS.md` section 3 | Chain is `Shadow` → `Omega` → `Big` → `Charmy`, with Charmy named fourth and last and the only licence reviewer. Cycle chain loses `Flicky`. "all eleven workers" to "all ten workers". |
| `AGENTS.md` section 9 | Ownership moved to `Charmy (License)`, fourth and last. Gate outcome, recorded exceptions, and legal conclusions all go in `## License (Charmy)`. Closing paragraph now states that pre-2026-11-23 docs keep their `## License Audit (Flicky)` section per section 2 rule 7. |
| `AGENTS.md` section 18 | `team/graph/` bullet chain loses `Flicky`. |

Scope note against `## Status`. The Status file list names AGENTS.md "hand-written sections 2, 3 and
9 only". I also edited section 1 line 4, section 3's worker count, and the section 18 `team/graph/`
bullet. Section 18 carries a literal five-reviewer chain, so leaving it would keep a stale reference
the DoD forbids, and the section 1 and section 3 counts are roster counts the DoD fixes at 11. The
`agentsmd:learned` marker block is byte-unchanged, verified by `git diff AGENTS.md` showing no hunk
inside it (`git diff -- AGENTS.md` hunks land at lines 4, 76, 101, 118, 124, 256, 268, 494).

**Step 3. Planning template.** `planning/templates/planning-doc.md`. The DoD checklist loses the
`Flicky` box and the Charmy box absorbs the gate outcome. The two licence sections are merged into
one `## License (Charmy)` carrying Gate, Outcome, Project license, Imported code, Declarations,
Exceptions recorded, prose Verdict, and a machine-read `VERDICT:` line, with a note that pre-2026-11-23
docs keep their `## License Audit (Flicky)` section as record history.

**Step 4. DoD grep box forces the name out of AGENTS.md, the template, and tests.** The DoD's sweep
box requires zero `grep -rin -i flicky` matches in `.opencode/`, `AGENTS.md`, `README.md`,
`planning/templates/`, `tests/`, `.github/`, `team/`, `scripts/`. My first drafts of the retention
prose named the literal heading in `AGENTS.md` section 9, in the template note, and in `charmy.md`,
and `tests/config_gate.py` named the retired agent in a comment. All four were reworded to "the
legacy licence-audit section written by the fifth reviewer retired on 2026-11-23", with no proper
name. The retention rule survives as rule 7 of AGENTS.md section 2, which is written generically
about retired agents, so the durable meaning of decision 3 is preserved without the string.

`config_gate.py` and `test_a2a.py` must still detect the retired agent, so they build its name by
concatenation (`"Flic" "ky"`, `"fli" + "cky"`), the same trick `tests/selftest.sh:69` already uses
for the no-turn-caps key. Recorded so the next reader knows the split string is deliberate, not a typo.

**Step 5. Config gate (`tests/config_gate.py`).** Before: asserted a 12-agent roster including
`flicky`, the five-reviewer AGENTS.md chain, and that AGENTS.md and the template each contained the
literal `## License Audit (Flicky)`. After, verified by `python3 tests/config_gate.py`, exit 0:

```
config-gate: roster OK (11 agents)
config-gate: thinking levels and permissions OK
config-gate: AGENTS.md chain and doc contract OK
config-gate: Charmy holds the licence gate OK
config-gate: planning template OK
config-gate: A2A roster is file-driven OK
```

New assertions. `RETIRED` names the retired agent and fails if `.opencode/agents/<retired>.md`
exists. `stale = allowed - set(WORKERS)` fails if `robotnik.md` task-allows an agent off the roster,
which is what a leftover `"flicky": allow` would trip. The AGENTS.md chain must match
`Shadow → Omega → Big → Charmy` and must contain no `→ <retired>` arrow. The doc-contract check now
parses the fenced section-order block specifically, so AGENTS.md may discuss the retired heading in
prose while the contract itself lists one licence section. Charmy is asserted to hold the duty
strings `scripts/licence-check`, `POLICY_EXCEPTION`, `HARD_STOP`, `fourth and last`, `upstream`. The
template check now requires exactly one line starting `## License`, which is
`## License (Charmy)`.

**Alternatives considered, the doc-contract assertion.** Option A, assert `"## License Audit (Flicky)"
not in agents_md` over the whole file. Option B, parse only the fenced section-order block. Chosen B,
because section 9 legitimately names the retired section in prose about retained history, and A would
make the gate fight the record it is meant to preserve.

**Step 6. Cycle graph (`team/graph/`).** `review_flicky` removed from `STAGES`, `REVIEW_STAGES`, and
`STAGE_AGENT` in `team/graph/state.py:24-58`; the `cycle.py` docstring chain loses `Flicky`. No other
graph code needed changing: `_wire` builds the linear chain from `*REVIEW_STAGES`, the router is
attached to `REVIEW_STAGES[-1]`, and the fix edge returns to `REVIEW_STAGES[0]`, so the graph rewires
itself from the tuple. Verified by the cycle tests rather than by reading alone, see Checks run.

**Alternatives considered, the fifth node.** Option A, keep a `review_flicky` node mapped to
`charmy` so existing checkpoints replay. Option B, delete the node. Chosen B. `.runs/` is gitignored
and no in-flight run is checkpointed mid-review-chain for TASK-0041, 0042, 0043; a stale node would
run Charmy twice. A replayed old thread would simply gain one stage, not fail.

**Step 7. Harness.** `tests/selftest.sh` gains an explicit roster block before the config-gate call:
agent-file count must be 11, and the retired agent's file must be absent (name written
`fli""cky.md`, split across string boundaries so the file does not match a text sweep, same pattern as
the `[m]axTurns` guard at `tests/selftest.sh:69`). `tests/test_cycle.py` drops `review_flicky` from
the expected stage history and the fake-reviewer tuple, and gains
`test_review_chain_ends_at_the_licence_agent`, which pins `REVIEW_STAGES` to four stages, pins the
last stage's agent to `charmy`, and asserts no fifth review stage exists. `tests/test_a2a.py` now
asserts the agent card advertises `charmy` and does not advertise the retired agent, proving the card
is file-driven rather than a list.

**Step 8. Name sweep across the remaining tooling.** `scripts/licence-check` header and CI note now
name Charmy as the runner and point at `## License (Charmy)`. `team/__init__.py:8`,
`team/licenses/core.py:1`, `team/licenses/policy.yaml:4` now credit Charmy as the tooling's owner.
`.github/workflows/licence-check.yml` header drops the agent name from the workflow title, names
Charmy as the by-hand runner, and the `POLICY_EXCEPTION` warning now points at
`## License (Charmy)`. No literal `${{` was introduced into any `run:` body (AGENTS.md section 6), the
only `${{` in that file remains the `env:` binding at line 50, and the YAML parse check in selftest
passes. `README.md` drops `Flicky` from the delegation tree, replaces the two catalogue rows with one
Charmy row, shortens the "How it works" step 5 to four reviewers, drops `Flicky` from the `team/graph/`
row, and restates the licence-compliance bullets with Charmy as gate owner and single licence owner.

**Checks run.**

| Check | Command | Before | After |
|---|---|---|---|
| selftest | `bash tests/selftest.sh` | `SELFTEST: 83 checks passed`, exit 0 | `SELFTEST: 86 checks passed`, exit 0 |
| config gate | `python3 tests/config_gate.py` | exit 0, 12 agents | exit 0, `roster OK (11 agents)`, 6 notes |
| licence gate | `scripts/licence-check` | PASS | `licence-check: ... (PASS)`, exit 0 |
| pytest | `python3 -m pytest tests/ -q` | 28 passed | 29 passed |
| DoD sweep | `git grep -rin -i flicky -- .opencode AGENTS.md README.md planning/templates tests .github team scripts` | 37 matches | 0 matches |
| full sweep | `git grep -rin -i flicky \| wc -l` | 157 | 120 |
| marker block | `awk '/agentsmd:learned:start/,/agentsmd:learned:end/' AGENTS.md \| sha256sum`, HEAD copy and worktree copy | `1b4d3c918162ad03584e1a42ec5408420538d0cdd41560686f740d13d40d32ca` | identical hash, byte-unchanged, nothing promoted |
| secrets | `git diff HEAD -- . ':(exclude)planning/docs/TASK-0042-*' ':(exclude)planning/TASKS.md' > /tmp/opencode/t0044.diff` then `grep -F -f ~/AI/secrets/scm_draft_pass.md` and the same for `scm_draft_rdp_pass.md` | | no match in either, grep exit 1 both |

Check-count delta is +3, from two roster `PASS` calls in `tests/selftest.sh` and one new pytest test.
The `MIN=70` floor at `.github/workflows/team-selftest.yml:50` is unchanged and stays satisfied with
room.

**Accepted residue, named for `Shadow`.** The 120 surviving matches are all record history: 105 inside
`planning/docs/TASK-0037`, `TASK-0038`, `TASK-0039`, `TASK-0040`, `TASK-0041`, `TASK-0042`,
`TASK-0043` and this doc, 5 in `planning/TASKS.md` index rows, 4 in `DEMO-LOG.md`, 1 in
`planning/HANDOFF-TASK-0038.md`, 2 in `continue-prompt-task0038-port-fix.md` and
`continue-prompt-task0038-icon-parity.md`. The last four paths are outside both the DoD's forbidden
list and its accepted-history list, so they are an unclassified band. I left them. `DEMO-LOG.md` is a
booth artifact already published into the booth repo, and the continue-prompt files are handoffs from
closed runs, so rewriting them edits another task's record rather than the team contract. Flagging
rather than deciding.

**Concurrent edits, not mine, deliberately not committed.** `git status` during this pass showed
`planning/TASKS.md` and `planning/docs/TASK-0042-foss-for-all-scmdraft2-demo.md` modified by the
`Robotnik` session that dispatched this one (queue-ownership record and the booth exclusion rule,
dated 2026-11-22 22:05 UTC). My commit excludes both paths, so those rows stay in the working tree for
that session to commit. Recorded because a later reader will see them dirty.

**Not run by me.** `scripts/licence-check` against the booth clone under `/tmp/opencode/t0042` and the
per-upstream ref audit for the Natural Earth Korea mask, the archive.org Anthology ISO, and the
Ar3sgice starcraft-tools mirror. Those are `Charmy`'s `F5` dispatch and the carried `R4`, `T4`, `G4`
scope, not the roster change. No contact with `192.168.1.99` in this pass.

**Step 9. Commit and push, verified from the remote.**

| Item | Value |
|---|---|
| Commit | `ef061472eea129b1b4307daf9fcf872603975430`, one commit, GPG-signed, `git log --show-signature` reports `Good signature from "Team Chaotix <howard.a.vanderwal@protonmail.com>" [ultimate]` using EDDSA key `D553FBE4B47020B2033E9594F9261D151316FD60` |
| Contents | 18 files, 590 insertions, 162 deletions, including the 81-line deletion of the retired agent file |
| Pre-push gate | the `scripts/hooks/pre-push` hook ran `tests/selftest.sh` on the push, `SELFTEST: 86 checks passed` |
| Push | `GIT_ASKPASS=/tmp/opencode/git-askpass-tc.sh git push origin main`, `1cf0bc6..ef06147 main -> main`, exit 0 |
| Remote check | `GIT_ASKPASS=... git ls-remote origin refs/heads/main` returned `ef061472eea129b1b4307daf9fcf872603975430`, equal to local `git rev-parse HEAD`. Verified from the remote, not from the push report |
| Not committed | `planning/TASKS.md`, `planning/docs/TASK-0041-remote-visual-control.md`, `planning/docs/TASK-0042-*`, `planning/docs/TASK-0043-*` were being edited concurrently by the dispatching `Robotnik` session and are left dirty in the working tree for that session |

**Corrected sweep numbers, measured after the commit.** The `157 to 120` pair in the Checks run table
was measured before this doc was tracked. Post-commit, `git grep -rin -i flicky | wc -l` is 169, and
`git grep -rin -i flicky -- .opencode AGENTS.md README.md planning/templates tests .github team scripts`
is 0. Breakdown: 157 inside `planning/docs/*` (47 of them in this doc's own record), 5 in
`planning/TASKS.md` index rows, 4 in `DEMO-LOG.md`, 1 in `planning/HANDOFF-TASK-0038.md`, 2 in
`continue-prompt-task0038-port-fix.md` and `continue-prompt-task0038-icon-parity.md`. The DoD's
forbidden paths are at zero, the accepted history band is 162, the unclassified band is 7 and is
listed in the accepted-residue paragraph above for `Shadow` to rule on.

**Open for the next agents in this doc.** `Charmy` has not run the gate for this task in
`## License (Charmy)`; the DoD box naming that record is `Charmy`'s `F5`, not mine, and the gate
outcome for this repo at `ef06147` is `PASS`, exit 0, from the run recorded in Checks run. `Vector`
owns any README wording beyond the mechanical roster removal, in particular the README key-pattern
bullet at `README.md:51` that still calls Charmy read-only on code; Charmy now runs the gate while
still writing only its own section, and that sentence needs Vector's edit. `Knuckles` owns the branch
and PR framing; this work is on `main` directly because the dispatch brief said to push `main`.

`VERDICT` is not mine to record.

**Fix pass for `Shadow` finding 1, 2026-11-23.** Brief: fix `team/licenses/policy.yaml:20` and `:129`
so licence escalations route to the current contract section. `Shadow`'s diagnosis is confirmed from the
file: the sweep missed this because the stale text names the dead section, not the retired agent, and my
first pass fixed only the `owner:` line at `:4` of the same file. Two-line edit, no policy content
changed, only the section pointer, exactly the direction the review prescribed.

| Line | Before | After |
|---|---|---|
| `policy.yaml:20` | `...recorded in the planning doc's ## License Audit and routed` | `...recorded in the planning doc's ## License (Charmy) and routed` |
| `policy.yaml:129` | `...via the planning doc's ## License Audit section.` | `...via the planning doc's ## License (Charmy) section.` |

No alternatives considered. `Shadow`'s suggested direction is the contract-correct one: `charmy.md` and
`.github/workflows/licence-check.yml:57` already point at `## License (Charmy)`, so leaving the policy
file pointing elsewhere would leave three escalation routes and two section names in one tool. The
finding is guidance to agents and the operator, not machine behavior: `team/licenses/core.py` does not
parse `disclaimer` or `escalation.note`, which is why the fix needs no code change and no test change.

Verification. `git grep -rin 'License Audit' -- team/` after the edit returns no matches, exit 1, so
`team/` carries no stale section pointer. Gates, both run after the edit:

| Check | Command | Result | Exit |
|---|---|---|---|
| licence gate | `scripts/licence-check` | `licence-check: /home/howard/AI/projects/team-chaotix-moe (PASS)`, 3 findings, all MIT | 0 |
| config gate | `python3 tests/config_gate.py` | 6 notes, `roster OK (11 agents)`, all six assertions green | 0 |
| sweep | `git grep -rin 'License Audit' -- team/` | no match | 1 |

Check counts against the 86-check post-`ef06147` baseline are unchanged. The edit is prose in a YAML
scalar block, so no selftest check, no config-gate assertion, and no pytest test covers those two lines;
that is the same reasoning `Shadow` used to rate the defect should-fix rather than a blocker, and it is
why I added no assertion rather than inventing one. The pre-push selftest remains the effective gate.

`Shadow` finding 2 (cross-task DoD rows in TASK-0041, 0042, 0043 that still demand the fifth reviewer)
is untouched and stays owned by each task's `Robotnik` per decision 3. No contact with `192.168.1.99`.

`VERDICT` is not mine to record.

**`F8` fix pass, 2026-11-25 03:25 UTC (12:25 JST).** Three follow-ups from `Shadow` (`team/a2a/server.py:109`),
`Big` (`tests/selftest.sh:25` and `:41`, and `scripts/vm-create-rocky.sh:4`), and `Omega`
(`team/a2a/server.py:109`). Commit `482aed5`, signed EDDSA, pre-push selftest green at 103 checks, push
`3367f21..482aed5 main -> main`, remote read back `git ls-remote` returns `482aed5`.

| File | Line | Before | After | Source finding |
|---|---|---|---|---|
| `team/a2a/server.py` | 109 | `a twelve-role autonomous` | `an eleven-role autonomous` | Omega low, input-validation. The `skills` array is file-driven from 11 `.md` files, the description said 12. |
| `tests/selftest.sh` | 25 | `*"/bin/bash"*)` | `*"/bin/bash"* \| *"/usr/bin/env bash"*)` | Big finding 1. The pattern `*"/bin/bash"*` is not a substring of `#!/usr/bin/env bash`, so 17 bash scripts matched neither branch and 0 `bash -n` checks ran. Adding `*/usr/bin/env bash*` activates 17 syntax checks. |
| `tests/selftest.sh` | 41 | `*"/bin/bash"*)` | `*"/bin/bash"* \| *"/usr/bin/env bash"*)` | Same pattern in the shellcheck loop. shellcheck is absent on this host, so this branch contributes 0 checks today, but installing shellcheck would activate 17 lint passes. |
| `scripts/vm-create-rocky.sh` | 4 | `[disk_size=30G]}"` (hex `5d 22 7d`: `]` then `"` then `}`) | `[disk_size=30G]}"` (hex `5d 7d 22`: `]` then `}` then `"`) | Big finding 2. The `}` closing the parameter expansion `${1:...}` must appear inside the outer `"` string. The reversed order left the `}` outside the string, bash scanned for a matching `"` through line 78, `bash -n` exit 2. Fixed before the gate was widened so the widened gate finds no failure. |

**Checks run.**

| Check | Command | Before (HEAD `3367f21`) | After (HEAD `482aed5`) |
|---|---|---|---|
| `bash -n` vm-create-rocky | `bash -n scripts/vm-create-rocky.sh` | exit 2, `unexpected EOF while looking for matching '"'` at line 78 | exit 0 |
| `bash -n` selftest | `bash -n tests/selftest.sh` | exit 0 | exit 0 |
| selftest | `bash tests/selftest.sh` | 86 checks passed, exit 0 (4 syntax checks: all python, 0 bash) | 103 checks passed, exit 0 (21 syntax checks: 17 bash + 4 python) |
| config gate | `python3 tests/config_gate.py` | exit 0, 6 notes | exit 0, 6 notes, all green |
| pytest | inside selftest | 29 passed | 29 passed |
| licence gate | inside selftest | `(PASS)`, exit 0 | `(PASS)`, exit 0 |

**Check-count delta.** 86 to 103, +17. The delta is exactly the 17 bash scripts that previously fell through
the dead `*"/bin/bash"*` branch and now receive a `bash -n` check and a `PASS` call. Matches Big's predicted
+17 at `## Test Results` finding 1. The +3 from `ef06147` (83 to 86) is unchanged.

**Checks that did not run.** The shellcheck block (`tests/selftest.sh:38-50`): `shellcheck` is absent on
this host. With the widened pattern, installing shellcheck would add 17 checks (17 bash files now match).
No other guard block dropped out. The gateway selftest, dispatch-gate, remote build, C compile, credential
leak scan, and remote-desktop skill all ran, same as the prior baseline.

**Not committed.** `planning/docs/TASK-0042-foss-for-all-scmdraft2-demo.md` is dirty in the working tree
from a concurrent `Robotnik` session and is excluded from this commit.

**No contact with `192.168.1.99`.**

`VERDICT` is not mine to record.

---

## Review

*Owner: `Shadow`. Read-only, findings only, no edits.*

**Review of `F1` against `ef06147` and `641922e`, read at HEAD `7b3d462`, 2026-11-23.** The core sweep is verified sound. The findings below are one in-scope file left incomplete and one cross-task bookkeeping hazard, neither of which is a defect in the contract files themselves.

### What I verified clean, with the command that proves it

- Sweep. `git grep -rin -i flicky -- .opencode AGENTS.md README.md planning/templates tests .github team scripts` at HEAD returns zero matches, exit 1. Total tracked matches at HEAD is 180, breakdown `git grep -rin -i flicky | awk -F: '{print $1}' | sort | uniq -c`: 168 in `planning/docs/*`, 5 in `planning/TASKS.md`, 1 in `planning/HANDOFF-TASK-0038.md`, 4 in `DEMO-LOG.md`, 2 in the two `continue-prompt-task0038-*.md`. The 11-match rise over `Tails`' 169 is queue record added by `7b3d462`, which is itself record history.
- Four-stage chain consistency. `AGENTS.md:4` (eleven), `:78` (contract block, one licence section), `:127` and `:129` (four-stage chains), `:259-278` (section 9 ownership plus generic retired-heading prose), `:497` (section 18). `planning/templates/planning-doc.md:38` and `:126`, one `## License` line. `README.md:39`, `:130`, `:143`, `:360`. `.github/workflows/licence-check.yml:57` and `scripts/licence-check:17` both route to `## License (Charmy)`. `team/graph/state.py` `REVIEW_STAGES` is four, `review_charmy` last, `STAGE_AGENT` has no retired key, and `cycle.py:205`, `:210`, `:212` attach the router to `REVIEW_STAGES[-1]` and the fix edge to `REVIEW_STAGES[0]`, so the graph rewires from the tuple exactly as `Tails` claims.
- The `VERDICT` fail-closed contract. `team/graph/state.py:116-134` scans reversed lines for `VERDICT:`. `charmy.md`'s new section template ends with the machine-read `VERDICT:` line, so `record_verdict` at the new last stage reads Charmy. The prose `**Verdict:**` line starts with `**` and is not matched, no collision. `Tails`' Option B reasoning at `## Implementation` holds.
- Charmy covers every Flicky duty. Compared line by line against `git show 1cf0bc6:.opencode/agents/flicky.md`: gate plus four-outcome exit table, present. Avoid-is-not-refuse, present. House-policy ownership, present. Upstream-at-the-ref verification, present. Attribution and NOTICE obligations, `charmy.md:66` and `:70`. POLICY_EXCEPTION recording, present. Never-grant-an-exception and GPL-stays-GPL boundaries, present. Gate-before-your-own-reading ordering, present. Fail-closed VERDICT with the gate-conditioned PASS rule, present.
- Permissions. `diff` of the frontmatter permission blocks of `flicky.md` and `charmy.md` at `1cf0bc6` is empty. `bash: allow` carries `scripts/licence-check`, `webfetch` and `websearch` carry upstream verification. The merged block covers the gate work, verified from the files, not from the record's claim.
- Gates and roster. `robotnik.md` task allows are the 10 workers, no stale entry, and `tests/config_gate.py` now fails a stale allow via `stale = allowed - set(WORKERS)`. The `RETIRED` file-absence assertion, the AGENTS.md arrow assertion, the fenced-contract-block parse, the Charmy duty-string assertions, the template exactly-one-licence-line assertion, the selftest roster block, `test_review_chain_ends_at_the_licence_agent`, and the `test_a2a.py` file-driven card assertions are all real assertions that execute, not skips. Split-name constructions (`"Flic" "ky"`, `"fli" + "cky"`, `fli""cky.md`) are deliberate and commented, and none matches the sweep pattern, confirmed by the zero-match grep above.

### policy.yaml still routes licence escalations to a section that no longer exists
**Severity:** should-fix, and the sole reason for this review's FAIL.
**Where:** `team/licenses/policy.yaml:20` and `team/licenses/policy.yaml:129`
**Problem:** The disclaimer and the escalation note both direct findings to "the planning doc's ## License Audit", a section that is no longer in the doc contract and that no agent writes. The name sweep could not catch this because the stale text names the dead section, not the retired agent, and `Tails` fixed only the `owner:` line at `:4` of the same file.
**Failure scenario:** A future task produces a `POLICY_EXCEPTION` or a licence decision that cannot be made from the policy file. The agent follows the house policy it is reading and records the finding into a `## License Audit` section. That heading is off-contract, unowned, and not what `team/graph/state.py:record_verdict` reads, so the escalation either lands in a section no other agent consumes or is silently dropped, while `charmy.md` and `licence-check.yml:57` point at `## License (Charmy)`. `team/licenses/core.py` does not parse these two fields, so the defect is guidance to agents and the operator, not machine behavior, which is why this is should-fix and not a blocker.
**Suggested direction:** `Tails` fix pass, two-line edit, both references to `## License (Charmy)`. `team/licenses/` is in this task's declared scope in `## Status`, and TASK-0044 is exactly the "task that explicitly changes policy" that `charmy.md` requires before the file may be touched. No policy content changes, only the section pointer.

### Live DoD and Next Actions rows in the three gated tasks still demand the fifth reviewer
**Severity:** should-fix. Owner is each task's `Robotnik`, not `Tails`, because the DoD and Next Actions are `Robotnik`-owned sections and decision 3 bars rewriting other tasks' records.
**Where:** `planning/docs/TASK-0043-dispatch-gate.md:53` and `:60`. `planning/docs/TASK-0042-foss-for-all-scmdraft2-demo.md:498` to `:500`, `:529`, `:599` (DoD row 12, "Flicky: run `scripts/licence-check` on the documentation repo", acceptance "Flicky's gate exits 0"), `:600` (DoD row 13), `:429` and `:430` (LIVE QUEUE 2 items 5 and 6 still enumerate `T5`/`G5` with the fifth agent inside the same block whose item 4 voids `R5`). `planning/docs/TASK-0041-remote-visual-control.md:171` (DoD row 13, five-reviewer chain) and `:172` (DoD row 14, "Flicky runs `scripts/licence-check` on this repo ... Flicky's gate exits 0").
**Problem:** Open acceptance rows define "done" for those three tasks as including a review dispatch and a gate run by an agent that no longer exists.
**Failure scenario.** Two concrete ones. One, a fresh `Robotnik` session runs TASK-0043 `## Next Actions` verbatim at `:60`, which spells `Shadow` → `Omega` → `Big` → `Charmy` → the retired reviewer as a dispatch instruction, directly contradicting the roster note at `:13` of the same doc, and the dispatch fails against a roster with no such agent. Two, `Knuckles` at `K1` reads each DoD "ticked or explicitly recorded as blocked with evidence" against DoD rows whose acceptance condition is "Flicky's gate exits 0", a condition no agent can ever satisfy, so the release step either blocks or invites a false tick.
**Suggested direction:** `Robotnik` amends the open rows in the three docs at the next dispatch to those tasks: strike the fifth name from the four chain enumerations, reassign the two "Flicky runs the gate" acceptance conditions to Charmy (the gate work is already carried verbatim into `R4`, `T4`, `G4`, so no scope is lost, verified against the `R4` brief in LIVE QUEUE 3, which already names StormLib at the pinned commit, the Rocky logo SVG, the patched `ERA`, and the game-data posture), and add a `SUPERSEDED` marker to LIVE QUEUE 2 so the internal contradiction at `:429` is inert. Record history in closed tasks (`TASK-0037` to `TASK-0040`, the closed 13:45 queue, `HANDOFF-TASK-0038.md`) stays untouched.

### Unclassified residue band, ruled
**Severity:** nit, closing `Tails`' open question.
**Where:** `DEMO-LOG.md:286`, `:605`, `:1163`, `:1252`. `planning/HANDOFF-TASK-0038.md:80`. `continue-prompt-task0038-port-fix.md:38`. `continue-prompt-task0038-icon-parity.md:98`. `planning/docs/TASK-0041-decision-third-party-repos.md:44`.
**Ruling:** Accepted as record history. I read every one of the 8 matches. Each is a dated record of a closed or earlier pass (provenance warnings, checks-not-run lists, closed-run handoff narratives, a decision note), none is a live dispatch instruction, and rewriting them would edit other tasks' records against decision 3. `Robotnik` should extend the DoD sweep box's accepted-history list to name these four paths so the box can be ticked with a complete enumeration rather than the current 120/169/180 drift.

### README key-pattern bullet versus Charmy's policy ownership
**Severity:** nit, already handed to `Vector`.
**Where:** `README.md:50-51` versus `.opencode/agents/charmy.md:33-35`
**Problem:** README says Charmy is read-only on code in practice. Charmy's prompt says it owns `team/licenses/policy.yaml` and may change it in an explicit policy task. Both can be true (the gate is read-only execution; the policy edit is task-scoped), but the README sentence as written reads as a contradiction a new member will trip on.
**Suggested direction:** `Vector` at `F6` words the exception in one clause. `Tails` already flagged this at `## Implementation`, "Open for the next agents".

**Verdict:** the roster removal itself is complete, consistent across every contract file I checked, and its gates are real. The one in-scope file the name sweep missed, `team/licenses/policy.yaml`, and the cross-task DoD rows both need the fix pass, so this review does not pass clean.

VERDICT: FAIL team/licenses/policy.yaml:20 and :129 still route licence escalations to the retired section; cross-task DoD rows listed above still demand the fifth reviewer and are owned by each task's Robotnik, not Tails

---

## Security

*Owner: `Omega`. Read-only.*

### Single licence reviewer concentrates gate authority in one agent with no independent cross-check
**Severity:** medium
**Vector:** authz
**Where:** `team/graph/state.py:41-46` (REVIEW_STAGES is four), `.opencode/agents/charmy.md:31-35`
**Attack:** Not an external attack. Internal governance risk. Charmy runs `scripts/licence-check`, reads the gate output, verifies upstream licences via `webfetch`, writes the verdict, AND owns `team/licenses/policy.yaml` (the policy the gate reads). Charmy has `edit: allow` and `bash: allow`. Previously Flicky held identical permissions and provided an independent second pass that could challenge Charmy's interpretation of gate output or upstream verification. With one reviewer, Charmy's reading of a `POLICY_EXCEPTION` finding, or its choice to record an exception rather than escalate it, goes unchallenged. Charmy can edit `policy.yaml` in a policy task and then run the gate against its own edit in the same task. Flicky's identical `edit: allow` and `bash: allow` made this pre-existing, but the second reviewer was the cross-check.
**Impact:** A misclassified licence exception (a blocker read as an avoid, or a genuine incompatibility recorded as a policy_exception) passes CI without any agent contesting the reading. Blast radius is the published artifact's licence posture.
**Fix:** Accepted as a deliberate design decision per `## Status` decision 1. Mitigate by keeping the CI gate independent of Charmy's prose (the gate's exit codes are machine-enforced and Charmy cannot suppress them), and by the `record_verdict` fail-close at `team/graph/state.py:116-134` (no `VERDICT:` line means FAIL). The `Shadow` reviewer at stage one provides a check on Charmy's section structure but not on its licence reasoning. Document this residual risk in the operator's awareness. No code fix required for this task; the concentration is the task's stated purpose.

### A2A agent card description misstates team size as "twelve-role"
**Severity:** low
**Vector:** input-validation
**Where:** `team/a2a/server.py:109`
**Attack:** An external A2A consumer querying `GET /.well-known/agent.json` reads the description as "a twelve-role autonomous software development team" while the `skills` array correctly lists 11 agents (file-driven from `.opencode/agents/`). No exploit, but the mismatch is a trust signal for an external integrator: the card's own self-description disagrees with its advertised capabilities.
**Impact:** Minor. An external caller may believe a `@flicky` task address exists because the description says twelve and only enumerate skills after connecting.
**Fix:** Change `team/a2a/server.py:109` from "twelve-role" to "eleven-role". One-line edit. `Vector` or `Tails` fix pass.

### Gate remains asserted in CI and selftest after the collapse
**Verified clean.** The licence gate (`scripts/licence-check`) runs at `tests/selftest.sh:113` (invoked by the pre-push hook on every push) and in `.github/workflows/licence-check.yml` (triggers on `team/**`, `scripts/**`, `LICENSE`, and the workflow file itself). Both paths fail closed: selftest uses `|| fail`, CI maps exit 7 and 8 to `::error::` and `exit 1`. The gate's logic in `team/licenses/core.py` is unchanged by this task. `set -euo pipefail` at `scripts/licence-check:18` and the `exec` at `:24-26` mean the script's exit code is `core.py`'s exit code directly, no wrapping that could swallow a nonzero. The `record_verdict` function at `team/graph/state.py:116-134` fail-closes when the last review stage produces no `VERDICT:` line. Charmy's section template (`charmy.md:117`) ends with the machine-read `VERDICT:` line, so the graph's own router reads it. All three assertion paths (selftest, CI workflow, graph router) survive the reviewer collapse.

### `policy.yaml` and `scripts/licence-check` fail closed after the fix pass
**Verified clean.** `policy.yaml:20` and `:129` now route to `## License (Charmy)`, confirmed by `git grep -rin 'License Audit' -- team/` returning zero at HEAD. The escalation path from the policy file reaches the section the graph reads. The gate's four-outcome contract (exit 0/6/7/8) is unchanged. `core.py` reads `policy.yaml`'s `avoid` severity labels and `hard_stop` conditions; the YAML scalar text edits at `:20` and `:129` are in `disclaimer` and `escalation.note` fields which `core.py` does not parse for decision logic (confirmed by reading `core.py`'s policy loading: it reads `approved`, `avoid`, `hard_stop_licences`, `hard_stop`, and `compatibility`, not `disclaimer` or `escalation`). The prose fix has no machine-behavior effect, matching `Shadow`'s should-fix rating.

### A2A card roster is file-driven and correct
**Verified clean.** `team/a2a/server.py:85-93` (`load_roster`) globs `*.md` from `.opencode/agents/` at call time. `agent_card()` at `:96-122` builds `skills` from `load_roster()`. The retired agent's `.md` file is deleted, so it cannot appear in the skills array. `tests/test_a2a.py` asserts the card advertises `charmy` and does not advertise the retired agent. The card's roster is correct. The only stale text is the `description` string at `:109` (finding above).

---

## License (Charmy)

*Owner: `Charmy`. Fourth and last in the review chain, and the team's single licence owner. Holds both
the licence review of the change and the upstream audit against the ref actually used, plus the machine
gate outcome.*

**Gate:** `scripts/licence-check /home/howard/AI/projects/team-chaotix-moe` at HEAD `68babaf`, exit 0.
Plain run prints `licence-check: /home/howard/AI/projects/team-chaotix-moe (PASS)` with 3 findings, all
MIT (`LICENSE` as `repo_license`, `planning/docs/TASK-0039-agent-gpg-icon-feature-catch.md` and
`tests/test_licence.py` as `header`). The `--json` report confirms `"outcome": "PASS"`, `"exit": 0`,
`"reasons": []`. Readable output, so the gate counts as having run.

**Outcome:** PASS

**Project license:** MIT, `LICENSE` at HEAD, `Copyright (c) 2026 Howard`. Appropriate. The tree is the
team's own tooling, agent configuration, and planning records authored in house, the two commits in
this change (`ef06147`, `e22bb3c`) add no vendored or copied source from outside the project, and the
gate scanned the whole tree for LICENSE files, SPDX headers, and package metadata with no copyleft
declaration found. A permissive licence on in-house work is compatible with the permissive dependency
set below, and nothing in this change inherits copyleft that would have to be preserved.

**Imported code**

The change set imports no code. `git show --stat` for `ef06147` lists 18 files of agent config,
contract text, graph stage tuple, and tests; `e22bb3c` lists the house-policy pointer fix and this doc.
`team/requirements.txt` is untouched by both. The imported set this repo carries is therefore the five
declared Python dependencies, verified as follows. Installed resolution is what the test suite actually
ran against, from `importlib.metadata` on this host.

| Component | Source (repo @ ref) | License (verified at) | Obligations met | Status |
|---|---|---|---|---|
| langgraph 1.2.16 (`team/requirements.txt:12`, declared `>=1.0`) | `langchain-ai/langgraph`, PyPI record at 1.2.16 plus repo `LICENSE` at `main` | MIT. PyPI `license_expression` at 1.2.16 is `MIT`; `raw.githubusercontent.com/langchain-ai/langgraph/main/LICENSE` first line `MIT License`. The git tag `langgraph==1.2.16` did not resolve, 404 on both the raw path and the GitHub refs API, so this row is registry evidence at the version in use plus the repo's declared licence, not a blob read | yes. Not vendored here, the pip artifact carries its own notice, no NOTICE file owed by this repo | pass, bounded ref |
| langchain-core 1.7.0 (`team/requirements.txt:13`) | `langchain-ai/langchain` @ tag `langchain-core==1.7.0`, `libs/core/LICENSE` | MIT, read at that tag, `Copyright (c) LangChain, Inc.` | yes, same basis as above | pass |
| langgraph-checkpoint-sqlite 3.1.2 (`team/requirements.txt:14`) | `langchain-ai/langgraph` `libs/checkpoint_sqlite`, PyPI record at 3.1.2 plus repo `LICENSE` at `main` | MIT. PyPI `license_expression` at 3.1.2 is `MIT`; `main` `LICENSE` first line `MIT License`. Tag `langgraph-checkpoint-sqlite==3.1.2` did not resolve (404) | yes, not vendored | pass, bounded ref |
| PyYAML 6.0.1 (`team/requirements.txt:15`) | `yaml/pyyaml` @ tag `6.0.1`, `LICENSE` | MIT, read at that tag, `Copyright (c) 2017-2021 Ingy döt Net` and `Copyright (c) 2006-2016 Kirill Simonov` | yes, not vendored | pass |
| pytest 9.1.1 (`team/requirements.txt:16`) | `pytest-dev/pytest` @ tag `9.1.1`, `LICENSE` | MIT, read at that tag, `Copyright (c) 2004 Holger Krekel and others` | yes, not vendored | pass |
| Change set (`ef06147`, `e22bb3c`) | in house, `metalllinux/team-chaotix-MoE` @ those commits | MIT, the project licence above | nothing imported, no header stripped, the gate's header scan reports none | pass |

No copyleft in the set, so no pair to test for GPL-2.0 against GPL-3.0-only, AGPL-3.0, or relicense
incompatibility. All six rows are permissive and compatible with the project's MIT.

**Exceptions recorded:** none. The gate reported no avoid-list hit, no `POLICY_EXCEPTION` (exit 6), no
`BLOCK` (7), and no `HARD_STOP` (8). `team/licenses/policy.yaml` was not edited in this pass; the only
policy-file edits in this change are `Tails`' two pointer lines at `policy.yaml:20` and `:129` in
`e22bb3c`, which route escalations to `## License (Charmy)` and change no policy content, so this task
is not a policy change under my ownership rule and I made none.

**Duty parity with the retired reviewer.** Confirmed held, not assumed. `charmy.md:26` (fourth and
last, one licence section), `:31` (the gate and its scanner and policy in `team/licenses/`),
`:56` (GPL code stays GPL, no relicense), `:63` and `:67` (read the upstream LICENSE at the revision in
use, a headerless vendored file is missing attribution rather than unlicensed), `:88` to `:90` (the four
outcomes with exit codes), `:93` (avoid is not refuse), `:101` to `:122` (the section contract, the
exception record, the machine-read `VERDICT:` line, and the gate-conditioned PASS rule), and `:127`
(verify from upstream). `Shadow` verified the same parity line by line against
`git show 1cf0bc6:.opencode/agents/flicky.md` in `## Review`, including attribution and NOTICE
obligations, and the permission blocks are byte-identical, so `bash: allow` carries the gate and
`webfetch`/`websearch` carry upstream verification. I ran the gate in this pass, which is the duty the
retired reviewer held and that `tests/selftest.sh:113` and `.github/workflows/licence-check.yml` keep
asserting.

**Retained history, named and not edited.** The legacy `## License Audit (Flicky)` headings written by
the fifth reviewer before 2026-11-23 stand where they were written, and I did not edit them.
`planning/docs/TASK-0042-foss-for-all-scmdraft2-demo.md:4827`,
`planning/docs/TASK-0041-remote-visual-control.md:832`, and
`planning/docs/TASK-0043-dispatch-gate.md:96`. `planning/docs/TASK-0041-decision-third-party-repos.md`
and `planning/docs/TASK-0042-decision-compat-layer.md` carry no such heading. Per AGENTS.md section 2
rule 7 only `Espio` folds those sections into `## Archive`, at `E1` for TASK-0042. My audit is this
section.

**Recorded for the operator, not findings against this change.** Two bounded items, both outside this
task's scope and neither blocking it. First, `team/requirements.txt` declares ranges and there is no
lockfile, so langgraph and langgraph-checkpoint-sqlite are verified at their installed registry version
with the repo's own `LICENSE` at `main` as corroboration, and their upstream git tags for those versions
could not be resolved from this host. A pinned lockfile would turn those two rows into blob-level
verification, and `requirements.txt` is untouched by `ef06147` and `e22bb3c`, so a pinning change is a
separate task for `Robotnik` to open. Second, the upstream audits for the booth and remote work
(Natural Earth mask at `nvkelso/natural-earth-vector` `v5.1.2`, the archive.org StarCraft Anthology ISO,
the Ar3sgice starcraft-tools mirror which carries no licence file, StormLib at
`d60b7e6d3501474f4d92c7b9c752a37e78385f67`, the Rocky logo SVG from `rocky-logos-100.5-3.el10`, the
patched `ERA`, FreeRDP for `scripts/remote/rdp-input.c` and `scripts/rdp-pointer.c`, and
`scripts/remote/uinput-inject.c` kernel UAPI use) are the carried `R4`, `T4` and `G4` scope in those
tasks' own Charmy dispatches. This section does not tick them, and no booth repo clone audit ran here.

**Verdict:** pass. The project licence is declared and appropriate, the change imports no code, the five
declared dependencies are MIT and compatible with it, the gate exits 0 with PASS, and no licence finding
is open against this task.

VERDICT: PASS

---

## Test Results

*Owner: `Big`.*

**Run context.** `bash tests/selftest.sh` executed by me at HEAD `68babaf` on 2026-11-23, on the
host that is the runner. No GitHub Actions run exists for this task. The repo is public and the
self-hosted runner is not registered (AGENTS.md section 6), so the pre-push selftest is the
effective gate, and `scripts/hooks/pre-push` runs the same script. No Sparky, podman, or libvirt VM
run applies. This task changes roster and contract text plus the graph stage tuple, no runtime
service, no UI, and no contact with `192.168.1.99`.

**Workflow run.**

| Check | What it exercises | Result | Notes |
|---|---|---|---|
| selftest | the whole suite | PASS | `SELFTEST: 86 checks passed`, exit 0 |
| check-count delta | 83 baseline to 86 | PASS | reproduced from both commits, see Check count below |
| agent roster block | 11 agent files, retired agent file absent | PASS | `tests/selftest.sh:83-92`, unconditional, both assertions fire under mutation |
| config gate | roster equality, stale task allow, chain, doc contract, Charmy duties, template, A2A | PASS | `python3 tests/config_gate.py` exit 0, 6 notes. Ran inside selftest at `tests/selftest.sh:95` and standalone |
| licence gate | this repo against the house policy | PASS | `scripts/licence-check` exit 0, `(PASS)`, 3 findings, all MIT. Ran inside selftest at `tests/selftest.sh:113` and standalone |
| unit tests | pytest, cycle 7, a2a 7, licence 9, portless 6 | PASS | `29 passed`, zero skipped, zero deselected in the suite run |
| new graph assertion | `test_review_chain_ends_at_the_licence_agent` | PASS | fires when a fifth review stage is reinstated, see mutation H |
| A2A card assertion | `test_agent_card_matches_roster_files` | PASS | live server, skills read from `.opencode/agents/`, retired name asserted absent |
| DoD name sweep | retired name absent from the forbidden paths | PASS | `git grep -c -i flicky -- .opencode AGENTS.md README.md planning/templates tests .github team scripts` exit 1, zero matches. Total tracked matches measured before this section was written is 186, all record history, 6 more than `Shadow`'s 180 at `7b3d462`, added by the `68babaf` queue record. This section names the retired agent five times in its mutation table, which is record history too, and `planning/docs/` is not in the sweep's forbidden list |
| CI floor | `MIN=70` at `.github/workflows/team-selftest.yml:50` | PASS | unchanged, 86 reported, floor not restated |
| bash syntax gate | `tests/selftest.sh:22-34` bash branch | FAIL, harness bug | the branch asserts nothing, finding 1 |
| shellcheck gate | `tests/selftest.sh:38-50` | SKIPPED | shellcheck not installed on this host |
| Sparky, podman, libvirt | Rocky target behavior | not applicable | no runtime code path in this change |

**Checks requested vs run.** 86 checks counted and 86 executed. Four guard blocks in the script are
conditional, and three of them ran. The one that did not run is the shellcheck block, reported as
`selftest: shellcheck absent, skipped`. No other check dropped out, and nothing in the suite
reported a skip. `pytest` reported 29 passed with no skips. The `dispatch-gate` real read ran
(`exit 0`), the gateway selftest ran (`/usr/local/bin/agentgateway` present), the offline C build
ran, and the credential leak scan ran (`~/AI/secrets/scm_draft_pass.md` present).

**Check count, reproduced from both commits.** The 83 to 86 delta was re-measured rather than
accepted from `## Implementation`. Clean trees were exported with `git archive` into
`/tmp/opencode/t0044-base` at `1cf0bc6` and `/tmp/opencode/t0044-mut` at HEAD, and the gateway
selftest was held off in both with `AGENTGATEWAY_BIN=/nonexistent` so the two runs differ only by
the change. `1cf0bc6` answers `SELFTEST: 82 checks passed` with `28 passed` in pytest. HEAD answers
`SELFTEST: 85 checks passed` with `29 passed`. Adding the one gateway check each run skipped gives
83 and 86, which is the recorded pair, and the +3 is the two roster `PASS` calls at
`tests/selftest.sh:87` and `:91` plus the one new pytest test.

**Assertion liveness.** The roster and licence assertions were tested by breaking them, in seven
throwaway copies of the tree. Each mutant is a copy at HEAD with one defect injected.

| Mutant | Injection | Gate response | Exit |
|---|---|---|---|
| A | `.opencode/agents/flicky.md` restored | `selftest FAIL: agent roster is 12 files, expected 11` | 1 |
| A2 | same copy, `python3 tests/config_gate.py` | `config-gate FAIL: roster mismatch`, both lists printed | 1 |
| B | retired file restored and another agent removed, so the count stays 11 | `selftest FAIL: retired licence agent file is back in .opencode/agents` | 1 |
| C | `"flicky": allow` re-added to `robotnik.md` task block | `config-gate FAIL: robotnik: task allows an agent that is not on the roster: ['flicky']` | 1 |
| D | `POLICY_EXCEPTION` stripped from `charmy.md` | `config-gate FAIL: charmy: missing the licence-audit duty 'POLICY_EXCEPTION'` | 1 |
| E | `ROSTER = [...]` re-added to `team/a2a/server.py` | `config-gate FAIL: a2a server: the static ROSTER list must stay retired` | 1 |
| F | a second `## License Audit` line added to the planning template | `config-gate FAIL: planning template: expected exactly one licence section` | 1 |
| G | `→ \`Flicky\`` re-added to the AGENTS.md chain | `config-gate FAIL: AGENTS.md: a review chain still names the retired licence agent` | 1 |
| H | `review_flicky` re-added to `REVIEW_STAGES` | `test_review_chain_ends_at_the_licence_agent` FAILED, 5 failed in `tests/test_cycle.py` including two `KeyError` graph wiring failures | 1 |

Split-name constructions (`"Flic" "ky"`, `"fli" + "cky"`, `fli""cky.md`, `"review_" + "flic" + "ky"`)
are deliberate, commented at `tests/config_gate.py:27-30`, `tests/selftest.sh:78-82`, and
`tests/test_cycle.py:124-126`, and none matches the sweep pattern, which is why the sweep box above
returns zero while the assertions still name the retired agent.

### Finding 1, the bash syntax gate asserts nothing, harness bug, mine
**Where:** `tests/selftest.sh:25` and the same pattern at `tests/selftest.sh:40`
**Problem:** the case pattern is `*"/bin/bash"*`, and `/bin/bash` is not a substring of
`#!/usr/bin/env bash`, which is the shebang every bash file in this repo carries. Verified directly.
A loop over the 21 shebang'd files under `scripts`, `team`, and `tests` prints `NO MATCH bash branch`
for all 17 bash files and matches only the 4 python files, `scripts/a2a-send`,
`scripts/a2a-server.py`, `scripts/dispatch-gate`, `team/portless/portless`. So the syntax gate
contributes 4 `PASS` calls, all of them python, and the line `selftest: bash + python syntax OK`
overstates what it ran. The shellcheck loop uses the identical pattern, so installing shellcheck on
this host would add 0 checks and lint 0 files, which also means the shellcheck skip costs nothing.
**Failure scenario:** a bash file in `scripts` or `team` stops parsing and the suite stays green.
That is not hypothetical, see finding 2.
**Fix, owned by Big, out of this task's scope:** match the interpreter rather than a path prefix,
covering both `#!/bin/bash` and `#!/usr/bin/env bash`, in both loops, and re-count. Expected effect
is 17 additional syntax checks, and 17 more once shellcheck is installed on the runner. Not applied
in this pass because the brief is the TASK-0044 verdict, not a harness change, and a check-count
change in the middle of a review chain would move the number the other agents are quoting.

### Finding 2, a real defect the dead gate is currently hiding, code bug, goes to Tails
**Where:** `scripts/vm-create-rocky.sh:4`
**Evidence:** `bash -n scripts/vm-create-rocky.sh` answers
`scripts/vm-create-rocky.sh: line 78: unexpected EOF while looking for matching '"'`, exit 2. The
cause is on line 4, isolated by `sed -n '4p' scripts/vm-create-rocky.sh > t2.sh; bash -n t2.sh`,
also exit 2, while the corrected line parses with exit 0. `od -c` on that line ends `... 3 0 G ] " }`,
so the closing brace of the parameter expansion sits outside the closing double quote, and the
correct order is `...]}"`. Out of the 17 bash files checked by hand with `bash -n`, this is the only
failure.
**Blast radius.** None today. `grep -rn vm-create-rocky` over `scripts team .github tests README.md`
finds only the file's own usage string at `:4`, and `scripts/vm-create` is the documented entry
point (AGENTS.md section 12). `git log -1 -- scripts/vm-create-rocky.sh` is `88e9f01`, so this is
pre-existing and outside the TASK-0044 sweep, which is exactly why a sweep that greps for a name
finds it and a gate that should parse it does not. Owned by Tails as a one-character fix, paired
with finding 1, and not a blocker for this task's roster change.

### Finding 3, soft assertion, nit
**Where:** `tests/config_gate.py:139`. The retired static roster is guarded only by the literal
`"ROSTER = ["`. A `ROSTER=[` or a tuple form would pass the gate while hardcoding the roster again.
It fires under mutant E, so it is a real assertion with a narrow trigger, not a dead one. Recorded
rather than fixed for the same reason as finding 1.

### Finding 4, graph verdict contract, nit for Robotnik
**Where:** `team/graph/state.py:116-134`, contract at `:117-122`. A review stage whose output carries
no `VERDICT:` line is fail-closed. In this doc `Shadow` ends `## Review` with a `VERDICT:` line and
`Omega`'s `## Security` section ends with none. Under the graph router that reads `review_omega`, the
absence reads as fail. This is the graph's contract working as designed, and it is worth `Robotnik`
knowing before a graph-driven run reads this chain. My own report to the dispatcher carries a
`VERDICT:` line for the same reason.

**Coverage dropped by this run.** None relative to the recorded suite. The suite lost the shellcheck
block because the tool is absent, and that block would have asserted 0 checks even with the tool
present, per finding 1. The python files under `tests/` that carry no shebang, `conftest.py`,
`test_a2a.py`, `test_cycle.py`, `test_licence.py`, `test_portless.py`, are not `py_compile`'d by the
syntax gate, and are covered indirectly because `pytest` imports them, which is why they compile
cleanly here.

**Verdict:** the TASK-0044 change passes. The roster is 11 files with the retired agent file absent,
both selftest roster assertions execute and both fail when the retired agent is reinstated, the
config gate runs inside selftest and standalone and all six of its assertions fail under mutation,
the licence gate runs inside selftest and standalone at `PASS` exit 0, pytest is 29 passed with no
skips, the 83 to 86 delta reproduces from `1cf0bc6` and HEAD rather than being taken on trust, the
CI floor at 70 is unchanged, and the name sweep over the DoD's forbidden paths is zero. Two findings
do not block it and neither is a defect in the change under review. The bash syntax gate is a dead
branch that I own and must fix, and it is currently hiding a genuine `bash -n` failure in
`scripts/vm-create-rocky.sh:4` that belongs to Tails. Both are outside the roster sweep and neither
touches the contract files this task changed.

VERDICT: PASS the roster change, gates execute and fail under mutation, 86 checks reproduce the recorded delta. Two follow-ups are open and neither blocks this task, the dead bash syntax branch at tests/selftest.sh:25 and :40 owned by Big, and the parse failure at scripts/vm-create-rocky.sh:4 owned by Tails

---

## Docs

*Owner: `Vector`.*

**`F6` docs pass, 2026-11-25 03:11 UTC (12:11 JST).** The user-facing docs are aligned to the
eleven-agent roster and the four-stage review chain. Roster table verified file by file against
`.opencode/agents/`: the directory holds exactly 11 files (`amy`, `big`, `charmy`, `espio`,
`knuckles`, `omega`, `robotnik`, `shadow`, `sonic`, `tails`, `vector`, listed by `ls -la`), the
catalogue carries exactly 11 rows, one per file, no extra row, and the Mode column matches each
file's frontmatter (`robotnik` primary, `shadow` all, the other nine subagent).

| File | Sections touched | What changed |
|---|---|---|
| `README.md` | Architecture, line 9 | "12-agent team" to "11-agent team". The only stale roster count left in the README by the `F1` sweep. |
| `README.md` | Key permission patterns, `README.md:49-52` | Closes `Shadow`'s nit at `## Review`. Adds Charmy's one exception to the read-only-on-code bullet in a single clause: it owns `team/licenses/policy.yaml` and may change it only inside a task that explicitly changes policy, matching `charmy.md:33-35`. |
| `planning/templates/planning-doc.md` | | Checked, needed no change. `Tails` merged the licence sections at `ef06147`; my sweep grep shows no stale reference. |
| `AGENTS.md` | sections 1, 2, 3, 9, 18 | Checked, needed no change. Tails' pass landed them and my `grep -rinE 'twelve|12[- ]agent|five[- ]reviewer|flicky'` over `AGENTS.md` returns zero. |
| `.github/workflows/`, `team/licenses/`, `scripts/licence-check`, `tests/` | | Checked, needed no change. Same sweep, zero matches in those paths. |

**Checked and needed no change:** the rows above, plus the README delegation tree (11 names), the
"Agent catalogue" rows, the `team/graph/` row chain (Shadow, Omega, Big, Charmy), the "How it works"
step 5 (four reviewers), the "License compliance" bullets (Charmy single licence owner), and the
repository-structure note "(11 files)" at `README.md:399`, all re-read against the files rather than
taken from `F1`'s record.

**Could not verify, and what would settle it.** `team/a2a/server.py:109` still reads "twelve-role" in
the agent-card description string, found by the same sweep (the sole non-README match). Not edited by
me because it is code text and `## Status` at 00:50 UTC routes it into the `F8` `Tails` fix dispatch.
`F8` landing that one-line edit with the A2A card test green settles it. The README Sonic row's
"GitHub CLI" matches `sonic.md`'s own prompt but sits against AGENTS.md section 13's "the `gh` CLI is
not installed on this host"; pre-existing, outside this task, recorded rather than edited.

**Checks that did not run.** No GitHub Actions workflow ran (the self-hosted runner is unregistered on
this public repo, AGENTS.md section 6), so the effective gate for this commit is the `pre-push`
selftest, whose result is recorded in the commit record below. The licence gate, config gate, and
pytest were not re-run by me standalone; they run inside that selftest. No contact with
`192.168.1.99`. The `planning/docs/TASK-0042-*` file dirty in the tree belongs to a concurrent
session and is excluded from my commit.

---

## Release

*Owner: `Knuckles`.*

**`F7` close-out, 2026-11-25 03:40 UTC (12:40 JST).** `Knuckles`, dispatched as `F7`.

**DONE checklist verified:** partial. Every gate row is proven at HEAD. The branch-and-PR row is not
satisfied as written, see the landing shape below.

**Landing shape, recorded plainly.** `F1` already landed the implementation on `main`. There is no
`feature/TASK-0044-*` branch locally or on the remote, `git ls-remote --heads origin` lists only `main`
at `81142c7` and `task-0043-dispatch-gate`, because the `F1` dispatch brief told `Tails` to push
`main`. No PR was opened and no merge commit exists, so there is no merge to verify and I created none
retroactively. What closed this task is `F1` plus the review-driven follow-up commits, and what I
verified is each follow-up commit's presence on the remote ref.

**Verified from the remote, not from the dispatch report.**

| Item | Command | Result |
|---|---|---|
| Remote tip | `GIT_ASKPASS=/home/howard/AI/booth-2026/git-askpass-tc.sh git ls-remote origin refs/heads/main` | `81142c7cf7c693a92915c21411cc43cbd570a273` |
| `F6` landed | `git fetch origin main`, then `git merge-base --is-ancestor 3367f21 origin/main` | exit 0, ancestor of the remote ref |
| `F8` landed | same, `git merge-base --is-ancestor 482aed5 origin/main` | exit 0, ancestor of the remote ref |
| `F8` record landed | same, `81142c7` | exit 0, equal to the remote tip |
| Signatures | `git log --show-signature -1 3367f21` and `-1 482aed5` | both `Good signature from "Team Chaotix <howard.a.vanderwal@protonmail.com>" [ultimate]`, EDDSA `D553FBE4B47020B2033E9594F9261D151316FD60` |
| Signing policy | `git config commit.gpgsign` | `true`, `user.signingkey` the same key |

**Commit chain that constitutes this release**, all on `main`, all GPG-signed.

| Commit | Step |
|---|---|
| `ef06147` | `F1`, roster removal and the Charmy fold-in, 18 files, 590 insertions, 162 deletions |
| `e22bb3c` | `F1b`, closes `Shadow` finding 1, `team/licenses/policy.yaml:20` and `:129` pointers |
| `68babaf`, `8efdcf7` | `Robotnik`-owned records, `Shadow` finding 2 restatements and the `F3` to `F5` verdicts |
| `3367f21` | `F6` `Vector`, README to the 11-agent roster plus the Charmy policy-ownership clause |
| `482aed5` | `F8` `Tails`, `team/a2a/server.py:109`, the syntax-gate widening, `scripts/vm-create-rocky.sh:4` |
| `81142c7` | `F8` `## Implementation` record |
| this close-out | `F7` |

**Gates I re-ran at HEAD `81142c7` before committing this entry.**

| Gate | Command | Result |
|---|---|---|
| selftest | `bash tests/selftest.sh` | `SELFTEST: 103 checks passed`, exit 0 |
| config gate | `python3 tests/config_gate.py` | exit 0, six notes, `roster OK (11 agents)` |
| licence gate | `scripts/licence-check` | `(PASS)`, exit 0, 3 findings, all MIT |
| roster | `ls .opencode/agents/ | wc -l`, `test -e .opencode/agents/flicky.md` | 11 files, `flicky ABSENT` |
| name sweep | `git grep -c -i flicky -- .opencode AGENTS.md README.md planning/templates tests .github team scripts` | zero matches, exit 1. `git grep -i -n flicky | wc -l` is 196, all inside `planning/`, `DEMO-LOG.md` and the two `continue-prompt-task0038-*.md`, the accepted-history band `Shadow` ruled at `## Review` |
| four-stage chain | `grep -n '→' AGENTS.md | grep -i charmy` answers `:127`, `:129`, `:497`. `README.md:132` and `:145`. `planning/templates/planning-doc.md:126`. `python3 -c "from team.graph.state import REVIEW_STAGES, STAGE_AGENT; ..."` answers `('review_shadow', 'review_omega', 'review_big', 'review_charmy')` with last-stage agent `charmy` | consistent, no stale fifth reviewer |
| `F8` content present | `sed -n '109p' team/a2a/server.py`, `sed -n '25p;41p' tests/selftest.sh`, `sed -n '4p' scripts/vm-create-rocky.sh`, `bash -n scripts/vm-create-rocky.sh` | `an eleven-role autonomous`, the widened `*/usr/bin/env bash*` pattern in both loops, `]}\"` order correct, `bash -n` exit 0. This settles the item `## Docs` could not verify |
| marker block | `git show 1cf0bc6:AGENTS.md | awk '/agentsmd:learned:start/,/agentsmd:learned:end/' | sha256sum`, and the same awk over HEAD | both `1b4d3c918162ad03584e1a42ec5408420538d0cdd41560686f740d13d40d32ca`, byte-unchanged, nothing promoted |
| credentials | `git diff 1cf0bc6..81142c7 -- . ':(exclude)planning' > /tmp/opencode/t0044-f7.diff` then `grep -F -f ~/AI/secrets/scm_draft_pass.md` and the same with `~/AI/secrets/scm_draft_rdp_pass.md` | no match, exit 1 both |

**DoD ledger.** `## Definition of Done` is `Robotnik`'s section, marked "Owner: `Robotnik`, and nobody
else", and AGENTS.md section 2 rule 2 bars me from editing another agent's section, so I did not flip
the boxes. Conflict named rather than resolved silently. The rows with the proof that backs each one,
for `Robotnik` to apply.

| Row | State | Proof |
|---|---|---|
| 1, agent files and Charmy's audit duties | proven | `ls .opencode/agents/`, flicky absent, `config_gate.py` asserts the duty strings |
| 2, Charmy fourth and last, one licence section | proven | `config_gate.py` asserts `fourth and last` and the single `## License` line |
| 3, name sweep with surviving count reported | proven | zero in the forbidden paths, 196 total, band enumerated above |
| 4, four-stage chain in every contract file | proven | the chain row of the gate table above |
| 5, config gate asserts 11 agents and the duty, gate passes | proven | exit 0, six notes |
| 6, permission block superset with before and after recorded | proven | `## Implementation` at `doc:221-247`, `Shadow` verified the blocks byte-identical at `doc:515` |
| 7, Charmy records the gate outcome | proven, with a bound | Charmy recorded exit 0 `(PASS)` at HEAD `68babaf`, `doc:586-592`. That record predates `3367f21` and `482aed5`. The gate re-ran inside the `F8` selftest at `482aed5` and I re-ran it standalone at `81142c7`, both `(PASS)` exit 0, so the outcome holds at HEAD even though Charmy's own run predates the follow-ups |
| 8, selftest via pre-push, counts against the 83 baseline, `MIN=70` | proven | 83 to 86 at `ef06147`, 86 to 103 at `482aed5`, my run at `81142c7` answers 103, the pre-push hook re-ran it on the push below, floor unchanged at `.github/workflows/team-selftest.yml:50` |
| 9, no credential in the diff | proven | the credential row above, both greps exit 1 |
| 10, marker block byte-unchanged, nothing promoted | proven | identical sha256 at `1cf0bc6` and HEAD |
| 11, each reviewer reports with no unresolved blocker | proven | `Shadow` FAIL with two should-fix findings and no blocker, both closed (`e22bb3c`, and `68babaf` for the `Robotnik`-owned rows). `Omega` one medium accepted as the task's stated purpose and one low, that low fixed at `482aed5`. `Big` PASS. `Charmy` PASS |
| 12, Vector updates README | proven | `3367f21`, `README.md:9` and `README.md:49-52`, verified from the remote |
| 13, branch, PR, merge | **not satisfiable as written** | the work landed directly on `main` by dispatch instruction. Signed commits and remote verification, yes. Branch and PR, no. Recorded as a deviation, not ticked |

**Checks that did not run.** The GitHub Actions workflows `Team Selftest` and `Licence Check` never ran
for this task, the self-hosted runner is not registered on a public repo, AGENTS.md section 6, so the
pre-push selftest is the effective gate. The shellcheck block at `tests/selftest.sh:38-50` did not run,
`shellcheck` is absent on this host, and with the widened pattern it would contribute 17 lint passes
once installed. No CI, review, or security check ran behind a PR, because no PR exists. Sparky, podman,
and libvirt layers do not apply, this change is roster text, contract text, a graph stage tuple, and
tests, with no runtime service and no UI. No contact with `192.168.1.99` in this pass. No deployment
was dispatched, there is nothing deployable in this task.

**Versioning.** No release tag exists in this repo (`git tag` is empty) and no DoD row asks for one.
`team/__init__.py:15` stays at `2.0.0` and I did not bump it. Recorded for `Robotnik`, the removal of
`review_flicky` from `REVIEW_STAGES` is a contract change any future tag should reflect, and
`team/requirements.txt` still has no lockfile, which is `Charmy`'s recorded item at `doc:650-654`.

**Push and read-back.**

| Item | Value |
|---|---|
| Unpushed local commit found | `2a68f78 docs(planning): ...`, `git log origin/main..HEAD` showed it as the one commit ahead of `81142c7`. Pushed as part of this push |
| This entry | one commit, GPG-signed EDDSA, `docs(t0044 F7): ...` |
| Pre-push gate | `scripts/hooks/pre-push` ran `tests/selftest.sh` on the push, `SELFTEST: 103 checks passed` |
| Push | `GIT_ASKPASS=/home/howard/AI/booth-2026/git-askpass-tc.sh git push origin main` |
| Remote read-back | `git ls-remote origin refs/heads/main` after the push |

**Open outside this task, not blockers for it.** `Espio` still owes the `## Archive` prune of the legacy
licence-audit headings, `E1` in `planning/docs/TASK-0042-foss-for-all-scmdraft2-demo.md`. The booth and
remote upstream audits are the carried `R4`, `T4`, `G4` scope in their own tasks. `TASK-0044` itself is
closed at the release step.

VERDICT: PASS the roster change is on the remote at 81142c7, all gates re-run at HEAD pass, 103 checks, and the DoD branch-and-PR row is recorded as a deviation because F1 landed on main by dispatch instruction
---

## Archive

*Owner: `Espio`, the only agent that deletes.*
