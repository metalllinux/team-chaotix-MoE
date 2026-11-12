# Continuation prompt, TASK-0038: icon parity (make the Rocky 10 Cinnamon icons exactly match Fedora 45)

For a fresh `Robotnik` (PM) opencode session, launched from this directory
(`~/AI/projects/team-chaotix`). Written 2026-11-01 per operator request ("After
analysing the screenshots, create me a prompt for a new session to tackle those
issues"). The prior PM session analysed the 2026-11-01 screenshot pair and hands
the icon work off here. This session continues TASK-0038, scoped to icon parity:
make the Rocky 10 Cinnamon icons exactly match the Fedora 45 baseline, including
the task menu (taskbar) icons the operator reports as missing.

## One-line task

Make the Rocky 10 Cinnamon VM (182) panel, taskbar, tray, and desktop icons
exactly match the Fedora 45 Cinnamon baseline (181), including the task menu
(taskbar) app icons that are missing on the Rocky 10 side, then re-run the
review chain, docs, and the PR merge that is held for this fix.

## First actions (in order)

1. Read ONLY `planning/docs/TASK-0038-cinnamon-gpg-settings-icons.md`, the
   `## Status`, `## Definition of Done`, and `## Next Actions` sections. Do not
   read the doc in full; it is long.
2. Read the 2026-11-01 screenshot pair with `read` (multimodal, read the images
   directly):
   - `~/Linux/projects/cinnamon-for-rocky10/screenshots/rl10/2026-11-01/icons-not-match.png`
     (Rocky 10 Cinnamon, the VM to fix)
   - `~/Linux/projects/cinnamon-for-rocky10/screenshots/f45-beta/2026-11-01/example_of_what_icons_should_look_like.png`
     (Fedora 45 Cinnamon baseline, what the icons should look like)
3. Dispatch a worker (per the cycle, `Tails` for diagnosis and fix, `Big` for
   verification) to confirm the differences live on 182 vs 181, capture a fresh
   screenshot pair from both, and diagnose the root cause before fixing. Do not
   build on the 2026-11-01 pair alone; confirm live.
4. Then dispatch per `## Next Actions`. One agent at a time; wait for each to
   finish before the next (single inference slot, `--parallel 1`).

## The operator requirement (2026-11-01, binding)

The Rocky 10 Cinnamon icons must be exactly the same as in Fedora 45, including
the task menu (taskbar) icons. The operator reports that multiple task menu
icons are missing or not present on Rocky 10. This broadens the task's icon
parity scope beyond the desktop icons (which are already fixed and verified). It
covers all icon surfaces: the menu button, the taskbar and panel app icons, the
system tray applets, and the desktop icons.

## Observed differences from the 2026-11-01 screenshots (evidence, not root cause)

What the prior PM session saw in the 2026-11-01 pair, reading the images
directly:

- Menu button: the Fedora 45 button is a blue or teal rounded square with a
  white 3 by 3 dot grid. The Rocky 10 button is a dark grey rounded square with
  the same 3 by 3 grid, a different tint or theme.
- Taskbar, or task menu, app icons: the Fedora 45 taskbar shows five distinct
  app icons (a blue folder, a red swirl, a blue window, a dark terminal with a
  ">_" mark, and a green square with a white "M"). The Rocky 10 taskbar shows
  only three: the red swirl (matches), the dark terminal (matches), and one
  white generic "missing icon" placeholder (a broken or missing marker). The
  blue folder, the blue window, and the green "M" app icons are absent on Rocky
  10, and one app renders as a missing icon fallback.
- System tray applets: the Fedora 45 tray shows six applets (a blue circle, a
  "1" count, a white or grey square, a gear, a printer, and a 4 by 4 white dot
  grid) plus a clock. The Rocky 10 tray shows only the clock. The six tray
  applets are absent on Rocky 10.
- Desktop icons: already fixed by the `cinnamon-rocky-defaults` 1.0-3 gschema
  override and verified matching by Big. Re-verify them as part of the full
  parity check.

The broken "missing icon" placeholder in the Rocky 10 taskbar, together with the
near-empty Rocky 10 tray, point to missing icon theme files, a wrong active icon
theme, or a difference in the panel, taskbar, and tray applet configuration.
The root cause is not established. Diagnose it live before fixing: compare the
active icon theme, the icon theme search path, the installed icon theme
packages, and the panel, taskbar, and tray applet configuration between 182 and
181.

## Conflict to surface (do not override)

Big's 2026-11-01 PASS (in `## Test Results`) recorded that the desktop icons
match the 181 baseline, so the `cinnamon-rocky-defaults` 1.0-3 gschema override
works. But the operator's 2026-11-01 screenshots show a broader icon mismatch on
the panel, taskbar, and tray surfaces. These are different surfaces: Big
verified the desktop icons, while the operator is now reporting the panel
(taskbar and task menu) and tray icons. Surface both in `## Status` and do not
override Big's PASS. The task's icon parity scope was desktop only. The
operator's requirement broadens it to all surfaces. Do not treat Big's desktop
icons PASS as satisfying the operator's broader requirement.

## State as of 2026-11-01 (details in the planning doc)

- Release: branch tip `a7be2f38`, the annotated tag `v1.0.1`, pushed to
  `metalllinux/cinnamon-for-rocky10`. 64 RPMs, all signed under the tracked key.
  The PR is not merged. The DONE checklist stays "no" until the icon fix lands
  and the chain re-runs clean.
- 182 is at the final `v1.0.1` state but one commit behind tip `a7be2f38`
  (the licence rebuild is invisible on the desktop). 181 is the untouched
  baseline (its settings window is still open as evidence).
- After the icon fix, the remaining flow: re-run the review chain (`Shadow` →
  `Omega` → `Big` → `Charmy` → `Flicky`), `Vector` item 14 (docs final pass),
  and `Knuckles` item 15 (release record and PR merge). The PR merge is held
  until the icon fix lands and the chain is clean.

## Environment (paths only; never echo secret values)

- Project: `~/Linux/projects/cinnamon-for-rocky10/` (canonical repo
  `metalllinux`). The remote URL embeds a token; reference it by path and never
  print it.
- VMs (system level, passwordless `ssh howard@...`, key already installed):
  - `Rocky_Linux_10_Cinnamon_AI`, 192.168.1.182, the VM to fix
  - `Fedora-45-Cinnamon-AI`, 192.168.1.181, the baseline
  - VM trap: `sudo virsh` (the system connection) is the correct path for 181
    and 182 on this host. Bare `virsh` (the howard session) sees a different
    domain set ("failed to get domain", black screenshots).
- GPG: the secret key and passphrase are in `~/AI/secrets/`
  (`gpg-secret-key.asc`, `gpg-passphrase.txt`); the signing keyring is
  `~/.gnupg-cinnamon-rocky10`; the tracked public key is
  `keys/cinnamon-rocky10-public.asc`.
- Screenshots: `~/Linux/projects/cinnamon-for-rocky10/screenshots/` (the
  2026-11-01 pair above). New screenshot pairs go under
  `screenshots/rl10/2026-11-01/` and `screenshots/f45-beta/2026-11-01/`.

## Discipline (binding)

- Read only the `## Status` and `## Next Actions` sections of the planning doc,
  in small passes; the doc is the durable context, not this prompt.
- Dispatch one subagent at a time and wait; every subagent turn ends in a tool
  call (32k output cap, AGENTS.md section 14).
- Never echo secret values (the GPG passphrase, the VM password, the URL
  embedded token); record the command and the evidence for every claim.
- Rule r002: leave every change the team tests applied on the test VMs. Do not
  reset or destroy a test VM at the end of a run. The operator checks the VMs
  for themselves.
- If a dispatch fails with a request body size error (rule r001): record the
  handoff in `## Status`, stop dispatching, and continue in another fresh
  session from this same prompt.
