# Continue prompt — Cinnamon-for-Rocky10 (PM handoff, 2026-10-05)

Continue the Cinnamon-for-Rocky10 project from this handoff. Working directory:
/home/howard/AI/projects/team-chaotix. Start with planning/docs/TASK-0033-cinnamon-project-environment.md
and read ## Status and ## Next Actions. The 2026-10-05 entries in ## Status record the state.

**State at handoff:**

- TASK-0033: `Tails` run 2 complete. sshd enabled on `Fedora_45_Cinnamon` (first guest
  modification of the task, no reboot), `howard` password login verified, session state plus
  14-package Cinnamon inventory plus post-fix virsh screenshot (md5 plus PIL) written to
  ## Implementation. A password-echo incident during the blind-GUI key injection is recorded
  there with an operator rotation step.
- The next dispatch (`Shadow`) was interrupted in the prior PM session before completion.
  First check ## Review: if it has no dated `Shadow` findings block covering run 2, dispatch
  `Shadow` first; if one exists and covers run 2, proceed to `Omega`.

**Remaining work, in this order, one dispatch at a time** (single inference slot, strictly sequential):

1. TASK-0033 review chain: `Shadow` → `Omega` → `Big` → `Charmy`. `Omega` picks up the pre-flagged
   GitHub token embedded in the 10 component repos' `origin` URLs, plus the password-echo incident.
   `Big` independently re-verifies both VMs per the DoD. Open findings go back to `Tails`, then
   re-run the chain until clean.
2. Then `Vector` (old-path reference at `AGENTS.md:30` in the untracked project `AGENTS.md`, per
   ## Next Actions), then `Espio` to prune the doc.
3. Then continue TASK-0026 (planning/docs/TASK-0026-cinnamon-control-center-comparison.md) from
   item 2 of its ## Next Actions.
4. Then continue TASK-0027 (planning/docs/TASK-0027-cinnamon-brightness-fix.md) from its Amy item.

**Standing gotchas:**

- Every `virsh` command passes `-c qemu:///system`. The default URI on this host resolves to
  the empty `qemu:///session`.
- The VM password lives at `~/AI/secrets/pass.txt` and is read with `sshpass -f`. Never write
  it to any file, commit, log, or doc.
- Workers never read image files. Screenshots are analyzed with text tools only (md5, PIL
  histogram).
- Keep subagent briefs to two or three sentences that point at the planning doc. Do not paste
  file contents into briefs.
- An empty or truncated subagent result is not "nothing to report": check
  `~/.local/share/opencode/opencode.db` for `finish: "length"` with 32000 output tokens, then
  re-dispatch with a smaller brief.
