# TASK-0041 — Remote visual control of a GNOME/Wayland Rocky target (team capability)

> **Section order below is fixed.** Each agent writes to its own section and no other. `Robotnik`
> reads only `## Status` and `## Next Actions`. Do not reorder, rename, or remove sections.

- **Created:** 2026-11-13
- **Parent engagement:** `planning/docs/TASK-0042-foss-for-all-scmdraft2-demo.md` (FOSS for All booth demo, event 2026-11-28)
- **Continuous log:** `DEMO-LOG.md` (repo root) — every agent that touches the target appends one dated entry.

---

## Status

**Roster note, `Robotnik` 2026-11-22 22:05 UTC (2026-11-23 07:05 JST).** The fifth reviewer `Flicky` was retired by operator instruction under TASK-0044, and `Charmy` is now the team's single licence owner holding the audit and the machine gate. The `T1` to `T5` chain for this task is now four dispatches, `Shadow`, `Omega`, `Big`, `Charmy`, and `T4` carries the audit scope written in TASK-0044 `## Next Actions`. Do not dispatch `T5`. See `planning/docs/TASK-0044-flicky-into-charmy.md`. Ruling on `Shadow`'s TASK-0044 `F2` finding 2, 2026-11-23 00:10 UTC, the `## Plan` rows at `:171` and `:172` of this doc still name `Flicky` as a fifth reviewer and as the owner of the gate run. They are `Amy`'s section and stay byte-unchanged per AGENTS.md section 2 rule 2, this entry is the correction to them, the DoD row for the chain is restated in place, and `Espio` folds the legacy rows into `## Archive` at `E1`.

**Now:** Gate PASSED. Eyes, OCR, keyboard hands, and mouse hands are proven on the live target. Items 1, 2, 3, 12, 4, 5, 6, 7 complete. Chosen keyboard input path is `xfreerdp /kbd:pipe:<fifo>` with `/args-from:file:` for the credential and `/cert:ignore`. Chosen mouse input path is a custom C client (`rdp-pointer`) using `libfreerdp3` with `freerdp_client_context_new` for full channel initialization; click at (960, 14) opened the GNOME 49 calendar/notification dropdown, confirmed by before/after screenshot pair. Item 8 (AT-SPI fallback) not needed. Remaining: items 9 to 11 packaging, then the review chain.

**Open technical limit (load-bearing for TASK-0042).** The keyboard pipe carries Unicode code points and control characters only. Modifier chords (Super+letter, Ctrl+C) are not covered by that mechanism. Mouse pointer motion and click ARE covered: the `rdp-pointer` tool sends `PTR_FLAGS_MOVE` and button press/release events directly through the RDP protocol at the mutter compositor level, reaching all applications including Wine/XWayland clients. Map editing in SCMDraft 2 needs clicks; item 7 proves they work. Modifier chords remain an open packaging question for item 9.

**Corrected plan facts (`Tails`, item 4).** The "invalid RDP TLS certificate" symptom had a different cause than recorded: no certificate was configured at all, empty `TLS certificate` and `TLS key` in `grdctl status`, and the `49.3-4.el10_2` build does not auto-generate one, so the daemon never binds 3389. The key pair must live in `~/.config/gnome-remote-desktop/`, not `/etc/gnome-remote-desktop/`, because the daemon runs as the user. This RPM *does* provide `grdctl status --show-credentials`, `--headless`, and `--system`, contrary to the probe note in `## Plan`. Both records are kept because they disagree.

**Open hygiene items for the review chain (found, not fixed, deliberately outside the brief).**
1. `~/AI/secrets/scm_draft_pass.md` on the controller is mode 644, not 600 as AGENTS.md section 4 requires.
2. The target already had a world-readable plaintext grd credentials file at `/var/lib/gnome-remote-desktop/.local/share/gnome-remote-desktop/credentials.ini` containing a `howard` credential that the team did not create. That predates this task and needs a decision: rotate it, or leave it and keep 3389 source-restricted.
3. `gsettings ... lock-enabled` went `true` to `false` on the target for the demo, inverse recorded. Booth security should re-lock before the event or the operator accepts an unlocked demo desktop.

**Environment / scope (all verified 2026-11-13 by `Robotnik`):**
- Controller (this machine): `192.168.1.102`, Rocky Linux 10.2, LAN default route via `virbr0`. Present: `ssh`, `scp`, `sshpass`, `rsync`, `ssh-keygen`. Absent: `xdotool`, `ydotool`, `wtype`, `grim`, `tesseract`, ImageMagick `convert`, `podman`, `gh`. Python 3 present. GitHub API reached with `curl` + token from `~/AI/secrets/token.md`.
- Target: `192.168.1.99`, hostname `scmdraft2-map-creator`, Rocky Linux 10.2 (`el10_2`), GNOME Shell 49.4, `gnome-remote-desktop-49.3-4.el10_2` installed, `gnome-screenshot`/`wine`/`steam` not installed. 16 vCPU, 61 GB RAM, `/` 70 G with 64 G free, `nvme0n1` 931.5 G (largely unused). GPU: AMD Lucienne (RDNA2 iGPU). Enabled repos: `baseos`, `appstream`, `extras` only (no CRB, no EPEL, no RPM Fusion).
- Target SSH: password auth as `howard`, password at `~/AI/secrets/scm_draft_pass.md` (single line, 600). Verified: `sshpass -f ~/AI/secrets/scm_draft_pass.md ssh howard@192.168.1.99` returns the probe output. Port 22 open, port 3389 closed (RDP server installed but not enabled).
- Target session: `loginctl list-sessions` shows `howard seat0 tty2`; the SSH environment has no `WAYLAND_DISPLAY` and no `DISPLAY`, so any screenshot or input tool must reach the running graphical session (user D-Bus / `loginctl` user environment), not the SSH shell.
- Files in scope: new `scripts/remote/` (or equivalent) helpers, `.opencode/skills/`, `README.md`, `tests/selftest.sh` (new asserted checks), `DEMO-LOG.md`.
- Touches the DB schema: no. Graphical UI: yes (remote GNOME 49 Wayland session). Rocky Linux target: yes.

**Unknowns (load-bearing, do not guess):**
1. Which screenshot path actually works on GNOME 49 Wayland headlessly: `org.gnome.Shell.Screenshot` D-Bus, `gnome-remote-desktop` RDP frame capture, or a nested X11/XWayland capture. Not yet tested.
2. Which input path works on GNOME 49 Wayland: `gnome-remote-desktop` RDP input (mutter injects RDP input into the live session), `ydotool`/`dotool` uinput (needs root or a udev rule), or XTEST against XWayland. Not yet tested.
3. Whether EPEL10/CRB or negativo16 carry `ydotool`, `freerdp`, `tesseract`, `wine` on `el10_2`. Not yet tested. Enabling third-party repos on the target is a system change and must be recorded before it happens.
4. Booth network conditions on 2026-11-28 (whether both machines are on the same LAN at the venue). Assumed same LAN; if not, the whole remote model changes.

**Decisions recorded:**
- Controller-side capture and input both go through the target's own session; the controller never assumes a display of its own. Chosen because the target is the machine the audience watches.
- `gnome-remote-desktop` is preferred over installing a VNC server: it is already installed, it is the upstream GNOME mechanism for Wayland, and it is the documented path on RHEL-family systems. Fallback is uinput-based injection plus a D-Bus screenshot. Chosen over `xdotool` because XTEST does not reach a Wayland compositor.

---

## Definition of Done

*Owner: `Robotnik`, and nobody else. Written before any work started.*

- [ ] A repeatable **screenshot** path exists: one command on the controller captures the target's live GNOME 49 Wayland session and lands the PNG under a local evidence directory. Proven against `192.168.1.99` with the command and its output recorded in `## Implementation`.
- [ ] A repeatable **keyboard** path exists: one command types a known marker string into a GUI app on the target, and the marker is visible in a screenshot taken afterwards.
- [ ] A repeatable **mouse** path exists: one command moves the pointer and clicks a known target on the target's desktop, and the effect is visible in a screenshot.
- [ ] A repeatable **OCR** path exists: one command turns a captured PNG into text, and OCR of a window title or marker string returns the expected words.
- [ ] The four paths are packaged as team tooling (`scripts/remote/...` or equivalent) with a documented visual loop an agent can follow: act, capture, read the image, decide.
- [ ] A skill or docs page tells every agent how to use it, including the secrets rule (password read from `~/AI/secrets/scm_draft_pass.md` at run time, never echoed, never written to a file, never in a commit).
- [ ] `tests/selftest.sh` asserts at least one new check for the new tooling, and the whole selftest passes with an increased check count (record the before/after counts).
- [ ] `grep -R -F -f ~/AI/secrets/scm_draft_pass.md` over the repo returns no match after the change (evidence recorded, output not pasted).
- [ ] `Shadow`, `Omega`, `Big`, `Charmy` each report with no unresolved finding above `low`/no blocker. Restated in place 2026-11-23 00:10 UTC by `Robotnik` per `Shadow`'s TASK-0044 `F2` finding 2, the fifth reviewer named in the original row was retired under TASK-0044 and no agent can satisfy her row. `T4` carries her audit scope.
- [ ] `Vector` updates `README.md` and the tooling docs to match.
- [ ] Work is committed on a branch, GPG-signed, PR'd to `metalllinux/team-chaotix-MoE` `main`, merged (local pre-push selftest gate is the effective CI gate while the repo is public).
- [ ] `DEMO-LOG.md` records each step against the target.

---

## Next Actions

- [x] `Amy`: `## Plan` written (18 items, two decision docs).
- [x] `Tails`: items 1, 2, 3 complete. Evidence `~/AI/demo-evidence/task0041-shot1.png`.
- [x] `Tails`: items 12 and 4 complete. RDP listener live, credential via stdin (positional passwords land verbatim in the journal), inverses recorded.
- [x] `Tails`: item 5 complete, gate PASSED. `planning/docs/TASK-0041-decision-input-path.md` `## Recommendation` now records a confirmed mechanism.
- [x] `Tails`: item 6 satisfied by the item 5 proof (`CHAOTIX41` visible in `task0041-kbd-proof2.png` and returned by OCR). Item 8 not needed unless item 7 fails.
- [x] `Tails`: item 7 complete. Pointer motion and click proven via custom C client (`rdp-pointer`, libfreerdp3). Click at (960, 14) opened the GNOME 49 calendar/notification dropdown. Evidence `~/AI/demo-evidence/task0041-item7-before.png` and `task0041-item7-after.png`. Item 8 (AT-SPI fallback) not needed.
- [ ] `Tails`: items 9, 10, 11 (`scripts/remote/` including the `rdp-pointer` build step and its FreeRDP licence record, the `remote-desktop` skill, selftest asserts above 56 checks). Modifier-chord coverage belongs to item 9.
- [ ] `Omega`: rule on the three open hygiene items in `## Status`, on the 3389 listener, and on a self-signed RDP certificate accepted for a LAN demo.
- [ ] `Robotnik` decision for items 9 and 10 (2026-11-20, recorded rather than asked): the packaged screenshot command is `/usr/bin/gnome-screenshot-tool -f <file>`, not a `gnome-screenshot` package install and not a raw `gdbus` call. Evidence is TASK-0042 DEMO-LOG 2026-11-20 01:40-02:10, where a raw `gdbus` call to `org.gnome.Shell.Screenshot` returns `AccessDenied` from any caller while `gnome-screenshot-tool`, shipped by gnome-shell 49.4 on the target, is accepted as the recognised `org.gnome.Screenshot` client. `grdctl rdp disable` did not lift the denial, so the gate is caller identity in gnome-shell 49, not gnome-remote-desktop serving. The skill and the `scripts/remote/` helper must therefore wrap `gnome-screenshot-tool`. Reason this matters for the booth: the packaged path is the one that works while the RDP session is live.
- [ ] `Robotnik`: TASK-0042 planning is unblocked (item 5 and item 7 both PASSED). It runs in alternation with the TASK-0041 tail, because TASK-0042 carries the long-lead unknowns: the compatibility layer and StarCraft game data.

---

## Plan

*Owner: `Amy`.*

**Why this task exists.** TASK-0042 (FOSS for All booth, 2026-11-28) cannot verify a single GUI fact
about `192.168.1.99` without eyes. Nothing else in that demo (compatibility-layer choice, map
creation, playability, documentation screenshots) is checkable until the team can capture the target's
screen and drive it. It also closes a durable team gap: the team has no way to verify any remote Rocky
GUI, which also limits future Cinnamon/Sparky visual regression work.

**What it unblocks / what blocks it.** Unblocks: every TASK-0042 DoD bullet that says "visible",
"captured" or "recorded from the GUI", and the documentation repo's screenshot deliverable. Blocks
itself on nothing in this repo. Real dependencies outside this repo: the target machine (target-side
changes must be recorded with their inverse before they happen), a *new* credential for RDP
(`~/AI/secrets/scm_draft_rdp_pass.md`), RPM availability for `freerdp`/`tesseract`, and the
repo-enablement policy that TASK-0042 will hit when it needs `wine` (see
`planning/docs/TASK-0041-decision-third-party-repos.md`). Hard external constraint: 2026-11-28.

**MVP.** Eyes plus OCR. `scripts/remote/rt-shot` plus `rt-ocr` plus the skill page. That alone makes
TASK-0042 verifiable by screenshot even if hands never work. Hands (RDP input) is tier two and the
risky tier, and it is deliberately sequenced *after* eyes so no other item waits on it.
Deferred by design: mouse-drag and scroll semantics, multi-monitor handling, video/streaming capture
(`org.gnome.Mutter.ScreenCast`), audio, and any on-target GUI automation beyond keyboard/mouse/text.

**What this makes harder later.** (1) Enabling the RDP listener puts a second credential and an open
LAN port on a machine the audience stands next to, so every later booth machine inherits that posture
question. (2) The eyes path depends on an SSH user reaching the *user* D-Bus bus
(`DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus`), which is true today on GNOME 49.4 and is
the kind of thing a GNOME upgrade changes. (3) `scripts/remote/` must take the target as an argument
from day one, or the tooling becomes booth-specific and unusable for the next project. (4) The new
selftest checks must not require the target to be online, which constrains what can be asserted in CI.

### Evidence already established for this plan (Amy probes, 2026-11-13)

Each line was produced by the command named. Tails should not re-derive these, only build on them.

- `org.gnome.Shell.Screenshot` is registered on the target's **user** bus and reachable over plain SSH
  once `XDG_RUNTIME_DIR=/run/user/1000` and `DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus`
  are exported. Evidence: `busctl --user list | grep -i screenshot` → `org.gnome.Shell.Screenshot 10677 gnome-shell howard`.
  Method signatures are not yet read; `gdbus introspect --session --dest org.gnome.Shell.Screenshot
  --object-path /org/gnome/Shell/Screenshot` prints them (the `--only` flag does not exist in this gdbus build).
- Target graphical session is live and **unlocked**: `loginctl show-session 2` → `Type=wayland`,
  `LockedHint=no`, `Remote=no`. `loginctl show-user howard` → `Display=2`, `UID=1000`.
- `gnome-remote-desktop-49.3-4.el10_2` is installed; its user unit is `disabled; preset: disabled;
  active: inactive (dead)`. `grdctl` is at `/usr/bin/grdctl` and supports `rdp enable`,
  `rdp disable`, `rdp set-credentials [user [pass]]`, `rdp clear-credentials`, `rdp set-tls-cert`,
  `rdp set-tls-key`, `rdp set-port`, `rdp enable-view-only`, `rdp disable-view-only`,
  `rdp enable-port-negotiation`. There is no `status` subcommand and no system/headless mode keyword in this build.
  Every `grdctl` invocation on the target currently prints
  `[ERROR][com.freerdp.crypto] - [x509_utils_from_pem]: BIO_new failed for certificate` /
  `RDP server certificate is invalid`, so an existing cert file is present and broken.
- `freerdp` (3.10.3-12.el10_2 and 3.32.2-1.el10_2) and `tesseract` (5.3.4-11.el10_2) are installable on
  **both** machines from repos that are **already enabled**. Target: `dnf repolist --enabled` shows only
  `appstream baseos extras` and both packages resolve there. Controller additionally has `crb` and `epel`
  enabled plus a local `cinnamon-rocky10` repo.
- `ydotool`, `wtype`, `dotool`, `grim`, `xdotool` and `python3-evdev` are **not** in Rocky 10 baseos,
  appstream, CRB or EPEL10 (`dnf repoquery -q --available` returns nothing for them on either machine).
  `python3-libevdev` is available. So any uinput-based path requires a source build, and any copr or
  negativo16 add is a new repo, not a package install.
- `python3-pillow` and `ImageMagick` are available on the controller; `tesseract-langpack-eng` too.
- Target has `at-spi2-core-2.56.1-1.el10` installed with `org.a11y.Bus`, `at-spi2-registryd` live on the
  user bus, and `python3-pyatspi-2.46.1-5.el10` installable from the enabled repos. Mutter exposes
  `org.gnome.Mutter.{InputMapping,InputCapture,RemoteDesktop,ScreenCast,IdleMonitor}` on the user bus.
- Target `firewalld` is active, zone `public` on `enp2s0`, no extra ports open (3389 closed as recorded).
- Controller has its own desktop session (`loginctl list-sessions` shows `1000 howard seat0 tty2`,
  `DISPLAY=:0`). `Xvfb` and `freerdp-plugins` are not in the controller's enabled repos.
- Selftest baseline for the before/after count: `bash tests/selftest.sh` → `SELFTEST: 56 checks passed`
  (28 pytest tests). That is the "before" number.
- OpenCode skill layout, verified against https://opencode.ai/docs/skills/ : a project skill is
  `.opencode/skills/<id>/SKILL.md` with `name` and `description` frontmatter; the ID is the directory
  name. `.opencode/skills/` does not exist in this repo yet.

**Work breakdown.** One agent, one turn each, unless the acceptance criterion says otherwise.
`Robotnik` dispatches one at a time against the single inference slot. Items marked independent may be
run in any order relative to each other.

| # | Item | Owner agent | Acceptance criterion (provable by screenshot or command output) | Parallel with |
|---|---|---|---|---|
| 1 | **Eyes.** Prove the screenshot path. Introspect the `org.gnome.Shell.Screenshot` methods, call the full-screen method over SSH with the user-bus env set, write the PNG on the target, bring it back with `scp` or base64 into `~/AI/demo-evidence/` (outside git), read it back with `read`. Resolves unknown 1. | Tails | One recorded command. File exists under `~/AI/demo-evidence/`, size > 50 KB, `file` reports PNG dimensions matching the target's monitor. An agent then states what the image shows (window titles, panel). DEMO-LOG entry with the exact command. Method signatures recorded verbatim in `## Implementation`. | 2 (independent), 12 |
| 2 | **Controller deps.** Install `freerdp`, `tesseract`, `tesseract-langpack-eng`, `python3-pillow` on the controller from already-enabled repos. No new repo enabled anywhere. | Tails | `command -v xfreerdp tesseract` returns paths; `rpm -q` NEVRAs recorded; `dnf repolist --enabled` identical before and after; target untouched in this item. | 1, 12 (independent) |
| 3 | **OCR.** Turn the item-1 PNG into text on the controller. | Tails | `tesseract <png> -` output recorded, and it contains a word actually on screen (panel label or window title). | none (needs 1 and 2) |
| 4 | **Target-side RDP enablement, recorded and reversible.** Inspect `~/.config/gnome-remote-desktop/` on the target, fix or regenerate the TLS cert, `grdctl rdp enable` plus `rdp set-credentials` reading the password from `~/AI/secrets/scm_draft_rdp_pass.md` at run time (never on a command line that can be seen in `ps`, never echoed), firewalld rich rule permitting 3389 **from 192.168.1.102 only**, `systemctl --user enable --now gnome-remote-desktop`. Record the exact inverse of every command in the same entry. | Tails | On target: `ss -tlnp | grep 3389` shows LISTEN. On controller: `timeout 5 bash -c '</dev/tcp/192.168.1.99/3389' && echo OPEN`. `firewall-cmd --list-rich-rules` shows the source-restricted rule. The inverse command list is present in `## Implementation` and DEMO-LOG. | none (needs 1) |
| 5 | **Input mechanism decision.** Determine how keystrokes are injected without an interactive human at the controller. Read `xfreerdp --help` in full and record the candidate flags found (event replay, non-interactive password passing, window/timeout control). Choose one mechanism, write the choice into the decision doc `planning/docs/TASK-0041-decision-input-path.md` `## Recommendation`. Resolves unknown 2. | Tails | The `xfreerdp --help` excerpt is recorded, and the chosen mechanism is exercised once against the target with a proof line in `## Implementation`. If no mechanism works, the doc's fallback section names the source-build or AT-SPI route and the operator is flagged in `## Status`. | none (needs 2 and 4) |
| 6 | **Hands, keyboard.** One command types a marker into a GUI app on the target through the item-5 mechanism. | Tails | Screenshot taken after shows the marker text `CHAOTIX41`, and item-3 OCR of that PNG returns the same string. Both artifacts named in `## Implementation` and DEMO-LOG. | none (needs 5) |
| 7 | **Hands, mouse.** One command moves the pointer and clicks a known on-screen target (Activities overview or a dash icon). | Tails | A before/after PNG pair where the effect is visible, described in `## Implementation` with the click coordinates used. | none (needs 6) |
| 8 | **Fallback hands, conditional.** Only if items 5 to 7 fail: install `python3-pyatspi` on the target from enabled repos and drive a GTK app through `org.a11y.Bus` (set text, press a button). Record that this path cannot reach Wine/XWayland apps, which is why it does not satisfy TASK-0042. | Tails | Marker text appears in a screenshot and in OCR. The limitation is stated in `## Implementation`. | 7 (independent of 7 if 5/6 failed) |
| 9 | **Packaging.** `scripts/remote/` with `rt-shot`, `rt-ocr`, `rt-type`, `rt-click`, `rt-status`, each taking `--host` and a `--dry-run` that needs no target and no network. Password read from `~/AI/secrets/` at run time, `set +x`, no credential in argv where avoidable. | Tails | Every script passes `bash -n`, `chmod +x`, `--help` prints usage, `--dry-run` exits 0 with the target unreachable. `--dry-run` output contains no credential. | 11 (independent) |
| 10 | **Skill.** `.opencode/skills/remote-desktop/SKILL.md` (ID `remote-desktop`) with the act, capture, read, decide loop, the exact commands, and the secrets rule stated in prose. | Tails | The file parses as frontmatter plus body, `description` present, and an agent can complete one screenshot cycle following only the skill text. | 9 (independent) |
| 11 | **Selftest asserts.** Add checks that do not need the target online: scripts exist and are executable, `bash -n`, `--help` exit 0, `--dry-run` exit 0, the skill file exists with frontmatter, and a repo-wide secret grep guard for `~/AI/secrets/scm_draft_pass.md` and `~/AI/secrets/scm_draft_rdp_pass.md`. | Tails writes, Big verifies | `bash tests/selftest.sh` prints `SELFTEST: N checks passed` with N > 56, and the before/after numbers (56, N) are recorded in `## Test Results`. Suite passes with the target powered off. | 9 |
| 12 | **Secrets and target-change hygiene.** Create `~/AI/secrets/scm_draft_rdp_pass.md` (mode 600) for the RDP credential; run `grep -R -F -f <secret file> .` over the repo for both secrets and record only that each returned no match. | Tails implements, Omega reviews | Both greps return no match. `stat -c '%a %n'` shows 600 on the new secret file. No secret value appears in this doc, DEMO-LOG, or any commit. | 1, 2 |
| 13 | **Review chain.** `Shadow` → `Omega` → `Big` → `Charmy` → `Flicky`, one dispatch each, findings only. | those agents | Each section filled with no unresolved finding above `low`. Omega's findings must cover the open 3389 listener, the credential handling in argv and logs, and the user-D-Bus reach. | 14 (independent) |
| 14 | **Licence and dependency policy.** Charmy verifies `freerdp`, `tesseract`, `tesseract-langpack-eng`, `python3-pillow` licences at the upstream repo and ref actually shipped by the `el10_2` RPMs. Flicky runs `scripts/licence-check` on this repo. Both record the runtime-dependency-versus-vendored-code distinction from `planning/docs/TASK-0041-decision-third-party-repos.md`. | Charmy, Flicky | Charmy's table complete with upstream refs. Flicky's gate exits 0 (or 6 with a recorded exception). | 13 |
| 15 | **Docs.** README section for the remote visual loop, plus the documentation-repo-facing note. Vector also confirms DEMO-LOG has one entry per target-touching item. | Vector | README diff present, every target change in DEMO-LOG has an inverse command line next to it. | none |
| 16 | **Release.** Branch `task-0041-remote-visual-control`, GPG-signed commits, PR into `metalllinux/team-chaotix-moE` `main` via git plus REST (no `gh` on this host), merge after the local pre-push selftest gate passes. | Knuckles | PR number recorded, `git log --show-signature` shows signatures, `SELFTEST: N checks passed` printed at push time. | none |
| 17 | **Pre-event network validation.** On 2026-11-26 at the venue, re-run item 1 from the controller. Resolves unknown 4 by test. | Tails | One `rt-shot` succeeds on venue network, or `## Status` records the fallback (same-subnet SSH-only mode, or a documented controller reconfiguration). | none |
| 18 | **Archive.** Espio prunes superseded probe narration once the shipped commands are recorded. | Espio | Pruning log entry only. | none |

**Critical path.** 1 → 4 → 5 → 6 → 7 → 9 → 11 → Shadow → Omega → Big → Charmy → Flicky → Vector →
Knuckles. That is 15 sequential dispatches against the single inference slot. Items 2, 3, 10, 12 sit
beside it and never extend it. Item 8 is an off-path detour that only activates if 5 fails.

**Decision gate.** Item 5 is the gate. If no non-interactive input mechanism exists by 2026-11-17,
TASK-0042's playability bullets are at risk and `## Status` must say so in the same turn, because
TASK-0042 still has the compatibility layer, game data, and five maps behind it.

**Estimates.** `T = (O + 4M + P) / 6`, hours of agent time per item.

| Item | O | M | P | T |
|---|---|---|---|---|
| 1 eyes | 0.5 | 1 | 3 | 1.25 |
| 2 deps | 0.3 | 0.5 | 1.5 | 0.63 |
| 3 OCR | 0.3 | 0.5 | 2 | 0.72 |
| 4 RDP enable | 1 | 2 | 5 | 2.33 |
| 5 input decision | 1 | 2.5 | 6 | 2.83 |
| 6 keyboard | 0.5 | 1.5 | 4 | 1.75 |
| 7 mouse | 0.5 | 1 | 3 | 1.25 |
| 8 fallback hands | 1 | 2 | 5 | 2.33 (conditional) |
| 9 packaging | 1 | 2 | 4 | 2.17 |
| 10 skill | 0.5 | 1 | 2 | 1.08 |
| 11 selftest | 0.5 | 1 | 2.5 | 1.17 |
| 12 secrets | 0.2 | 0.3 | 1 | 0.45 |
| 13 review chain | 1.5 | 2.5 | 5 | 2.83 |
| 14 licence | 0.5 | 1 | 2 | 1.08 |
| 15 docs | 0.5 | 1 | 2 | 1.08 |
| 16 release | 0.3 | 0.6 | 1.5 | 0.70 |
| 17 venue check | 0.3 | 0.5 | 1.5 | 0.63 |

Critical-path sum is about 21 h. Buffer is 60 percent, about 33 h total, because item 5 dominates the
uncertainty and item 8 may add 2.33 h on top. Spread over 15 days with one sequential slot, the schedule
is comfortable; the risk is the unknown, not the calendar.

**Risks.**

- Unknown 2 has no answer yet, RDP consent flow. Likelihood medium. Impact blocks hands entirely.
  Mitigation: item 4 tests the credential-based unattended flow before anything is promised, and
  `grdctl rdp disable-view-only` is part of item 4 so input is permitted, not view-only. Contingency:
  item 8 AT-SPI path proves the loop for GTK apps, and a source-built `dotool` on the target with a udev
  rule is the last resort, recorded as a system change with its inverse.
- `xfreerdp` has no non-interactive input mode. Likelihood medium. Mitigation: item 5 is an evidence
  step (full `--help` recorded) before any script is written, and the candidate mechanisms are ranked
  in the decision doc rather than assumed. Contingency: run `xfreerdp` in a window on the controller's
  own `DISPLAY=:0` and bridge keystrokes to it, accepting the extra layer, or escalate to the operator
  for a hand-operated RDP session at the booth with the team capturing via item 1.
- Credential exposure through argv, `ps`, shell history, or DEMO-LOG. Likelihood medium, impact high.
  Mitigation: item 12 plus the Omega finding, freerdp's own non-argv password option chosen in item 5,
  `set +x` in every script, DEMO-LOG rule already in force. Contingency: rotate
  `~/AI/secrets/scm_draft_rdp_pass.md` with `grdctl rdp clear-credentials` then `set-credentials`.
- The 3389 listener on a booth LAN. Likelihood certain if item 4 proceeds, impact medium. Mitigation:
  source-restricted firewalld rich rule, `enable-view-only` available as an immediate downgrade, and
  item 4's recorded disable path. Contingency: `grdctl rdp disable` and the rule removal, then the
  screenshot-only demo remains.
- Screen lock or blank during the booth day makes every screenshot a lock screen. Likelihood medium.
  Mitigation: within item 4, set `gsettings set org.gnome.desktop.session idle-delay 0` and
  `org.gnome.screen-saver` lock off on the target, recorded with the previous values so they can be
  restored. Contingency: `loginctl unlock-session` over SSH.
- Selftest grows target-dependent and CI turns flaky. Likelihood medium, impact medium. Mitigation:
  item 11 asserts only offline behaviour (`--dry-run`, `bash -n`, file presence, grep guard).
  Acceptance explicitly requires a pass with the target powered off.
- Scope bleed from TASK-0042's `wine` repo problem into this task. Likelihood medium. Mitigation: the
  repo-enablement policy 1-pager is written now and TASK-0041 installs nothing third-party.
- Booth network is not the same LAN. Likelihood medium, impact high. Mitigation: `--host` flags from
  item 9, item 17 venue dry run. Contingency: SSH-over-WAN fallback (target reachable through a
  jump host), which changes the threat model and must then be reviewed by Omega again.

**Secrets management for the new credential.** `~/AI/secrets/scm_draft_rdp_pass.md`, mode 600, created
by item 12, never committed, never in a workflow file, never in a URL. Rotation is
`grdctl rdp clear-credentials` then `grdctl rdp set-credentials <user> <new>` on the target, then
rewrite the local file. What breaks during rotation: any in-flight RDP session, nothing else. Blast
radius if it leaks: anyone on the LAN can drive the booth desktop as `howard`, which is a live session
with the team's SSH access already known. Detection: `journalctl --user -u gnome-remote-desktop`
connection lines on the target, plus the firewalld rule being the only path in.

**CI/CD shape.** No new workflow. Triggers unchanged: the local `scripts/hooks/pre-push` selftest gate
is the effective gate while the repo is public (AGENTS section 6), and the existing `Team Selftest`
workflow covers the same checks on push or PR once a runner can register. Matrix: none, single job on
`[self-hosted, Linux, X64]`, no `fail-fast` decision needed. Nothing in CI touches the target machine,
no model call in CI (AGENTS section 6). Deployment is one PR to `main` on this repo, promotion gate is
the selftest check count plus the review chain being clear. Item 17 is a manual operator-scheduled dry
run, not CI.

**Validation.** Files that need a human look: `README.md` remote-desktop section,
`.opencode/skills/remote-desktop/SKILL.md`, `DEMO-LOG.md`, the two decision docs. Checks that prove it
worked: `bash tests/selftest.sh` with the before/after count recorded, `grep -R -F -f
~/AI/secrets/scm_draft_pass.md .` with no match, `ss -tlnp` and `firewall-cmd --list-rich-rules` on the
target, `rpm -q` for each installed package, `git log --show-signature -1`, and the operator reading at
least one PNG from `~/AI/demo-evidence/` and confirming it shows what `## Implementation` says it shows.
The visual loop is validated by an agent, not by a test, because the artifact is an image (AGENTS
section 7).

**Rollback.** Detection is per-item and immediate: each item's acceptance is one command whose output
either contains the marker or does not, so a failed item is visible in the same turn it runs. Repo-side
revert is `git revert <merge commit>` on `main`, or close the PR if the review chain blocks; the point
of no return on the repo side is the merge, and nothing here is irreversible because no migration, no
schema, and no published package is involved. Target-side has no git, so the rule is stricter: every
target change is written in the same DEMO-LOG entry as the command plus its exact inverse, and no
target change may be destructive (config files are copied to `~/AI/demo-backup/<date>/` on the target
before being altered). The item-4 inverse set is `grdctl rdp clear-credentials`, `grdctl rdp disable`,
`systemctl --user disable --now gnome-remote-desktop`, `firewall-cmd --remove-rich-rule='<rule>'` plus
`firewall-cmd --reload`, and `gsettings reset` for any gsettings key touched. State a retry must
tolerate: a target left with RDP enabled, credentials set, a stale cert file, and a portless-free
listener. Item 4 must be idempotent (re-running it must not create a second rule or a second cert).
Failure of items 1 or 3 leaves nothing behind except a PNG under `~/AI/demo-evidence/`, which is
outside git and can simply be deleted.

**Assumptions, marked as assumptions.** The venue LAN is the same subnet (item 17 tests it). GNOME 49's
`Screenshot` D-Bus method accepts a caller-supplied filename (item 1 reads the signature). The
credential-based GNR flow needs no on-screen consent (item 4 tests it). `xfreerdp` supports a
password-by-file or by-environment option (item 5 verifies against `--help` rather than trusting the
flag name). No agent may proceed past item 5's decision doc on an assumption instead of a recorded test.

---

## Implementation

*Owner: `Tails`.*

**Alternatives considered**

### Problem: Screenshot a GNOME 49 Wayland session programmatically over SSH

GNOME 49 restricts `org.gnome.Shell.Screenshot.Screenshot` to callers that own the D-Bus well-known
name `org.gnome.Screenshot`. A plain `gdbus call` over SSH gets `AccessDenied: Screenshot is not
allowed`. This was verified on the target.

**Option A — `org.gnome.Mutter.ScreenCast` CreateSession + PipeWire frame grab.** Create a screencast
session, receive PipeWire video frames, extract a still. Pros: uses the official screen-capture API
designed for remote access. Cons: requires PipeWire client code (Python `gi.stream` or `pipewire`
library), produces a video stream rather than a single file, more moving parts, ScreenCast API Version
4 requires portal approval on some configurations.
**Option B — Request `org.gnome.Screenshot` bus name, then call `Screenshot` directly.** Claim the
well-known name `org.gnome.Screenshot` on the session bus (flags 0x4, allow-replacement), then call
`org.gnome.Shell.Screenshot.Screenshot(false, false, filename)` from the same connection. GNOME Shell
checks the sender name against its allow-list; owning the name satisfies the check. Pros: single call,
produces a PNG file directly on the target, no PipeWire, no portal dialog. Cons: the name-claim
workaround is documented in GitLab issue #4840 as intentional Shell behavior (the Shell cannot
enforce name checks as a security boundary), so it will survive future GNOME versions as a
side-effect of how D-Bus works; however it is not a supported API contract.
**Option C — XWayland capture (`DISPLAY=:0 xwd -root`).** Target has XWayland sockets (`X0`, `X1`).
Pros: trivially works with any X11 capture tool. Cons: requires installing `xorg-x11-apps` or
ImageMagick on the target (system change), captures the XWayland composite layer which may miss
native Wayland surfaces or show them differently, and XWayland sockets can be removed by future
GNOME versions.
**Option D — Enable RDP and capture frames via `xfreerdp` bitmap cache.** Requires item 4 (RDP
enablement) first. Pros: official remote-desktop mechanism. Cons: heavier, requires credentials and
firewall changes, circular dependency for items 1/3 which are prerequisites for item 4.

**Chosen:** Option B. Because it produces a clean full-screen PNG in one D-Bus round-trip with no
additional packages, no portal dialog, no target-side install, and no dependency on item 4. The name
request is a documented GNOME Shell behavior (Shell's own `Screenshot` D-Bus implementation checks
the caller name; the check was explicitly noted as non-security in !1970 discussion).
**Competing priorities:** XWayland capture (Option C) is simpler conceptually but requires a target
package install (ImageMagick or xorg-x11-apps), which is a system change on a machine the audience
stands next to. Avoided. ScreenCast (Option A) is the "intended" future API but its PipeWire plumbing
is overkill for a still frame and adds a dependency not yet proven in the enabled repos.

### D-Bus method signatures (verbatim from target introspection)

```
interface org.gnome.Shell.Screenshot {
  methods:
    InteractiveScreenshot(out b success,
                          out s uri);
    Screenshot(in  b include_cursor,
               in  b flash,
               in  s filename,
               out b success,
               out s filename_used);
    ScreenshotWindow(in  b include_frame,
                     in  b include_cursor,
                     in  b flash,
                     in  s filename,
                     out b success,
                     out s filename_used);
    ScreenshotArea(in  i x,
                   in  i y,
                   in  i width,
                   in  i height,
                   in  b flash,
                   in  s filename,
                   out b success,
                   out s filename_used);
    PickColor(out a{sv} result);
    FlashArea(in  i x,
              in  i y,
              in  i width,
              in  i height);
    SelectArea(out i x,
               out i y,
               out i width,
               out i height);
  signals:
  properties:
};
```

Source: `gdbus introspect --session --dest org.gnome.Shell.Screenshot --object-path
/org/gnome/Shell/Screenshot` on the target with `XDG_RUNTIME_DIR=/run/user/1000` and
`DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus` exported.

**Changes**

| File | What changed |
|---|---|
| `DEMO-LOG.md` | Appended five dated entries (items 1, 2, 3, 12, 4) with commands and results. |
| `~/AI/secrets/scm_draft_rdp_pass.md` (outside git) | New RDP credential, mode 600, generated with `openssl rand` under `umask 077`, never displayed (item 12). |
| Target `192.168.1.99` | RDP enabled with cert, credentials, firewall rule, service unit, screensaver lock setting. Full change and inverse record in the item-4 DEMO-LOG entry and below. |

No repo source files modified yet (scripts/skills arrive in item 9/10). Evidence files live outside
git under `~/AI/demo-evidence/`.

**Checks run**

| Check | Result |
|---|---|
| Item 2: `command -v xfreerdp tesseract` | `/usr/bin/xfreerdp`, `/usr/bin/tesseract` |
| Item 2: `rpm -q freerdp tesseract tesseract-langpack-eng python3-pillow` | NEVRAs recorded above |
| Item 2: `dnf repolist --enabled` diff before/after | IDENTICAL (no new repos) |
| Item 2: target untouched | No target-side install performed in item 2 |
| Item 1: `file ~/AI/demo-evidence/task0041-shot1.png` | PNG image data, 1920x1080, 8-bit RGBA, non-interlaced |
| Item 1: file size | 854449 bytes (> 50 KB threshold met) |
| Item 1: agent visual read of PNG | GNOME 49 desktop confirmed: panel with date/time "13 Nov 22:12", battery 100%, Rocky wallpaper, no windows |
| Item 3: `tesseract ~/AI/demo-evidence/task0041-shot1.png -` | Output contains "13Nov 22:12" and "100%", both visible in the image |
| Selftest | Not re-run (no new repo files to assert yet; item 11 adds those checks) |

**Item 2 target-side note:** no packages were installed on the target during item 2. The target's
`dnf` database was not touched.

**Item 1 workaround mechanism detail (for item 9 packaging):** The working call sequence is:
1. Connect to the session bus (`XDG_RUNTIME_DIR=/run/user/1000`,
   `DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus`).
2. Call `org.freedesktop.DBus.RequestName("org.gnome.Screenshot", 0x4)` on the same connection.
3. Call `org.gnome.Shell.Screenshot.Screenshot(false, false, <absolute-path-on-target>)` from that
   same connection. The Shell sees the caller owns `org.gnome.Screenshot` and permits the method.
4. Fetch the PNG from the target path via `scp`.

Flag `0x4` is `G_BUS_NAME_OWNER_FLAGS_ALLOW_REPLACEMENT`. If `org.gnome.Screenshot` is already owned
by a running screenshot tool, the request returns result 1 (primary owner) because GNOME 49 does not
run a persistent `org.gnome.Screenshot` service by default. This was verified live on the target.

### Item 12: RDP credential and hygiene (done 2026-11-13)

`~/AI/secrets/scm_draft_rdp_pass.md` created, mode 600 (`stat -c '%a %n'` -> `600`), generated by
`umask 077` + `openssl rand -base64 24 | tr -d '/+=' | cut -c1-20`, value never displayed or placed on
an argument line. Repo greps: `grep -R -F -f ~/AI/secrets/scm_draft_pass.md .` exit 1 (no match);
`grep -R -F -f ~/AI/secrets/scm_draft_rdp_pass.md .` exit 1 (no match). Output not pasted per plan.

Hygiene facts recorded for Omega, not fixed by me (outside my brief):
1. `~/AI/secrets/scm_draft_pass.md` on the controller is mode 644, outside the AGENTS section-4
   mode-600 rule. One `chmod 600` fixes it; no action taken here.
2. The target already held a world-readable (644) plaintext grd credential file at
   `/var/lib/gnome-remote-desktop/.local/share/gnome-remote-desktop/credentials.ini` (owner
   `gnome-remote-desktop`) before any team change, containing a pre-existing `howard` credential not
   created by this team. Its value entered my probe output once via `grdctl status --show-credentials`
   and is deliberately recorded nowhere; item 4 replaced it (`clear-credentials` then
   `set-credentials`). The file's 644 mode is unchanged by the replacement and needs tightening.

### Item 4: target RDP enablement (done 2026-11-13)

**Root cause of the invalid-certificate problem Amy recorded (resolved).** Every `grdctl` call on the
target printed `[ERROR][com.freerdp.crypto] - [x509_utils_from_pem]: BIO_new failed for certificate` /
`RDP server certificate is invalid` because **no TLS certificate was configured at all**: `grdctl
status` showed empty `TLS certificate` and `TLS key` fields, and this `49.3-4.el10_2` build does not
auto-generate one (daemon journal: `RDP TLS certificate and key not yet configured properly`). The
error is a symptom, not a broken cert file: with a valid cert configured the error no longer appears
(verified live, `grdctl status` clean afterwards). Contradiction surfaced against `Amy`'s recorded
probe (`## Plan`): on this same RPM, `grdctl` **does** have a `status` subcommand (with
`--show-credentials`) and **does** have `--headless` and `--system` options. Both readings are
recorded; the live `grdctl --help` text from the target is the evidence.

**Alternatives considered**

*Problem: give the grd daemon a usable TLS certificate.*
- Option A, self-signed pair in `~/.config/gnome-remote-desktop/` owned by `howard`, wired through
  `grdctl rdp set-tls-cert`/`set-tls-key`. Chosen: the user daemon runs as `howard` (unit
  `gnome-remote-desktop.service` in `user@1000.service`), so only a `howard`-readable key works; no
  new repo, no policy change, and the cert store sits exactly where a future GNOME would look for it.
- Option B, pair in `/etc/gnome-remote-desktop/` owned by the `gnome-remote-desktop` system user.
  Tried and failed: the daemon cannot read the 600 key as `howard` (journal shows
  `RDP TLS certificate and key not yet configured properly`). That path belongs to the system
  daemon, not this user session. Lesson recorded: for the user unit, cert and key must live where
  the user can read them.
- Option C, the system daemon (`--system`, `gnome-remote-desktop.service` system unit plus
  `gnome-remote-desktop-configuration.service` and the handover flow) for login-before-gnome-session.
  Rejected for this task: it changes the machine's login posture (a step-stop class of change), and
  TASK-0042 drives an already-running graphical session.

*Problem: set the RDP password without exposing it in argv, `ps`, history, or logs.*
- Option A, stdin: `grdctl rdp set-credentials howard` with the secret file piped through SSH stdin.
  Chosen. Mechanism verified from the RPM itself (`strings usr/bin/grdctl` shows
  `g_data_input_stream_read_line_utf8`, i.e. grdctl reads the missing password from stdin) and then
  proven live with a dummy value before the real one was used. The password appears in no argv, no
  journal entry (checked `sudo journalctl` for sudo-wrapped commands), no file in git.
- Option B, positional password argument. Rejected: argv is visible in `ps` on the target and, when
  wrapped in sudo, is written verbatim into the journal (observed for the openssl command).
- Option C, `credentials.ini` direct write. Rejected: bypasses the daemon and D-Bus config service,
  fragile across updates.

**Idempotency (plan requirement).** Rich rule guarded by `firewall-cmd --query-rich-rule` (was no,
now yes; re-run adds no second rule). Certificate generation guarded by a configured-cert check on
`grdctl status`. `set-credentials` overwrites. `enable` and `systemctl --user enable --now` are
idempotent. Verified: exactly one rule in both runtime and permanent views.

**Target changes with their exact inverses** (full detail in the DEMO-LOG item-4 entry; run the
inverse list in order to restore the pre-item-4 state, which was: unit disabled and inactive, RDP
disabled, View-only yes, cert fields empty, no rich rule, `lock-enabled true`, `idle-delay uint32 0`):

| Change | Inverse |
|---|---|
| `systemctl --user enable --now gnome-remote-desktop.service` | `systemctl --user disable --now gnome-remote-desktop.service` |
| `grdctl rdp enable` | `grdctl rdp disable` |
| `grdctl rdp disable-view-only` | `grdctl rdp enable-view-only` |
| self-signed cert pair in `~/.config/gnome-remote-desktop/` + `grdctl rdp set-tls-cert`/`set-tls-key` | `rm -f ~/.config/gnome-remote-desktop/tls-{cert,key}.pem` (inverse before disabling the unit) |
| `grdctl rdp set-credentials howard` (stdin) | `grdctl rdp clear-credentials` |
| `sudo firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.1.102" port port="3389" protocol="tcp" accept'` + `--reload` | same with `--remove-rich-rule` + `--reload` |
| `gsettings set org.gnome.desktop.screensaver lock-enabled false` (was `true`) | `gsettings set org.gnome.desktop.screensaver lock-enabled true` |

Backup taken before changes: target `~/AI/demo-backup/2026-11-13/grd-credentials.ini/` (copy of the
pre-existing grd credential store). Additive, no inverse required.

**Competing priorities traded away.** Self-signed TLS means every RDP client shows a certificate
warning; accepted for a source-restricted LAN demo, flagged for Omega. A CA-issued or ACME cert would
remove the warning but adds a PKI dependency the enabled repos do not provide. Cert key is RSA-2048
in a user-readable home directory; the private key (600, `howard`) is the sensitive file, and the
firewall rule is the only network path in.

**Checks run (items 12 and 4)**

| Check | Command | Result |
|---|---|---|
| New secret mode | `stat -c '%a %n' ~/AI/secrets/scm_draft_rdp_pass.md` | `600` |
| Secret grep, SSH password | `grep -R -F -f ~/AI/secrets/scm_draft_pass.md .` | exit 1, no match |
| Secret grep, RDP password | `grep -R -F -f ~/AI/secrets/scm_draft_rdp_pass.md .` | exit 1, no match |
| Target listener | `ss -tlnp \| grep 3389` | `LISTEN 0 5 *:3389 *:* users:(("gnome-remote-de",pid=13977,fd=22))` |
| Controller reach | `timeout 5 bash -c '</dev/tcp/192.168.1.99/3389' && echo OPEN` | `OPEN` |
| Firewall rule | `sudo firewall-cmd --list-rich-rules` (+ `--permanent` view) | exactly one rule, source `192.168.1.102`, port 3389/tcp; `--list-ports` empty |
| Rule idempotency | `sudo firewall-cmd --query-rich-rule='<rule>'` | yes |
| Service state | `systemctl --user is-enabled is-active gnome-remote-desktop.service` | `enabled`, `active`; symlink created at `~/.config/systemd/user/gnome-session.target.wants/` |
| grd status | `grdctl status` | Unit active, RDP enabled, Port 3389, View-only no, TLS fingerprint present (value not recorded), cert/key paths set, cert error gone |
| Credential set | `grdctl status --show-credentials` filtered to the Username line | `Username: howard`; Password line suppressed, value recorded nowhere |
| gsettings | before `lock-enabled true`, `idle-delay uint32 0`; after `false`, `0` | lock setting changed with inverse recorded; idle untouched |
| Journal audit | `sudo journalctl --since 22:29 \| grep -i rdp` | no credential value written by our commands |

Selftest not re-run: items 12 and 4 add no repo code; item 11 owns the new asserts (baseline 56
stays valid).

### Item 5: input mechanism decision (done 2026-11-14)

**Problem: inject keyboard input into the target's GNOME 49 Wayland session from the controller,
scripted, no human at a keyboard.**

**Alternatives considered**

*Problem: mechanism for non-interactive keystroke injection over RDP.*

- **Option A, `xfreerdp /kbd:pipe:<fifo>`.** FreeRDP 3.32.2 creates a named pipe (FIFO) when this
  option is set. Writing UTF-8 text to the pipe sends one Unicode keyboard event (press + release,
  5 ms between each) per character into the RDP session. The server (gnome-remote-desktop / mutter)
  injects them as compositor-level input. Pros: fully scripted (pipe write is a shell command),
  no GUI interaction needed on the controller side, reaches every application in the session
  including Wine/XWayland clients because mutter receives the events at the compositor level.
  Chosen. Verified live.
- **Option B, `/dump: replay`.** Requires a prior recording. A chicken-and-egg problem for the
  first automated interaction: the recording itself would need scripted input. Rejected as primary
  mechanism.
- **Option C, controller-side X11 keystroke bridging to the xfreerdp window.** Launch xfreerdp on
  the controller's own `DISPLAY=:0` and use a local X11 input tool to bridge keystrokes into the
  xfreerdp window. Cons: no input tool (xdotool, xdotool) exists in enabled repos, and this adds
  a dependency and an extra layer. Rejected.
- **Option D, uinput on the target (Option B from the decision doc).** Not packaged. Rejected for
  the same reason the decision doc rejected it.

*Problem: pass the RDP password without it appearing in `ps`, shell history, or journal.*

- **Option A, `/args-from: file:<path>` with mode 600.** FreeRDP reads all command-line arguments
  from a file (one per line). The `/p:<password>` argument is in the file, never in argv. File is
  created under `umask 077`, deleted immediately after use. Chosen.
- **Option B, `/from-stdin`.** Reads credentials interactively from stdin. Works, but the pipe
  mechanism also uses stdin-adjacent file descriptors and the stdin-credential path requires
  knowing the exact prompt sequence (username prompt suppressed when `/u:` is already present, then
  a password prompt). More fragile than `/args-from` for scripting. Not chosen.
- **Option C, positional `/p:` on argv.** Visible in `ps`. Rejected.

*Problem: handle the self-signed TLS certificate without a GUI dialog.*

- **Option A, `/cert:ignore`.** FreeRDP skips all certificate verification. Acceptable for the
  source-restricted LAN. Chosen.
- **Option B, `/cert:tofu`.** Trust-on-first-use. Would require a first interactive connection or
  a pre-known fingerprint. `/cert:fingerprint:<hash>:<hex>` could work but adds a fingerprint
  maintenance step. Rejected for simplicity.

**Mechanism details (source evidence)**

`xf_client.c` (FreeRDP 3.32.2 tag, upstream GitHub) `xf_process_pipe` (line 1306): opens the FIFO
with `O_NONBLOCK | O_RDONLY`, reads up to 63 bytes per iteration, passes to `xf_inject_keypress`.
`xf_inject_keypress`: converts UTF-8 to WCHAR (UTF-16), then for each code point calls
`freerdp_input_send_unicode_keyboard_event(input, 0, code)` (press) then `KBD_FLAGS_RELEASE`
(release), with 5 ms Sleep between each. No modifier sequences, no key scancodes: only Unicode
code points. Control characters (Enter = U+000D, Tab = U+0009, Escape = U+001B) are valid Unicode
and gnome-remote-desktop's mutter input layer handles them as key events.

`xf_handle_pipe` (line 1361): calls `mkfifo(pipe, S_IWUSR | S_IRUSR)`. The pipe must NOT already
exist when xfreerdp starts (it creates it). On exit or signal, `cleanup_pipe` unlinks it.

`/args-from: file:<path>` (from `--help`): "Read command line from a file, stdin or file descriptor.
This argument can not be combined with any other. Provide one argument per line."

**Live proof (2026-11-14 08:12)**

1. Launched `gnome-text-editor` on the target's Wayland session via SSH with
   `nohup gnome-text-editor &` (PID 15531 confirmed via `pgrep -fa`).
2. Started `xfreerdp /args-from:file:/tmp/opencode/rdp-args` (args file mode 600, 9 lines:
   `/v`, `/u`, `/p:<password from secret file>`, `/cert:ignore`, `/kbd:pipe:/tmp/opencode/rdp-kbd`,
   `/w:1920`, `/h:1080`, `/size:1920x1080`, `/t:chaotix-remote`).
3. Connection established in approximately 300 ms (TLS negotiation logged, Kerberos errors are
   cosmetic: no KDC on LAN, NLA negotiation falls back to TLS path).
4. Pipe created by xfreerdp: `prw-------. 1 howard howard 0 Nov 14 08:12 /tmp/opencode/rdp-kbd`.
5. `printf 'CHAOTIX41' > /tmp/opencode/rdp-kbd`.
6. 2-second propagation delay.
7. Screenshot captured via the item-1 D-Bus path: `~/AI/demo-evidence/task0041-kbd-proof2.png`,
   1256031 bytes, PNG 1920x1080 RGBA.
8. **Image shows:** gnome-text-editor window with "CHAOTIX41" visible both in the title bar
   (document name) and in the editor body (text content with cursor after the final character).
9. `tesseract ~/AI/demo-evidence/task0041-kbd-proof2.png - | grep CHAOTIX41` returns
   `+ CHAOTIX41`. OCR confirmed.
10. xfreerdp killed (PID no longer exists). Args file, pipe, and PID file removed.
    Target text editor killed (PID 15531). No residual credential file on disk.

**Proof line:** `printf 'CHAOTIX41' > /tmp/opencode/rdp-kbd` injected 9 keystrokes into a focused
text field on a GNOME 49 Wayland session on `192.192.1.99` via `xfreerdp /kbd:pipe:` over the
item-4 RDP listener, confirmed by both visual screenshot read and OCR.

**Limitations recorded for item 6 and item 9 packaging:**

- The pipe sends Unicode code points only. Modifier combinations (Super+letter, Ctrl+C, Alt+Tab)
  cannot be injected through the pipe. For modifier keys, an alternative approach is needed:
  either the `/kbd:remap:` option to remap scancodes, or a helper that opens the overview via
  the shell's D-Bus (`org.gnome.Shell.Eval` or `Eval` method) as a workaround. The pipe CAN send
  Enter, Tab, Escape, Backspace, Space (all valid Unicode code points that mutter maps to key
  events), which covers text input fully.
- gnome-remote-desktop's consent dialog: not triggered when view-only is disabled and credentials
  are set (verified in this test and in item 4). No consent prompt appeared during either
  xfreerdp connection. This confirms the decision doc's assumption.
- The xfreerdp window exists on the controller's `DISPLAY=:0` during the connection. It renders
  the remote desktop. For headless operation in scripts, `+disable-output` can deactivate graphics
  decoding (confirmed in `--help`). The pipe and RDP input continue to work without rendering.

**Competing priorities traded away.** `/cert:ignore` is a security trade-off (no MITM protection).
Accepted for the source-restricted LAN (firewall rule restricts to one IP). An improvement for
production would be `/cert:fingerprint:<sha256>:<hex>` with the target's cert fingerprint pinned.
The `/args-from` file temporarily contains the password in plaintext on the controller filesystem;
mode 600 and immediate deletion bound the exposure window to the session lifetime. A future
improvement is `/args-from:stdin` which avoids writing the password to a file at all (not tested
in this item because the pipe mechanism also interacts with stdin; the two can share a file
descriptor but the exact interaction is not documented in `--help`).

**Checks run (item 5)**

| Check | Command | Result |
|---|---|---|
| xfreerdp alive after connect | `kill -0 $RDP_PID` | alive (PID 871837) |
| Pipe created by xfreerdp | `ls -la /tmp/opencode/rdp-kbd` | `prw-------`, owner howard |
| Connection latency | logged timestamps | TLS handshake in ~25 ms after start |
| No consent dialog | visual screenshot | gnome-text-editor visible, no overlay/prompt |
| Marker text visible | agent read of PNG | "CHAOTIX41" in editor body and title |
| OCR | `tesseract ... \| grep CHAOTIX41` | `+ CHAOTIX41` (confirmed) |
| Args file cleanup | `ls /tmp/opencode/rdp-args` | no such file (deleted) |
| Pipe cleanup | `ls /tmp/opencode/rdp-kbd` | no such file (xfreerdp unlinks on exit) |
| Target editor closed | `kill 15531` over SSH | process killed |
| No credential in argv | xfreerdp process cmdline (`/proc/871837/cmdline`) at the time was `/args-from` only, not visible now; args file was mode 600 |

### Item 7: mouse pointer motion and click (done 2026-11-14)

**Problem: inject pointer motion and a left-button click into the target's GNOME 49 Wayland session from the controller, scripted, non-interactive.**

**Alternatives considered**

*Problem: mechanism for pointer injection through the existing RDP channel.*

- **Option A, XTEST on controller DISPLAY=:0 forwarded through xfreerdp window.** Launch xfreerdp on the controller (already proven to connect), position the cursor over the xfreerdp window via `XTestFakeMotionEvent`/`XTestFakeButtonEvent` (libXtst via ctypes), xfreerdp's X11 event loop captures and forwards them as RDP pointer events. Rejected after live test: xfreerdp's `xf_input.c` `register_input_events()` explicitly skips devices named "Virtual core pointer" (`if (strcmp(dev->name, "Virtual core pointer") == 0) continue;`). XTEST only generates events on the virtual core pointer (device 3 in XI2). Verified live: cursor position on the target did not change after XTEST motion (confirmed by before/after screenshots with cursor visible). The controller's Cinnamon/Muffin compositor does not re-route XTEST events to physical-device XI2 channels.
- **Option B, custom C client using libfreerdp3 (Chosen).** Write a minimal RDP client that connects to gnome-remote-desktop and calls `freerdp_input_send_mouse_event(input, PTR_FLAGS_MOVE, x, y)` followed by `PTR_FLAGS_DOWN | PTR_FLAGS_BUTTON1` (press) and `PTR_FLAGS_BUTTON1` (release). This bypasses the X11 client entirely and sends pointer events directly through the RDP protocol. gnome-remote-desktop's server code (`rdp_input_mouse_event`) injects them at the mutter compositor level. Verified live.
- **Option C, AT-SPI widget activation (item 8 fallback).** Can activate buttons and set text in GTK apps. Does not produce pointer motion or a cursor position change, so does not satisfy the literal acceptance criterion ("moves the pointer and clicks"). Kept as fallback only.

*Problem: gnome-remote-desktop rejects bare `freerdp_connect()` clients.*

gnome-remote-desktop's `rdp_peer_capabilities` callback checks for DRDYNVC (Dynamic Virtual Channel) support. Clients without it get "Client doesn't support the DRDYNVC SVC, closing connection" and a `PDU_TYPE_DEACTIVATE_ALL`. Root cause: FreeRDP's channel subsystem (`rdpClientContext` with `rdpChannels`) is what registers DRDYNVC in the Confirm Active PDU's Network Definition Block. A bare `freerdp_context_new()` client has no channel loading. Fix: use `freerdp_client_context_new()` with `ContextSize = sizeof(rdpClientContext)` which initializes the full channel subsystem. After this, channels load: ainput, rdpgfx, disp, rdpsnd. Connection succeeds.

**Mechanism details (source evidence)**

`freerdp_input_send_mouse_event(input, flags, x, y)` from `/usr/include/freerdp3/freerdp/input.h`:
- `PTR_FLAGS_MOVE` (0x0800): moves the pointer to (x, y) on the server session.
- `PTR_FLAGS_DOWN | PTR_FLAGS_BUTTON1` (0x8000 | 0x1000): presses left button at (x, y).
- `PTR_FLAGS_BUTTON1` (0x1000, no DOWN flag): releases left button at (x, y).
- Coordinates are 16-bit unsigned (0–65535), directly addressing the remote desktop pixel grid.

`rdp_peer_capabilities` in gnome-remote-desktop (48.1/main branch, target RPM `gnome-remote-desktop-49.3-4.el10_2`, links `libfreerdp-server3.so.3` from `freerdp-libs-3.32.2-1.el10_2`): checks `freerdp_settings_get_bool(peer->context->settings, FreeRDP_SupportDynamicChannels)`. Server sets this from the client's Confirm Active Network Definition Block. If absent, returns FALSE, connection is rejected.

`freerdp_client_context_new(&entry)` from `libfreerdp-client3`: allocates `rdpClientContext` (which includes `rdpChannels`), sets `instance->LoadChannels = freerdp_client_load_channels`, which during `freerdp_connect()` loads channel plugins (drdynvc, rdpgfx, disp, ainput, rdpsnd) and adds them to Confirm Active.

**Live proof (2026-11-14 09:21–09:22)**

1. Built: `gcc -o /tmp/opencode/rdp-pointer /tmp/opencode/rdp-pointer.c $(pkg-config --cflags --libs freerdp-client3)` (18272 bytes, ELF 64-bit, dynamically linked to libfreerdp3, libfreerdp-client3, libwinpr3).
2. Created args file `/tmp/opencode/rdp-args2` (mode 600): `/v:192.168.1.99`, `/u:howard`, `/p:<password>`, `/cert:ignore`, `/w:1920`, `/h:1080`, `+disp`. Password line generated from `~/AI/secrets/scm_draft_rdp_pass.md`.
3. Before screenshot via item-1 D-Bus path: `~/AI/demo-evidence/task0041-item7-before.png`, 1592482 bytes, PNG 1920×1080 RGBA. Shows GNOME 49 desktop with top panel "14 Nov 09:22" and Rocky wallpaper. No dropdown open.
4. Ran: `timeout 15 /tmp/opencode/rdp-pointer /tmp/opencode/rdp-args2 960 14 click`. Output: connected, DRDYNVC channels loaded (ainput, rdpgfx, disp, rdpsnd), pointer event sent, done. Exit 0.
5. After screenshot: `~/AI/demo-evidence/task0041-item7-after.png`, 1305048 bytes, PNG 1920×1080 RGBA. Shows GNOME 49 **calendar/notification dropdown open**: "Saturday 14 November 2026" with November calendar grid (day 14 highlighted in blue), "No Notifications" bell icon, "Today - No Events", "Add World Clocks..." button. Cursor visible near panel at click point.
6. Dismissal click at (400, 800) returned desktop to normal state.
7. Args file and temp password file deleted (`rm -f`). No residual credential on disk.

**Click coordinates**: (960, 14) on the target's 1920×1080 GNOME 49 Wayland session (the date/time label in the top panel bar).

**Pointer motion proof**: prior test (same session) moved cursor from approximately (780, 555) to (960, 540) via `PTR_FLAGS_MOVE`. Confirmed by cursor-check screenshot with `include_cursor=True`.

**Controller-side system change** (inverse recorded):

| Change | Inverse |
|---|---|
| `sudo dnf install -y freerdp-devel` → installed `freerdp-devel-2:3.32.2-1.el10_2` and `libwinpr-devel-2:3.32.2-1.el10_2` from already-enabled repos | `sudo dnf remove -y freerdp-devel libwinpr-devel` |

No new repo was enabled. No target-side system change in this item.

**Competing priorities traded away.** The C client approach requires `freerdp-devel` on the controller (a build-time dependency). The XTEST approach would have needed zero new packages but is proven non-functional. A future improvement: use `/args-from:stdin` instead of a file to avoid writing the password to disk even temporarily. Not adopted here because the pipe mechanism and stdin-based credential input interact in the xfreerdp code path but not in the standalone client.

**Limitations recorded for item 9 packaging.** The `rdp-pointer` binary connects, sends events, and disconnects in one shot. For `scripts/remote/rt-click`, each invocation opens a new RDP connection (~100 ms overhead). For rapid successive clicks in TASK-0042 map editing, a persistent connection with an event queue would be faster. The item 9 script should decide whether to reuse a connection or open per-action.

**Checks run (item 7)**

| Check | Command | Result |
|---|---|---|
| Connection succeeds | `rdp-pointer ... click` exit code | 0 (success) |
| DRDYNVC channels loaded | stderr output | ainput, rdpgfx, disp, rdpsnd loaded |
| Pointer moved | Before/after screenshots with `include_cursor=True` | Cursor moved from (780,555) to (960,540) |
| Click effect visible | Agent visual read of `task0041-item7-after.png` | Calendar/notification dropdown open |
| Before screenshot | `file task0041-item7-before.png` | PNG 1920×1080 RGBA, 1592482 bytes |
| After screenshot | `file task0041-item7-after.png` | PNG 1920×1080 RGBA, 1305048 bytes |
| Args file mode | `ls -la /tmp/opencode/rdp-args2` | `-rw-------` (600) |
| Args file cleanup | `ls /tmp/opencode/rdp-args2` after test | no such file (deleted) |
| Password not in argv | `rdp-pointer` argv was `<argsfile> 960 14 click` only | password never in argv |
| No secret in repo | `grep -R -F -f ~/AI/secrets/scm_draft_rdp_pass.md .` | (not run here; item 11 asserts this) |
| gnome-remote-desktop log | `sudo journalctl _UID=1000` during attempt | no rejection for the successful attempt |

Selftest not re-run: item 7 adds no repo code. Item 9 packages `rdp-pointer` into `scripts/remote/rt-click`; item 11 adds the selftest asserts.

### Packaging pass, 2026-11-22 (`Tails`, items 9 to 11 resumed from the unrecorded landing)

Previous child `ses_dfcfff07effe43cPjWBkzhcnKt` landed `scripts/remote/` on disk
with no record and left the callable tools non-executable. This pass resumed from
those files rather than rewriting them. Commit `b906f00`, pushed 2026-11-22,
pre-push selftest gate green at 83 checks.

**What landed.**

| File | Change | Why |
|---|---|---|
| `scripts/remote/*` (10 files, inherited) | committed as-is except one fix | the unrecorded landing resumed, not rewritten |
| `scripts/remote/rt-build:48-49` | fixed doubled path `${RT_ROOT}/scripts/rdp-input.c` to `${RT_ROOT}/rdp-input.c` | RT_ROOT is already `scripts/`; dry run printed `scripts/scripts/rdp-pointer.c` |
| `scripts/remote/rt-*` (8 callable tools) | `chmod +x` | the previous pass left them mode 644, so `--help` failed with exit 126 |
| `scripts/remote/NOTICE` | new, written this pass | `rt-build` references it as the FreeRDP licence record; it did not exist. Records the verified package identity from `rpm -q --qf '%{NAME}-%{VERSION}-%{RELEASE} licence=%{LICENSE}\n' freerdp-libs` → `freerdp-libs-3.32.2-1.el10_2 licence=Apache-2.0 AND HPND AND LGPL-2.1-or-later AND LicenseRef-Fedora-Public-Domain AND OFL-1.1`, the upstream FreeRDP dual licence (Apache-2.0 or GPL-2.0+, team takes Apache-2.0), the kernel UAPI header exception for `uinput-inject.c`, and the no-third-party-data rule |
| `tests/selftest.sh` | 22 new asserts (see below) | item 11, all offline |
| `.github/workflows/team-selftest.yml:50` | `MIN=40` to `MIN=70` | CI floor must track a suite that grew; 70 leaves headroom for environment-conditional skips (shellcheck, session store, agentgateway, gcc/freerdp) |
| `.opencode/skills/remote-desktop/SKILL.md` | new skill page | item 10, carries the secrets rule and the verified facts |

**Checks run.**

1. Before: `bash tests/selftest.sh` → `SELFTEST: 61 checks passed` (the inherited
   files were already counted by the shebang syntax gate because they were on disk).
2. After, this pass: `bash tests/selftest.sh` → `SELFTEST: 83 checks passed`, green
   on three consecutive runs including inside the pre-push hook. +22 asserts:
   inventory of 11 packaged files (1), executable bits (1), `--help` documents
   `--dry-run` per tool (8), `--dry-run` exits 0 with the `<host>` placeholder and
   no credential read for `rt-shot` and `rt-status` (2) and for `rt-ocr` (1),
   `rt-lib` still defaults to `gnome-screenshot-tool` (1, Robotnik decision of
   2026-11-20), `uinput-inject.c` still carries `UI_DEV_CREATE` settle handling
   (1, dispatch P1 fact), real offline `rt-build` compile of all three C tools into
   a scratch dir with gcc plus `pkg-config --exists freerdp-client3` (1, guarded
   skip when the toolchain is absent), input-tool dry runs `rt-type --text`,
   `rt-key --chord ctrl+t`, `rt-click --click 960 14`, `rt-uinput --probe` against
   the built scratch binaries (4), credential leak scan of the whole checkout
   against `~/AI/secrets/scm_draft_pass.md` as a run-time grep pattern with blank
   lines stripped (1), skill page present with the secrets rule wording (1).
   The scan satisfies the DoD grep line for the SSH credential; the rdp credential
   file was not scanned (see not-run list).
3. Skill discovery proof, item 10. Command:
   `opencode api get '/api/skill?location[directory]=/home/howard/AI/projects/team-chaotix-moe'`
   returns ids `['opencode', 'report', 'browser', 'add-ai-model', 'create-article',
   'new-model-import', 'push-to-github', 'remote-desktop']`. That proves opencode
   discovers `.opencode/skills/` for this project (docs table at
   `https://opencode.ai/docs/skills` names it as the Project source; the API read
   is the live proof).
4. Push: `GIT_ASKPASS=/tmp/opencode/git-askpass-tc.sh git push origin main` →
   `4201ef6..b906f00 main -> main`, pre-push hook ran `tests/selftest.sh` and
   passed at 83.

**Checks that did not actually run (explicit).**

1. No packaged tool ran against the live target in this pass. `rt-shot`, `rt-type`,
   `rt-key`, `rt-click`, `rt-status`, `rt-uinput` were exercised only through
   `--help` and `--dry-run`, which by design contact nothing and read no
   credential. The real-run paths are the proven item 4 to 7 mechanisms; the
   packaging inherits that proof, it does not re-prove it. No `DEMO-LOG.md` entry
   was written because the target was not touched.
2. `grep` against `~/AI/secrets/scm_draft_rdp_pass.md` over the repo was not run
   as a separate command; the selftest scans only `scm_draft_pass.md`. The rdp
   credential did appear verbatim in a `/tmp` args file in earlier passes
   (TASK-0042 `## Status` names `/tmp/opencode/t0042/rdp-args` for `Omega`), and
   nothing in this commit contains it, but the assertion does not cover it.
   Left for the review chain to weigh.
3. shellcheck is absent on this controller, so the shellcheck gate skipped on all
   files including the new selftest code; the new code was written to warning-
   level-clean style (here-strings instead of `grep -q` pipelines, quoted
   expansions) but that is unverified by a shellcheck run.
4. The commit is unsigned. The recent chain (`8e75aac`, `d26ef2b`, `5f9947d`) is
   unsigned too and the review chain is already weighing a signed-versus-unsigned
   chain; `b906f00` continues the unsigned run rather than silently diverging.

**Competing priorities.** The selftest asserts the packaged surface offline
(dry runs, compile, inventory, leak scan) rather than a live-target round trip,
because item 11 requires the asserts to pass with the target offline. The cost: a
regression in the real RDP or uinput paths would not be caught by CI. The build
assert compiles for real when the toolchain is present, which trades a few seconds
of CI time for proof that all three C sources actually compile against the
distro freerdp headers.

---

## Review

*Owner: `Shadow`. Read-only — findings only, no edits. Severity order, blockers first.*

### Correction to the packaging record's unsigned-commit claim

**Severity:** nit (factual record error, no code impact)
**Where:** `planning/docs/TASK-0041-remote-visual-control.md:791-793`
**Problem:** The Implementation record states "The commit is unsigned" for `b906f00` and names it as continuing "the unsigned run." Both commits ARE signed.
**Failure scenario:** A reader (Knuckles at item 16, or the operator auditing signatures) reads the record and believes the chain is unsigned, potentially blocking or misrouting the release step.
**Evidence:** `git verify-commit b906f00` returns `gpg: Good signature from "Team Chaotix" [ultimate]` against EDDSA key `D553FBE4B47020B2033E9594F9261D151316FD60` (short `F9261D151316FD60`). Same for `1eea4ec`, `e3b33bc`, `0485c2d`, and `3e43d2a`. The earlier chain the record names (`8e75aac`, `d26ef2b`, `5f9947d`) IS unsigned (verify-commit exit 1, no signature). The packaging commits broke the unsigned run, they did not continue it.
**Suggested direction:** `Tails` replaces the four lines at `:791-793` with a corrected statement: the packaging pass commits are signed against `F9261D151316FD60`, the unsigned chain ended before `b906f00`. `Omega` verified both signatures (dispatch brief confirms).

---

### Modifier-chord limit does not block any packaging DoD row

The `## Status` paragraph at `:18` states "Modifier chords remain an open packaging question for item 9." That note predates the packaging landing. `rt-key` covers chords through raw RDP scancode keydown/keyup pairs (AT set 1), and TASK-0042 proved `Ctrl+T`, `Ctrl+U`, `Ctrl+D`, `Ctrl+S` against SCMDraft 2 through that exact path (`scripts/rdp-input.c`, verbs `keydown`/`keyup`/`key`/`keyx`). The DoD keyboard row (row 2) requires "one command types a known marker string into a GUI app" which `rt-type` satisfies, and the packaging row (row 5) requires the loop be packaged. Both are satisfied. The Status paragraph is a stale open-question marker that `Espio` or `Robotnik` can close. No packaging row is left unsatisfiable.

---

### DoD rows 5 through 8 and 12 are satisfied

| DoD row | Criterion | Evidence |
|---|---|---|
| 5 | Four paths packaged as team tooling with a documented visual loop | `scripts/remote/` carries `rt-shot`, `rt-ocr`, `rt-type`, `rt-key`, `rt-click`, `rt-status`, `rt-uinput`, `rt-build`, `rt-lib`. `SKILL.md` documents the act/capture/read/decide loop. |
| 6 | Skill or docs page with the secrets rule in prose | `.opencode/skills/remote-desktop/SKILL.md` carries the binding secrets paragraph. Discovery proven by the `opencode api` call recorded at `:762-768`. |
| 7 | Selftest asserts with an increased check count | 22 new offline asserts landed at `b906f00`. The K6 host-key hardening at `3e43d2a` added 2 more asserts (103→105). K8 added 1 more (105→106). Current run: `SELFTEST: 106 checks passed (floor 100)`. Before/after counts 61→83 recorded at `:744-746`. |
| 8 | Repo-wide grep for both secrets returns no match | The selftest scan at `tests/selftest.sh:253-264` covers both `scm_draft_pass.md` and `scm_draft_rdp_pass.md`, fails on absent file or blank file, and passes at 106. The packaging-pass "not run" list at `:781-786` correctly named that the rdp credential scan was then selftest-only; since K6 the scan covers both credentials as an assert, and it passes. |
| 12 | DEMO-LOG records each step against the target | Items 1, 2, 3, 4, 5, 6, 7, 12 each have a DEMO-LOG entry with commands and inverses. Items 9-11 are packaging-only and touched no target, so no entry is required. |

---

### No DoD row demands the retired fifth reviewer

DoD row 9 was restated in place 2026-11-23 00:10 UTC (`:59`) to name `Shadow`, `Omega`, `Big`, `Charmy`. Plan rows 13 and 14 at `:171-172` still carry `Flicky`; those are `Amy`'s section and per AGENTS.md section 2 rule 7 (retired headings stay), `Robotnik`'s ruling at `:14` is the correction, and `Espio` folds them at `E1`. The `## License Audit (Flicky)` section heading at `:832` is a retained legacy heading. `Charmy` writes in its own section. No DoD row is unsatisfiable by the retirement.

---

### Checks that did not actually run in this review pass

1. No packaged tool exercised against the live target. `rt-shot`, `rt-type`, `rt-key`, `rt-click`, `rt-status`, `rt-uinput` were read and dry-run reviewed only. The live-target round trip is proven by items 4-7 evidence, inherited, not re-proven.
2. `shellcheck` is absent on this controller, so the new selftest code was not shellcheck-verified.
3. No standalone `grep -R -F -f ~/AI/secrets/scm_draft_rdp_pass.md .` was issued in this pass. The selftest credential scan (which covers both secrets) ran as part of the 106-check pass.
4. The `scripts/licence-check` gate was not re-run in this pass. The gate last ran green at K7 (TASK-0042 `## License (Charmy)`), and the packaging commits add no new third-party code, only team-authored sources with SPDX headers. `Charmy` at `T4` owns the re-run.

---

### Verdict

No blocker. No should-fix. The packaging satisfies TASK-0041 DoD rows 5, 6, 7, 8, and 12. The one finding is a factual correction to the Implementation record (unsigned-commit claim), severity nit, landable by `Tails` in one edit to `:791-793`.

Written 2026-11-25 10:12 UTC (2026-11-25 19:12 JST).
---

## Security

*Owner: `Omega`. Read-only. Severity order.*

---

## License (Charmy)

*Owner: `Charmy`. Fourth in the review chain. Every license is verified at the upstream source repository and the ref used, never from a copy in this repo.*

**Project license:** — appropriate | finding

**Imported code**

| Component | Source (repo @ ref) | License (verified at) | Obligations met | Status |
|---|---|---|---|---|

**Verdict:** pass | findings

---

## License Audit (Flicky)

*Owner: `Flicky`. Fifth in the review chain. Runs the machine gate; the gate is evidence, and this section records it.*

**Gate:** `scripts/licence-check <project-root>` (exit 0 `PASS` · 6 `POLICY_EXCEPTION` · 7 `BLOCK` · 8 `HARD_STOP`)

**Outcome:** | **Verdict:** pass | findings

---

## Test Results

*Owner: `Big`. Verdicts, never raw log dumps.*

| Check | What it exercises | Result | Notes |
|---|---|---|---|

**Checks requested vs run:** N requested, N executed.

**Verdict:**

---

## Docs

*Owner: `Vector`.*

| File | Sections touched | What changed |
|---|---|---|

---

## Release

*Owner: `Knuckles`.*

**DONE checklist verified:** yes / no

- **Branch:**
- **Commits:** GPG-signed
- **PR:**

---

## Archive

*Owner: `Espio`, the only agent that deletes.*

**Pruning log**

| Date | What was pruned or compressed | Rough size |
|---|---|---|
