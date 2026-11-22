---
name: Remote Desktop
description: Drive and observe a remote Rocky Linux GNOME/Wayland target through the scripts/remote visual-control loop (capture, OCR, keyboard, mouse, uinput). Use for any TASK that needs eyes or hands on 192.168.1.99 or another remote GUI host.
---

## The loop

act, capture, read the image, decide. Every tool in `scripts/remote/` is one
step of that loop. Captures land on the controller under an evidence
directory outside git (`~/AI/demo-evidence/` for booth work), never in a
tracked path.

## Secrets rule (binding)

A credential is read from its file under `~/AI/secrets/` at run time only.
It is never echoed, never placed in argv (so never in `ps` or shell history),
never written to a file, a commit, a log, or a planning doc. The wrappers
enforce this: `sshpass -f <file>`, and RDP argument lines piped into a tool's
stdin. `--dry-run` prints the exact commands with a `<host>` placeholder and
reads no credential. `grdctl` on the target takes the credential via stdin
(`--headless`) the same way. Files: `scm_draft_pass.md` (target SSH),
`scm_draft_rdp_pass.md` (RDP). A mode other than 600 on a secret file is a
warning the tools print, not something they fix silently.

## Tools

All take `--host <ip>`, `--dry-run`, and the shared credential-path options.
`scripts/remote/rt-build` compiles the C helpers into
`~/.cache/team-chaotix/remote-build` (never a tracked path) and points at
`scripts/remote/NOTICE` for the licence record.

| Tool | What it does |
|---|---|
| `rt-status` | Target inventory: session type, screenshot tool, session bus, grd listener, `/dev/uinput` state |
| `rt-shot` | One full-screen PNG of the live session, fetched to the controller, target-side copy removed unless `--keep-target-copy` |
| `rt-ocr` | Local `tesseract` read of a captured PNG; `--grep <marker>` verifies an injected marker string |
| `rt-type` | Unicode text into whatever has focus, through the RDP input channel (code points only, no chords) |
| `rt-key` | Raw AT set-1 scancodes: `--key`, `--down`/`--up`, `--chord ctrl+t`, modifier holds |
| `rt-click` | Pointer `--move`, `--click x y`, `--drag` waypoints through the RDP pointer channel |
| `rt-uinput` | Kernel-level injection below gnome-remote-desktop: `--probe` or `--script <command file>` via `/dev/uinput` on the target |

## Verified facts (carry them, do not re-derive)

- Capture is `/usr/bin/gnome-screenshot-tool -f <file>` run with
  `XDG_RUNTIME_DIR=/run/user/1000` and
  `DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus`. A raw `gdbus` call
  to `org.gnome.Shell.Screenshot` returns `AccessDenied` from any caller that
  is not the recognised `org.gnome.Screenshot` client (target 192.168.1.99,
  DEMO-LOG 2026-11-20 01:40-02:10). `rt-shot` wraps the working binary.
- RDP keyboard input carries Unicode code points and control characters only.
  Modifier chords need scancodes: `rt-key --chord` (proven for Ctrl+T, Ctrl+U,
  Ctrl+D, Ctrl+S against SCMDraft 2), Super is `0x5B` extended.
- Pointer motion and click reach all applications including Wine/XWayland
  clients (proven: click at 960,14 opened the GNOME 49 dropdown).
- uinput path, proven in TASK-0042 dispatch P1: events emitted in the same
  millisecond as `UI_DEV_CREATE` are dropped, so the injector settles 1800 ms
  before its first event. Relative motion (`rmove`, `rclick`) works; the
  pen-tablet absolute device produced a zero-pixel difference on this target.
  A pure-`ctypes` injector returned `EINVAL` on every ioctl, reason
  unestablished; the self-authored C helper works.
- The target has no compiler; `rt-build` compiles on the controller and
  `rt-uinput` copies the binary over, runs it with `sudo -n`, and removes it
  again unless `--keep-target-copy`.
- RDP connection: `/cert:ignore` is accepted for the LAN demo's self-signed
  certificate; the credential reaches the tools through stdin argument lines.
  The listener is enabled on the target with `grdctl rdp enable` (state
  recorded in TASK-0041).

## Target hygiene

Every tool that places a file on the target removes it again by default.
Every target-touching run appends one dated entry to `DEMO-LOG.md` at the
repo root with the proving command and its exact inverse. Do not change the
target's maps. Leave test changes on test VMs for the operator (rule r002).

## Selftest

`tests/selftest.sh` asserts the inventory, executable bits, `--help`,
offline dry runs, the offline C build, and a credential leak scan against
the secret file pattern. It never contacts the target.
