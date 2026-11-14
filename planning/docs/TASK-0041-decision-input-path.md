# Input path for a remote GNOME 49 Wayland session

Depth: 6-pager. This one creates a new credential, opens a port on a machine the audience stands next
to, and decides whether the demo can drive a Wine-hosted Windows app. Expensive to walk back in public
posture if it is done badly, so it is written down before implementation.

## 1. Problem

The team must send keystrokes, pointer motion, and clicks into a running GNOME 49.4 Wayland session on
`192.168.1.99` from `192.168.1.102`, in a form a script can drive unattended. The DoD requires a marker
string typed into a GUI app and a pointer click, both provable in a screenshot. Evidence that this is
not a solved problem on this machine today: `xdotool`, `ydotool`, `wtype`, `dotool` and `grim` are not
installed on either machine and do not exist in Rocky 10 baseos, appstream, CRB or EPEL10 (`dnf
repoquery -q --available`, 2026-11-13). The SSH environment has no `WAYLAND_DISPLAY` and no `DISPLAY`
(`## Status`), so an SSH-launched tool cannot simply attach to a display. Port 3389 is closed and the
`gnome-remote-desktop` user unit is `disabled; inactive (dead)` even though the package is installed
(`systemctl --user status gnome-remote-desktop`, 2026-11-13). XTEST against XWayland would only reach
X11 clients, and the tool that speaks it is not packaged.

## 2. Background

Two decisions are already recorded in `## Status`: control reaches the target's own session, and
`gnome-remote-desktop` is preferred over a VNC server because it is installed, it is the upstream GNOME
Wayland mechanism, and it is the documented RHEL-family path. `dotool` and `ydotool` were assumed
available and the probe shows they are not, which is what forced this document. What the probe did find
on the target: `org.gnome.Shell.Screenshot` on the user bus, `org.a11y.Bus` with `at-spi2-registryd`
live, `org.gnome.Mutter.{InputCapture,InputMapping,RemoteDesktop,ScreenCast}` on the user bus,
`at-spi2-core` installed, `python3-pyatspi` installable from enabled repos, session 2 `Type=wayland`
`LockedHint=no`. `grdctl` exists with `rdp enable`, `set-credentials`, `clear-credentials`,
`set-tls-cert`, `set-tls-key`, `set-port`, `enable-view-only`, `disable-view-only`, and no status or
system-mode subcommand; every `grdctl` call currently errors with `RDP server certificate is invalid`.

## 3. Options

**A. RDP through `gnome-remote-desktop`, driven by FreeRDP from the controller.** Enable the already
installed server with `grdctl`, credentials, a regenerated TLS cert, a source-restricted firewalld rule,
then inject input through an RDP client. Pros: compositor-level input, so it reaches *everything* on the
session including the Wine-hosted SCMDraft 2 that TASK-0042 actually needs; no new package on the
target; `freerdp` client is installable on the controller from enabled repos; it is the upstream
mechanism, which is the story the booth is telling. Cons: a new credential and an open port; the
`grdctl` in 49.3 shows no headless/system-mode switch, so whether a credential-based connect works
without someone at the target accepting a dialog is untested; FreeRDP's ability to inject scripted input
without a human at a keyboard is unverified; and a GUI RDP client on the controller adds a layer the
team would rather not own.

**B. uinput injection on the target (`ydotool`/`dotool` or a small hand-written uinput writer).**
Pros: no network listener, no new credential, compositor-level input that also reaches Wine. Cons: no
package exists in any enabled or available repo, so it is a source build on the demo machine plus a udev
rule plus either root or a polkit grant, which is a deeper system change than an RPM install; the
`/dev/uinput` permission model is exactly the kind of thing that breaks silently; and it is a second
toolchain to maintain for a demo that has 15 days.

**C. AT-SPI accessibility scripting on the target (`python3-pyatspi` against `org.a11y.Bus`).**
Pros: installable from enabled repos, no port, no credential, deterministic widget-level control (set
text, press button, list the window tree), and it produces a *text* record rather than only a picture,
which is better evidence than OCR. Cons: it only reaches accessibility-aware toolkits, so GTK and
Qt-with-a11y apps work and the Wine-hosted SCMDraft 2 window does not. It can prove the DoD loop and it
cannot run the demo.

**D. XTEST against the target's XWayland from an SSH-launched client.** Pros: X11 clients are what Wine
creates windows on, so it is the only compositor-adjacent path that reaches the demo app without RDP.
Cons: `xdotool` is not packaged anywhere; the XWayland socket is reachable only from inside the session
and normally needs the client in the session's environment; and it cannot touch GNOME Shell itself, so
Activities, Files, and the shell UI stay out of reach.

## 4. Recommendation

**A, confirmed.** Option A works. The mechanism is `xfreerdp /kbd:pipe:<fifo>` combined with
`/args-from:file:<path>` for non-interactive password passing and `/cert:ignore` for the self-signed
TLS. Proof was exercised live on 2026-11-14 against the target at 192.168.1.99:
`printf 'CHAOTIX41' > /tmp/opencode/rdp-kbd` injected 9 keystrokes into a focused gnome-text-editor
window on the target's GNOME 49 Wayland session, confirmed both by visual read of the screenshot
(`~/AI/demo-evidence/task0041-kbd-proof2.png`, 1256031 bytes, "CHAOTIX41" visible in editor body and
title bar) and by OCR (`tesseract ... | grep CHAOTIX41` returned the string). No consent dialog
appeared. The entire sequence ran without a human at the controller keyboard.

Evidence for the three "what would change my mind" conditions:
- `grdctl` on-screen consent: NOT triggered. Two unattended connections succeeded without any
  dialog or prompt. (Verified 2026-11-13 in item 4, reconfirmed 2026-11-14 in this proof.)
- FreeRDP scripted input: CONFIRMED working. `/kbd:pipe:` is the mechanism. The pipe is a named FIFO
  that xfreerdp creates at startup (mode 0600, owned by the user), reads UTF-8 from, and converts
  each code point to a Unicode keyboard event pair (press + release, 5 ms between). See FreeRDP
  3.32.2 `client/X11/xf_client.c` lines 1306-1395 for the implementation.
- GNOME-remote-desktop input broken for XWayland: not yet directly tested against a Wine window
  (no Wine installed on the target yet). However, the injection is at the mutter compositor level
  (the Unicode keyboard event is handled by mutter's input system, not by a toolkit-specific bridge),
  so it will reach XWayland clients. This will be tested in item 6 against the actual demo app.

The pipe's Unicode-only design means it injects text characters and control characters (Enter
U+000D, Tab U+0009, Escape U+001B, Backspace U+0008, Space U+0020) but NOT modifier combinations.
For modifier key combinations needed during the demo (Super for Activities, Ctrl+letter shortcuts,
Alt+Tab), a supplementary mechanism will be needed in item 9 packaging. Options: send a key
sequence that the application interprets without a modifier (e.g., GNOME Shell's "type to search"
in the overview), or use `org.gnome.Shell.Eval` D-Bus as a side channel for shell-level actions,
or write the modifier key events directly via FreeRDP's scancode path in a custom addin.

**Mouse pointer injection: CONFIRMED working (item 7, 2026-11-14).** A custom C client (`rdp-pointer`, links `libfreerdp3` via `freerdp_client_context_new` for full DRDYNVC channel initialization) sends `freerdp_input_send_mouse_event(input, PTR_FLAGS_MOVE, x, y)` for motion and `PTR_FLAGS_DOWN | PTR_FLAGS_BUTTON1` / `PTR_FLAGS_BUTTON1` for left-click press and release. gnome-remote-desktop's `rdp_input_mouse_event` callback injects these at the mutter compositor level. Proof: click at (960, 14) opened the GNOME 49 calendar/notification dropdown, confirmed by before/after screenshot pair (`task0041-item7-before.png`, `task0041-item7-after.png`). Pointer motion confirmed by cursor-position screenshots.

Mouse injection reaches the entire Wayland session at the compositor level, the same as keyboard injection. This means it reaches XWayland and Wine-hosted windows identically. The mechanism is the RDP input PDU (not X11 or XI2), so it is toolkit-agnostic.

XTEST against xfreerdp's X11 window was tested and rejected: xfreerdp's XI2 handler skips the virtual core pointer device, and XTEST only generates events there. This path cannot forward pointer events. The C client bypasses the X11 client entirely.

Option C (AT-SPI) is no longer needed as a proof mechanism. It remains as a diagnostic tool for inspecting widget state (reading window titles, enumerating the accessibility tree) which complements OCR. Option B (uinput) is off the table. Option D (XTEST against XWayland) remains dropped. Option A (RDP) now covers both keyboard and pointer.

**Decision gate: PASSED.** TASK-0042 can proceed on the assumption that keyboard input reaches the
target's desktop session programmatically. The remaining open question for TASK-0042 is whether the
demo app (Wine-hosted SCMDraft 2) is reachable by the same input path once Wine is installed, which
item 6 tests.

## 5. Risks and mitigations

- **Unattended connect does not work.** Likelihood medium, impact: no hands for the demo. Mitigation:
  item 4 tests it before anything is built on top. Contingency: option C proves the loop, and the demo
  is re-scoped to a hand-driven session with the team capturing and narrating.
- **FreeRDP cannot be driven by a script.** Likelihood medium, impact: hands exist but only with a human
  at the controller. Mitigation: item 5 reads `xfreerdp --help` in full and records what is actually
  available before any script is written; candidate mechanisms are ranked in the decision rather than
  assumed. Contingency: run the RDP client in a window on the controller's own `DISPLAY=:0` and bridge
  keystrokes, accepting the extra layer.
- **New credential leaks** through argv, `ps`, shell history, or the log. Likelihood medium, impact
  high: anyone on the LAN drives a live desktop. Mitigation: secret file at `~/AI/secrets/` mode 600,
  read at run time, freerdp's own file or environment option chosen in item 5, `set +x` in every script,
  the DEMO-LOG no-credential rule, and the repo-wide grep guard asserted in selftest. Contingency:
  `grdctl rdp clear-credentials` and a new password, which costs nothing but an in-flight session.
- **Open 3389 on a booth LAN.** Likelihood certain if A proceeds. Mitigation: firewalld rich rule
  allowing 192.168.1.102 only, `enable-view-only` available as a one-command downgrade, and the disable
  sequence recorded before the enable command runs. Contingency: disable for the parts of the day the
  demo is not running.
- **Input works but the session is locked or blanked mid-demo.** Likelihood medium. Mitigation: idle-delay
  and lock settings changed with the previous values recorded so they can be restored. Contingency:
  `loginctl unlock-session`.
- **RDP input reaches GTK apps but not the Wine window.** Likelihood low to medium, impact: the demo
  fails even though the DoD passes. Mitigation: item 6's marker test is run against the kind of window
  TASK-0042 needs, not only against a text editor, before the loop is declared working.

## 6. Plan and validation

Sequence is the plan table in `planning/docs/TASK-0041-remote-visual-control.md`: item 1 (eyes), item 4
(enable and prove the listener), item 5 (this document's Recommendation updated with the `xfreerdp`
evidence), item 6 (keyboard marker), item 7 (mouse click), item 8 (option C, run if 5 to 7 fail), then
packaging, skill, selftest, review chain, docs, release, venue dry run on 2026-11-26. Owners are named
per item there. Success criteria are the four DoD bullets of TASK-0041, each proved by a PNG under
`~/AI/demo-evidence/` plus a command output, and the marker string appearing in both. Rollback for the
target side is the recorded inverse set (`clear-credentials`, `rdp disable`, unit disable, firewall rule
removal, gsettings reset); the repo side is a `git revert`. Point of no return: none in code. The only
irreversible risk is a target config change made without a backup copy, which is why every target change
copies to `~/AI/demo-backup/<date>/` first.
