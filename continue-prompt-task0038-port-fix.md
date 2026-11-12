# Continuation prompt, TASK-0038: Xorg + lightdm port, post-Shadow fix loop

For a fresh `Robotnik` (PM) opencode session, launched from this directory
(`~/AI/projects/team-chaotix`). Written 2026-11-04 per rule r001: the prior PM session's
`Tails` dispatch failed at startup with "Compaction summary reached the output token limit"
(PM session context too large for the child to inherit). The prior session read five
screenshots and six long subagent summaries; this session must not repeat that.

## One-line task

Fix the four findings `Shadow` recorded for the 2026-11-02/03 work (one blocker, two
should-fix, one nit), then run the review chain to the end and finish the held release.

## First actions (in order)

1. Read ONLY `planning/docs/TASK-0038-cinnamon-gpg-settings-icons.md` — the `## Status`,
   `## Definition of Done`, and `## Next Actions` sections. Do not read the doc in full; it
   is long.
2. Dispatch `Tails` for the fix pass. The findings are cited in `## Review` (read that
   section yourself only if you must; the `## Status` handoff summarizes them):
   - Blocker: parse-broken `%post`/`%postun` in `spec/cinnamon-rocky-defaults.spec:157-171`
     (every `if` missing its `then`). Repair the scriptlets including the design's guarded
     gdm re-enable, rebuild at `1.0-7`, re-sign under the tracked key, refresh
     `SHA256SUMS` / `repodata/`, re-stage, apply on 182 under `gpgcheck=1` — the scriptlet
     must do the work itself this time (no `scriptlet failed` in the dnf log, DM default
     state verified), and the record must disclose the earlier unrecorded manual step on
     182 (the post-transaction symlink).
   - Should-fix 1: move the seven X-stack/lightdm specs from `/tmp/opencode/task38-lightdm/`
     into the project `spec/` tree so all 104 RPMs are rebuildable from the repo.
   - Should-fix 2: correct the INSTALL.md "Current status" paragraph to claim only what
     `## Test Results` records.
   - Nit: the `vm-test/install-set.txt:10-12` one-liner (`sort -u`) must reproduce the
     committed file (`sort -f`-ordered).
   Point at the planning doc; do not restate it in the brief.
3. Then, per `## Next Actions`, one agent at a time (single inference slot, `--parallel 1`):
   `Shadow` re-review → `Omega` → `Big` (fresh-consumer `gpgcheck=1` run plus `## Test
   Results` entries for the two new DoD items: window-button theme availability, default
   login screen) → `Charmy` → `Flicky` → `Vector` (README + tag-pinning sentences;
   INSTALL.md is already done) → `Knuckles` (commit + PR, held until the icons match).

## State as of 2026-11-04 (details in the planning doc)

- 104-RPM set built, signed, staged; 40-name install set plus `gnome-icon-theme`. 182 is
  live in a working lightdm session (left applied, r002); 181 is the untouched baseline.
- `Shadow` verified everything else clean: 104/104 sums + signatures under the tracked
  subkey, repodata = 104 packages, provenance HEADs + Koji buildids match, docs match the
  40-name install set.
- The blocker matters because it is the only mechanism that makes lightdm the default on a
  fresh consumer; the `1.0-7` rebuild is what the fresh-consumer test must pass.

## Environment (paths only; never echo secret values)

- Project: `~/Linux/projects/cinnamon-for-rocky10/` (canonical repo `metalllinux`). The
  remote URL embeds a token; reference it by path and never print it.
- VMs (system level, passwordless `ssh howard@...`, key installed):
  - `Rocky_Linux_10_Cinnamon_AI`, 192.168.1.182, the changed VM (passwordless sudo for
    howard/wheel in effect)
  - `Fedora-45-Cinnamon-AI`, 192.168.1.181, the baseline
  - VM trap: `sudo virsh` (the system connection) is the correct path; bare `virsh`
    (the howard session) is a rootless instance with a different domain set.
- GPG: secret key + passphrase in `~/AI/secrets/` (`gpg-secret-key.asc`,
  `gpg-passphrase.txt`); signing keyring `~/.gnupg-cinnamon-rocky10`; tracked public key
  `keys/cinnamon-rocky10-public.asc`.
- Screenshots: `~/Linux/projects/cinnamon-for-rocky10/screenshots/` (the operator pairs and
  the team captures under `rl10/` and `f45-beta/` date directories).

## Discipline (binding)

- Read only `## Status` / `## Definition of Done` / `## Next Actions` of the planning doc,
  in small passes. Do not read the screenshots again unless a worker reports a discrepancy
  you must adjudicate.
- Dispatch one subagent at a time and wait; every subagent turn ends in a tool call (32k
  output cap, AGENTS.md section 14).
- Never echo secret values (the GPG passphrase, the VM password, the URL-embedded token);
  record the command and the evidence for every claim.
- Rule r002: leave every change the team tests applied on the test VMs. Do not reset or
  destroy a test VM at the end of a run. The operator checks the VMs for themselves.
- Rule r001: if a dispatch fails with a request-body or compaction-summary size error,
  record the handoff in `## Status`, stop dispatching, and continue in another fresh
  session from this same prompt.
