# Continuation prompt — TASK-0038: System Settings, icon parity, and the GPG republish

*For a fresh `Robotnik` (PM) opencode session, launched from this directory
(`~/AI/projects/team-chaotix`). Written 2026-10-26 per operator request ("For the system
settings etc work, write a prompt to a file in this directory"). The prior PM session stopped
at its context boundary (rule r001) after TASK-0039 was merged; this session continues
TASK-0038.*

## One-line task

Continue TASK-0038 (Cinnamon for Rocky 10: GPG signing + install, System Settings launch +
icon, icon parity vs the Fedora 45 baseline) from plan items 6 and 7, through the
fresh-consumer-VM verification, to the review chain, docs, and the republish release.

## First actions (in order)

1. Read ONLY `planning/docs/TASK-0038-cinnamon-gpg-settings-icons.md` — `## Status`, `##
   Definition of Done`, `## Next Actions`, and `Tails`' last boundary note in `##
   Implementation` (the item-5 section). Do not read the doc in full; it is long.
2. Verify the working-tree state before building on it (first `Tails` dispatch): from
   `~/Linux/projects/cinnamon-for-rocky10/` run `sha256sum -c` against
   `/home/howard/snapshots/TASK-0038/rpms.sha256` and `git status`; expected is 62 modified
   (61 re-signed RPMs + `SHA256SUMS`) plus 3 deleted (the superseded csd 6.7.2-2 triplet) plus
   untracked. If the state differs, stop and re-read the doc.
3. Then dispatch per `## Next Actions`. One agent at a time; wait for each to finish before
   the next (single inference slot, `--parallel 1`).

## State as of 2026-10-26 (details are in the planning doc)

Plan items 1-5 done:
- Item 1: pre-change snapshot at `/home/howard/snapshots/TASK-0038/` (full-tree tarball,
  `rpms.sha256`, preserved reflogs, blob-compare artifact). This is the rollback point.
- Item 2: project git object store repaired (`git fetch --refetch`), `git fsck --full` clean;
  canonical bytes = working tree = `main` = `feature/TASK-0027` (tip `8d41fc9`).
- Item 3: per-file signature audit. Root cause of the operator's `gpgcheck=1` failure: 64 of
  67 published RPMs signed under the old key (`1689676AF4D4F6FEC142B4429C0A8912FDA02785`),
  3 under the tracked key's signing subkey (`14CF2C0A8A47323C`; primary
  `2274BFE1BF28C051CD98675BEBD13108EB7FEF99`), while `setup-repo.sh` / `INSTALL.md` ship and
  import only the tracked key and `INSTALL.md:188` / `:283` plus `README.md:156` record the
  OLD fingerprint.
- Item 4: signing keyring recreated at `~/.gnupg-cinnamon-rocky10` from `~/AI/secrets/`
  (path references only); `sign-rpms.sh` preflight passes; a throwaway signature proved the
  passphrase matches the key.
- Item 5: the 64 old-key RPMs re-signed under the tracked key in staging (`rpm --resign`),
  `repodata/` + `SHA256SUMS` regenerated, and a dnf `gpgcheck=1` consumer sub-check passed
  (positive control: tracked key, 22/22, RC=0; negative control: old key, RC=1, `GPG check
  FAILED`); the staged set was swapped into published `rpms/`.

Remaining, per the `## Plan` work breakdown (read it for the exact rows):
- Items 6 and 7 (independent): the System Settings item — `cinnamon-control-center` does not
  open on the Rocky 10 Cinnamon VM and its icon is broken (root cause not yet established;
  diagnose before fixing); and the icon parity item — desktop/panel icons differ from the
  Fedora 45 baseline, per the screenshots.
- Items 8 and 9 per the critical path: the fresh-consumer-VM end-to-end verification, where
  the GPG track converges at item 9 — `gpgcheck=1` full-set install from the documented
  procedure, desktop boot, System Settings launch, icon verification.
- Then items 10-15 per the plan: the fix loop, `Vector` docs, and the `Knuckles` release
  (commit + merge of the republished `rpms/` + `SHA256SUMS` + the `INSTALL.md` / `README.md`
  fingerprint and procedure fixes).

The `Big` verification run MUST use the new `big.md` "Cinnamon / desktop RPM projects" layer
(added by TASK-0039, merged to `main` as `dfbd140`): GPG verification on a fresh consumer,
icon parity against the reference desktop, and feature parity (Fedora 45 Cinnamon reference
vs the Rocky 10 Cinnamon RPMs, at feature level).

## Environment (paths only; never echo secret values)

- Project: `~/Linux/projects/cinnamon-for-rocky10/` (canonical repo `metalllinux`). The remote
  URL embeds a token; reference it by path, never print it. Moving it out of the URL is an
  operator configuration item (already flagged).
- Comparison screenshots: `~/Linux/projects/cinnamon-for-rocky10/screenshots/rl10/2026-10-24/`
  (Rocky 10 Cinnamon) vs `.../f45-beta/2026-10-24/` (Fedora 45 Cinnamon baseline). Read them
  with `read`; the RL10 shot shows the broken System Settings icon, the bare panel, and the
  missing desktop icons (Computer / Home / Rubbish Bin).
- GPG: secret key + passphrase in `~/AI/secrets/` (`gpg-secret-key.asc`,
  `gpg-passphrase.txt`); signing keyring `~/.gnupg-cinnamon-rocky10`; tracked public key
  `keys/cinnamon-rocky10-public.asc`.
- Existing test VMs: `Rocky_Linux_10_Cinnamon` and `Fedora_45_Cinnamon` (SSH as `howard`;
  password in `~/AI/secrets/pass.txt` — path reference only). The fresh consumer VM for the
  `gpgcheck=1` test is provisioned with `scripts/vm-create` per the `big.md` layer.
- Rollback: `/home/howard/snapshots/TASK-0038/` (byte-for-byte tree, `rpms.sha256`,
  `item5-pre-swap-rpms` backup).

## Discipline (binding)

- Read only `## Status` and `## Next Actions` of the planning doc, in small passes; the doc is
  the durable context, not this prompt.
- Dispatch one subagent at a time and wait; re-brief `Tails` per plan item (one item per
  turn); every subagent turn ends in a tool call (32k output cap, AGENTS.md section 14).
- Never echo secret values (GPG passphrase, VM password, the URL-embedded token); record the
  command and evidence for every claim.
- If a dispatch fails with a request-body size error (rule r001): record the handoff in
  `## Status`, stop dispatching, and continue in another fresh session from this same prompt.
