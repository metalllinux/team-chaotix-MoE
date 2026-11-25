# TASKS — Team Chaotix

Master index of every task the team is working or has worked. One row per task, one planning doc per
task. `Robotnik` owns this file.

Statuses: `Planning` · `In Progress` · `In Review` · `In Test` · `Releasing` · `Done` · `Blocked`

| Key | Title | Owner agent | Planning doc | Status |
|---|---|---|---|---|
| TASK-0001 | Team Chaotix V1 Setup | Robotnik | n/a, built ahead of the team | Done |
| TASK-0007 | Git worktrees support for parallel projects | Robotnik | planning/docs/TASK-0007-git-worktrees.md | Done |
| TASK-0010 | EVO-X2 iGPU wedges: root cause + durable fix | Robotnik | planning/docs/TASK-0010-evox2-gpu-wedge-fix.md | Done |
| TASK-0011 | Set Q4_K_XL Qwen 3.8 as the team's default model | Robotnik | planning/docs/TASK-0011-default-model-q4kxl.md | Done |
| TASK-0012 | Align team dispatch to single-slot endpoint (--parallel 1) | Robotnik | planning/docs/TASK-0012-single-slot-sequencing.md | Done |
| TASK-0013 | README: GMKtec EVO-X2 + Qwen 3.8 UD-Q4_K_XL model host setup | Robotnik | planning/docs/TASK-0013-evox2-readme-setup.md | Done |
| TASK-0014 | Vector agent: extend bash permissions to finish TASK-0013 DoD items | Robotnik | planning/docs/TASK-0014-vector-bash-permissions.md | Done |
| TASK-0019 | Diagnose Espio empty-result failures; harden team against the 32k turn cap | Robotnik | planning/docs/TASK-0019-espio-32k-turn-cap.md | Done |
| TASK-0020 | TV project: quiet hours for hard drive activity (installer option + override commands) | Robotnik | planning/docs/TASK-0020-quiet-hours.md | Done |
| TASK-0021 | Team lesson: interactive-input test stubs fed via `$(...)` lose in-subshell state | Robotnik | planning/docs/TASK-0021-subshell-input-stub-lesson.md | Done |
| TASK-0022 | Set IQ4_XS Qwen 3.8 as the team's default model | Robotnik | planning/docs/TASK-0022-team-model-iq4xs.md | Done |
| TASK-0023 | Install ripgrep (rg) on the agent host | Robotnik | planning/docs/TASK-0023-rg-host.md | Done |
| TASK-0025 | Team v2: license agent, VM isolation, agentgateway/A2A, agentsmd, operator model | Robotnik | planning/docs/TASK-0025-team-v2-upgrade.md | Done (2026-09-29; all spec items implemented, verified end-to-end, committed) |
| TASK-0028 | Rocky 10 + Fedora Cinnamon VM deploy skill | Shadow | planning/docs/TASK-0028-vm-deploy-skill.md | Done |
| TASK-0029 | VM scripts repair (align scripts/ with AGENTS.md section 12) | Robotnik | planning/docs/TASK-0029-vm-scripts-repair.md | Planning |
| TASK-0030 | Team model migration to Qwen3.8-27B-UD-IQ3_XXS (thinking low on workers) | Robotnik | planning/docs/TASK-0030-team-model-migration.md | Done |
| TASK-0031 | vm-deploy skill update (dual libvirt instance gotcha, boot caveats) | Tails | planning/docs/TASK-0031-vm-deploy-skill-update.md | Done |
| TASK-0032 | Operator-directed text corrections (site woodwork draft: banned word + phrase) | Tails | planning/docs/TASK-0032-operator-text-corrections.md | Done |
| TASK-0036 | Host reinstall: back up the state outside ~/AI and ~/Linux (GPG signing key, old public key, VM disks, team files) | Robotnik | planning/docs/TASK-0036-host-reinstall-backup.md | In Progress (operator 2026-10-20: ~/AI and ~/Linux are auto-backed up; the rest is this task) |
| TASK-0037 | Team platform: cycle graph, A2A, portless, licence gate, gateway wrapper; new Flicky licence agent | Robotnik | planning/docs/TASK-0037-team-platform.md | In Progress (implementation landed on main as 28e4b2a 2026-10-24; selftest 55 checks green; review chain pending; runner registration N/A while repo is public, operator decision — local pre-push selftest is the gate) |
| TASK-0039 | Update team agents to catch GPG, icon, and feature-parity issues | Robotnik | planning/docs/TASK-0039-agent-gpg-icon-feature-catch.md | Done (2026-10-25; merged to main as dfbd140 via PR #2; selftest 56/56 + config gate green; commit-signing gap recorded as team-wide follow-up — resolved by TASK-0040) |
| TASK-0041 | Remote visual control of a GNOME 49 Wayland Rocky 10.2 target (screenshots, OCR, keyboard, mouse) | Robotnik | planning/docs/TASK-0041-remote-visual-control.md | In Progress (2026-11-26 02:11 JST, 2026-11-25 17:11 UTC. Review chain complete as `T1` `Shadow`, `T2` `Omega`, `T3` `Big`, `T4` `Charmy`, `T5` void under TASK-0044, and `K9` `Tails` landed the one `T1` nit plus the selftest guarded-build fix at `9190b04`. `Omega` closed findings 1, 3 and 8 and left finding 2 open, the RDP `/cert:ignore` self-signed certificate with no channel test ever run, and the mode 644 secret as operator action. `Big` measured 61 to 83 at `b906f00`, proved the offline rule with `unshare -rn`, and named two unfixed harness items, 4 of 6 dry-run asserts relying on tool self-report and a loose `UI_DEV_CREATE` alternation. Residual DoD rows, a `Vector` docs pass as `D2`, the `DEMO-LOG.md` row, and a `Knuckles` read-back as `K3`. Resume at `LIVE QUEUE 7` item 3 in the TASK-0042 doc `## Next Actions`) |
| TASK-0043 | Dispatch gate, the dispatcher's context ceiling made mechanical | Robotnik | planning/docs/TASK-0043-dispatch-gate.md | Done (2026-11-26 02:11 JST, 2026-11-25 17:11 UTC, closed by `K2` `Knuckles` with 10 of 10 DoD rows ticked. Review chain ran as `G1` `Shadow`, `G2` `Omega`, `G3` `Big`, `G4` `Charmy`, `G5` void, and the fix the chain agreed on landed at `f1907ab`, cumulative in-flight prompt measured from numeric store fields, explicit `--session` required, peak window, worst-jump term and the fitted 1.6 inherit ratio retired, WARN 245760 and BLOCK 258048 unified with the dispatcher instructions. Selftest 106 before `f1907ab` and 110 after. `44a017e` and `f1907ab` verified as ancestors of `refs/heads/main` at `11058ef`. agentsmd promotion and margin re-fit remain operator-owned, `Big`'s synthetic-store fixture stays open as a harness item) |
| TASK-0042 | FOSS for All booth demo: SCMDraft 2 on 192.168.1.99 under Wine, five maps, docs repo | Robotnik | planning/docs/TASK-0042-foss-for-all-scmdraft2-demo.md | In Progress, dispatchable queue empty, no context handoff (2026-11-26 02:11 JST, 2026-11-25 17:11 UTC, `Robotnik` session `ses_ded91638cffe1PedTvitwlfONJ`. `LIVE QUEUE 6` ran in full, `T2`, `T3`, `T4`, `K9`, `G1` to `G4`, the gate fix at `f1907ab`, `D1` `Vector`, `K1` `Knuckles`, then `P3` once its date gate lifted on 2026-11-26 JST, `K2` and `E1`. **NOT DONE, `K1` verified 5 of 23 DoD rows ticked**, blockers named in `## Release`. `P3` measured the six-map rebuild cycle at 2231.62 s against the 2231.57 s baseline with per-map overhead 43.90 to 44.42 s, confirmed host-key pinning, and found the urgent item, the target firewall rich rule restricts 3389 to `192.168.1.102` only, so venue reachability on 2026-11-28 is an operator ruling. `D1` and `K1` were issued out of order against one working tree and swept each other's doc text, `12e7928` and `93ddaf6` are mixed-attribution, recorded and reconciled by `E1`, no history rewritten. Booth repo stays private under `R4`'s FAIL on `7c4fa16`, `C2` and `C3` are operator rulings, booth `main` reads `19ab5af`. Resume at `LIVE QUEUE 7` in `## Next Actions`) |
| TASK-0040 | Commit signing key for Team Chaotix, key material in ~/AI/secrets | Robotnik | planning/docs/TASK-0040-commit-signing-key-setup.md | In Progress (2026-11-10: W1-W6 complete; final key F9261D151316FD60 uid Team Chaotix <howard.a.vanderwal@protonmail.com> in ~/AI/secrets (600/700), ~/.gitconfig applied and backed up, three remotes wired, proof commit b1ea2c3a…0a8e on verification/TASK-0040-commit-signing (single signed empty commit off origin/main, not merged); operator web-UI done: final key registered at account level, prior team registrations deleted, protonmail address verified on the account; operator browser confirmation done: green Verified; 9/10 DoD boxes ticked; review chain re-run on the identity change complete (2026-11-11: Shadow pass 3 clean, Omega pass, Big PASS 6/6, Charmy pass, Flicky gate PASS exit 0); Knuckles doc-delta commit + Espio prune next; box 7 open on egress root cause (external, router/ISP) + PAT rotation + auto-backup destination) |

| TASK-0044 | Remove the Flicky agent and fold its licence-audit role into Charmy | Robotnik | planning/docs/TASK-0044-flicky-into-charmy.md | Done (2026-11-25 03:45 UTC, 12:45 JST, closed by `F7` `Knuckles`, remote `refs/heads/main` read back at `8d71d94` with `3367f21` and `482aed5` proven ancestors, all 13 DoD rows ticked, branch and PR recorded as a deviation because `F1` landed on `main` by dispatch instruction, selftest 83 to 86 at `F1` and 86 to 103 at `F8`. Earlier history retained: In Progress, handoff needed (2026-11-23 01:05 UTC, 10:05 JST, Robotnik session ses_dfa49b1f9ffeFR3Hj0IC38MUzW stopped delegating after five dispatches on a `PASS` reading of 52.0 percent with peak 78985 and child projection 136214 of 262144, 6067 below the 142281 projection TASK-0043 records as a false `PASS` whose real child request reached 262242. Review chain landed, `F2` Shadow FAIL with two should-fix findings both closed, `F3` Omega one medium one low two clean, `F4` Big PASS, `F5` Charmy PASS with the gate exit 0, and `F1b` landed the policy.yaml escalation fix at e22bb3c, main at 8efdcf7 pushed with selftest 86 checks. Remaining for this task, `F6` Vector, `F8` Tails, `F7` Knuckles, briefs written out in TASK-0042 `## Next Actions` `LIVE QUEUE 4`. Earlier handoff 2026-11-22 22:30 UTC, opened by direct operator instruction, DoD written before work started, and `F1` landed at `ef06147` and `641922e` on `origin/main`, verified from the remote, `.opencode/agents/flicky.md` deleted, eleven agent files remain, `git grep -in flicky` returns 0 matches across `.opencode`, AGENTS.md, README.md, tests, .github, team, scripts and planning/templates, selftest 83 to 86 checks. Review chain owed, `Shadow` as `F2`, `Omega` as `F3`, `Big` as `F4`, `Charmy` as `F5`, then `Vector` as `F6` and `Knuckles` as `F7`, briefs written out in TASK-0042 `## Next Actions` `LIVE QUEUE 3`. Review chain is now `Shadow`, `Omega`, `Big`, `Charmy`, and `R5`, `T5` and `G5` in TASK-0042 `LIVE QUEUE 2` are void with their scope carried into `R4`, `T4` and `G4`) |

The "Team Chaotix V1 Setup" row is the pipeline itself, built before the team existed to build it.
It has no planning doc because there was no team to write one. Every row after this one follows the
normal shape.

---

## How a row gets here

1. A task arrives from the user or from an upstream issue or pull request.
2. `Robotnik` creates `planning/docs/TASK-XXXX-<slug>.md` from
   `planning/templates/planning-doc.md` and writes `## Definition of Done` itself. Nobody else writes
   that section.
3. The row is added here.

## How a row leaves

It does not. Rows stay at `Done` as the project's record, and the planning doc stays with them. Closed
docs are how the team remembers what was decided and why. `Espio` prunes their contents; it
never deletes a doc.

## Conventions

- **`Owner agent`** is whoever the work is with *right now*, not who will finish it.
- **`Blocked`** always has a reason in the planning doc's `## Status`, naming what would unblock it.
- The `Planning doc` cell links to the file.

