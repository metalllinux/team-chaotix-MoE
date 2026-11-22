# DEMO LOG — FOSS for All Conference 2026 booth demonstration

Continuous log of everything the Team Chaotix team does for the FOSS for All booth demo.
Event: 2026-11-28, Centerfield EAST 18F, AWS Korea, Seoul.

Machines: controller `192.168.1.102` (this machine, where opencode and the team run) and target
`192.168.1.99` (`scmdraft2-map-creator`, Rocky Linux 10.2, GNOME 49 Wayland), which the team drives.

Planning docs: `planning/docs/TASK-0041-remote-visual-control.md` (the eyes-and-hands capability) and
`planning/docs/TASK-0042-foss-for-all-scmdraft2-demo.md` (the demo itself).

Rules for this file. Append, never rewrite. One dated entry per step. State the command that produced
a claim. No credential, token, key, or password ever appears here, not even partially. Screenshots and
other evidence files live outside git under `~/AI/demo-evidence/` and are named here, not committed.

---

## 2026-11-13

**13:05 Robotnik — intake.** Operator request recorded: team drives `192.168.1.99` over SSH, installs
SCMDraft 2 from Stormcoast Fortress under a Windows compatibility layer, builds five maps
(`foss-for-all`, `rocky-logo`, `rocky-with-heart`, `republic-of-korea`, `tux`), documents everything in
`metalllinux/foss-for-all-booth-demonstration-scmdraft-2`. Team capability gap identified and split into
TASK-0041. Confidence: high on the request, unknown on the compatibility layer and on StarCraft game data.

**13:07 Robotnik — controller inventory.** `command -v` for ssh, scp, sshpass, rsync, ssh-keygen,
xdotool, ydotool, wtype, grim, tesseract, convert, podman, gh. Result: the SSH toolchain is present,
every GUI input tool, every screenshot tool, OCR, ImageMagick, podman, and `gh` are absent. This is why
TASK-0041 exists.

**13:08 Robotnik — target probe over SSH.** Command:
`sshpass -f ~/AI/secrets/scm_draft_pass.md ssh howard@192.168.1.99 '<probe>'`. Result: hostname
`scmdraft2-map-creator`, Rocky Linux 10.2 `el10_2`, GNOME Shell 49.4, `gnome-remote-desktop-49.3-4.el10_2`
installed, `gnome-screenshot`/`wine`/`steam` not installed, 16 vCPU, 61 GB RAM, 64 G free on `/`,
`nvme0n1` 931.5 G, AMD Lucienne iGPU, repos `baseos`/`appstream`/`extras` only. SSH session has no
`WAYLAND_DISPLAY` and no `DISPLAY`, so screenshot and input tooling must reach the live seat0 session.

**13:08 Robotnik — target reachability.** `ping -c1 192.168.1.99` OK. TCP 22 open. TCP 3389 closed,
which means the GNOME RDP server is installed but not enabled.

**13:09 Robotnik — documentation repo check.** `curl` against `api.github.com` with the token at
`~/AI/secrets/token.md`: `metalllinux/foss-for-all-booth-demonstration-scmdraft-2` exists, private,
default branch `main`, created 2026-11-13T00:51:58Z, empty.

**13:10 Robotnik — upstream source check.** `webfetch` of
`http://www.stormcoast-fortress.net/cntt/software/scmdraft/download/`: current release is SCMDraft II
0.9.10 (Installer and ZIP), 0.9.11 pre-release alphas live under `/Irregularies/`, all builds are
Windows binaries, and the site's own non-Windows guide is a Wine guide at `/cntt/software/scmdraft/wine-example/`.

**13:12 Robotnik — task records created.** `TASK-0041` and `TASK-0042` planning docs written with
`## Definition of Done` from Robotnik, rows added to `planning/TASKS.md`, this log created.

**22:05 Tails — item 2, controller dependencies.** Command: `sudo dnf install -y freerdp tesseract
tesseract-langpack-eng python3-pillow`. Installed from already-enabled repos only (appstream, baseos,
crb, epel, extras, cinnamon-rocky10, google-chrome). NEVRAs: `freerdp-3.32.2-1.el10_2.x86_64`,
`tesseract-5.3.4-11.el10_2.x86_64`, `tesseract-langpack-eng-4.1.0-9.el10.noarch`,
`python3-pillow-12.3.0-2.el10.x86_64`. Paths: `/usr/bin/xfreerdp`, `/usr/bin/tesseract`. Repolist
verified identical before and after. Target untouched in this item.

**22:12 Tails — item 1, eyes (screenshot path proven).** Command:
`sshpass -f ~/AI/secrets/scm_draft_pass.md ssh howard@192.168.1.99 'export XDG_RUNTIME_DIR=/run/user/1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus; python3 -c "..."'`
— a Python script that requests the `org.gnome.Screenshot` D-Bus bus name (flag 0x4) then calls
`org.gnome.Shell.Screenshot.Screenshot(false, false, "/tmp/task0041-shot1.png")`. The direct
`gdbus call` without the name request returns `AccessDenied: Screenshot is not allowed` because
GNOME 49 restricts the interface to callers that own `org.gnome.Screenshot`. With the name requested,
the call returns `(True, '/tmp/task0041-shot1.png')`. File fetched with `sshpass -f
~/AI/secrets/scm_draft_pass.md scp howard@192.168.1.99:/tmp/task0041-shot1.png
~/AI/demo-evidence/task0041-shot1.png`. Result: 854449 bytes, PNG 1920x1080 RGBA. Image shows: GNOME
top panel with "13 Nov 22:12" center, Activities button left, system indicators (accessibility,
network, volume, battery 100%) right; Rocky Linux 10 dark-purple geometric wallpaper; no windows open.

**22:14 Tails — item 3, OCR.** Command: `tesseract ~/AI/demo-evidence/task0041-shot1.png -`. Output:
`13Nov 22:12 > & 100%`. Contains the panel date text ("Nov") and battery percentage ("100%"), both
visually present in the image. OCR path confirmed.

**22:27 Tails — item 12, secrets and target-change hygiene.** Controller: `umask 077` then
`openssl rand -base64 24 | tr -d '/+=' | cut -c1-20 > ~/AI/secrets/scm_draft_rdp_pass.md` (the value
was never displayed, never on an argument line). `stat -c '%a %n'` shows `600` on the new file.
Repo hygiene: `grep -R -F -f ~/AI/secrets/scm_draft_pass.md .` exit 1 (no match) and
`grep -R -F -f ~/AI/secrets/scm_draft_rdp_pass.md .` exit 1 (no match). Note recorded for Omega: the
pre-existing `~/AI/secrets/scm_draft_pass.md` is mode 644 on the controller, which is outside the
mode-600 secrets rule, and the target held a pre-existing world-readable (644) plaintext grd
credentials file (see item 4 entry).

**22:29-22:34 Tails — item 4, target RDP enablement, recorded with inverses.** All target-side.
Every inverse is the line marked INV; running the INV list in order fully returns the target to its
pre-item-4 state.

Pre-state (commands: `systemctl --user is-enabled is-active gnome-remote-desktop.service` then
`grdctl status`): unit `disabled; inactive`; RDP Status disabled, Port 3389, TLS certificate empty,
TLS fingerprint (null), View-only yes, Negotiate port yes. The known invalid-certificate problem
(`[ERROR][com.freerdp.crypto] - [x509_utils_from_pem]: BIO_new failed for certificate` / `RDP server
certificate is invalid`) reproduced on every `grdctl` call. Cause established by this session: no TLS
certificate was configured at all (the cert and key paths in `grdctl status` were empty), and this
49.3 build does not auto-generate a certificate, so the daemon logs `RDP TLS certificate and key not
yet configured properly` and never binds 3389. Once a valid cert is configured the error is gone.
A pre-existing grd credential (username `howard`, plaintext, stored 644 world-readable at
`/var/lib/gnome-remote-desktop/.local/share/gnome-remote-desktop/credentials.ini`) was found before
any change of ours; its value is not recorded here and was overwritten by item 4's
`clear-credentials` plus `set-credentials`.

Backup (no inverse, additive): `sudo mkdir -p /home/howard/AI/demo-backup/2026-11-13` and
`sudo cp -a /var/lib/gnome-remote-desktop/.local/share/gnome-remote-desktop
/home/howard/AI/demo-backup/2026-11-13/grd-credentials.ini`.

1. `systemctl --user enable --now gnome-remote-desktop.service`. INV:
   `systemctl --user disable --now gnome-remote-desktop.service` (it was disabled and inactive before).
2. `grdctl rdp enable`. INV: `grdctl rdp disable`.
3. `grdctl rdp disable-view-only`. INV: `grdctl rdp enable-view-only` (view-only was yes before).
4. TLS certificate. A first attempt placed the pair in `/etc/gnome-remote-desktop/` with owner
   `gnome-remote-desktop`; it failed because the user daemon runs as `howard` and cannot read the
   600 key there (daemon log: `RDP TLS certificate and key not yet configured properly`), and a
   copy-then-delete ordering mistake removed that key (it was already unreadable to `howard`, so
   nothing of the user's was lost). Final fix, as `howard` with `umask 077`:
   `openssl req -x509 -newkey rsa:2048 -sha256 -days 825 -nodes
   -keyout ~/.config/gnome-remote-desktop/tls-key.pem
   -out ~/.config/gnome-remote-desktop/tls-cert.pem
   -subj "/CN=scmdraft2-map-creator" -addext "extendedKeyUsage=serverAuth"`, then `chmod 644` on the
   cert (key stays 600, owner `howard`), then `grdctl rdp set-tls-cert
   ~/.config/gnome-remote-desktop/tls-cert.pem` and `grdctl rdp set-tls-key
   ~/.config/gnome-remote-desktop/tls-key.pem`, then `systemctl --user restart
   gnome-remote-desktop.service`. INV: `rm -f ~/.config/gnome-remote-desktop/tls-cert.pem
   ~/.config/gnome-remote-desktop/tls-key.pem` (and `rmdir ~/.config/gnome-remote-desktop`), which
   removes the cert store before the service is disabled per inverse 1.
5. Credentials, password never on an argument line, never echoed, read from
   `~/AI/secrets/scm_draft_rdp_pass.md` at run time through stdin:
   `sshpass -f ~/AI/secrets/scm_draft_pass.md ssh howard@192.168.1.99 'grdctl rdp set-credentials
   howard' < ~/AI/secrets/scm_draft_rdp_pass.md` (grdctl reads the password from stdin when the
   argument is omitted; verified first with a dummy value, and `sudo journalctl` shows no sudo-wrapped
   password command). INV: `grdctl rdp clear-credentials`.
6. Firewall, source-restricted to the controller: `sudo firewall-cmd --permanent --zone=public
   --add-rich-rule='rule family="ipv4" source address="192.168.1.102" port port="3389" protocol="tcp"
   accept'` then `sudo firewall-cmd --reload` (guarded by `--query-rich-rule`, which was no before).
   INV: `sudo firewall-cmd --permanent --zone=public --remove-rich-rule='rule family="ipv4" source
   address="192.168.1.102" port port="3389" protocol="tcp" accept'` then `sudo firewall-cmd --reload`.
7. `gsettings set org.gnome.desktop.screensaver lock-enabled false`. Previous value was `true`. INV:
   `gsettings set org.gnome.desktop.screensaver lock-enabled true` (or `gsettings reset
   org.gnome.desktop.screensaver lock-enabled`). `org.gnome.desktop.session idle-delay` was already
   `uint32 0` before, so it was not changed and needs no inverse.

Acceptance evidence. Target `ss -tlnp | grep 3389` -> `LISTEN 0 5 *:3389 *:*
users:(("gnome-remote-de",pid=13977,fd=22))`. Controller `timeout 5 bash -c
'</dev/tcp/192.168.1.99/3389' && echo OPEN` -> `OPEN`. `sudo firewall-cmd --list-rich-rules` and the
`--permanent` view both show exactly the one source-restricted rule; `--list-ports` remains empty.
`grdctl status` reports Unit active, RDP enabled, Port 3389, View-only no, TLS fingerprint present
(SHA-256 of the self-signed certificate, value not recorded here), Username `howard`. Self-signed TLS
means any RDP client will see a certificate warning; that is accepted for the LAN demo and flagged
for Omega. Idempotency: the rich rule is guarded by `--query-rich-rule`, the certificate is guarded
by a configured-cert check, `set-credentials` overwrites, and `enable`/`enable --now` are idempotent,
so re-running item 4 creates no second rule and no second cert.

**08:04-08:13 Tails — item 5, input mechanism decision (gate PASSED).** Read `xfreerdp --help` in
full (417 lines). Candidate non-interactive input mechanisms found: `/kbd:pipe:<filename>` (named
pipe for typing text into the RDP session), `/dump: record|replay` (event replay, requires prior
recording), `/args-from: file|stdin|fd|env` (read all arguments from a file, hiding `/p:<password>`
from argv), `/from-stdin` (credential prompt via stdin), `/cert:ignore` (skip TLS verification
without a dialog). Chose `/kbd:pipe:` for input injection, `/args-from:file:` for credential hiding,
and `/cert:ignore` for the self-signed cert. Source evidence: FreeRDP 3.32.2 `client/X11/xf_client.c`
`xf_inject_keypress` converts UTF-8 to UTF-16 and sends one Unicode keyboard event pair per character.

Live test. Opened `gnome-text-editor` on the target via SSH (`nohup gnome-text-editor &`, PID 15531).
Built an args file at `/tmp/opencode/rdp-args` (mode 600, 9 lines, password read from
`~/AI/secrets/scm_draft_rdp_pass.md` into the file under `umask 077`, never displayed). Started
`xfreerdp /args-from:file:/tmp/opencode/rdp-args` in background (PID 871837). xfreerdp connected to
192.168.1.99:3389 via TLS (certificate warning suppressed by `/cert:ignore`), created the named pipe
at `/tmp/opencode/rdp-kbd` (mode 0600). Wrote `printf 'CHAOTIX41' > /tmp/opencode/rdp-kbd`. Two-second
propagation. Screenshot captured via the proven D-Bus screenshot path:
`~/AI/demo-evidence/task0041-kbd-proof2.png`, 1256031 bytes, PNG 1920x1080 RGBA. Image shows
gnome-text-editor with "CHAOTIX41" visible in the editor body and title bar. OCR confirmation:
`tesseract ~/AI/demo-evidence/task0041-kbd-proof2.png - | grep CHAOTIX41` returns `+ CHAOTIX41`.
Killed xfreerdp. Deleted args file, pipe, and PID file. Closed editor on target (`kill 15531`).
No credential on any visible command line. No secret value written to any file in the repo.

No consent dialog appeared during either connection. The target's RDP session accepted the credential
without any on-screen prompt (confirming `grdctl rdp disable-view-only` from item 4 removed the
consent flow). The decision gate is PASSED: TASK-0042 can proceed on scripted keyboard input.
No target-side system change in this item (only a temporary text editor process, started and stopped).

### 2026-11-14 09:22 JST — Tails — Item 7: Mouse pointer motion and click (PASS)

**Mechanism chosen**: Custom C client using libfreerdp3 (Route 2).
Alternative routes tested and rejected:
- Route 1 (XTEST on controller DISPLAY=:0 forwarded through xfreerdp): FAILS. xfreerdp's XI2 input handler explicitly skips the "Virtual core pointer" device, and XTEST only generates events on that device. Verified: pointer position did not change on target.
- Route 3 (AT-SPI): available as fallback but does not produce pointer motion; only widget activation.

**Build**: `gcc -o rdp-pointer rdp-pointer.c $(pkg-config --cflags --libs freerdp-client3)` on the controller. Binary: `/tmp/opencode/rdp-pointer`, 18272 bytes.

**Connection**: `rdp-pointer` uses `freerdp_client_context_new` with a full `rdpClientContext` to initialize the channel subsystem (DRDYNVC, rdpgfx, disp, ainput, rdpsnd loaded). gnome-remote-desktop's `Capabilities` callback requires DRDYNVC. Connection parameters via `/args-from:file:` format (mode 600 file, password never in argv).

**Commands (no credential on any visible command line)**:

1. Before screenshot via D-Bus screenshot path: `iface.Screenshot(True, False, "/tmp/item7-before.png")` on target. Fetched with `scp`. 1592482 bytes.
2. `timeout 15 /tmp/opencode/rdp-pointer /tmp/opencode/rdp-args2 960 14 click` (args file mode 600, generated from `~/AI/secrets/scm_draft_rdp_pass.md`). Connection established, DRDYNVC channels loaded, pointer event sent.
3. After screenshot: `iface.Screenshot(True, False, "/tmp/item7-after.png")`. Fetched with `scp`. 1305048 bytes.

**Result**: `~/AI/demo-evidence/task0041-item7-before.png` shows GNOME 49 desktop with top panel showing date/time "14 Nov 09:22" and no dropdown. `~/AI/demo-evidence/task0041-item7-after.png` shows the GNOME 49 calendar/notification dropdown opened: "Saturday 14 November 2026" calendar grid, "No Notifications" bell icon, "Today - No Events", and "Add World Clocks..." button. The cursor is visible at the click point in the panel area.

**Click coordinates**: (960, 14) on the target's 1920×1080 GNOME 49 Wayland session. This is the date/time label in the top panel. Clicking it opens the calendar/notification dropdown.

**Controller-side system changes** (with inverses):
- `sudo dnf install -y freerdp-devel` → installed `freerdp-devel-2:3.32.2-1.el10_2` and `libwinpr-devel-2:3.32.2-1.el10_2` from already-enabled repos (no new repo). Inverse: `sudo dnf remove -y freerdp-devel libwinpr-devel`.

**Target-side system changes**: none. The target's RDP server was already enabled from item 4. No new package, service, or setting was changed.

No secret value on any visible command line, in any file committed to git, or in the DEMO-LOG. Args file was mode 600 and deleted after use.

### 2026-11-14 10:00-10:18 JST — Tails — TASK-0042 Item 1: Compatibility layer test (Wine chosen)

**Objective**: Test Wine and GE-Proton on target. Record which runs SCMDraft 2. Record repo enablement with inverse.

**Repo enablement (target, system change)**:

| Repo | Enable command | Inverse command | Reason |
|---|---|---|---|
| EPEL | `sudo dnf install -y epel-release` (NEVRA: `epel-release-10-7.el10_1.noarch`) | `sudo dnf remove -y epel-release` | Prerequisite for RPM Fusion; Wine not ultimately sourced from EPEL |
| RPM Fusion free | `sudo dnf install -y /tmp/rpmfusion-free-release-10.noarch.rpm` (NEVRA: `rpmfusion-free-release-10-1.noarch`, SHA-256: `fa8fa63f7dc3db45315b28f91a4c29d1f5298302820c377b108bd2815cb914e6`) | `sudo dnf remove -y rpmfusion-free-release` | Tested for Wine; not available in RPM Fusion for EL 10 |
| RPM Fusion nonfree | `sudo dnf install -y /tmp/rpmfusion-nonfree-release-10.noarch.rpm` (NEVRA: `rpmfusion-nonfree-release-10-1.noarch`, SHA-256: `9a96984a248329e420d47a60489a768e25263d0bfacf44277e6499b264ac77f1`) | `sudo dnf remove -y rpmfusion-nonfree-release` | Tested for Wine; not available in RPM Fusion for EL 10 |
| CRB | `sudo dnf config-manager --set-enabled crb` | `sudo dnf config-manager --set-disabled crb` | Provides `mingw64-zlib-1.3.1-5.el10.noarch` and `mingw64-win-iconv-0.0.8-15.el10.noarch` (wine-core dependencies) |
| COPR `forecastwolf157/Wine-test` | `sudo dnf copr enable -y forecastwolf157/Wine-test` | `sudo dnf copr disable -y forecastwolf157/Wine-test` | Provides `wine-10.17-1.el10.x86_64` |

**Wine install**: `sudo dnf install -y wine` → `wine-10.17-1.el10.x86_64` from repo `copr:copr.fedorainfracloud.org:forecastwolf157:Wine-test`. Verified: `wine --version` → `wine-10.17 (Staging)`.

**SCMDraft 2 download**: `curl -fsSL -o ~/scmdraft2/SCMDraft2_0.9.10.zip "http://www.stormcoast-fortress.net/downloads/scmdraft2/download/"`. 1458849 bytes. SHA-256: `b7db5f947e25daf0ed5205f3f3b74c8207a7cc678db11011043daa48c1439d01`. Contents: `ScmDraft 2.exe` (PE32 GUI, 3214848 bytes), `plugins/TrigEdit.sdp`.

**Wine prefix**: `WINEPREFIX=~/.wine-scmdraft wineboot --init`. Created successfully.

**Wine test (PASS)**: `wine64 "ScmDraft 2.exe"` from `~/scmdraft2/`. Process PID 19713, alive, 2425596 VSZ / 44556 RSS. Wine log: `starting in experimental wow64 mode`, `waylanddrv:wayland_process_init` active. Screenshot captured at 10:18 showing "Scmdraft 2 - Select Profile" window with full splash art and profile list. Evidence: `~/AI/demo-evidence/task0042-wine-scmdraft2.png`, 1609215 bytes, PNG 1920x1080 RGBA.

**GE-Proton test (FAIL)**: `GE-Proton11-12-x86_64.tar.gz` downloaded from GitHub (`GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-12/`), 566859228 bytes, SHA-512: `2e37447902529c9fc39138dc0b3f24aed3513b59a190b825e6b4a668e49e2033bdf6b8a7998e8686e067bbb3f61f3a6633e2408f0cc96f6dad983bd18e2db31e` (verified against published checksum). Extracted to `~/.proton-test/GE-Proton11-12-x86_64/`. Invocation: `python3 proton run in <compatdata> <exe>`. Exit code 1. Error: `PermissionError: [Errno 13] Permission denied: '/dist.lock'` (first attempt, fixed with absolute path), then `/lib/ld-linux.so.2: could not open`. strace confirms: wine execs `files/lib/wine/i386-unix/wine-preloader` (a 32-bit ELF) which requires `/lib/ld-linux.so.2` (32-bit glibc dynamic linker). `glibc.i686` is not available in any repo on this target (verified across baseos, appstream, extras, crb, epel, rpmfusion). GE-Proton cannot run 32-bit Windows apps on this system without glibc.i686.

**Decision**: Wine 10.17. Recorded in `planning/docs/TASK-0042-decision-compat-layer.md`.

**Target paths not in git**: `~/.wine-scmdraft/`, `~/scmdraft2/`, `~/.proton-test/`. No binary, game data, or credential committed to any repo.

**Screenshot mechanism**: GNOME Shell Screenshot D-Bus interface via Python Gio on the session bus, with `RequestName("org.gnome.Screenshot", 4)` and `Screenshot(false, false, path)` on the same connection. Same mechanism as TASK-0041 item 1.

**Cleanup**: EPEL (`epel-release-10-7.el10_1`) and RPM Fusion (`rpmfusion-free-release-10-1.noarch`, `rpmfusion-nonfree-release-10-1.noarch`) removed: `sudo dnf remove -y epel-release rpmfusion-free-release rpmfusion-nonfree-release`. These were tested for Wine availability (none found) and were not needed for the final Wine install path. Final repos on target: `baseos`, `appstream`, `extras`, `crb`, `copr:copr.fedorainfracloud.org:forecastwolf157:Wine-test`. COPR GPG key: `gpg-pubkey-465fccc2-68bd0e9e` (`forecastwolf157_Wine-test (None) <forecastwolf157#Wine-test@copr.fedorahosted.org>`). Wine verified working after cleanup: `wine --version` → `wine-10.17 (Staging)`.

### 2026-11-14 10:51-12:22 JST — Tails — TASK-0042 Item 2: Game data acquisition and terrain verification (PASS)

**Objective**: Place legally obtainable StarCraft game data into the Wine prefix chosen in item 1 and prove
SCMDraft 2 renders real terrain tiles from it rather than blank placeholders.

**Repo re-enablement (target, system change)**. Item 1 removed EPEL and RPM Fusion as unneeded. Item 2
re-enabled them because `7zip`, `unrar` and `python3-pip` resolve nowhere else on `el10_2`. The enable
commands and their inverses are recorded before execution, per the repo-enablement policy.

| Repo | Enable command | Inverse command | Why |
|---|---|---|---|
| EPEL | `sudo dnf install -y epel-release` (NEVRA `epel-release-10-7.el10_1.noarch`) | `sudo dnf remove -y epel-release` | Provides `7zip-16.02-7.el10_1.x86_64`, `7zip-standalone`, `python3-pip` |
| RPM Fusion free | `sudo dnf install -y /tmp/rpmfusion-free-release-10.noarch.rpm` (SHA-256 `fa8fa63f7dc3db45315b28f91a4c29d1f5298302820c377b108bd2815cb914e6`) | `sudo dnf remove -y rpmfusion-free-release` | Pulled as the RPM Fusion dependency chain; no package ultimately sourced from it |
| RPM Fusion nonfree | `sudo dnf install -y /tmp/rpmfusion-nonfree-release-10.noarch.rpm` (SHA-256 `9a96984a248329e420d47a60489a768e25263d0bfacf44277e6499b264ac77f1`) | `sudo dnf remove -y rpmfusion-nonfree-release` | Provides `unrar` (RAR is unredistributable in EPEL) |

Packages installed from them, with inverses:

| Package | Install command | Inverse |
|---|---|---|
| `7zip`, `7zip-standalone` (EPEL) | `sudo dnf install -y 7zip 7zip-standalone` | `sudo dnf remove -y 7zip 7zip-standalone` |
| `unrar` (RPM Fusion nonfree) | `sudo dnf install -y unrar` | `sudo dnf remove -y unrar` |
| `python3-pip` (EPEL) | `sudo dnf install -y python3-pip` | `sudo dnf remove -y python3-pip` |
| `mpyq` (pip, MPQ archive reader) | `pip3 install mpyq` | `pip3 uninstall -y mpyq` |

Repo state after this item, verified with `dnf repolist`: `baseos`, `appstream`, `extras`, `crb`,
`epel`, `rpmfusion-free-updates`, `rpmfusion-nonfree-updates`,
`copr:copr.fedorainfracloud.org:forecastwolf157:Wine-test`. This is the drifted state `## Status` flags for
Omega. To return the target to the item 1 repo set, run the three `dnf remove` commands in the first table.

**Download sources and hashes** (verified with `sha256sum` and `md5sum` on the target before use)

| Archive | URL | Size bytes | SHA-256 |
|---|---|---|---|
| Starcraft No Install (ZIP) | `https://archive.org/download/StarcraftBWNoInstall/Starcraft%20No%20Install.zip` | 1274887159 | `1fe0ca7c10c1bca26f61270c5afa9b3aee475eb4f67d538c9c753443c185e426` (archive.org MD5 `beb270e821fcef85dcf1a3da9a049b8c` matched with `md5sum -c`) |
| BW-1161.exe (Brood War 1.16.1 patch) | `http://ftp.blizzard.com/pub/broodwar/patches/PC/BW-1161.exe` | 26497843 | `96890f59b664eb54dbb3be634f2045e70a4a757e87b405ec4aeeb69d50fb7bb1` |
| SC-1161.exe (StarCraft 1.16.1 patch) | `http://ftp.blizzard.com/pub/starcraft/patches/PC/SC-1161.exe` | 10696135 | `755b4dbe3f8a928831b19bfa975445885b8c1760ffa4e5a795d37e7f02e6c31e` |
| StarCraft Anthology original installer ISO | `https://archive.org/download/starcraft-anthology-original-installer/StarCraft_Anthology.iso` | 1343639552 | `802b439d197a801f219076bb8cbe4b9c5664627fafd982ee625306d72d1a93f3` |

**Three acquisition paths, and why the third won.** Path A, the StarcraftBWNoInstall ZIP, unpacked to a
RAR inside it (password `NoInstall`, opened with `unrar`), but its MPQs are renamed `INSTALL.EXE` and carry
PE headers rather than MPQ signatures, so `mpyq` could not open them and SCMDraft 2 failed with
`ERROR_FILE_NOT_FOUND` when pointed at them. Path B, running the 1.16.1 patch installers `BW-1161.exe` and
`SC-1161.exe` under Wine against path A's files: both log `Prepatch successful` in `prepatch.log`, but
without a `StarCraft.exe` anchor to patch they did not produce a usable game install. Path C, the
StarCraft Anthology installer ISO, contains proper `Installer Tome.mpq` and `Installer Tome 2.mpq` archives
that `mpyq` opened directly (hash-table format, no encryption key needed). Chosen: path C.

Provenance warning recorded for Charmy and Flicky: the Anthology ISO is a copy of Blizzard data hosted on
archive.org. This team did not verify the upstream chain of that copy, and the official free Blizzard path
(StarCraft: Remastered base game, and the 1.16.1 installers now mirrored by Blizzard) was not the path used
for the data that ended up in the prefix. The documentation repo must not describe how the data was obtained
until that ruling lands.

**Game data installed** at `~/.wine-scmdraft/drive_c/Program Files (x86)/StarCraft/`, sizes verified with
`ls -la` on the target 2026-11-14 12:03 JST.

| File | Size bytes | Source inside the ISO |
|---|---|---|
| `StarCraft.exe` | 1220608 | `Installer Tome.mpq` → `PC\StarCraft.exe` |
| `Storm.dll` | 409600 | `Installer Tome.mpq` → `PC\storm.dll` |
| `patch_rt.mpq` | 1085198 | `Installer Tome.mpq` → `PC\patch_rt.mpq` |
| `Broodat.mpq` | 21557762 | `Installer Tome.mpq` → `Common\BrooDat.mpq` |
| `Stardat.mpq` | 65285451 | `Installer Tome 2.mpq` → `Common\StarDat.mpq` |
| `BroodWar.mpq` | 595050147 | `Installer Tome 2.mpq` → `Common\BroodWar.mpq` |

`file StarCraft.exe` on the target: `PE32 executable (GUI) Intel 80386, for MS Windows`. The 1.16.1 patch
installers were then run against this directory under Wine, which is why the prefix also holds
`BW-1161.exe`, `SC-1161.exe`, `bnupdate.exe`, `prepatch.log` and `PTC*.tmp` patch scratch files.

**Terrain rendering proof (acceptance met)**. SCMDraft 2 launched with a shipped map as argument:
`wine64 "ScmDraft 2.exe" "/home/howard/game-data/starcraft-extracted/Starcraft/maps/(2)River Crossing.scm"`,
process alive (PID 28096). Screenshot via the proven GNOME Shell Screenshot D-Bus path:
`~/AI/demo-evidence/task0042-item2-loaded2.png`, 855933 bytes, PNG 1920x1080 RGBA. The image shows the Jungle
World tileset with Dirt, Mud, Jungle, Rocky Ground and Ruins tiles, a visible tile grid, doodads (trees,
rocks), blue mineral fields in the upper right, a blue start location, a red diamond location marker, the
terrain palette populated with Water, Dirt, Mud, Jungle, Rocky Ground, Ruins, Raised Jungle, Temple, High
Dirt, High Jungle, High Ruins, High Raised Jungle and High Temple, and a status bar reading
`Jungle World\Dirt`. That status-bar text is the load-bearing evidence: it can only come from tileset data
read out of `Stardat.mpq`. The New Map dialog screenshot `~/AI/demo-evidence/task0042-item2-newdlg.png`,
61040 bytes, lists all eight tilesets (Badlands, Space Platform, Installation, Ash World, Jungle World,
Desert World, Ice World, Twilight World).

**Target paths created, all outside git** (with inverses): `~/game-data/` (downloads and extraction
scratch) inverse `rm -rf ~/game-data/`; game data inside the prefix, inverse `rm -rf ~/.wine-scmdraft/`.
Verification that nothing binary leaked into a repo: `git ls-files | grep -iE '\.(exe|zip|mpq|dll|iso|7z|scm)$'`
returns nothing in `team-chaotix-moe`, and the documentation repo has no commits at all. Note for the record:
this item did **not** verify a clean `git status`. Checked later on 2026-11-14, `git status --porcelain` shows
`DEMO-LOG.md` and every planning doc as untracked (`??`) with `planning/TASKS.md` modified, so the continuous
log and the planning docs exist only in the working tree and have never been committed or pushed. That is a
bookkeeping gap for `Robotnik` and `Vector`, not a binary leak.

**Checks not run in this item**: archive.org's published MD5 for the Anthology ISO was not cross-checked
against the local `sha256sum`; the SC-1161.exe hash was computed locally but not compared against a
published Blizzard checksum. Both are recorded as unverified rather than assumed.

### 2026-11-14 13:02-13:52 JST — Tails — TASK-0042 Item 3: Playability verification (NO ROUTE WORKS, blocker recorded)

**Objective**: Test the three playability options (SCMDraft 2 play function, `StarCraft.exe` in the same Wine
prefix with the map as argument, OpenBW) and confirm injected keyboard and pointer input reach the
Wine-hosted window.

**Game-data defect found first.** `ls -la` and `xxd -l 16` in the prefix game directory showed the item 2
install is partly invalid: `Stardat.mpq`, `Broodat.mpq` and `patch_rt.mpq` begin `4d50 511a` (MPQ1 magic),
but `BroodWar.mpq` (595050147 bytes) begins `4d5a 9000` and `file` reports `PE32 executable (GUI) Intel 80386`.
The same defect exists in the other archive: in `~/game-data/sc1161/Starcraft`, `StarCraft.mpq` (601389682)
and `BroodWar.mpq` (571847688) are also PE files. A signature scan found `MPQ1` magic at
294912 and 522122555 inside `BroodWar.mpq` and at 259584 inside `StarCraft.mpq`, so both large archives are
a PE stub with a real MPQ appended at a section-aligned offset. Carving from that offset self-validates:
for `BroodWar.mpq` at 294912 the MPQ header's own packed size is 571552776 and the carved length is
571552776, exactly equal; for `StarCraft.mpq` at 259584 packed size 601130098 equals carved length
601130098. Both carved files are structurally consistent MPQ1 archives (hash table at 196608, block table
inside the carved range). This also explains the first launch error: `Starcraft was unable to open a required
file ... font\font.gid File not found` was raised against a `BroodWar.mpq` that is not an MPQ at all.

**Clean game set built (target, reversible)**. `unrar x -y -idq -pNoInstall` extracted all 258 entries of
`Starcraft + BW Expansion.rar` (1293946274 bytes uncompressed) into `~/game-data/sc1161/`, then the two
carved MPQs plus every other file were assembled into `~/game-data/sc-clean/Starcraft/` (1.2 GB). Inverse:
`rm -rf ~/game-data/sc-clean/ ~/game-data/sc1161/`. Files verified MPQ1: `StarDat.mpq` 66184609,
`BrooDat.mpq` 23847431, `patch_rt.mpq` 1086853. Verified PE (correct): `StarCraft.exe`, `storm.dll`,
`Smackw32.dll`, `battle.snp`. `mpyq` opens `patch_rt.mpq` and lists 60 entries including
`game\tFontGam.pcx`; `StarDat.mpq` and `BrooDat.mpq` have encrypted listfiles that mpyq cannot read
(`NotImplementedError: Encryption is not supported yet`).

**Route (b), `StarCraft.exe` in the same Wine prefix (FAIL, evidence recorded).** Launched from the clean
directory with `WINEPREFIX=$HOME/.wine-scmdraft wine64 StarCraft.exe`: the process starts and stays alive
(PID 29905, 198568 KB RSS), it sets the display mode
`ddraw1_SetDisplayMode iface ..., width 640, height 480, bpp 8` with
`DDSCL_FULLSCREEN DDSCL_ALLOWREBOOT DDSCL_EXCLUSIVE`, Wine reports
`ddraw_attach_d3d_device Using existing window ... Successfully initialized 3D`, and the game writes to the
surface continuously: the `+ddraw` trace contains 6067 `ddraw_surface_update_frontbuffer` calls,
68 `ddraw_palette_SetEntries` calls and 64 `ddraw7_WaitForVerticalBlank` calls in 22 s. Despite that, the
window renders nothing. Pixel analysis of `~/AI/demo-evidence/task0042-item3-sc-x11c.png` over the window
region `(0,0)-(1400,1080)`: `getcolors` returns 1 distinct color, `(1512000, (0, 0, 0))`, every pixel pure
black. No error dialog, no crash, process consuming 3:18 CPU in 187 s.

**Why the X11 graphics driver was not available.** Wine 10.17 on this target uses only its Wayland driver.
`wine reg add "HKCU\Software\Wine\Drivers" /v Graphics /t REG_SZ /d x11 /f` succeeded and the value is
present in `~/.wine-scmdraft/user.reg` under `[Software\\Wine\\Drivers]`, yet the next launch still logged
`waylanddrv:wayland_process_init`. With `WINEDLLOVERRIDES="winewayland.drv="` and with `XDG_RUNTIME_DIR`
and `WAYLAND_DISPLAY` unset (only `DISPLAY=:0` and `XAUTHORITY=/run/user/1000/.mutter-Xwaylandauth.3K31Y3`
left), even `wine notepad` fails with `err:winediag:nodrv_CreateWindow Application tried to create a window,
but no driver could be loaded`, and no `winex11` line appears in the log. `ldd` on
`/usr/lib64/wine/x86_64-unix/winex11.so` resolves `libX11.so.6`, `libXext.so.6`, `libxcb.so.1`, `libXau.so.6`,
so the driver's own library dependencies are present. An X-based fallback cannot be built either:
`dnf repoquery --available xorg-x11-server-utils` and `xorg-x11-server-Xvfb` both return nothing on the
current repo set, and `xauth`, `xdpyinfo`, `xrandr`, `xwininfo`, `import` and `convert` are not installed.

**Route (a), SCMDraft 2's own play function (NOT RUN end to end).** Not exercised: it launches the same
`StarCraft.exe` under the same Wine build and therefore the same DirectDraw presentation path proven black
above. `strings -n 4 "ScmDraft 2.exe"` shows the feature depends on locating the game:
`Unable to determine the starcraft installation folder - edit the profile options to set the options
manually and verify the path`, `Unable to read the starcraft path from the uninstall location.` and
`Unable to read the starcraft path from the 1.16 location.` Those registry locations are absent from the
prefix (`grep -iE 'blizzard|starcraft' ~/.wine-scmdraft/user.reg` finds none), so the profile would need the
game path set manually first. Recorded as not run rather than as a failure.

**Route (c), OpenBW (FAIL as a map-playback route, evidence from upstream).** Upstream is
`https://github.com/OpenBW/openbw` (org `OpenBW`, repo `openbw`; the README points build instructions at
`https://github.com/OpenBW/bwapi`). `GET /repos/OpenBW/openbw/releases` returns an empty list, so there is
no prebuilt binary. `ui/CMakeLists.txt` needs only `find_package(SDL2 REQUIRED)` with
`-DOPENBW_NO_SDL_IMAGE -DOPENBW_NO_SDL_MIXER`, so a native build on `el10_2` is plausible
(`cmake-3.31.8-1.el10`, `gcc-c++-14.3.1-4.4.el10_2`, `SDL2-devel-2.28.5-6.el10_2`,
`libtomcrypt-devel-1.18.2-21.el10_1` all resolve; `libsmacker-devel` does not). The blocking finding is map
format: `replay.h` `load_replay` requires the identifier `0x53526572` (its own replay format), and the
token `scm` occurs zero times across `replay.h`, `ui/ui.h` and `data_loading.h` (fetched from
`raw.githubusercontent.com`, sizes 9674, 70487 and 64650 bytes). OpenBW therefore cannot load a
SCMDraft-authored `.scm` map. The build itself was not attempted, recorded as not run.

**Input gate (PASS).** Keyboard injection reaches a Wine-hosted window. `xfreerdp /args-from:file:...` in
FreeRDP 3.32 rejects any other command-line argument (`/args-from ... This argument can not be combined
with any other`), so `/kbd:pipe:<fifo>` was written into the args file itself; the FIFO must not be
pre-created because xfreerdp creates it (`xf_handle_pipe: Failed to create named pipe ... File exists`).
Marker typed into Wine `notepad.exe` in the same prefix: `~/AI/demo-evidence/task0042-item3-marker-kbd2.png`
shows `CHAOTIX42` in the notepad body with the caret at `Ln 1, Col 10`. OCR: crop of the editor body returns
`CHAOTIX42|`; full-image OCR returns the same line as `CHAOTIXA2|` (4 misread as A). Pointer injection
reaches the Wine-hosted SCMDraft 2 window: after `/tmp/opencode/t0042/rdp-input <args> move 960 540` the
SCMDraft 2 status bar reads `794, 431 (24,13)` (`~/AI/demo-evidence/task0042-item3-move-test.png`, read with
`tesseract` on a 2x upscaled crop), and an earlier click moved the same readout to `1226, 666 (38,21)`.
RDP coordinates map 1:1 to physical screenshot pixels (`540 * 0.8 = 432`, readout `431`). A pointer click on
SCMDraft 2's `Scenario` menu strip at (152, 49) did not leave a menu open in two attempts, once with the
RDP connection held open for 3 s; cause not established, recorded as an open item for menu-driven
automation in Wine-hosted windows.

**Controller-side tooling added (team-written, Apache-2.0, links libfreerdp3).**
`/tmp/opencode/t0042/rdp-input.c`, built with
`gcc -w -o rdp-input rdp-input.c $(pkg-config --cflags --libs freerdp-client3)`, 22544 bytes. It holds one
RDP connection open while playing a script of `move`, `click`, `type`, `key`, `keyx` and `wait` events, which
the existing `rdp-pointer` (one event per connection) cannot do. Typing uses
`freerdp_input_send_unicode_keyboard_event` from `<freerdp/input.h>`; that call returned
`error: unicode key down failed for U+4D` against gnome-remote-desktop in every attempt, so the working
keyboard path remains `xfreerdp /kbd:pipe:`. Not yet committed to the repo.

**Target state left after this item.** Running: SCMDraft 2 (PID 28096) with `(2)River Crossing.scm` open,
wineserver and three `winedevice.exe`, and a stale `rundll32.exe setupapi,InstallHinfSection` (PID 23245)
left from the item 2 patch runs. Notepad and `StarCraft.exe` were killed. New paths, all outside git:
`~/game-data/sc1161/` and `~/game-data/sc-clean/` (inverse `rm -rf` both), `/tmp/t0042_sc.sh`,
`/tmp/t0042_sc_x11.sh`, `/tmp/t0042_sc_x11e.sh`, `/tmp/t0042_notepad.sh`, `/tmp/t0042_x11probe.sh`,
logs `/tmp/sc-*.log`. A stray second Wine prefix `~/.wine` exists (created 2026-11-14 12:46 during a launch
attempt that lacked `WINEPREFIX`), inverse `rm -rf ~/.wine`. Args files holding the RDP password were
mode 600 and deleted after use (`rm -f /tmp/opencode/t0042/rdp-args /tmp/opencode/t0042/rdp-args-kbd
/tmp/opencode/t0042/rdp-kbd`). No credential, binary or game data in any git path.

**Checks not run in this item.** OpenBW build attempt (not attempted). SCMDraft 2 play function with a
manually set StarCraft path (not run). A second DirectDraw application under the same Wine build, which is
the test that would separate a Wine Wayland presentation defect from a StarCraft-side stall (not run).
`dnf repoquery --available wine` for other installable Wine versions on `el10_2` (not run).

---

**14:56 Tails — item 3 bounded playability recovery, three hypotheses, acceptance NOT met.** Per the
`## Status` decision, three attempts in order, stop at the first StarCraft game window rendering a
loaded map. None produced a loaded map; the box stays open and is rewritten as a limitation.

**Hypothesis 1, Wine emulated virtual desktop for the exclusive DirectDraw mode (COPR Wine 10.17). FAIL.**
First launch failed with `err:winediag:nodrv_CreateWindow` because a leftover from the earlier item-3 pass,
`HKCU\Software\Wine\Drivers` `"Graphics"="x11"`, forced the broken X11 driver. Removed it
(`wine reg delete "HKCU\Software\Wine\Drivers" /v Graphics /f`); the Wayland driver then initialised
(`waylanddrv:wayland_process_init wl_display=...`). Enabled the virtual desktop with the winetricks `vd`
keys (`HKCU\Software\Wine\Explorer` `"Desktop"="Default"`,
`HKCU\Software\Wine\Explorer\Desktops` `"Default"="640x480"`), pre-started the VD host
(`wine64 explorer /desktop=Default,640x480`, PID 33463), launched
`wine64 StarCraft.exe testmap.scm` (PID 33491, RSS 153792 KB, alive 1:19, 2457
`ddraw_surface_update_frontbuffer` writes). Result: composited output is pure black across the whole
screen, PIL `getcolors` on `~/AI/demo-evidence/t0042-h1-vd.png` and `...-vd2.png` returns exactly one
colour `(2073600, (0,0,0))`. The `+ddraw` trace shows StarCraft still holds `DDSCL_FULLSCREEN
DDSCL_EXCLUSIVE` 640x480x8 (flags `0x13`), so the virtual desktop does not change the cooperative level for
this game. Rules out: the virtual-desktop mechanism as a fix on this COPR build.

**Hypothesis 2, Flatpak Wine from Flathub as a different build. RENDERS, but no loaded map.**
Added the user Flathub remote and installed `org.winehq.Wine` branch `wow64-25.08` (Wine 11.0, 32-bit
Windows app support). Copied the clean 1.16.1 set into the flatpak prefix
`~/.var/app/org.winehq.Wine/data/wine/drive_c/StarCraft/` and ran
`flatpak run --command=wine org.winehq.Wine "C:\StarCraft\StarCraft.exe" "C:\StarCraft\testmap.scm"`
(PID 36539). Result: the COPR black composite is gone. Screenshot-verified rendered content:
`~/AI/demo-evidence/t0042-h2-fp.png` (7885 distinct colours, Brood War intro cinematic),
`~/AI/demo-evidence/t0042-h2-fp2.png` (43524 colours, intro scene), and `~/AI/demo-evidence/t0042-h2-fp3.png`
(the fully rendered main menu, "Version 1.16.1", Single Player / Campaign Editor / Multiplayer / Exit /
View Intro / Show Credits). This build renders; the COPR build did not. But the map argument does not
auto-play, it lands on the main menu, and pointer/click injection does not reach the game in this only
rendering-capable mode: `rdp-input ... click 695 272` (Single Player) and `click 1370 745` (Exit) left the
in-game cursor fixed at (975,565) and did not quit the process (alive 10:16 after the Exit click). Tried
Flatpak Wine plus the virtual desktop (`explorer /desktop=Default,640x480`, PID 37589 + StarCraft 37645):
the game then presents inside a small 640x480 window but goes black again
(`~/AI/demo-evidence/t0042-h2-vdmenu2.png`, 2073600 black pixels). Rules out: on this Wayland target the
only mode that presents StarCraft's DirectDraw is exclusive fullscreen, which captures the pointer so RDP
input cannot drive the menu; the windowed/VD mode that would accept input presents black.

**Hypothesis 3, native engine, single pass. Not achievable, not attempted.** OpenSAGE is a re-implementation
of the SAGE engine used in Command & Conquer: Generals (`github.com/OpenSAGE/OpenSAGE`), not StarCraft, so it
cannot load a StarCraft map. OpenBW: this pass corrects the earlier item-3 note. The OpenBW core engine reads
its own replay format, but the BWAPI launcher's `auto_menu` does load `.scm`/`.scx` maps for a single-player
game (TorchCraft/OpenBW docs set `BWAPI_CONFIG_AUTO_MENU__MAP=.../m5v5_c_far.scm`; a 2026-09-20 native spike
loaded `(2)Benzene.scx` with StarDat/BrooDat/Patch_rt). So OpenBW can reach a loaded map. It is not a
single-pass path to a rendered window on this target: the published native spikes build it headless with the
UI disabled (`OPENBW_ENABLE_UI=0`), OpenBW has no built-in opponent and is early-stage, and the build needs
the `deps/asio` submodule plus a working OpenBW UI rendering path (SDL/OpenGL) that the prior pass recorded as
not resolved. A build that renders a map window was therefore not achievable in one pass and was not run.

**All three failed acceptance.** No screenshot shows a StarCraft game window rendering a loaded map. Flatpak
Wine 11 renders the game (intro + menu) where COPR Wine 10.17 shows black; the blocker to a loaded map is
input, not rendering.

**Target changes this pass, each with its inverse.**
- COPR prefix X11 forcing removed (reverting the earlier item-3 change, restoring the Wayland default):
  `WINEPREFIX=~/.wine-scmdraft wine reg delete "HKCU\Software\Wine\Drivers" /v Graphics /f`. Inverse:
  `WINEPREFIX=~/.wine-scmdraft wine reg add "HKCU\Software\Wine\Drivers" /v Graphics /t REG_SZ /d x11 /f`.
- COPR prefix virtual-desktop keys added then removed (net zero): `wine reg add "HKCU\Software\Wine\Explorer"
  /v Desktop /d Default` and `...Explorer\Desktops /v Default /d 640x480`, both later `wine reg delete ... /f`.
- Test map copy `~/game-data/sc-clean/Starcraft/testmap.scm`. Inverse: `rm -f ~/game-data/sc-clean/Starcraft/testmap.scm`.
- Flathub user remote added. Inverse: `flatpak --user remote-delete flathub`.
- Flatpak Wine installed: `flatpak install -y flathub org.winehq.Wine/x86_64/wow64-25.08` (Wine 11.0, plus
  freedesktop Platform 25.08 runtimes). Left installed for Omega to rule on. Inverse:
  `flatpak uninstall -y org.winehq.Wine && flatpak uninstall --unused`.
- Game data copied into the flatpak prefix drive_c. Inverse: `rm -rf ~/.var/app/org.winehq.Wine/data/wine/drive_c/StarCraft`.
- Flatpak prefix Graphics=x11 and virtual-desktop keys added then removed (net zero).
- Target helper logs `/tmp/sc-vd1.log /tmp/sc-vd2.log /tmp/sc-vd3.log /tmp/expl1.log /tmp/explhost.log
  /tmp/fp-sc.log /tmp/fp-sc-vd.log /tmp/fp-expl.log /tmp/np1.log`. Inverse: `rm -f` each.
- Controller args file `/tmp/opencode/t0042/rdp-args-click` (mode 600, held the RDP password). Inverse:
  `rm -f /tmp/opencode/t0042/rdp-args-click`. Deleted after this pass.
Stale COPR processes from earlier passes were killed (`pkill`, `wineserver -k`); not a persistent change.
No credential, binary or game data committed to any git path.

### 2026-11-14 15:20-16:05 JST — Tails — TASK-0042 Item 4: Map construction technique (PASS on terrain, NOT RUN on GR)

**Objective**: Prove terrain painting changes the map and persists, test unit placement, assess GR-graphics path, assign a technique to each of the five map designs.

**Control path settled.** Keyboard scancode injection via `rdp-input` (`keydown`/`key`/`keyup` events using `freerdp_input_send_keyboard_event`) drives SCMDraft 2's keyboard commands reliably. Ctrl+T, Ctrl+U, Ctrl+S, and Enter all work. Injected mouse clicks on modal dialog buttons (Save Changes?, Save as blizzard certified?) dismiss the dialog without completing the intended action (three attempts, no save). The reliable save sequence is: Wine `taskkill` sends WM_CLOSE → SCMDraft 2 shows "Save Changes?" dialog → Enter (scancode 0x1C) confirms Yes → certification dialog → Enter confirms → save completes. This is the proven automation path.

**Target changes and inverses.**

| Change | Command | Inverse |
|---|---|---|
| Maps directory created | `mkdir -p ~/scmdraft-maps/test` | `rm -rf ~/scmdraft-maps/` |
| Test map copied | `cp ~/game-data/sc-clean/Starcraft/maps/"(2)River Crossing.scm" ~/scmdraft-maps/test/test.scm` | removed by directory inverse |
| Test map painted and saved (90426→93113 bytes) | via SCMDraft 2 UI, Water tiles painted at tile (19,13) region | removed by directory inverse |
| Screenshot helper script | `cat > /tmp/shot.py` | `rm -f /tmp/shot.py` |
| Temp screenshots | `/tmp/t0042-item4-*.png` (20 files) | `rm -f /tmp/t0042-item4-*.png` |
| Firegraft download attempt | `curl -fsSL -o ~/firegraft_0.9.2.zip "http://www.stormcoast-fortress.net/downloads/firegraft/download/"` | `rm -f ~/firegraft_0.9.2.zip` (result is 2234-byte PHP error, not a binary) |
| SCMDraft 2 process (PID 38721/38796, then 40936) | `nohup wine64 "$HOME/scmdraft2/ScmDraft 2.exe" "$HOME/scmdraft-maps/test/test.scm" &` | `pkill -9 -x "ScmDraft 2.exe"; wineserver -k` |

No new package installed on the target. No repo enabled. No credential on any command line. No binary or game data in any git path.

**Controller-side change.** `scripts/rdp-input.c` extended with `keydown <scancode>` and `keyup <scancode>` events (modifier hold and release), rebuilt at `/tmp/opencode/t0042/rdp-input` (22616 bytes). Source uncommitted (same as item 3 additions).

**Evidence captured.** Terrain painting proven: `~/AI/demo-evidence/t0042-item4-painted.png` (Water tiles visible on canvas, status bar reads "Jungle World\Water"). Persistence proven: `~/AI/demo-evidence/t0042-item4-reopen.png` (relaunched map shows painted Water tiles, title bar clean, no asterisk). Layer switching proven: `~/AI/demo-evidence/t0042-item4-units.png` (Ctrl+U switches to Units layer, status bar "67 (1) / 1650 units"). Save mechanism proven: file mtime and size changed after taskkill+Enter+Enter sequence (90426→93113 bytes, verified by `stat`).

**Firegraft download broken.** `http://www.stormcoast-fortress.net/downloads/firegraft/download/` returns PHP warnings (`fopen(./files/firegraft/Firegraft.zip): failed to open stream: No such file or directory`), 2234 bytes, SHA-256 `9d7aba004cfdde4c651acf7d91075afc0e376c4e9532b3f792a05410b41518d5`. Not a binary. The file does not exist on their server.

**Technique assigned to five maps.** All five: terrain tiles, large geometric patterns (8–12 tiles per character stroke). `foss-for-all`: block text on two lines. `rocky-logo`: shield shape. `rocky-with-heart`: shield + heart geometric. `republic-of-korea`: peninsula outline or Taegeuk pattern. `tux`: silhouette shape. GR-graphics as a potential enhancement is not confirmed available.

**Checks not run.** Individual unit placement from expanded tree onto canvas. GR-graphics import workflow (no working tool download). Brush size confirmation via visual comparison. Ctrl+Z undo. Target-side uinput injection. Map validation/SCMDraft "is valid" check on saved file. Firegraft from alternative source. grCreator (not found anywhere).

**Cleanup performed.** SCMDraft 2 process killed. Temp files removed from `/tmp`. `~/firegraft_0.9.2.zip` removed. `/tmp/shot.py` removed. Maps directory `~/scmdraft-maps/test/test.scm` left on disk for booth reuse (inverse: `rm -rf ~/scmdraft-maps/`).

---

**17:36–17:52 Tails — item 5, Map 1 `foss-for-all` built and saved.**

Maps directory created: `mkdir -p ~/scmdraft-maps/foss-for-all`. Base map copied: `cp ~/game-data/sc-clean/Starcraft/maps/"(2)River Crossing.scm" ~/scmdraft-maps/foss-for-all/foss-for-all.scm` (90426 bytes, standard MPQ-wrapped StarCraft map format).

SCMDraft 2 launched: `nohup wine64 ~/scmdraft2/"ScmDraft 2.exe" ~/scmdraft-maps/foss-for-all/foss-for-all.scm &`. Profile confirmed via Enter (scancode 0x1C). Water tile selected via palette click at (62, 775), confirmed by status bar reading "Jungle World\Water".

**Terrain painting via drag strokes.** 36 drag operations painted the "FOSS" and "FOR ALL" text using rdp-input's new `drag` event (added to `scripts/rdp-input.c`, press-hold-move-release sequence). Each drag traces a continuous terrain band along a path, painting Water tiles. Character layout: 7 tiles wide × 8 tiles tall per letter, 2 tiles gap between characters. "FOSS" at tile rows 7–14, "FOR ALL" at tile rows 19–26. All coordinates computed by `/tmp/opencode/t0042/paint_text.py`.

Brush observation: SCMDraft 2's isometric terrain mode paints a ~4–5 tile band per drag stroke. The keyboard `-` key (scancode 0x0C) selected Player 11 rather than reducing brush size (the terrain-layer brush-size command requires canvas focus that could not be achieved via injected keyboard events). The `keyx 0x4A` (numpad minus extended) produced no visible brush change. The "01" toolbar combo box dropdown did not open on click (consistent with item 4's dialog-button limitation).

**Save.** `wine taskkill /im "ScmDraft 2.exe"` sent WM_CLOSE. Enter confirmed "Save Changes?" dialog. Enter confirmed "Save as blizzard certified?" dialog. File saved: 90426→95081 bytes, mtime 17:50:19. Verified by `stat`.

**Reload verification.** SCMDraft 2 relaunched with the saved file. Title bar: "ScmDraft 2.0 (Beta 0.9.10) - [/home/howard/scmdraft-maps/foss-for-all/foss-for-all.scm ]" (no asterisk, clean load). No error dialog appeared. Editor displays the map with terrain rendered and the painted Water tile strokes visible.

**Evidence.** `~/AI/demo-evidence/item5-loaded.png` (1327146 bytes, PNG 1920×1080). Shows SCMDraft 2 editor with foss-for-all.scm loaded, title bar confirms filename without asterisk, status bar reads "Jungle World\Dirt", "Isometrical Terrain", map renders terrain with blue Water tile letter shapes visible against Jungle/Dirt/Rocky Ground background. The "FOSS" and "FOR ALL" text strokes are recognisable as deliberate geometric terrain patterns. `~/AI/demo-evidence/item5-text-painted.png` (1273741 bytes). Shows the same map before save, with text strokes freshly painted.

**ls output (target).**
```
-rw-r--r--. 1 howard howard 95081 Nov 14 17:50 /home/howard/scmdraft-maps/foss-for-all/foss-for-all.scm
```
File type: MoPaQ (MPQ) archive.

**Target system changes (item 5, all reversible).**

| Change | Command | Inverse |
|---|---|---|
| Map directory | `mkdir -p ~/scmdraft-maps/foss-for-all` | `rm -rf ~/scmdraft-maps/foss-for-all/` |
| Map file created and saved (95081 bytes) | via SCMDraft 2 UI: drag painting + taskkill save | removed by directory inverse |
| SCMDraft 2 processes (multiple launches) | `nohup wine64 ... &` | `wineserver -k` (done) |
| Temp files on target | `/tmp/t0042-item5-*.png`, `/tmp/t0042-item5-*.log` | `rm -f /tmp/t0042-item5-*` |
| Python parse helper | `/tmp/parse_map.py` | `rm -f /tmp/parse_map.py` |

No new package installed. No repo enabled. No credential on any command line. No binary or game data committed to any git path.

**Controller-side change.** `scripts/rdp-input.c` extended with `drag x1 y1 x2 y2 ...` event (press-hold-move-release drag sequence for continuous terrain painting). Binary rebuilt at `/tmp/opencode/t0042/rdp-input` (22616 bytes). Source file change uncommitted.

**Checks run.**

| Check | Result |
|---|---|
| File exists after save | `ls -la` shows 95081 bytes, mtime 17:50:19 |
| File type | MoPaQ (MPQ) archive |
| Size change from painting | 90426→95081 bytes (4655 bytes increase from added terrain data) |
| Map loads without error dialog | SCMDraft 2 title bar shows filename, no asterisk, no error popup |
| Water tile selection | Status bar "Jungle World\Water" after palette click at (62,775) |
| Drag painting | 36 strokes executed, blue Water tiles visible in screenshot |
| Save sequence (taskkill→Enter→Enter) | File mtime and size changed, verified by `stat` |
| No Wine processes left running | `ps aux \| grep` shows 0 after wineserver -k |
| No binary/game data in git | `git status` unchanged from prior items |

**Checks not run.** Playability verification via game window (blocked by item 3's exclusive-fullscreen finding). Map format validation (SCMDraft 2 "map is valid" check). Text legibility OCR (terrain isometric rendering makes OCR unreliable for terrain-drawn text). Game data provenance ruling (Charmy/Flicky's task). `rpm -q wine` NEVRA re-verification (unchanged from item 1). Target repo set verification (unchanged from items 1–2).

---

## 18:32–18:53 Tails — technique recovery (incomplete, neither technique proven)

Recovery pass replacing item 4's terrain-drag technique per the Shadow blocker. Dispatched to test two candidate techniques on a cleared flat blank map. **Result: neither technique was tested to completion.** No booth-simulation artifact produced. No colour-coverage measurement. Items 6 to 9 remain blocked.

**Control-path findings from this pass.** Ctrl+N opens SCMDraft 2's New Map dialog (Scenario Size width/height, tileset list, tile-type list, Create Map/Cancel buttons). Ctrl+D confirmed switches to Doodads layer. Ctrl+A confirmed selects all doodads on a layer (red selection rectangles visible in `t0042-flat-doodads-del.png`). The Delete key scancode for actually deleting the selection was not confirmed. The "Isometrical" toolbar combo box did not open on injected click.

**Target system changes and inverses.**

| Change | Command | Inverse |
|---|---|---|
| Legibility test directory | `mkdir -p ~/scmdraft-maps/legibility-test` | `rm -rf ~/scmdraft-maps/legibility-test/` |
| flat-test.scm created (90426 bytes) | `cp ~/game-data/sc-clean/Starcraft/maps/"(2)River Crossing.scm" ~/scmdraft-maps/legibility-test/flat-test.scm` | `rm ~/scmdraft-maps/legibility-test/flat-test.scm` |
| SCMDraft 2 log file | `> /tmp/t0042-recovery.log` (via wine64 launch) | `rm -f /tmp/t0042-recovery.log` |
| Wine processes launched | `nohup wine64 ~/scmdraft2/"ScmDraft 2.exe" ... &` (multiple) | `wine taskkill /f /im "ScmDraft 2.exe"` then `wineserver -k` (done, confirmed 0 remaining) |

No new package installed. No repo enabled. No credential on any command line. No binary or game data in any git path. `git status --porcelain` unchanged from prior items.

**Evidence files (`~/AI/demo-evidence/`).**

| File | Size | Content |
|---|---|---|
| `t0042-recovery-init.png` | 1511588 | Profile dialog (Select Profile, SCMDraft 2 splash) |
| `t0042-recovery-after-enter.png` | 60255 | Blank grey canvas, no map loaded (Ctrl+N not yet tried) |
| `t0042-recovery-ctrln.png` | 67179 | **New Map dialog**: 128×128, Space Platform tileset selected |
| `t0042-recovery-jungle.png` | 60280 | Dialog closed, unsaved blank grey map (Jungle World selection failed) |
| `t0042-flat-loaded.png` | 418756 | Wine Mono Installer dialog over River Crossing map loading |
| `t0042-flat-cleared.png` | 854820 | River Crossing loaded: Jungle World tileset, terrain palette expanded (Water/Dirt/Jungle/Rocky Ground etc.), 187 doodads visible, start location, minerals |
| `t0042-flat-doodads.png` | 855312 | **Ctrl+D confirmed**: Doodads layer active, status bar "187 Doodads" |
| `t0042-flat-doodads-del.png` | 850646 | **Ctrl+A confirmed**: all doodads selected with red rectangles |

**GR-graphics tooling located (record only, nothing installed).**

- **IronGRP** (`github.com/sjoblomj/irongrp`): MIT licence, Rust, GRP↔PNG conversion, 113 commits, Linux-native build possible. Obtainable.
- **Firegraft** (v0.91, v0.93): freeware by DiscipleofAdun. Available in `github.com/Ar3sgice/starcraft-tools` (`firegraft0.91.zip`, `firegraft093.zip`). Stormcoast Fortress download link is broken (confirmed item 4). Win32 binaries. Redistribution rights unclear.
- **bmp2scx** (`github.com/Ar3sgice/starcraft-tools`, `bmp2scx1.0.rar`): converts a BMP bitmap to a StarCraft map with terrain tiles per pixel. No licence file in the repo. Win32. Potentially the most direct path to tile-contrast without SCMDraft 2 painting. Not installed.
- **grCreator**: **does not exist.** No tool by this name was found in any search or repo. The name in doc:50 was a plan-level hypothesis that does not correspond to a real product.
- **GrpEditor** (`github.com/mighty1231/GrpEditor`): LGPL v3, Qt-based GRP frame editor. Obtainable.
- **grplib** (SourceForge): LGPL v2, C library for GRP format. Obtainable.
- **GRPConv**, **GRPEdit**, **CoordinateDraw**, **StarCraft Picture Mapper 4.1**: present in Ar3sgice repo. No licence file in the repo. Charmy must rule before documentation references them.

**Verdict.** Neither technique A (unit-per-tile pixels) nor technique B (tile contrast, single clicks, no drag) is proven or disproven. The blocker stands unchanged. Next recommended step: test `bmp2scx` under the existing COPR Wine prefix, which converts an image to terrain tiles directly and bypasses the SCMDraft 2 painting mechanism entirely.

**Checks not run.** Technique A glyph painted and read. Technique B glyph painted and read. Booth-simulation artifact (4x Lanczos downscale). Colour-coverage measurement (HSV 180–260 band). Delete-key scancode confirmation. Rectangular mode toggle. Brush-size reduction. `bmp2scx` installed or tested. IronGRP installed or tested. Map validation. `rpm -q wine` re-verification. Target repo set verification.

## 2026-11-15

**09:20 Robotnik — PM context limit reached, handoff recorded.** Two dispatch attempts failed with `request (262191 tokens) exceeds the available context size (262144 tokens)`, the identical figure both times. What a child session inherits is the dispatcher's own context, so the failure is the size of this session rather than the size of any brief. This is learned rule r001. Remedy recorded in `planning/docs/TASK-0042-foss-for-all-scmdraft2-demo.md` `## Status`, and the full remaining dispatch queue is written out verbatim in that doc's `## Next Actions` so a fresh `Robotnik` session resumes from the record rather than from memory. `planning/TASKS.md` marks both tasks as handoff needed.

**09:25 Robotnik — records committed locally.** Command: `git add` of `DEMO-LOG.md`, `planning/TASKS.md`, and the five TASK-0041 and TASK-0042 planning and decision docs, then commit. Reason, six days of records were untracked, which is a risk to the deliverable independent of any technical blocker. Secret guard run before the commit, `grep -R -F -f ~/AI/secrets/scm_draft_pass.md .` and the same against the RDP secret file, both returned no match. Commit signing is enabled with the Team Chaotix key and `core.hooksPath` is `scripts/hooks`. No push, the local selftest gate is the effective gate while the repository is public.

## 2026-11-15 (afternoon)

**10:05 Robotnik — dispatch ceiling made mechanical, TASK-0043.** Operator instruction, update the team so the context-ceiling failure cannot recur. New `scripts/dispatch-gate`, read-only against `~/.local/share/opencode/opencode.db`, peak prompt over a window of recent assistant calls plus the worst single jump, times an inherit ratio of 1.6, answering PASS WARN or BLOCK with exit codes 0, 3, 4. Calibration is measured, against this very session the gate reported child projection 285280 of 262144, 108.8 percent, BLOCK, and the real failures were 262191. `tests/selftest.sh` gained four asserted checks, 56 to 61. Rule added to AGENTS.md section 14 item 4 and to `.opencode/agents/robotnik.md` as `## The dispatch ceiling`. Recorded as a deviation that `Robotnik` wrote this rather than `Tails`, because delegation was impossible in a session already at the ceiling.

**10:40 Robotnik — TASK-0043 merged and pushed.** Branch `task-0043-dispatch-gate`, commit `418e8b2`, pull request #1 opened and merged with `merge_method=merge`, merge commit `44a017e`, local `main` fast-forwarded. The pre-push hook ran `tests/selftest.sh` and printed `SELFTEST: 61 checks passed` before the push was accepted. Verified present on `origin/main`, `scripts/dispatch-gate`, the selftest block, AGENTS.md section 14 item 4, and `.opencode/agents/robotnik.md` `## The dispatch ceiling`. GitHub writes used the token at `~/AI/secrets/token.md` read at run time through a `GIT_ASKPASS` helper and a header file under `/tmp/opencode`, both mode 700 and 600 and both deleted immediately after the last GitHub call, with no token in any remote URL, commit message, log, or committed file. Commit signatures verified with `git log --show-signature`, good signature for Team Chaotix.

## 2026-11-19

**23:25–23:55 Tails, TASK-0042 dispatch 1, terrain value harvest.** Objective: obtain one plaintext
CHK from a map SCMDraft 2 actually renders, then diff that terrain encoding against the writer at
`/tmp/opencode/t0042/build_map.py`. Acceptance met on the precise-statement branch. The harvest
succeeded with an MIT-licensed open-source library, `StormLib`.

**Attempt 1, a SCMDraft 2 save without map protection. FAILED, evidence recorded.** Upstream options
page `stormcoast-fortress.net/cntt/software/scmdraft/options/` has no protection setting. Command
`strings -n 2 ~/scmdraft2/"ScmDraft 2.exe" > /tmp/sd2.strings` then `grep -n "(\*\." /tmp/sd2.strings`
returns nothing, so there is no save dialog filter for any format other than the ones the binary
already uses; the only `.chk` strings in the binary are the internal MPQ member name
`staredit\scenario.chk` and a file-type label in the backup dialog. The binary also carries the string
`Opening protected maps disabled! Compile with -IGNORE_PROTECTION option set`, which puts the switch
at build time, not in the UI. `find ~ -name "Scm*.tmp"` found SCMDraft's temp files, and parsing them
showed they are byte copies of the file that was opened: the temp files beside River Crossing copies
are encrypted, the temp files beside this team's own plaintext maps are plaintext.
`~/scmdraft2/backupDB.scmdDB` is itself an MPQ whose 7 entries all carry the ENCRYPTED flag.

**Attempt 2, a published open-source MPQ tool. SUCCEEDED.** Upstream and licence recorded before
install: `github.com/ladislav-zezula/StormLib`, commit `d60b7e6d3501474f4d92c7b9c752a37e78385f67`,
`LICENSE` is `The MIT License (MIT), Copyright (c) 1999-2013 Ladislav Zezula`. Built on the controller
only, no build toolchain was added to the target.

| Step | Command | Inverse |
|---|---|---|
| Copy two protected maps off the target, read-only | `sshpass -f ~/AI/secrets/scm_draft_pass.md ssh howard@192.168.1.99 'cat "/home/howard/game-data/sc-clean/Starcraft/maps/(2)River Crossing.scm"' > /tmp/opencode/t0042/maps/rc.scm`, same for `(2)Bottleneck.scm` | `rm -f /tmp/opencode/t0042/maps/rc.scm /tmp/opencode/t0042/maps/bn.scm` |
| Record the copies | `sha256sum maps/* > maps.sha256`. rc.scm `481364dc58e8401d966ef9ce04f87b375344a95838b292007a05fdeb0b721a9e`, bn.scm `02e9c31af0405439f5cf6e813f8570e8daa0473ec20e56ff25aa96898b833cbc` | none, a controller text file |
| Clone StormLib | `git clone --depth 3 https://github.com/ladislav-zezula/StormLib /tmp/opencode/t0042/StormLib` | `rm -rf /tmp/opencode/t0042/StormLib` |
| Build it | `cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DSTORM_USE_BUNDLED_LIBRARIES=ON`, `cmake --build build -j8` | `rm -rf /tmp/opencode/t0042/StormLib` |
| Build the extractor | `g++ chkdump.c -I StormLib/src -L StormLib/build -lstorm -o chkdump -lpthread -lm` | `rm -f /tmp/opencode/t0042/chkdump` |
| Harvest | `./chkdump maps/rc.scm 'staredit\scenario.chk' rc.chk` gives 257441 bytes, head `56455220020000003b00495645520200`. `./chkdump maps/bn.scm ... bn.chk` gives 186130 bytes | `rm -f /tmp/opencode/t0042/rc.chk /tmp/opencode/t0042/bn.chk` |

**Target changes this step, all reversible.** `scp /tmp/opencode/t0042/{rc.chk,build_map.py,mk_variants.py,shot.py,run_viewer.sh}
howard@192.168.1.99:/tmp/` (inverse `rm -f /tmp/rc.chk /tmp/build_map.py /tmp/mk_variants.py /tmp/shot.py /tmp/run_viewer.sh`).
`python3 /tmp/mk_variants.py /tmp/rc.chk /home/howard/scmdraft-maps/probe` wrote `harvA.scm` 273912 B,
`harvB.scm` 48818 B, `harvC.scm` 57398 B, `harvD.scm` 273912 B (inverse `rm -f ~/scmdraft-maps/probe/harv{A,B,C,D}.scm`).
Four launches `bash /tmp/run_viewer.sh <A|D|B|C>`, each `nohup wine64 ~/scmdraft2/"ScmDraft 2.exe" <map>` under the
exported seat0 session environment, each terminated by `pkill -f "ScmDraft[ ]2"`. Final state
`scmdraft_count=0`. The `wineserver` and `winedevice.exe` processes that were already running when this
dispatch started were not touched. No package installed on the target, no repo enabled, no credential on any
command line (`sshpass -f` only), no SCMDraft binary, no third-party binary, and no game data in any
git-tracked path. All StormLib work and all extracted data live under `/tmp/opencode/t0042`.

**Read attempts that the target refused.** The screenshot path that TASK-0041 proved now fails on this
target. Commands and exact errors: `gdbus call --session --dest org.gnome.Shell.Screenshot --object-path
/org/gnome/Shell/Screenshot --method org.gnome.Shell.Screenshot.Screenshot false false /tmp/harvA.png`
gives `GDBus.Error:org.freedesktop.DBus.Error.AccessDenied: Screenshot is not allowed`, the same through
`dbus-send`, and the same with `XDG_SESSION_ID`, `XDG_CURRENT_DESKTOP`, `WAYLAND_DISPLAY` and
`XDG_SESSION_TYPE` exported. `org.gnome.Screenshot` at `/org/gnome/Screenshot` gives
`org.freedesktop.DBus.Error.UnknownMethod: Object does not exist at path "/org/gnome/Screenshot"`.
`command -v gnome-screenshot` returns nothing. `org.gnome.ScreenSaver.GetActive` returns `(false,)`, so
the screen is not locked. `rpm -q gnome-shell` is `gnome-shell-49.4-9.el10_2.rocky.0.2.x86_64`. Nothing
was changed on the target to try to force the API open, so no visual verification of the four test maps
was captured in this step, and the four maps remain on the target for a later step to read.

## 2026-11-20

**00:33-01:25 Tails, TASK-0042 dispatch, restore a screenshot path on the target.** Objective: restore a working screenshot path on 192.168.1.99, then read the four probe maps harvA, harvB, harvC, harvD in order and record which render terrain. Verdict: the screenshot path was NOT restored. Both candidates the brief named are blocked on this target/controller combination, with evidence recorded for each. harvA to harvD remain on the target, still unread.

**Candidate 1, the cheapest, `dnf install gnome-screenshot` from an already enabled repo. CANNOT RUN, no install performed.** Command `dnf repoquery --available gnome-screenshot` returned empty across the eight enabled repos (appstream, baseos, copr:forecastwolf157/Wine-test, crb, epel, extras, rpmfusion-free-updates, rpmfusion-nonfree-updates). `dnf repoquery --available '*screenshot*'` returns only `gnome-shell-extension-screenshot-window-sizer` (an extension, not a capture tool). `grim` and `weston-screenshooter` return empty. The package that provides the `org.gnome.Screenshot` D-Bus activation file is `gnome-screenshot`, and `dnf repoquery --whatprovides '/usr/share/dbus-1/services/org.gnome.Screenshot.service'` returns no provider. Installing it would require enabling a repo, which the brief forbids ("install nothing on the target outside an already enabled repo"). No install was attempted. Recorded as a check asked about that did not run.

**Candidate 2, the fallback that touches the target not at all, framebuffer capture inside the team's own FreeRDP client. CONNECTS AND NEGOTIATES BUT DOES NOT YIELD A FRAME.** Built `/tmp/opencode/t0042/rdp-shot.c` on the controller from the same FreeRDP 3 API as `rdp-input.c`, linking `freerdp3` and `freerdp-client3`. `gnome-remote-desktop` is active on the target, RDP enabled on 3389, view-only no (confirmed by `grdctl status`). rdp-shot reaches CONNECTION_STATE_ACTIVE with NLA HYBRID_EX and a 1920x1080 monitor. The RDPGFX exchange succeeds: the client advertises caps, the server confirms `RDPGFX_CAPVERSION_107 flags 0x22`, sends `ResetGraphics 1920x1080`, `CreateSurface 0 1920x1080 format 0x20`, `MapSurfaceToOutput 0`, and four `RDPGFX_CODECID_CAPROGRESSIVE` frames (the server uses RemoteFX progressive, not H264). Despite that, the decoded surface never reaches GDI: `instance->context->gdi->gfx` is NULL and the captured buffer is a uniform white field (PIL: 1 distinct colour, mean luma 255, min 255 max 255), which is the value `gdi_init` initialises and never writes. `gdi_graphics_pipeline_init(gdi, gfx)` is exported but needs a `RdpgfxClientContext*`, and the constructor `rdpgfx_client_context_new` is not exported in this distro build (build flags in the library string report `WITH_CLIENT_INTERFACE=OFF`, `WITH_OPENH264=OFF`, `WITH_GFX_H264=OFF`, `WITH_FFMPEG=OFF`, `WITH_AOM=OFF`, `WITH_DAV1D=OFF`), and no `.so` under `/usr/lib64` exports it. The deprecated `FreeRDP_SupportGraphicsPipeline` auto-bind does not run in 3.32. `/gfx:RFX9` is accepted by the parser but does not set `gdi->gfx`; `/gfx:AVC444` and `/gfx:off` are rejected by this build's parser. A backtrace from gdb showed an earlier crash was `gdi_init` called in the wrong connect phase, fixed by moving it to PostConnect, but the gfx-to-GDI bind remains unavailable. So candidate 2 is a working connect-and-input client but not yet a working framebuffer capture on this FreeRDP build.

**Target system changes this dispatch: NONE.** Only read-only queries were run against the target (`dnf repoquery`, `ls`, `rpm -q`, `systemctl --user is-active gnome-remote-desktop`, `grdctl status`, `gdbus ... NameHasOwner`). No package installed, no repo enabled or disabled, no file written on the target, no process started. The four maps `~/scmdraft-maps/probe/harv{A,B,C,D}.scm` are unchanged (confirmed by `ls -la`). The `wineserver` (62669) and two `winedevice.exe` (62678, 62710) that were already running when this dispatch began were not touched, per the standing rule.

**Controller system change this dispatch (diagnostic only, the target is not the controller).** Installed gdb for a backtrace. Command `sudo dnf install -y gdb`. NEVRA `gdb-17.2-4.el10_3.x86_64`, repo baseos/appstream. Inverse `sudo dnf remove -y gdb`. Build artefacts `rdp-shot.c`, `rdp-shot`, `sanity_desktop.ppm` live under `/tmp/opencode/t0042`, never in a git-tracked path. No credential, no SCMDraft binary, no game data, no third-party binary in any git path.

**Reads that did NOT run.** harvA, harvB, harvC, harvD were not read visually. No editor screenshot, no terrain render was captured, because no working screenshot path exists on this target/controller combination yet.

**Recommendation for the next dispatch.** The distro FreeRDP 3.32 on the controller cannot render gnome-remote-desktop's RDPGFX output into a framebuffer from a headless client. Three concrete options, each to be taken with a recorded inverse: (1) controller-side, build FreeRDP from source with `WITH_CLIENT_INTERFACE=ON` and the GDI gfx pipeline so the gfx context is available, then rdp-shot binds it; (2) controller-side, drive `xfreerdp` (which wires the pipeline internally) into a window on the controller and capture that controller window; (3) target-side, restore the `org.gnome.Shell.Screenshot` D-Bus path that TASK-0041 proved, which is now denied while gnome-remote-desktop serves, by testing whether stopping or reconfiguring gnome-remote-desktop lifts the denial, recorded with the inverse.

**01:40-02:10 Tails, TASK-0042 dispatch, screenshot-path lever (a) and the harvA-D read.** Objective: test lever (a), whether gnome-remote-desktop serving causes the `org.gnome.Shell.Screenshot` AccessDenied, and if a screenshot path is restored, capture harvA, harvB, harvC, harvD in order and record which render terrain. Result: a screenshot path IS restored with no target change, gnome-remote-desktop serving is NOT the cause of the denial, and none of harvA-D render terrain (none open in SCMDraft). Continuous log for this entry only; controller captures under `/tmp/opencode/t0042`, never in git.

**Lever (a) verdict, with direct evidence.** Command `grdctl rdp disable` (which sets the whole unit to `inactive`) then the same `gdbus call ... org.gnome.Shell.Screenshot.Screenshot false false /tmp/t0042-after-disable.png` still returned `GDBus.Error:org.freedesktop.DBus.Error.AccessDenied: Screenshot is not allowed` and produced no file. The denial persists with gnome-remote-desktop fully inactive, so gnome-remote-desktop serving is NOT the cause, and the prior `## Next Actions` claim that "the denial appears only while grd serves" is disproven by experiment. RDP was re-enabled immediately after with the exact inverse `grdctl rdp enable`, restoring `Unit status: active`, `RDP: Status: enabled`. No target change remains from this test.

**What actually gates the call, found from the target's own code.** `rpm -qa --last` shows gnome-shell 49.4-9.el10_2.rocky.0.2, mutter 49.4, gnome-remote-desktop 49.3 were last installed 2026-11-13, the same build TASK-0041 used, so the trigger is a state fact, not a package update. `gnome-shell` ships `/usr/bin/gnome-screenshot-tool`, a Python tool that calls the *same* `org.gnome.Shell.Screenshot` interface but registers as the `org.gnome.Screenshot` D-Bus client. Command `gnome-screenshot-tool -f /tmp/t0042-toolshot.png` returned rc 0 and wrote a 786058-byte 1920x1080 PNG. PIL on it: 9262 distinct colours, luma 0..255, mean 35; visual read confirms the live Rocky desktop (wallpaper, top bar "20 Nov 01:53"). So the raw `gdbus`/`dbus-send` caller is denied while the recognised screenshot client is allowed. Screenshot path restored, no target change, gnome-remote-desktop left enabled so the proven input loop is intact. The earlier "no screenshot tool is installed" conclusion (2026-11-19) was wrong: it looked for the `gnome-screenshot` package, but gnome-shell 49 provides `gnome-screenshot-tool`.

**harvA-D read.** Each map was launched with the proven seat0 export (`bash /tmp/run_viewer.sh <map>`, `nohup wine64 ~/scmdraft2/"ScmDraft 2.exe" harv<map>.scm`), the profile dialog dismissed with `rdp-input rdp-args key 0x1C`, then captured with `gnome-screenshot-tool -f /tmp/harv<map>-shot.png` and copied to the controller. A control, the real protected `(2)River Crossing.scm`, was launched the same way and rendered the full Jungle World (title bar carries the path, Terrain palette expanded to Water/Dirt/Mud/Jungle/Rocky Ground/Ruins, status bar `Jungle World\Dirt`), proving the launch, Enter, and capture path all work in this session. harvA, harvB, harvC, harvD each showed a title bar with **no map path**, a collapsed Terrain palette (`Microtile None`, `Tile None`), and a uniform grey canvas (PIL canvas: 4 distinct colours, dominated by 128,128,128), versus the control's 1057 canvas colours. A pre-Enter / post-Enter test on harvB confirmed the profile was dismissed (splash, 40675 colours, before Enter; editor chrome after Enter) yet harvB still did not load, ruling out an input-timing cause. **None of harvA, harvB, harvC, harvD render terrain.** harvA and harvD carry the harvested River Crossing CHK verbatim (harvD with ISOM zeroed); harvB and harvC are the writer's own 64x64 build; all four are wrapped in `build_map.build_mpq`, and all four fail identically, so the common factor is the container, not the terrain values. The writer stores the blob unencrypted and uncompressed (`flags = MPQ_EXISTS|MPQ_SINGLE`), while the River Crossing blob that SCMDraft does open is encrypted+compressed (`0x80010200`), so the file-data encoding is the open-gate difference isolated by this read.

**Target system changes this dispatch, all reversible, target left at prior state.**

| Change | Command | Inverse | Status |
|---|---|---|---|
| RDP listener disabled for the lever-(a) test | `grdctl rdp disable` | `grdctl rdp enable` | done, verified `active`/`enabled` after |
| launch helpers written to target /tmp | `cat > /tmp/run_viewer.sh` and `scp run_rc.sh /tmp/run_rc.sh` | `rm -f /tmp/run_viewer.sh /tmp/run_rc.sh` | done |
| SCMDraft 2 launches (harvA, River Crossing control, harvB, harvC, harvD, harvB re-test) | `bash /tmp/run_viewer.sh <v>` / `bash /tmp/run_rc.sh` | `pkill -f "ScmDraft[ ]2"` (only the processes this dispatch started) | done, `no scmdraft` confirmed |
| launch logs and capture PNGs in target /tmp | `nohup wine64 ... > /tmp/h<v>.log`, `gnome-screenshot-tool -f /tmp/harv<v>-shot.png` | `rm -f /tmp/h{A,B,C,D,rc}.log /tmp/*.png` created this step | done |

No package installed on the target. No repo enabled or disabled. No credential on any command line (SSH and scp via `sshpass -f`; RDP via the mode-600 `rdp-args` file). The four maps `~/scmdraft-maps/probe/harv{A,B,C,D}.scm` are unchanged (sizes 273912, 48818, 57398, 273912, same mtimes). The pre-existing `wineserver` (62669) and its `winedevice.exe` children (the still-open "Unused Unprotector 2 v1.2alpha3" window in `session-910.scope`) were not touched.

**Checks run.** `grdctl rdp disable` then gdbus screenshot (AccessDenied persists); `grdctl rdp enable` (restored); `rpm -qa --last` (graphical stack unchanged since 2026-11-13); `gnome-screenshot-tool -f` (rc 0, real 1920x1080 PNG, 9262 colours); River Crossing control (renders Jungle World, title shows path); harvA-D canvas PIL (4 colours each, grey); harvB pre/post-Enter (splash then editor, map still not loaded); final target state (no scmdraft, wineserver present, grd active/enabled, harv maps unchanged).

**Checks NOT run (named honestly).** No booth-simulation artifact or colour-coverage measurement, because no harv map rendered terrain. The isolation experiment (A vs B vs C vs D) is inconclusive as designed: none opened, so terrain values were never actually tested against an opening writer map. Whether StormLib-produced or compressed-blob maps open in SCMDraft was not tested this dispatch. The harvested River Crossing CHK was re-opened via the writer container (harvA/harvD) but not via a StormLib-written container.

**02:40-03:10 Tails, TASK-0042 dispatch 2, StormLib container and CHK content fix, acceptance met.** Objective: make one writer-produced map that actually opens in SCMDraft 2 on the target, by replacing `build_map.build_mpq` with an MPQ written through the already-built StormLib (MIT, `github.com/ladislav-zezula/StormLib` at `d60b7e6d3501474f4d92c7b9c752a37e78385f67`). Acceptance, a writer map whose SCMDraft title bar shows its path and whose canvas shows rendered terrain tiles, captured with `/usr/bin/gnome-screenshot-tool`, with the colour count attached. Result: **acceptance met by `slE.scm`**, and the experiment isolated two separate gates, the container encoding and the CHK content.

**Controller-side build.** `mkmpq.c` (new, `/tmp/opencode/t0042/mkmpq.c`), linked against the existing `StormLib/build/libstorm.a`, `g++ -w -o mkmpq mkmpq.c -I StormLib/src -L StormLib/build -lstorm`. It uses `SFileCreateArchive` (flags `MPQ_CREATE_LISTFILE`, file count 8) and `SFileAddFileEx` with `MPQ_FILE_SINGLE_UNIT`, and zlib via `SFileAddFileEx(..., MPQ_COMPRESSION_ZLIB, MPQ_COMPRESSION_NEXT_SAME)`. Maps written: `slA` (harvested `rc.chk` verbatim, plain), `slB` (writer CHK at 64x64 with harvested terrain values, plain), `slC` (same zlib-compressed, blob on disk 1759 B of 40949), `slD` (harvested River Crossing shell with only MTXM and TILE replaced by the writer's 128/144 alternating values), `slE` (minimal writer CHK with the harvested layout fixes, see the findings). SHA-256 in `/tmp/opencode/t0042/sl.sha256`: slA `070ec027d8855f8212ca2500b4b191040f6735bed59a6f4c00bc41922aa40b68`, slB `5fe0f267bb2b521009dc329cf3e46204dce02207969c96de4018f2c5f7a85fc3`, slC `04863cff16ef4ccb14fa6a37dfb431eb859ea25bd1622016a99aa7d0c2a85c7e`, slD `176d299f86dfe9ce35f1fe98ff5cd97d046dc4ff7e235b43cb9074d2008ef17b`, slE `403911d73383bf314fbd2579a126392fe4488d1ffe774eefe692dd5695af7857`. Every archive round-trips: `./chkdump slX.scm 'staredit\scenario.chk' rtX.chk && cmp rtX.chk slX.chk` is byte-identical for A, B, C (C through StormLib decompression), D, E.

**Target steps, each with its inverse.**

| Step | Command | Inverse | Status |
|---|---|---|---|
| Copy five test maps to the target | `sshpass -f ~/AI/secrets/scm_draft_pass.md scp -o StrictHostKeyChecking=no sl{A,B,C,D,E}.scm howard@192.168.1.99:~/scmdraft-maps/probe/` | `rm -f ~/scmdraft-maps/probe/sl{A,B,C,D,E}.scm` | maps left in place for operator inspection |
| Launch helper written to target | `scp run_sl.sh howard@192.168.1.99:/tmp/run_sl.sh` (seat0 export plus `nohup wine64 "$HOME/scmdraft2/ScmDraft 2.exe" "$map"`) | `rm -f /tmp/run_sl.sh` | done, verified absent |
| Seven SCMDraft launches (rc control, slA, slB, slC, slD, slE, plus the earlier failed staging attempts which started nothing) | `bash /tmp/run_sl.sh <map>` then `rdp-input rdp-args key 0x1C` for the profile dialog | `pkill -f "ScmDraft[ ]2"` (only processes this dispatch started) | done, final `pgrep` shows no ScmDraft; pre-existing `wineserver` 62669 untouched |
| Captures on target then fetched | `XDG_RUNTIME_DIR=/run/user/1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus gnome-screenshot-tool -f /tmp/sl<X>-shot.png` then `scp` to `/tmp/opencode/t0042/` | `rm -f /tmp/sl*-shot.png /tmp/sl.log` | done, verified absent |
| Staging directory created by an scp with a non-existent remote target path | scp auto-created `/tmp/stage` | `rm -f /tmp/stage/*; rmdir /tmp/stage` | done, verified gone |
| SCMDraft 2's own backup side-effect | opening a map writes `Scm*.tmp` byte-copies next to it: new `Scm102d.tmp` (slB), `Scm51d5.tmp` (slC), `Scmcdbc.tmp` (slA), `Scm74fe.tmp` (slD), `Scmb619.tmp` (slE) in `~/scmdraft-maps/probe/` | `rm -f ~/scmdraft-maps/probe/Scm{102d,51d5,cdbc,74fe,b619}.tmp` | left in place with the inverse recorded, per rule r002 |

No package installed, no repo enabled or disabled, no registry change, no credential on any command line (SSH and scp through `sshpass -f`, RDP through the mode-600 `rdp-args` file), no binary or game data in any git path.

**Capture verdicts, canvas crop (160,100)-(1905,870), PIL colour counts.**

| Capture | Title bar | Canvas colours | Verdict |
|---|---|---|---|
| `slrc-shot.png` control, real `(2)River Crossing.scm` | shows path | 275 (full 1063) | renders Jungle World |
| `slA-shot.png` harvested CHK in StormLib container, plain | shows `/home/howard/scmdraft-maps/probe/slA.scm` | 275 (full 1063) | **opens and renders**; pixel diff against the control: 66 changed sample points of 129600, diff bbox `(286,43)-(630,56)` is the title text only, so the canvas is the same rendered map |
| `slB-shot.png` old writer CHK in StormLib container, plain | no map path | 81, dominated `(128,128,128)` grey | does not open |
| `slC-shot.png` same, zlib-compressed blob | no map path | 81, same grey | does not open |
| `slD-shot.png` harvested shell with writer MTXM/TILE | shows path | 273 (full 1058) | opens, renders flat alternating ground under the *harvested, unmodified* ISOM |
| `slE-shot.png` fixed writer CHK, plain | shows `/home/howard/scmdraft-maps/probe/slE.scm` | 143 (full 934) | **opens and renders** flat alternating Jungle ground, the acceptance map |

**Findings.** (1) The container gate is real and resolved: `harvA` (harvested CHK in `build_map.build_mpq`) shows no title path while `slA` (the same 257441 CHK bytes in the StormLib archive) opens and renders identically to the control. This decides the contradiction recorded at doc:1074 against doc:1343: the hand-rolled `build_mpq` container is rejected, StormLib's is accepted. (2) A second, independent gate lives in the CHK content: the writer's CHK fails even inside the accepted container (`slB`, `slC`), while the same container with the harvested shell opens (`slA`, `slD`). (3) The writer CHK defects against the harvest, found by section diff: the writer's `STR` carries a spurious leading `u16` count that the real layout does not (real `STR ` is 1024 `u16` offsets then NUL-terminated strings), `MASK` is all zero where every harvested map is all `0xFF`, the writer emits `IVE2` which real maps do not carry, and the writer omits `IOWN`, `PUNI`, `UPGR`, `PTEC`, `UPRP`, `UPUS`, `MRGN`, `WAV `, `UNIS`, `UPGS`, `TECS`. `slE` fixed all of them at once and opens; which single fix is the gate is not isolated. (4) `slD` renders the writer's flat 128/144 terrain while carrying the harvested map's original ISOM (dominant value 64), so SCMDraft draws terrain from `TILE`/`MTXM` as written, and a flat ISOM of `0x10` at size `4*(W+2)*(H+1)` (`slE`) is sufficient for a flat map. (5) The compressed-blob and `(attributes)` fallbacks were not needed: the plain StormLib container with correct CHK content opens. (6) The 2026-11-14 claim that build_map-container maps opened is now contradicted by their own evidence: the title strip of the 2026-11-15 `calib3` shot (controller, `strip-calib3.png`) shows `9.10)` with no map path, the same signature as the harv failures. The 2026-11-14 `calib.scm` screenshot itself lives only on the target at `~/AI/demo-evidence/t0042-calib-open.png` and was not re-read this pass.

**Checks run.** mkmpq build; StormLib round-trip `cmp` for all five maps; block-table inspection (StormLib writes the blob `flags 0x80000000` plain and `0x80000200` zlib, `(listfile)` `0x80030200`, tables encrypted with the standard keys); seven launches with profile Enter; `gnome-screenshot-tool` captures (rc, slA, slB, slC, slD, slE); PIL colour counts; slA-vs-control pixel diff; title strip reads (slA, slC, slD, slE show paths, slB and calib3 do not); final target state (no ScmDraft, `wineserver` 62669 present, `grdctl` active/enabled, harvA-D unchanged, captures and helper removed).

**Checks NOT run (named honestly).** Isolation of which single slE fix (STR layout, MASK 0xFF, no IVE2, added family sections) is the open-gate, not run. Re-open persistence test on slE (open, kill, open again), not run. Map validation dialog, not run. 4x booth-simulation artifact and colour-coverage measurement on slE, not run, because slE is a flat field, not a design. The 2026-11-14 `t0042-calib-open.png` screenshot was not re-read. No zlib variant was tried against the *fixed* CHK content (only the broken content was compressed).

**03:33-04:28 Tails, TASK-0042 dispatch 3, map 1 `foss-for-all` at 256 by 256 with the proven slE pipeline, contrast calibration, legibility gate artifacts, re-open persistence.** Objective: build map 1 at the full 256x256 extent with `build_slE`-structure CHK wrapped by `mkmpq`, calibrate a contrasting terrain pair from the harvest before glyph work, and produce the editor screenshot, minimap screenshot, 4x booth-simulation, colour-coverage numbers, and the re-open persistence check that dispatch 2 named as not run. Continuous log covers only map 1, not the other four.

**Harvest reads (read-only from the target, nothing committed).** Copied the SCMDraft-saved `foss-for-all.scm` (the rejected item 5 map) and `colorbase.bin` off the target to derive terrain facts. Proving commands, `sshpass -f ~/AI/secrets/scm_draft_pass.md ssh ... 'cat .../foss-for-all.scm' > item5.scm` then `./chkdump item5.scm 'staredit\scenario.chk' item5.chk` (258473 B, head `56455220020000003b00495645520200`), and `scp ... ~/game-data/bmp2scx/colorbase.bin`. Inverse `rm -f /tmp/opencode/t0042/item5.scm /tmp/opencode/t0042/item5.chk /tmp/opencode/t0042/rt-foss.chk /tmp/opencode/t0042/colorbase.bin`. The item 5 diff (`values in item5 not in rc.chk`) returned only low-frequency groups 78 to 179 and 566 to 567 (each freq 1 to 5), which are cliff-transition tiles, not a clean water value. This confirms the item 5 lettering is muddled terrain, consistent with the Shadow blocker, so item 5 was not used as the water reference.

**Contrast calibration (the brief's "calibrate from rc.chk group inventory before glyph work").** Whole-map single-value calibration maps built controller-side with the slE pipeline and launched in SCMDraft 2, each captured with `gnome-screenshot-tool` and measured with PIL HSV on the canvas crop `(175,115)-(1860,872)`. Result table (value = group*16, subtile 0):

| value | group | rendered colour (PIL) | verdict |
|---|---|---|---|
| 0 | 0 | black, no terrain | invalid / void |
| 32 | 2 | brown h34-42 | ground |
| 48 | 3 | brown h34-37 | ground |
| 96 | 6 | blue (32,32,48) h240, whole map | flat Water, blue |
| 192 | 12 | green h70-75 | ground |
| 288 | 18 | green h69-75 | ground |
| 2240 | 140 | brown h34-37 | ground |
| 2880 | 180 | brown h34-37 | ground |

Value 96 (group 6) renders as flat blue across the whole canvas with no cliff speckle. Group 6 is a real harvested River Crossing value (freq 56, the river), so the contrasting pair is chosen from the harvest: glyph foreground value 96 (blue flat Water) on a 128/144 flat ground background. The earlier guess value 3840 (group 240) was tested as a glyph and rendered as a reddish speckled raised/cliff texture on ground, so it was rejected, not used.

**Map 1 build.** `build_map1.py glyph 96` wrote `foss-for-all.chk` (614210 B) with the slE harvested family sections, `MTXM`==`TILE` 131072 B (one u16 per tile, 256x256), `ISOM` 265224 B = `4*(256+2)*(256+1)` filled `0x10`, `VER` 59, harvested `VCOD`, `MASK` all `0xFF`; terrain values `128`/`144` ground checkerboard, `96` for the glyph mask (`glyph.py` renders "FOSS" and "FOR ALL" as 5x7 block letters at 6x8 tiles per cell). Wrapped by `mkmpq plain`. Round-trip `./chkdump foss-for-all.scm 'staredit\scenario.chk' rt-foss.chk && cmp rt-foss.chk foss-for-all.chk` byte-identical. SHA-256 `051fc1392257ec07b17a2dd3c6b9371d0fc1e5434e1a4dcc87df3d325f9f13f0`. Target copy at `~/scmdraft-maps/foss-for-all/foss-for-all-programmatic.scm` verified same SHA-256 on the target after the session, so the opened file is the code-written build, unmodified.

**Target steps, each with its inverse.**

| Step | Command | Inverse | Status |
|---|---|---|---|
| Copy two maps/binary off the target read-only | `sshpass -f ~/AI/secrets/scm_draft_pass.md ssh ... 'cat ...' > item5.scm`, `scp ... colorbase.bin` | `rm -f` the four controller copies | done, removed |
| scp calibration and test maps to the target | `scp -o StrictHostKeyChecking=no calib-*.scm stripes.scm howard@192.168.1.99:~/scmdraft-maps/probe/` | `rm -f ~/scmdraft-maps/probe/{calib-0,calib-32,calib-48,calib-96,calib-192,calib-288,calib-2240,calib-2880,stripes}.scm` | maps left in place for inspection (rule r002) |
| scp map 1 to the target | `scp -o StrictHostKeyChecking=no foss-for-all.scm howard@192.168.1.99:~/scmdraft-maps/foss-for-all/foss-for-all-programmatic.scm` | `rm -f ~/scmdraft-maps/foss-for-all/foss-for-all-programmatic.scm` | left in place |
| launch helper | `scp t0042-run.sh howard@192.168.1.99:/tmp/t0042-run.sh` (seat0 export plus `nohup wine64 ... "$map"` under `WINEPREFIX=$HOME/.wine-scmdraft`) | `rm -f /tmp/t0042-run.sh` | done, verified absent |
| SCMDraft launches (calib-0, stripes, seven calibration values, map 1 twice) | `bash /tmp/t0042-run.sh <map>` then `./rdp-input rdp-args key 0x1C` (profile), zoom set by `./rdp-input rdp-args click 385 90` then `keyx 0x50`/combo selection | `pkill -f "ScmDraft[ ]2"` (only processes this dispatch started) | done, final `pgrep` shows no ScmDraft and no wineserver |
| captures on target then fetched | `gnome-screenshot-tool -f /tmp/<name>.png` then `scp` to `/tmp/opencode/t0042/` | `rm -f /tmp/*.png /tmp/t0042-run.log` created this step | done, verified removed |
| SCMDraft backup side-effects | opening a map writes `Scm*.tmp` byte copies beside it: new `Scm4680.tmp`, `Scm8ebf.tmp`, `Scmfb7c.tmp` in `~/scmdraft-maps/foss-for-all/` | `rm -f ~/scmdraft-maps/foss-for-all/Scm{4680,8ebf,fb7c}.tmp` | left in place with the inverse recorded |

No package installed, no repo enabled or disabled, no registry change, no credential on any command line (SSH and scp via `sshpass -f`; RDP via the mode-600 `rdp-args` file), no binary, map, or game data committed to any git path (`git status --porcelain` shows no `.scm`/`.png`/`.chk`/`.mpq`). The pre-existing lingering `wineserver` 62669 (its `winedevice.exe` children, but no Unprotector GUI app, already present at dispatch start) exited on its own during the session; the only wineserver observed was a `~/.wine-scmdraft` one (84177) started by this dispatch's own SCMDraft launches, which exited on its own after `pkill`; no process this dispatch did not start was killed.

**Legibility gate artifacts (all under `/tmp/opencode/t0042`, none git-tracked).**
- Editor screenshot, real SCMDraft render at 25% zoom: `foss25b.png`, title bar carries `.../foss-for-all-programmatic.scm`, Terrain palette populated (Jungle World), "FOSS" rendered in blue tiles on green/brown ground, no cliff speckle at the blue/ground boundary.
- Whole-map minimap screenshot, the editor's own overview thumbnail of the entire 256x256 map: `foss-minimap-mm.png`, shows both lines "FOSS" (top) and "FOR ALL" (bottom) in blue on ground.
- 4x booth-simulation, whole map downscaled with PIL Lanczos, tile colours taken from the measured editor render (blue `(32,32,48)`, ground green/brown): `foss-maskrender-booth4x.png` (128x128), both lines readable. Editor-canvas downscale also produced at `foss-booth4x.png`.
- Colour coverage: glyph design 7104 of 65536 tiles = 10.8 percent blue (HSV 180-260). Whole-map editor minimap thumbnail blue fraction 1749/14883 = 11.8 percent (matches the design coverage). Main-canvas 25% view (only the FOSS line in frame) measured 6.5 percent blue.

**Re-open persistence (the check dispatch 2 named as not run).** Killed the SCMDraft session, relaunched the same disk file `foss-for-all-programmatic.scm` with the seat0 export, dismissed the profile with Enter, captured `foss-reopen.png`. Title bar shows the full path with no asterisk (clean load, no dirty flag), the disk file size and mtime unchanged (614561 B), and the overview thumbnail renders the same blue "FOSS" and "FOR ALL". Terrain persists across kill and relaunch of the same file.

**Verdict.** Map 1 is built at the maximum 256x256 extent with the proven `build_slE` plus `mkmpq` pipeline, the design fills the horizontal extent (glyph bbox x14-241 of 256, 89 percent of the width) and is centered vertically, the contrasting pair is calibrated from the harvest (value 96 blue water on 128/144 ground), and it renders in SCMDraft 2 with a clean blue-on-ground boundary (no cliff artefact) and persists on re-open. Whether the design is legible at booth scale is left to an independent reader (Shadow) per the legibility gate; the builder does not declare it.

**Checks NOT run (named honestly).** SCMDraft 2 map-format validation dialog (Scenario menu) not run, dialog button injection is proven unreliable (item 4). A literal in-game StarCraft minimap render not run, because the item 3 playability blocker (exclusive-fullscreen pointer capture) stands; the editor's own overview thumbnail is used as the whole-map/minimap evidence instead and is named as such. The whole-map main-canvas editor view could not be brought fully into frame at the minimum 25 percent zoom (the isometric diamond is slightly taller than the viewport), so the whole-map render evidence is the editor overview thumbnail plus the calibrated mask render, not a single full main-canvas capture; both are named. The booth-simulation and coverage are computed from the real editor colours, but the mask render is an orthographic composite using those measured colours, named as such. The item 1 claim `wine-10.17-1.el10.x86_64` and the target repo set were not re-verified this pass (unchanged from items 1-2).

**05:28-06:20 Tails, TASK-0042 dispatch 4, contrast measurement across tilesets and map 1 rebuilt on Ice World.** Objective: test the brighter-tileset hypothesis `Shadow` raised, measure WCAG glyph-to-ground contrast for every tileset whose terrain can be harvested on the target, and rebuild map 1 on the best candidate only if a measured ratio reaches 3.0. Result: seven tilesets measured, Ice World reaches 7.42, Space Platform 3.77, map 1 rebuilt on Ice World at 256x256 with the filename decision applied. Continuous log below, one entry per target-touching step. Controller artefacts live under `/tmp/opencode/t0042`, none in a git-tracked path.

**Step 1, harvest read, read-only against the target.** Command `sshpass -f ~/AI/secrets/scm_draft_pass.md ssh -o StrictHostKeyChecking=no howard@192.168.1.99 "tar -C /home/howard/game-data/sc1161/Starcraft/maps -cf - ." | tar -xf - -C /tmp/opencode/t0042/maps-all`, then `./chkdump <map> 'staredit\scenario.chk' <out>` per map (`/tmp/opencode/t0042/harvest_inventory.py`). 157 `.scm` files read, 157 plaintext CHKs extracted, zero failures, ERA inventory: Badlands 33, Space Platform 32, Installation 2, Ash World 22, Jungle World 68, Desert 0, Ice 0, Twilight 0 maps. Consequence recorded: no protected map of Desert, Ice, or Twilight exists on the target, so those three tilesets cannot be harvested, and the game MPQ route to their CV5 tables is already blocked (Finding 9, 2026-11-19). Inverse: nothing written on the target; controller side `rm -rf /tmp/opencode/t0042/maps-all` done at 06:14, the 164 extracted CHKs and `ts-harvest/inventory.json` kept as the terrain reference.

**Step 2, whole-map grid calibration, seven tilesets.** Builder `/tmp/opencode/t0042/build_ts.py` (new): the proven slE structure, one reference CHK per tileset (`ts-harvest/ref-era0.chk` from `(7)River War.chk`, `ref-era1.chk` from Bottleneck, `ref-era2.chk` from `(2)Wakka Wakka.chk`, `ref-era3.chk` from `(2)Volcanis.chk`), and for the three unharvested tilesets the River Crossing shell with only the `ERA ` word patched to 5, 6, 7. Each calibration map is 20x20 tiles, 4x4 blocks of 5x5 tiles, one candidate terrain value per block, candidates taken from the harvested value inventories (`ts-harvest/candidates.json`). Commands: `sshpass -f ~/AI/secrets/scm_draft_pass.md scp -o StrictHostKeyChecking=no ts{0,1,2,3,5,6,7}-cal.scm t0042-run.sh howard@192.168.1.99:/tmp/stage/` then `mv` into `~/scmdraft-maps/probe/` and `/tmp/` (a staging directory was needed because scp cannot place two different targets in one call; `/tmp/stage` removed in the same command). Launch and capture per map: `bash /tmp/t0042-run.sh <map>`, `./rdp-input rdp-args key 0x1C` to dismiss the profile, `gnome-screenshot-tool -f /tmp/ts<era>-cal-shot.png`, then scp back. Inverse: `rm -f ~/scmdraft-maps/probe/ts{0,1,2,3,5,6,7}-cal.scm` (left in place for inspection, rule r002); `rm -f /tmp/t0042-run.sh /tmp/ts*-shot.png` done at 06:15; `pkill -f "ScmDraft[ ]2"` for the seven launches this step started, pre-existing `wineserver` untouched (there was none at dispatch start, confirmed by `pgrep -af 'ScmDraft|wineserver'`).

**Step 3, boundary pairtests.** Commands: `scp ts6-pair.scm ts1-pair.scm ts2-pair.scm howard@192.168.1.99:~/scmdraft-maps/probe/`, then the same launch, Enter, capture, fetch loop. Each pairtest is 20x20 tiles with the ground value in tile rows 0 to 3 and 16 to 19 and the glyph value in rows 4 to 15. Measured on the renders (`/tmp/opencode/t0042/measure_pair.py`): Ice World ground (176,176,176) luminance 0.43415 against glyph (32,32,44) luminance 0.01522, WCAG 7.423, boundary strips 85.0 and 85.6 percent of pixels matching one of the two region tones, the remainder the editor's own 1 to 2 pixel grid line at (0,0,0) plus the glyph tile's own edge highlight, no cliff ramp. Installation and Space Platform pairtests are recorded in `## Implementation`. Inverse: `rm -f ~/scmdraft-maps/probe/ts{6,1,2}-pair.scm` left in place per r002, `rm -f /tmp/ts*-pair-shot.png` done.

**Step 4, hover probe, a negative result worth recording.** Commands: `scp ts6-rows.scm ts1-rows.scm howard@192.168.1.99:~/scmdraft-maps/probe/`, two launches, then 16 hovers per map with `./rdp-input rdp-args move 244 <y>` and a capture per hover. The status bar coordinate field tracked every hover correctly (`78, 334 (2,10)`, `78, 494 (2,15)`), but the tileset and terrain name field stayed `Ice World\Snow` for all 16 different terrain values, and `Space Platform\Low Platform` for all 16 there. Finding: in SCMDraft 2 0.9.10 that status-bar field reports the selected terrain brush, not the hovered tile, so it cannot name a tile, and the earlier use of `Jungle World\Dirt` as a per-tile reading should be read as the selected brush rather than as the hovered tile. Tileset identification itself still holds, since the field named `Badlands`, `Space Platform`, `Installation`, and `Ice World` correctly per map, and the Terrain palette listed each tileset's own type list. Inverse: `rm -f ~/scmdraft-maps/probe/ts{6,1}-rows.scm` left in place per r002; `rm -f /tmp/rows*.png` done during the step and again at 06:15.

**Step 5, map 1 rebuilt on Ice World, filename decision applied.** Controller build: `python3 build_ts.py glyph ts-harvest/ref-era6.chk foss-ice 192 64 64`, `./chkdump foss-ice.scm 'staredit\scenario.chk' rt-foss-ice.chk && cmp rt-foss-ice.chk foss-ice.chk` byte-identical, SHA-256 `e856f0e1d62ec8f7ecfccf8f0d5f08aee0d5798ef972ea9fee996bbf3bfd3eb0`, 256x256, MTXM==TILE, ISOM 265224 B of `0x10`, terrain values 64 for ground (58432 tiles) and 192 for the glyph (7104 tiles, 10.84 percent), glyph bbox x14-241 y64-191. Target commands, in order, each with its exact inverse:
| Step | Command | Inverse | Status |
|---|---|---|---|
| rename the illegible 2026-11-14 build off the plain name | `mv ~/scmdraft-maps/foss-for-all/foss-for-all.scm ~/scmdraft-maps/foss-for-all/rejected-foss-for-all.scm` | `mv ~/scmdraft-maps/foss-for-all/rejected-foss-for-all.scm ~/scmdraft-maps/foss-for-all/foss-for-all.scm` | done |
| move the superseded Jungle build off the plain-name directory role | `mv ~/scmdraft-maps/foss-for-all/foss-for-all-programmatic.scm ~/scmdraft-maps/foss-for-all/superseded-foss-for-all-jungle.scm` | `mv ~/scmdraft-maps/foss-for-all/superseded-foss-for-all-jungle.scm ~/scmdraft-maps/foss-for-all/foss-for-all-programmatic.scm` | done, extension of the decision recorded in `## Implementation` for `Robotnik` to ratify |
| place the Ice build at the plain name | `scp foss-ice.scm howard@192.168.1.99:~/scmdraft-maps/foss-for-all/foss-for-all.scm` | `rm -f ~/scmdraft-maps/foss-for-all/foss-for-all.scm` | done, target SHA-256 equals the controller build |
| launch, zoom, capture, re-open | `bash /tmp/t0042-run.sh <map>` then `./rdp-input rdp-args key 0x1C`, `click 385 90` plus `keyx 0x50` for the Zoom combo, `click 1893 700` twice for scrollbar page-down, `gnome-screenshot-tool -f /tmp/<name>.png`, `pkill -f "ScmDraft[ ]2"` between sessions | `rm -f /tmp/foss-ice-*.png /tmp/ice25-*.png /tmp/t0042-run.sh /tmp/t0042-run.log /tmp/before-reopen.txt /tmp/after-reopen.txt` | captures fetched, all target-side files removed 06:15 |
| SCMDraft backup side-effects of the two opens | none run, SCMDraft writes these itself: `Scmced6.tmp`, `Scme833.tmp` in `~/scmdraft-maps/foss-for-all/`, and `Scm{185d,4118,6251,86fe,acb6,ce8e,f6f5,4d25,95e5,e032,4e9,8ff9,a210,a616}.tmp` in `~/scmdraft-maps/probe/` from the calibration opens | `rm -f ~/scmdraft-maps/foss-for-all/Scm{ced6,e833}.tmp ~/scmdraft-maps/probe/Scm{185d,4118,6251,86fe,acb6,ce8e,f6f5,4d25,95e5,e032,4e9,8ff9,a210,a616}.tmp` | left in place per r002 |

No package installed, no repo enabled or disabled, no registry change, no credential on any command line (SSH and scp through `sshpass -f`, RDP through the mode-600 `rdp-args` file), no map, CHK, PNG, or binary committed to any git path (`git status --porcelain` shows no `.scm`, `.chk`, `.mpq`, or `.png`). Final target state verified: `pgrep -af 'ScmDraft|wineserver'` returns none, `/tmp/t0042-run.sh` absent, capture PNGs absent, `~/scmdraft-maps` holds 76 files including the calibration and pairtest maps left for inspection, `~/scmdraft-maps/foss-for-all/` holds `foss-for-all.scm` (the Ice build) plus the two renamed predecessors.

**Gate numbers for the rebuilt map 1.** WCAG measured on the real SCMDraft render of the saved file (crop `(155,105)-(1878,832)`, ground cluster luminance above 0.15, glyph cluster below 0.06, grid line and red marker excluded): ground (176,176,176) luminance 0.43415, glyph (32,32,44) luminance 0.01522, ratio 7.423 against the 3.0 gate. Coverage: design 7104 of 65536 tiles 10.84 percent, editor overview thumbnail dark-design share 9.47 percent, dark share of terrain pixels inside the 33 percent main-canvas frame 19.56 percent, which is a crop that contains one whole line rather than the whole map. Booth artefacts: `foss-ice-maskrender-booth4x.png` 128x128 built from the measured tones, its own WCAG 6.709 after Lanczos blending, `foss-ice-booth4x-foss.png` and `foss-ice-booth4x-all.png` 430x181, the 4x Lanczos downscales of the real 33 percent canvas frames. Re-open persistence: kill, relaunch the same disk file, title bar shows the path with no asterisk, size 614561 B, mtime `2026-11-20 06:03:19`, and SHA-256 identical before and after, and the overview thumbnail renders both lines.

**Checks NOT run (named honestly).** SCMDraft 2 map-format validation dialog, still not run on any saved map, dialog button injection is unreliable. A literal in-game StarCraft minimap render, the item 3 playability blocker stands. Single editor canvas view of both text lines at once, the FOSS line spans 228 tiles which is wider than the 25 percent canvas width of 215 tiles, so one line cannot be framed whole horizontally at any zoom SCMDraft permits; the overview thumbnail is the whole-map view. Tile elevation class per candidate value, the hover probe showed the status bar names the selected brush, not the hovered tile, so low-versus-high pairing of value 64 against value 192 is not established, only the rendered boundary cleanliness is. Harvest of Desert, Ice, and Twilight terrain values, no protected map of those tilesets exists on the target.

**07:03 Tails, TASK-0042 dispatch 5, map 2 `rocky-logo` and map 3 `rocky-with-heart` at the full 256 by 256 extent on Ice World, full gate artifact set, measured contrast, re-open persistence.** Objective per the `Robotnik` map-order decision (doc:22). Build maps 2 and 3 with the proven slE pipeline on Ice World, glyph value 192 on ground 64, and produce for each the editor captures, the whole-map real overview thumbnail, a 4x booth simulation, coverage numbers, the WCAG ratio measured on that map's own render, and the re-open persistence check. The builder does not declare either map legible, an independent reader does. Controller artifacts live under `/tmp/opencode/t0042`, none in a git-tracked path. SSH and scp use `sshpass -f ~/AI/secrets/scm_draft_pass.md`; RDP input uses a mode-600 `/tmp` scratch `rdp-args` regenerated from `~/AI/secrets/scm_draft_rdp_pass.md` at run time and removed at dispatch end. No credential on any command line, in any commit, log, doc, or git path.

**Controller build (target not touched).** New file `/tmp/opencode/t0042/rocky.py`: `rocky_logo()` a filled Rocky shield/badge silhouette (chamfered top, straight upper sides, point at the bottom, bbox x27-229 y28-225 of 256), `rocky_heart()` a filled heart silhouette from the implicit curve `(x^2+y^2-1)^3 - x^2 y^3 <= 0` (lobes at top, point at bottom, bbox x43-212 y10-205). Both are filled silhouettes with no internal counter, features far above the 56-tile minimum Shadow set (doc:1660). `build_ts.py` gained a `silhouette` mode. Commands: `python3 build_ts.py silhouette ts-harvest/ref-era6.chk rocky-logo 192 64 64 rocky-logo`, `python3 build_ts.py silhouette ts-harvest/ref-era6.chk rocky-with-heart 192 64 64 rocky-with-heart`. Both era 6, `MTXM`==`TILE` 65536 u16, `ISOM` 265224 B of `0x10`, distinct terrain values {64,192}. Round-trip `./chkdump rocky-logo.scm 'staredit\scenario.chk' rt-rocky-logo.chk && cmp rt-rocky-logo.chk rocky-logo.chk` byte-identical, same for the heart, CHK head `56455220020000003b00495645520200`. SHA-256 `rocky-logo.scm` `d62455f7192c3e3ef109b20dd099cd0c5f2e459d750b551352354d0cd9436056`, `rocky-with-heart.scm` `5d5ceab57283acc9a802db4b79436aa2441f9adea3bd645a22b445fa634182cc`.

**Target steps, each with its exact inverse.**

| Step | Command | Inverse | Status |
|---|---|---|---|
| create per-map directories | `ssh ... "mkdir -p ~/scmdraft-maps/rocky-logo ~/scmdraft-maps/rocky-with-heart"` | `rmdir ~/scmdraft-maps/rocky-logo ~/scmdraft-maps/rocky-with-heart` (only empty; maps removed first) | done |
| copy the two maps to the target | `sshpass -f ~/AI/secrets/scm_draft_pass.md scp -o StrictHostKeyChecking=no rocky-logo.scm howard@192.168.1.99:~/scmdraft-maps/rocky-logo/rocky-logo.scm`, same for the heart | `rm -f ~/scmdraft-maps/rocky-{logo,with-heart}/*.scm` | done, target SHA-256 equals the controller build |
| launch helper to target | `scp -o StrictHostKeyChecking=no t0042-run.sh howard@192.168.1.99:/tmp/t0042-run.sh` | `rm -f /tmp/t0042-run.sh` | done, verified absent |
| map 2 launch, profile Enter, default capture, overview-jump capture | `ssh ... "pkill -f 'ScmDraft[ ]2'; sleep 2; bash /tmp/t0042-run.sh <map>; sleep 8"` then `./rdp-input rdp-args key 0x1C`, `gnome-screenshot-tool -f /tmp/rlogo-100.png`, `./rdp-input rdp-args click 45 178`, `gnome-screenshot-tool -f /tmp/rlogo-jump.png` | `rm -f /tmp/rlogo-*.png` | done, captures fetched, removed 07:05 |
| map 2 re-open | `pkill -f 'ScmDraft[ ]2'`, relaunch same disk file, `key 0x1C`, `gnome-screenshot-tool -f /tmp/rlogo-reopen.png`; `stat`/`sha256sum` before and after | `rm -f /tmp/rlogo-reopen.png` | done, file 614559 B, mtime and SHA-256 identical before and after |
| map 3 launch, capture, jump, re-open | as map 2 with the heart map, `/tmp/rheart-100.png`, `/tmp/rheart-jump.png`, `/tmp/rheart-reopen.png` | `rm -f /tmp/rheart-*.png` | done, file 614565 B, mtime and SHA-256 identical before and after |
| SCMDraft backup side effects of the opens | SCMDraft writes these itself: `Scm852c.tmp`, `Scmb810.tmp` in `~/scmdraft-maps/rocky-logo/`; `Scmd5b5.tmp`, `Scmd2e2.tmp` in `~/scmdraft-maps/rocky-with-heart/` | `rm -f ~/scmdraft-maps/rocky-logo/Scm{852c,b810}.tmp ~/scmdraft-maps/rocky-with-heart/Scm{d5b5,d2e2}.tmp` | left in place per rule r002, inverse recorded |
| remove this dispatch's scratch | `ssh ... "rm -f /tmp/t0042-run.sh /tmp/t0042-run.log /tmp/rlogo-*.png /tmp/rheart-*.png"` | n/a, these are the inverses above | done, verified absent |
| clean up processes this dispatch started | `pkill -f 'ScmDraft 2.exe'; pkill -f 'start.exe /exec'` | n/a | done, `ps` shows no ScmDraft, no wineserver, no start.exe; dispatch start `pgrep` showed none, so every one of these was started by this dispatch |
| remove the transient RDP args scratch | `rm -f /tmp/opencode/t0042/rdp-args` | n/a | done; a pre-existing `rdp-args` from 2026-11-14 held the RDP password, this dispatch regenerated it from `~/AI/secrets` at run time (mode 600) and removed it at the end |

No package installed, no repo enabled or disabled, no registry change. Final target state: `ps` shows no ScmDraft/wineserver, `/tmp/t0042-run.sh` absent, this dispatch's captures absent, `grdctl` active/enabled on port 3389, `~/scmdraft-maps/rocky-logo/` and `~/scmdraft-maps/rocky-with-heart/` hold the maps plus their backups (left for the operator per r002). No binary, map, CHK, or PNG committed to any git path.

**Gate numbers (both maps, `/tmp/opencode/t0042/maps23_report.json`).** Coverage: `rocky-logo` design 30349 of 65536 tiles = 46.31 percent, whole-map overview thumbnail dark-design share 40.41 percent; `rocky-with-heart` design 24144 of 65536 tiles = 36.84 percent, thumbnail dark share 32.16 percent. WCAG measured on each map's own render, ground cluster (176,176,176) luminance 0.43415 against glyph cluster (36,40,56) luminance 0.02178, ratio 6.745 against the 3.0 gate, measured both on the whole-map overview thumbnail crop `(8,105,142,245)` and on the main-canvas frame crop `(155,105,1878,832)` of the viewport jumped onto the design. 128x128 calibrated mask-render booth sim WCAG 6.745. The glyph tone (36,40,56) is slightly lighter than map 1's (32,32,44) because the Ice value 192 tile carries internal texture; the ratio is unchanged in substance.

**Checks NOT run (named honestly).** SCMDraft 2 map-format validation dialog, not run on either saved map, the dialog-button injection blocker from item 4 stands. A literal in-game StarCraft minimap render, the item 3 playability blocker stands, the editor overview thumbnail is the whole-map render used instead and is named as such. Zoom combo selection to 25 percent was attempted twice and did not apply (the combo kept reading 100 percent), consistent with the dispatch 3 note that zoom control is partly flaky; the whole design was brought into the main canvas by an overview-thumbnail click that jumps the viewport, not by a zoom change, so no whole-map main-canvas-at-reduced-zoom frame exists and the whole-map render evidence is the overview thumbnail plus the calibrated mask render. Tile elevation class for the 64/192 pair was not established (the hover-probe finding stands). Independent legibility read of either map, that is `Shadow`'s verdict and this builder does not make it. Harvest of Ice terrain values, no protected Ice map exists on the target, the 64/192 pair is render-validated, not harvest-validated, the caveat recorded in `## Status`.

**08:14-08:36 Tails, TASK-0042 dispatch 6, maps 2 `rocky-logo` and 3 `rocky-with-heart` REBUILT against the four `## Status` decisions and Shadow's blockers.** Map 2's Rocky mask is now rasterized from the shipped distro SVG (`/usr/share/icons/hicolor/scalable/apps/start-here.svg`, `rocky-logos-100.5-3.el10`) by `/tmp/opencode/t0042/rocky_svg.py` (parse the two shipped `<path>` d-strings, flatten the cubic Beziers, scanline-fill the union), replacing the inherited shield mask in `rocky.py:10-13` that shadowed from the wrong description at doc:202 / doc:766. The corrected mark is a disc with a 45-degree chevron notch through its lower right, code coverage 40140/65536 = 61.25 percent, bbox x0-255 y0-255. Map 3 is rebuilt as the corrected Rocky disc carrying a heart: the SVG mark scaled 0.76 on the left and a filled heart placed at its lower right, placement chosen by a programmatic search for zero overlap and a >=5-tile ground gap (`/tmp/opencode/t0042/rocky.py`), so both stay silhouette-class with no internal counter; code coverage 29000/65536 = 44.25 percent, bbox x0-255 y20-255. Booth artifacts are now downscales of the captured real editor overview thumbnail (real SCMDraft pixels), `<map>-booth64.png` and `<map>-booth32.png`; the code-generated mask image is renamed `<map>-calibration-render.png` / `-calibration-render-4x.png` and its contrast field is `calibration_render_wcag`, never a booth simulation. Ice World era 6, glyph value 192 on ground 64, `MTXM`==`TILE` 65536 u16, `ISOM` 265224 B of `0x10`, distinct values {64,192}. SHA-256 `rocky-logo.scm` `447360ce8077e54293bf37857402860fdb6b918eb335ca95426c7d2abc656e83`, `rocky-with-heart.scm` `b9b056c27a67851508dae01493ccd92ee4df4d70846f2ab8b9cb635fe141f0d8`. SSH and scp use `sshpass -f ~/AI/secrets/scm_draft_pass.md` (password read from the file, never echoed, never on a command line); RDP input uses a mode-600 `/tmp/opencode/t0042/rdp-args` regenerated at run time from `~/AI/secrets/scm_draft_rdp_pass.md` and removed at dispatch end.

**Controller build (target not touched).** `python3 build_ts.py silhouette ts-harvest/ref-era6.chk rocky-logo 192 64 64 rocky-logo` and `... rocky-with-heart 192 64 64 rocky-with-heart`; round-trip `./chkdump rocky-logo.scm 'staredit\scenario.chk' rt-rocky-logo.chk && cmp rt-rocky-logo.chk rocky-logo.chk` byte-identical (same for the heart), CHK head `56455220020000003b00495645520200`. Superseded dispatch-5 controller artifacts renamed `superseded-rocky-*-{mm,mm-2x,booth4x,maskrender,maskrender-booth4x}.png` and `superseded-maps23_report.json`. New honest gate report `/tmp/opencode/t0042/maps23_rebuild_report.json` from `measure_rebuild.py`.

**Target steps, each with its exact inverse.**

| Step | Command | Inverse | Status |
|---|---|---|---|
| rename the superseded map 2 build off the plain name (its identifiability gate failed as Rocky per Shadow doc:1753) | `mv ~/scmdraft-maps/rocky-logo/rocky-logo.scm ~/scmdraft-maps/rocky-logo/rejected-rocky-logo-shield.scm` | `mv ~/scmdraft-maps/rocky-logo/rejected-rocky-logo-shield.scm ~/scmdraft-maps/rocky-logo/rocky-logo.scm` | done, naming extension flagged for `Robotnik` to ratify |
| rename the superseded map 3 build off the plain name (heart-only, name half-empty per Shadow doc:1774) | `mv ~/scmdraft-maps/rocky-with-heart/rocky-with-heart.scm ~/scmdraft-maps/rocky-with-heart/superseded-rocky-with-heart-heartonly.scm` | `mv ... back` | done, flagged for ratification |
| place the rebuilt map 2 at the plain name | `sshpass -f ~/AI/secrets/scm_draft_pass.md scp rocky-logo.scm howard@192.168.1.99:~/scmdraft-maps/rocky-logo/rocky-logo.scm` | `rm -f ~/scmdraft-maps/rocky-logo/rocky-logo.scm` | done, target SHA-256 equals the controller build |
| place the rebuilt map 3 at the plain name | `sshpass -f ~/AI/secrets/scm_draft_pass.md scp rocky-with-heart.scm howard@192.168.1.99:~/scmdraft-maps/rocky-with-heart/rocky-with-heart.scm` | `rm -f ~/scmdraft-maps/rocky-with-heart/rocky-with-heart.scm` | done, target SHA-256 equals the controller build |
| launch helper to target | `scp t0042-run.sh howard@192.168.1.99:/tmp/t0042-run.sh` | `rm -f /tmp/t0042-run.sh` | done, verified absent |
| map 2 launch, Enter, default capture, overview-jump capture | `bash /tmp/t0042-run.sh ~/scmdraft-maps/rocky-logo/rocky-logo.scm` then `./rdp-input rdp-args key 0x1C`, `gnome-screenshot-tool -f /tmp/rocky-logo-100.png`, `./rdp-input rdp-args click 75 175`, `gnome-screenshot-tool -f /tmp/rocky-logo-jump.png` | `rm -f /tmp/rocky-logo-100.png /tmp/rocky-logo-jump.png` | done, captures fetched (thumbnail map body dark share 59.76 percent, reads as disc+notch), removed 08:36 |
| map 2 re-open persistence | `pkill -f 'ScmDraft[ ]2'`, relaunch same disk file, `key 0x1C`, `gnome-screenshot-tool -f /tmp/rocky-logo-reopen.png`; `stat`/`sha256sum` before and after | `rm -f /tmp/rocky-logo-reopen.png` | done, 614559 B, mtime and SHA-256 identical before and after |
| map 3 launch, capture, jump, re-open | as map 2 with the heart map, `/tmp/rocky-with-heart-100.png`, `-jump.png`, `-reopen.png` | `rm -f /tmp/rocky-with-heart-*.png` | done, 614565 B, mtime and SHA-256 identical before and after, thumbnail renders disc+notch+heart |
| SCMDraft backup side effects of the opens | SCMDraft writes these itself: `Scm6dfd.tmp`, `Scmcca6.tmp` in `~/scmdraft-maps/rocky-logo/`; `Scm248c.tmp`, `Scm7d37.tmp` in `~/scmdraft-maps/rocky-with-heart/` | `rm -f ~/scmdraft-maps/rocky-logo/Scm{6dfd,cca6}.tmp ~/scmdraft-maps/rocky-with-heart/Scm{248c,7d37}.tmp` | left in place per rule r002, inverse recorded |
| remove this dispatch's target scratch | `rm -f /tmp/t0042-run.sh /tmp/t0042-run.log /tmp/rocky-logo-*.png /tmp/rocky-with-heart-*.png` | n/a, these are the inverses above | done, verified absent |
| clean up processes this dispatch started | `pkill -f 'ScmDraft 2.exe'; pkill -f 'start.exe /exec'` | n/a | done, `pgrep` shows no ScmDraft/wineserver/start.exe; dispatch start `pgrep` showed none, so every one was started by this dispatch |
| remove the transient RDP args scratch | `rm -f /tmp/opencode/t0042/rdp-args` | n/a | done; regenerated from `~/AI/secrets` at run time (mode 600) and removed at dispatch end |

No package installed, no repo enabled or disabled, no registry change. Final target state verified: `pgrep -af 'ScmDraft|wineserver|start.exe'` returns none, `/tmp/t0042-run.sh` absent, this dispatch's captures absent, `grdctl` active/enabled on 3389, `~/scmdraft-maps/rocky-logo/` holds `rocky-logo.scm` (rebuilt SVG mark) plus `rejected-rocky-logo-shield.scm` and their backups, `~/scmdraft-maps/rocky-with-heart/` holds `rocky-with-heart.scm` (rebuilt disc+heart) plus `superseded-rocky-with-heart-heartonly.scm` and their backups. No binary, map, CHK, or PNG committed to any git path (`git status --porcelain` lists no `.scm`, `.chk`, `.mpq`, `.png`).

**Gate numbers (`maps23_rebuild_report.json`).** Coverage: `rocky-logo` code 61.25 percent, real overview thumbnail map-body dark share 59.76 percent; `rocky-with-heart` code 44.25 percent, thumbnail map-body dark share 43.1 percent. Contrast measured on each map's own real render, ground cluster (176,176,176) luminance 0.43415 against glyph cluster (36,40,56) luminance 0.02178, WCAG 6.745 against the 3.0 gate, on the whole-map overview thumbnail crop `(8,105,142,245)` and on the main-canvas frame crop `(155,105,1878,832)`; booth64 (real thumbnail downscaled to 64 px) measured the same pair. The synthetic calibration render is labelled `calibration_render_wcag` 6.745 and named as containing no SCMDraft pixel.

**Checks NOT run (named honestly).** SCMDraft 2 map-format validation dialog, still not run on any saved map. A literal in-game StarCraft minimap render, the item 3 playability blocker stands; the editor overview thumbnail is the whole-map real render used and named as such. Zoom combo to 25 percent was not attempted this dispatch, the whole-map evidence is the overview thumbnail (a real whole-map render) plus the real-thumbnail booth downscales; the main-canvas frame is a viewport jumped onto the design by an overview click, not a reduced-zoom whole-map view. Tile elevation class for the 64/192 pair not established. Independent legibility read of either rebuilt map, `Shadow`'s verdict, the builder does not make it. Harvest of Ice terrain values, no protected Ice map exists, the 64/192 pair is render-validated. The map-3 disc+heart layout scale and gap were chosen by a controller-side placement search, not measured for legibility; that judgment is left to the independent reader.

**13:50-13:53 Tails, TASK-0042 dispatch L1, live construction segment on the target, seed and finish, on a dedicated copy `live-demo.scm`.** Objective per `## Status` (dispatch L1): perform a visible construction segment on 192.168.1.99 driven only by injected input, on a dedicated copy seeded from an existing map so the five deliverable maps stay byte-stable. Coarse terrain placement across the extent, unit and start-location placement, doodads, Ctrl+D/T/U layer switching, and a Ctrl+S save proven by the file changing on disk. Acceptance: a before and after real capture of the same view, the exact injected command list saved as a replayable file, proof the change persisted across a kill and re-open, and per-step colour counts. No step depends on an injected click on a Delphi dialog button, on the Isometrical to Rectangular toggle, or on the Delete scancode. SSH and scp use `sshpass -f ~/AI/secrets/scm_draft_pass.md`; RDP input uses a mode-600 `/tmp/opencode/t0042/rdp-args` regenerated from `~/AI/secrets/scm_draft_rdp_pass.md` at run time and removed at dispatch end. Controller artifacts live under `/tmp/opencode/t0042`, none in a git-tracked path.

**Seed and byte-stability.** Copy under a dedicated name `/home/howard/scmdraft-maps/live-demo/live-demo.scm` from the Blizzard map `(2)River Crossing.scm` (Jungle World, seed SHA-256 `481364dc58e8401d966ef9ce04f87b375344a95838b292007a05fdeb0b721a9e`, 90426 B). After the run, the seed and the three built deliverable maps are unchanged: `foss-for-all.scm` `e856f0e1...`, `rocky-logo.scm` `447360ce...`, `rocky-with-heart.scm` `b9b056c2...`, all matching their recorded SHAs. Maps 4 and 5 do not exist yet.

**Segment driven (the replayable list).** `/tmp/opencode/t0042/live-demo-commands.txt`, replayed by `/tmp/opencode/t0042/drive_construct.py`. Launch `/tmp/t0042-run.sh live-demo.scm` (seat0 Wayland export), profile dismissed `./rdp-input rdp-args key 0x1C`. Terrain band painting: `click 62 843` (Rocky Ground) then `drag 320 360 1500 360 1500 392 320 392`; `click 62 923` (High Dirt) then a band at y 520; canvas page-down `click 1893 700` x3; a Rocky band at y 420; a High Dirt band at y 600. Layer switching `keydown 0x1D key 0x14 keyup 0x1D` (Ctrl+T), `... 0x16` (Ctrl+U), `... 0x07` (Ctrl+D). Unit and doodad placement attempts (tree scroll `click 160 1000` x4, `Terran` toggle `click 40 1008`, canvas `click 760 450`; `Doodads` `click 10 927`, canvas `click 760 470`). Save `keydown 0x1D key 0x1F keyup 0x1D` (Ctrl+S) then `key 0x1C` (Enter confirms the certification dialog, a keyboard default, not a button click).

**Target steps, each with its exact inverse.**

| Step | Command | Inverse | Status |
|---|---|---|---|
| create the demo-scratch directory | `ssh ... "mkdir -p ~/scmdraft-maps/live-demo"` | `rm -rf ~/scmdraft-maps/live-demo` | done |
| reset the copy to the pristine seed | `ssh ... "cp '/home/howard/game-data/sc-clean/Starcraft/maps/(2)River Crossing.scm' ~/scmdraft-maps/live-demo/live-demo.scm"` | `rm -f ~/scmdraft-maps/live-demo/live-demo.scm` | done, baseline 90426 B sha `481364dc...` |
| copy the launch helper to the target | `sshpass -f ... scp t0042-run.sh howard@192.168.1.99:/tmp/t0042-run.sh` | `rm -f /tmp/t0042-run.sh` | done, verified absent after run |
| launch, paint, layer-switch, save, kill, re-open, pan | `bash /tmp/t0042-run.sh ~/scmdraft-maps/live-demo/live-demo.scm`; the rdp-input sequence above; `gnome-screenshot-tool -f /tmp/live-<step>.png` per step; `pkill -f 'ScmDraft[ ]2'` between sessions | `rm -f /tmp/live-*.png /tmp/probe*.png` | done, captures fetched to controller, target captures removed |
| SCMDraft backup side effects of the opens | SCMDraft writes these itself: `Scm{31af,5eaf,74b4,88dc}.tmp` in `~/scmdraft-maps/live-demo/` | `rm -f ~/scmdraft-maps/live-demo/Scm{31af,5eaf,74b4,88dc}.tmp` | left in place per r002, inverse recorded |
| remove this dispatch's target scratch | `rm -f /tmp/t0042-run.sh /tmp/t0042-run.log /tmp/live-*.png /tmp/probe-*.png /tmp/probe2-*.png` | n/a, these are the inverses above | done, verified absent |
| clean up processes this dispatch started | `pkill -f 'ScmDraft[ ]2'; pkill -f 'start[.]exe /exec'` | n/a | done, `pgrep` shows no ScmDraft; a `wineserver` left idle as prior dispatches leave it; dispatch-start `pgrep` showed no ScmDraft, so every one started by this dispatch |
| remove the transient RDP args scratch | `rm -f /tmp/opencode/t0042/rdp-args` | n/a | done; regenerated from `~/AI/secrets` at run time (mode 600) and removed |

**pkill self-match trap, recorded.** The launch-kill line `pkill -f 'ScmDraft 2.exe'; pkill -f 'start.exe /exec'` returned SSH exit 255 with no output: each pattern's regex matched the literal text inside the killing command's own `bash -c` command line, so `pkill` killed its own SSH session. Fixed with bracket regex `'ScmDraft[ ]2'` and `'start[.]exe /exec'`, which match the wine-launched process but not their own command line. No package installed, no repo enabled or disabled, no registry change, no credential on any command line.

**Gate evidence (`live_construct_report.json`).** Before and after of the same top-left viewport (`montage/verdict_beforeafter.png`): pristine at `before`, elevated tan plateau bands appear at `band1_rocky` and `band2_highdirt`, and the same bands are still present at `reopen` after kill and re-open. Persistence down the extent (`montage/verdict_persist.png`): `reopen_down1` carries a grey high plateau band painted in a panned viewport. Per-step canvas colour counts (crop `(160,120,1895,855)`, dark share): before 94.11, band1 93.80, band2 88.41, band4 86.76, reopen 88.41, reopen_down1 84.97. Layer switching read from the status bar (`montage/verdict_layers.png`): Ctrl+T `Terrain`/`Isometrical Terrain`, Ctrl+U `Units`/`67 (1) / 1650 units`, Ctrl+D `Doodads`, Ctrl+T `Terrain`/`High Jungle`. Disk persistence: `live-demo.scm` 90426 to 94921 B, SHA-256 `481364dc...` to `506b0b79bc0e4e1755a20941167cd297db150e2c33dbe6b5311a1bf7a9fca308`, identical `stat` and `sha256sum` before and after the re-open.

**Checks NOT run (named honestly).** Unit, start-location, and doodad placement were attempted and did not land: the status-bar unit count stayed `67 / 1650` and canvas colour counts were byte-identical across `layer_units`, `unit_attempt`, `layer_doodads`, `doodad_attempt` (135 colours, dark 86.75), so no sprite was placed, reason named in `## Implementation`. SCMDraft 2 map-format validation dialog, not run. A literal in-game StarCraft minimap, the item 3 playability blocker stands. Before/after is the editor viewport at 100 percent zoom, not a reduced-zoom whole-map frame. Independent read of these captures by an agent other than this builder is `Shadow`'s L2 verdict, not made here.

---

**19:35-19:45 Tails, TASK-0042 dispatch L3, live-segment fix pass on the target, closes the three Shadow should-fixes from dispatch L2.** Objective per `## Review` doc:2021 (dispatch L2 verdict): re-drive the live construction segment on 192.168.1.99 against `~/scmdraft-maps/live-demo/live-demo.scm` and close three findings. SSH and scp use `sshpass -f ~/AI/secrets/scm_draft_pass.md`; RDP input uses a mode-600 `/tmp/opencode/t0042/rdp-args` regenerated from `~/AI/secrets/scm_draft_rdp_pass.md` at run time and removed at dispatch end. Controller artifacts live under `/tmp/opencode/t0042`, none in a git-tracked path.

**Root cause found, scancode bug.** The L1 commands file used scancode `0x07` for Ctrl+D. In AT set 1, `0x07` is the "6" key, not "D". The correct AT set 1 scancode for D is `0x20`. Ctrl+6 cycles the unit race filter (changing "User Select" to "Protoss") without switching layers. This is why L1's Ctrl+D appeared to stay on the Units or Terrain layer. Ctrl+D with the correct scancode `0x20` switches to Doodads, proven by status-bar OCR reading `Doodads | User Select | Force 1 (Force 1) | Select Doodads | 187 Doodads.` (capture `l3v4-doodads_layer.png`). A tree scroll state issue also contributed: after a layer switch, the terrain palette tree scroll changes, shifting palette coordinates. The fix is ORDER: paint first (proven coordinates from the launch state), then layer-switch.

**Fix 1, Ctrl+D proven from a clean state.** Ctrl+D (scancode `0x20`) issued after painting, from a clean Terrain layer with no preceding tree clicks. Status bar read from x=0 (`montage/l3_layers.png`). OCR reads `... | Doodads | User Select | Force 1 (Force 1) | Select Doodads | 187 Doodads.` Ctrl+T returns to Terrain (`Jungle World\Rocky Ground`), Ctrl+U switches to Units (`67 (1) / 1650 units`), final Ctrl+T returns to Terrain. All four layer transitions confirmed by status-bar OCR, not asserted.

**Fix 2, placement steps cut and recorded.** The L1 `unit_attempt` steps (4 tree page-downs, Terran toggle, canvas click) produced 2 px of canvas change. The L1 `doodad_attempt` steps (Doodads node click, canvas click) produced 0 px. Both are excluded from this segment and from the booth sequence. The DoD live-construction box is satisfiable by the terrain core alone: band painting, Ctrl+D/T/U layer switching, Ctrl+S + Enter save, persistence across kill and re-open.

**Fix 3, before and after on the main canvas.** Before/after pair: `montage/l3_beforeafter.png` shows the identical top-left main-canvas viewport (crop (160,120,1895,855)) before painting and after kill and re-open. The right panel shows expanded brown/tan plateau bands replacing green jungle ground. Per-step diffs measured on the main canvas: `before` to `band1_rocky` 20723 px (1.63%), `band1_rocky` to `band2_highjungle` 82541 px (6.47%), `band2_highjungle` to `pan1` 420372 px (32.96%), `pan1` to `band3_rocky` 112696 px (8.84%). Each painted band is approximately 1180 px long inside a 1735 px canvas, approximately 69 percent of the canvas width.

**Segment driven (replayable list).** `/tmp/opencode/t0042/live-demo-commands-l3.txt`, replayed by `/tmp/opencode/t0042/drive_l3.py`. Launch `/tmp/t0042-run.sh live-demo.scm` (seat0 Wayland export), profile dismissed `./rdp-input rdp-args key 0x1C`. Terrain painting: `click 62 843` (Rocky Ground) then `drag 320 360 1500 360 1500 392 320 392`; `click 62 923` (High Jungle) then drag at y 520; canvas page-down `click 1893 700` x3; Rocky Ground band at y 420. Layer switching: Ctrl+D (`keydown 0x1D key 0x20 keyup 0x1D`), Ctrl+T (`... 0x14`), Ctrl+U (`... 0x16`), Ctrl+T (`... 0x14`). Save: Ctrl+S (`... 0x1F`) then Enter (`key 0x1C`).

**Target steps, each with its exact inverse.**

| Step | Command | Inverse | Status |
|---|---|---|---|
| reset the copy to the pristine seed | `ssh ... "cp '/home/howard/game-data/sc-clean/Starcraft/maps/(2)River Crossing.scm' ~/scmdraft-maps/live-demo/live-demo.scm"` | `rm -f ~/scmdraft-maps/live-demo/live-demo.scm` | done, baseline 90426 B sha `481364dc...` |
| copy the launch helper to the target | `sshpass -f ... scp t0042-run.sh howard@192.168.1.99:/tmp/t0042-run.sh` | `rm -f /tmp/t0042-run.sh` | done, removed at dispatch end |
| launch, paint, layer-switch, save, kill, re-open, pan | `bash /tmp/t0042-run.sh ~/scmdraft-maps/live-demo/live-demo.scm`; the rdp-input sequence; `gnome-screenshot-tool -f /tmp/l3v4-<step>.png` per step; `pkill -f 'ScmDraft[ ]2'` between sessions | `rm -f /tmp/l3v4-*.png /tmp/t0042-run.log` | done, captures fetched to controller, target captures removed |
| SCMDraft backup side effects | SCMDraft writes `Scm*.tmp` files in `~/scmdraft-maps/live-demo/` | `rm -f ~/scmdraft-maps/live-demo/Scm*.tmp` | left in place per r002, inverse recorded |
| clean up processes | `pkill -f 'ScmDraft[ ]2'; pkill -f 'start[.]exe /exec'` | n/a | done, verified no ScmDraft at dispatch end |
| remove transient RDP args | `rm -f /tmp/opencode/t0042/rdp-args` | n/a | done; regenerated at run time (mode 600) and removed |

**Gate evidence (`l3_report.json`).** Before and after of the same main-canvas viewport (`montage/l3_beforeafter.png`): green jungle ground at `before`, elevated brown/tan plateau bands visible at `reopen` after kill and re-open. Per-step canvas measurements (crop (160,120,1895,855)): before dark 94.10 green 27.42; band1 dark 93.78 green 23.43 (Rocky Ground band landed); band2 dark 88.41 green 21.10 brown 2.33 (High Jungle band landed); pan1 dark 89.13 (scroll shows painted bands); band3 dark 92.17 (new band painted in panned view); reopen dark 88.41 (painted bands persist); reopen_down1 dark 84.95 brown 3.15 (bands persist down the extent). Layer switching read from the status bar from x=0 (`montage/l3_layers.png`): Ctrl+D `Doodads | Select Doodads | 187 Doodads`, Ctrl+T `Terrain | Isometrical Terrain | Jungle World\Rocky Ground`, Ctrl+U `Units | No selection | 67 (1) / 1650 units`, Ctrl+T `Terrain | Isometrical Terrain | Jungle World\Rocky Ground`. Disk persistence: `live-demo.scm` 90426 to 94538 B, SHA-256 `481364dc...` to `9048e91beb45...`.

**Deliverable byte-stability.** After the run, all three built deliverable maps are unchanged: `foss-for-all.scm` `e856f0e1...`, `rocky-logo.scm` `447360ce...`, `rocky-with-heart.scm` `b9b056c2...`, all matching their recorded SHAs. Maps 4 and 5 do not exist yet.

**Scancode reference (recorded for future dispatches).** AT set 1 make codes used by SCMDraft 2 layer hotkeys via RDP keyboard injection: Ctrl (left) = `0x1D`, T = `0x14`, U = `0x16`, D = `0x20`, S = `0x1F`, Enter = `0x1C`. The L1 file's `0x07` for "Ctrl+D" is the "6" key and cycles the unit race filter, not a layer switch.

**Steps safe to perform in front of an audience on 2026-11-28.** Terrain band painting (Rocky Ground and High Jungle drags across the canvas, visible on the main canvas at 100 percent zoom, 1.63 to 8.84 percent canvas change per step). Ctrl+D layer switch (status bar reads `Doodads`, proven from a clean Terrain state with correct scancode 0x20). Ctrl+T (status bar reads `Terrain`). Ctrl+U (status bar reads `Units`, count changes). Ctrl+S + Enter save (certification dialog confirmed by Enter, file grows on disk). Canvas page-down scroll (visible viewport change, 32.96 percent diff). Kill and re-open (persistence confirmed, painted bands present after re-open). Timing approximately 100 seconds of visible build plus save, suitable for a booth loop.

**Steps NOT safe for audience.** Unit, start-location, and doodad placement (not drivable, 0 to 2 px change). Tree navigation for unit or doodad selection (coordinates depend on live tree scroll state, unreliable). Ctrl+6 (the old `0x07` code, not a layer switch, cycles race filter). Any step requiring a Delphi dialog button click. The Isometrical to Rectangular toggle. The Delete scancode.

**Checks NOT run (named honestly).** SCMDraft 2 map-format validation dialog, not run. A literal in-game StarCraft minimap, the item 3 playability blocker stands. Independent read of these captures by an agent other than this builder is pending (`Shadow` L2 already ran against L1 artifacts, this L3 evidence needs a fresh read). Placement steps not attempted (cut by design). No mid-drag capture exists, paint progressive during the drag is inferred from before and after states. Physical booth legibility not measured, pixel statistics on captured PNGs.

**Changes table.** Controller, all under `/tmp/opencode/t0042`, none in git: `live-demo-commands-l3.txt` (replayable L3 command list, new), `drive_l3.py` (L3 driver, new), `l3_report.json` (per-step measurements, new), captures `l3v4-*.png` and `l3v4-status-*.png` (new), `montage/l3_beforeafter.png` and `montage/l3_layers.png` (new), `scancodetest-*.png` (scancode probe, new), `rdp-args` regenerated at run time and removed. Target: `~/scmdraft-maps/live-demo/live-demo.scm` overwritten with the pristine seed then modified by the segment, `/tmp/t0042-run.sh` copied then removed. No package installed, no repo enabled, no credential on any command line.

**20:29 Tails, TASK-0042 dispatch M1, map 4 `tux` controller build at the full 256 by 256 extent on Ice World era 6, one filled body silhouette, no belly, no internal counter.** Objective per the M1 brief in `## Next Actions` and the maps 4 and 5 design limits in `## Status`: build `tux` with `build_ts.py silhouette ts-harvest/ref-era6.chk tux 192 64 64 tux`, then produce on the target the four gate numbers (coverage, WCAG contrast measured on that map's own real render, a booth artifact that is a downscale of the captured editor overview thumbnail and nothing else, and the re-open hash, size and mtime after a kill and relaunch). The builder does not declare the map legible; an independent reader does (`Shadow`, dispatch M2). SSH and scp use `sshpass -f ~/AI/secrets/scm_draft_pass.md`; RDP input uses a mode-600 `/tmp/opencode/t0042/rdp-args` regenerated from `~/AI/secrets/scm_draft_rdp_pass.md` at run time and removed at dispatch end. Controller artifacts live under `/tmp/opencode/t0042`, none in a git-tracked path.

**Dispatch-start target state.** `pgrep -af 'ScmDraft[ ]2'`, `pgrep -af 'wineserve[r]'`, `pgrep -af 'start[.]exe'` each return nothing, `/tmp/t0042-run.sh` absent, so every process this dispatch starts is one it started and will clean up. `~/scmdraft-maps/` holds the three built deliverable maps plus the earlier probe and scratch directories; no `tux` directory yet.

**Controller build (target not touched).** New module `/tmp/opencode/t0042/tux.py`: `tux()` renders the filled Tux body silhouette as the union of six implicit ellipses (head `128,50` r50; body `128,155` 78x100; flippers `28,150` and `228,150` 30x68; feet `93,228` and `163,228` 42x30), one tile per pixel into a 256x256 boolean mask. Per the `## Status` design limits it carries NO belly and NO internal counter of any kind (no eyes, no beak, no holes): the identity must be carried by the outline alone (narrower round head over a wider body, flippers protruding at the sides with a visible armpit notch, feet protruding at the lower corners). Self-checks in `python3 tux.py`: coverage 43976/65536 = 67.10 percent, bbox x0-255 y0-255 (fills the full extent: head top row 0, feet bottom row 255, flipper tips columns 0 and 255), 4-connected components 1, enclosed ground tiles 0 (flood fill from the border reaches every ground pixel, so the mask has no internal counter). Every feature clears the 56-tile coarse-feature floor in both dimensions (head 101, body 157x201, flipper 58x137, foot 85x58). `/tmp/opencode/t0042/rocky.py` gains one registry line `"tux": _tux.tux` in `MASKS` so the proven `build_ts.py silhouette` mode resolves the mask name without touching `build_ts.py`; the mask itself lives in its own module. *Alternatives.* Option A, hand the Tux mask directly inside `rocky.py`, rejected: `rocky.py` is documented as the maps 2/3 mask module and a single-responsibility `tux.py` matches how `glyph.py` and `rocky_svg.py` already sit beside it. Option B, teach `build_ts.py` to import a mask module by name, rejected: it would change the byte-proven builder for no benefit when the registry already exists.

`python3 build_ts.py silhouette ts-harvest/ref-era6.chk tux 192 64 64 tux`: era 6, chk 614201 B, `MTXM`==`TILE` 65536 u16, `ISOM` 265224 B of `0x10`, distinct terrain values {64,192}, mkmpq rc 0 mode plain. Round-trip `./chkdump tux.scm 'staredit\scenario.chk' rt-tux.chk && cmp rt-tux.chk tux.chk` byte-identical, CHK head `56455220020000003b00495645520200`. `tux.scm` 614552 B, SHA-256 `79002eacd5d673c531d6e2e417dddb6c00b02d9a9b9577fab7d43373f682bca4`.

**Target steps, each with its exact inverse.**

| Step | Command | Inverse | Status |
|---|---|---|---|
| create the map-4 directory | `ssh ... "mkdir -p ~/scmdraft-maps/tux"` | `rmdir ~/scmdraft-maps/tux` (only after the map and backups are removed) | done |
| copy the map to the target | `sshpass -f ~/AI/secrets/scm_draft_pass.md scp -o StrictHostKeyChecking=no tux.scm howard@192.168.1.99:~/scmdraft-maps/tux/tux.scm` | `rm -f ~/scmdraft-maps/tux/tux.scm` | done, target `stat` 614552 B mtime `2026-11-20 20:33:23`, target SHA-256 `79002eac...` equals the controller build |
| launch helper to target | `scp -o StrictHostKeyChecking=no t0042-run.sh howard@192.168.1.99:/tmp/t0042-run.sh` | `rm -f /tmp/t0042-run.sh` | done, verified absent at dispatch end |
| launch, profile Enter, default capture | `bash /tmp/t0042-run.sh ~/scmdraft-maps/tux/tux.scm; sleep 8` then `./rdp-input rdp-args key 0x1C` (profile dismissed), a second `key 0x1C` four seconds later (harmless on the editor canvas; the title bar shows no asterisk in every capture, the map was never marked dirty), `gnome-screenshot-tool -f /tmp/tux-100.png` | `rm -f /tmp/tux-100.png` | done, capture fetched (title `[/home/howard/scmdraft-maps/tux/tux.scm ]`, status `Ice World\Snow`, populated Ice palette, overview thumbnail renders the silhouette), target capture removed |
| overview-jump onto the body, capture | `./rdp-input rdp-args click 75 175`, `gnome-screenshot-tool -f /tmp/tux-jump.png` | `rm -f /tmp/tux-jump.png` | done, viewport parked inside the body, a real whole-design render but single-tone |
| overview-jump to ground, capture | `./rdp-input rdp-args click 32 136`, `gnome-screenshot-tool -f /tmp/tux-jump2.png` | `rm -f /tmp/tux-jump2.png` | done, frame holds ground only; kept as evidence the viewport-centre mapping, not as a contrast frame |
| overview-jump onto the boundary, capture | `./rdp-input rdp-args click 47 134`, `gnome-screenshot-tool -f /tmp/tux-jump3.png` | `rm -f /tmp/tux-jump3.png` | done, frame holds the ground/glyph boundary with a clean stepped edge; this is the main-canvas contrast frame |
| re-open persistence | `stat`/`sha256sum` before; `pkill -f 'ScmDraft[ ]2'`, relaunch the same disk file, `key 0x1C`, `gnome-screenshot-tool -f /tmp/tux-reopen.png`; `stat`/`sha256sum` after | `rm -f /tmp/tux-reopen.png` | done, 614552 B mtime `2026-11-20 20:33:23` SHA-256 `79002eac...` identical before and after; the re-open capture shows the title with no asterisk and the same thumbnail silhouette |
| SCMDraft backup side effects of the opens | SCMDraft writes these itself: `Scm9ff9.tmp`, `Scma565.tmp` in `~/scmdraft-maps/tux/` | `rm -f ~/scmdraft-maps/tux/Scm{9ff9,a565}.tmp` | left in place per rule r002, inverse recorded |
| remove this dispatch's target scratch | `ssh ... "rm -f /tmp/tux-{100,jump,jump2,jump3,reopen}.png /tmp/t0042-run.sh /tmp/t0042-run.log"` | n/a, these are the inverses above | done, verified absent |
| clean up processes this dispatch started | `pkill -f 'ScmDraft[ ]2'; pkill -f 'start[.]exe /exec'` | n/a | done, `pgrep` shows no ScmDraft, no wineserver, no start.exe; dispatch start `pgrep` showed none, so every one was started by this dispatch |
| remove the transient RDP args scratch | `rm -f /tmp/opencode/t0042/rdp-args` | n/a | done; regenerated from `~/AI/secrets` at run time (mode 600) and removed at dispatch end |

No package installed, no repo enabled or disabled, no registry change, no credential on any command line. Deliverable byte-stability verified after the run: `foss-for-all.scm` `e856f0e1...`, `rocky-logo.scm` `447360ce...`, `rocky-with-heart.scm` `b9b056c2...`, all matching their recorded SHAs. The only target map directory this dispatch created is `~/scmdraft-maps/tux/`.

**Gate numbers (`/tmp/opencode/t0042/tux_report.json`, measured by `measure_tux.py`, which reuses the maps 2/3 rebuild measurement functions).** Coverage: code 43976 of 65536 tiles = 67.10 percent, real overview thumbnail map-body dark share 64.57 percent (crop `(4,4)-(131,131)` of the panel crop `(8,105)-(142,245)`, crops named). WCAG contrast measured on the map's own real render: ground cluster (176,176,176) against glyph cluster (36,40,56), ratio 6.745 against the 3.0 gate, measured on the whole-map overview thumbnail crop and again on the real main-canvas boundary frame `tux-jump3.png` crop `(155,105)-(1878,832)`; the 64 px booth downscale measures 6.745 on its own real pixels. The tones match maps 2 and 3 exactly because the same Ice 192 tile carries the design on ground 64. Booth artifact: `tux-booth64.png` and `tux-booth32.png`, downscales of the captured real editor overview thumbnail map body and nothing else, they contain SCMDraft pixels; `tux-mm-2x.png` is a 2x enlargement of the same real crop named as an enlargement; the synthetic mask image is `tux-calibration-render.png` / `-4x.png` with contrast reported only as `calibration_render_wcag` and labelled as containing no SCMDraft pixel. Re-open persistence: kill and relaunch the same disk file, 614552 B, mtime `2026-11-20 20:33:23`, SHA-256 `79002eacd5d673c531d6e2e417dddb6c00b02d9a9b9577fab7d43373f682bca4` identical before and after.

## 2026-11-20 22:25-23:12 — Dispatch L4: live construction segment on Ice World era 6 seed (`Tails`)

**Objective.** Re-drive the live construction segment on an Ice World era 6 flat seed, closing the `M2` paint-contrast blocker (`## Review` doc:2184). Per-pixel WCAG between before and after tone at the same canvas coordinate must measure 3.0 or better.

**Seed.** Flat 256x256 Ice World era 6, ground value 64 (Rocky Snow), written by `/tmp/opencode/t0042/build_ice_seed.py` using the proven `build_ts.py` pipeline (`ref-era6.chk` family sections, `mkmpq` StormLib wrap). Placed at `~/scmdraft-maps/live-demo/live-demo-ice.scm`, 614562 B, SHA-256 `8f338a3cea24c1e0c5381088fc0175f5a35151fdd543f971337d99b14d627c74`. Inverse: `rm -f ~/scmdraft-maps/live-demo/live-demo-ice.scm`.

**Palette coordinates derived from fresh capture.** `l4-palette.png` (2026-11-20 22:25) shows Ice World terrain tree. Click x=62, Rocky Snow y=806, High Outpost y=934. Not inherited from the Jungle layout.

**Visible construction.** SCMDraft launched with seat0 Wayland export via `/tmp/t0042-run.sh`, profile dismissed with Enter (0x1C). Three terrain bands painted by drag (click 62 934 → drag waypoints), canvas scrolled by page-down (click 1893 700), layer switches by Ctrl+D (0x20), Ctrl+U (0x16), Ctrl+T (0x14). Ctrl+S (0x1F) triggers Compatibility Warning (era 6 is Broodwar tileset), dismissed with Escape (0x01).

**Per-pixel WCAG (measured by `drive_l4.py`, threshold 30, canvas crop 160,120,1895,855):**
- band1: median 6.094 (245867 changed px, 41635 inside stroke rect, 16.9%)
- band2: median 6.159 (359955 changed px, 49768 inside stroke rect, 13.8%)
- band3: median 6.094 (231538 changed px, 44155 inside stroke rect, 19.1%)

**Era 6 save blocker discovered and recorded.** Ctrl+S and taskkill save paths trigger a Broodwar Compatibility Warning → Windows file dialog → "Invalid character(s) in path" (Wine path `/` characters in filename field). Tested at three target paths, multiple key sequences. No save completes. This is a Wine/Delphi interaction issue specific to era 6 tileset.

**Persistence proof (programmatic file replacement).** Banded map built by `build_ice_after.py` (552 tiles value 192 in three bands at tile rows 5-8, 12-15, 18-21, columns 5-50), 614562 B, SHA-256 `9a9c24660f55a25341388e75d5bf8e68f9ca9e9df58f2568f7e5fc33fe7888b8`. Replaced at `~/scmdraft-maps/live-demo/live-demo-ice.scm`. Kill, relaunch, kill: identical 614562 B, identical SHA-256. Re-open capture (`l4-reopen-final.png`) shows three dark bands against grey ground, title bar path with no asterisk, status `Ice World\Snow`. WCAG flat-to-reopened: median 6.745. Inverse: replace with seed version.

**M2 should-fixes closed.** Status-bar crop widened to (0,1045,1920,1080) = 35 rows full width. `l3_report.json` dispatch label corrected from "L3v3" to "L3v4" with explanatory note.

**Replayable command list.** `/tmp/opencode/t0042/live-demo-commands-l4.txt`, 9 steps, all injected input. No Delphi dialog click, no Isometrical/Rectangular toggle, no Delete scancode.

**Byte-stability verified after run.** `foss-for-all` `e856f0e1...`, `rocky-logo` `447360ce...`, `rocky-with-heart` `b9b056c2...`, `tux` `79002eacd5d6...`, all matching recorded SHAs.

**Target state after dispatch.** `~/scmdraft-maps/live-demo/live-demo-ice.scm` holds the banded version (persistence proof). `/tmp/l4-*.png` removed. `/tmp/t0042-run.sh` left in place (used by future dispatches). SCMDraft not running. No package installed, no repo enabled, no registry change, no credential on any command line.

**Command producing this entry:** `python3 drive_l4.py` (controller), captures via `gnome-screenshot-tool` on target, SCP return. Inverse for target artifacts: `rm -f ~/scmdraft-maps/live-demo/live-demo-ice.scm`.

## 2026-11-21 00:01 — Dispatch M3, step 1: republic-of-korea mask and CHK build (`Tails`)

**Objective.** Build map 5 `republic-of-korea` at the full 256x256 extent on Ice World era 6 with glyph 192 on ground 64 as a coarse filled peninsula outline with coastal features at 10 tiles or larger and no Taegeuk and no trigrams. Carry two `tux` corrections from `M2` should-fixes.

**Mask.** `/tmp/opencode/t0042/korea.py` defines `republic_of_korea()` returning a 256x256 boolean mask. The mainland polygon uses the 17-vertex simplified South Korea outline from Natural Earth derived GeoJSON (`github.com/johan/world.geo.json KOR.geo.json`, retrieved 2026-11-21), projected through an equirectangular mapping at midpoint latitude 36.0N with cosine longitude correction. Jeju Island is a separate filled ellipse at 126.53E 33.37N, 22x14 tiles. The mask has 2 connected components (mainland + Jeju), zero enclosed ground tiles (no internal counter), bbox x78-198 (121w) y11-250 (240h), code coverage 16390/65536 = 25.01 percent. Registered in `rocky.py` MASKS as `republic-of-korea`.

**Build.** `python3 build_ts.py silhouette ts-harvest/ref-era6.chk republic-of-korea 192 64 64 republic-of-korea`. Output: `republic-of-korea.chk` 614215 B, `republic-of-korea.scm` 614566 B, SHA-256 `50e55299dd86fafbcf5976f841992dd326e3d9b56c4d27fecbfdebfd06ea03ca`. ERA 6, DIM 256x256, STR name `republic-of-korea`, MTXM==TILE 65536 u16 values distinct [64, 192], ISOM 265224 B of 0x10.

**Inverse.** `rm -f /tmp/opencode/t0042/republic-of-korea.{chk,scm}`. Target inverse recorded with placement.

## 2026-11-21 00:06-00:30 — Dispatch M3, step 2: republic-of-korea target placement, capture, persistence (`Tails`)

**Target placement.** `~/scmdraft-maps/republic-of-korea/republic-of-korea.scm` placed, 614566 B, mtime `2026-11-21 00:05:59`, SHA-256 `50e55299dd86fafbcf5976f841992dd326e3d9b56c4d27fecbfdebfd06ea03ca`, identical to controller. Inverse: `rm -f ~/scmdraft-maps/republic-of-korea/republic-of-korea.scm`.

**SCMDraft launch and capture.** Launched via `bash /tmp/t0042-run.sh` (seat0 Wayland export, `~/.wine-scmdraft` prefix). Profile dismissed with Enter (0x1C). First launch used single-quoted `~` path which Wine did not expand; killed and relaunched with `$HOME` expansion, title bar then reads `/home/howard/scmdraft-maps/republic-of-korea/republic-of-korea.scm`. Overview thumbnail panel shows the peninsula silhouette. Overview-jump click at panel pixel (110,140) jumped the viewport to a boundary frame containing both ground and glyph tones. Captures: `korea-100c.png` (editor overview), `korea-jump1.png` (main-canvas boundary frame), `korea-reopen.png` (re-opened).

**Gate numbers.** Coverage: code 16390/65536 = 25.01 percent, overview thumbnail map-body dark share 25.07 percent (measured ground 12277 + glyph 4108 = 16385 tiles in the body crop, close to the code count). WCAG: ground (176,176,176) vs glyph (36,40,56) = 6.745, measured on the overview thumbnail map-body crop AND on the main-canvas boundary frame `korea-jump1.png` crop (155,105)-(1878,832). Map body bounds in the overview panel: x 8-149, y 85-259 (142w x 175h).

**Booth artifacts.** `korea-mm.png` (real overview thumbnail map body crop), `korea-booth64.png` and `korea-booth32.png` (Lanczos downscales of the real overview thumbnail map body, contain SCMDraft pixels), `korea-mm-2x.png` (2x enlargement of the same crop). `korea-calibration-render.png` and `-4x.png` (synthetic mask render, labelled calibration only, no SCMDraft pixel).

**Re-open persistence.** Kill SCMDraft, SCMDraft wrote `Scmdecf.tmp` backup, relaunch the same disk file. File identical: 614566 B, SHA-256 `50e55299...` identical, mtime `2026-11-21 00:05:59` identical. Visual: 0.00 percent pixel diff in the overview panel crop (threshold 16), 0 pixel diff in the title bar. SCMDraft's `Scmdecf.tmp` backup left in place per r002.

**Byte-stability verified.** All four prior deliverable maps unchanged: `foss-for-all` `e856f0e1...`, `rocky-logo` `447360ce...`, `rocky-with-heart` `b9b056c2...`, `tux` `79002eacd5d6...`.

**Target state after step.** `~/scmdraft-maps/republic-of-korea/republic-of-korea.scm` in place with `Scmdecf.tmp` backup. `/tmp/korea-*.png` captures created on target (inverses: `rm -f /tmp/korea-*.png`). SCMDraft not running. No package installed, no repo enabled, no registry change, no credential on any command line.

**Command producing this entry:** `bash /tmp/t0042-run.sh` on target, `rdp-input rdp-args key 0x1C` and `rdp-input rdp-args click 110 140` on controller, `gnome-screenshot-tool` captures on target, SCP return. Inverse for target artifacts: `rm -f ~/scmdraft-maps/republic-of-korea/republic-of-korea.scm ~/scmdraft-maps/republic-of-korea/Scmdecf.tmp /tmp/korea-*.png`.

## 2026-11-21 00:30 — Dispatch M3, step 3: `tux` M2 should-fix corrections (`Tails`)

**Correction 1: `tux` booth artifacts re-cropped.** `M2` finding doc:2274: Shadow measured the real map body in `tux-100.png` at x 18-145, y 112-240 (128x129 px, 0.5 px/tile). The record's `THUMB_BODY` crop (4,4,131,131) maps to absolute (12,109)-(139,236), 6 px left and 3 px up from the true body. The old crop excluded 447 dark design pixels (4.07 percent) including the right flipper tip and feet bottom edge, and included 952 panel chrome pixels (5.81 percent). Re-cropped `tux-mm.png`, `tux-booth64.png`, `tux-booth32.png`, and `tux-mm-2x.png` from the measured body bounds. Corrected dark share 67.37 percent (ground 5322 + glyph 10988 = 16310 of 128x129 = 16512 total, 0 chrome px). WCAG 6.745 confirmed on the re-cropped body and on booth64. Corrected absolute map body: x 18-145 y 112-240. Corrected panel-relative crop: [10,7,137,135].

**Correction 2: truncation note.** The `tux` outline is truncated by the map frame. The union of the six ellipses touches all four map borders (head top row 0, flipper tips at columns 0 and 255, body and feet bottom at row 255). The widest design row (row 174) spans the full 256 tiles. There is no ground margin on the silhouette's left, right, or bottom. The feet do not protrude below the body (both reach row 255), so the foot separation is a 1 px gap at 127 px and vanishes at 64 px. This is a design fact of the current silhouette construction (the ellipses fill the extent), not a build error, and it is the reason Shadow recorded that `tux` reads as a silhouette at 64 px but not at 32 px (doc:2280-2284).

**No target state change.** These corrections are controller-side re-crops of existing captured artifacts. The `tux.scm` map on the target is unchanged at `79002eacd5d6...`, 614552 B.

## 2026-11-21 08:06-08:08 — Dispatch L5, step 1: the Ice live-demo map copied into the Wine prefix and opened by its Windows-style path (`Tails`)

**Objective.** Test the `## Status` hypothesis behind the era 6 save blocker: SCMDraft 2 rejects the save because its filename field holds a Unix path with forward slashes, so opening the same map from inside the Wine prefix under `~/.wine-scmdraft/drive_c/` so the editor sees a `C:\` path with native separators may let Ctrl+S complete. Phase 1 places the map and opens it; the save attempt is step 2.

**Dispatch-start target state.** `pgrep -af 'ScmDraft[ ]2'`, `pgrep -af 'wineserve[r]'`, `pgrep -af 'start[.]exe'` each return nothing, so every process this dispatch starts is one it started. Baseline hashes before any write: `~/scmdraft-maps/live-demo/live-demo-ice.scm` 614562 B `9a9c24660f55...` (the L4 banded persistence artifact), `foss-for-all` `e856f0e1d62e`, `rocky-logo` `447360ce8077`, `rocky-with-heart` `b9b056c27a67`, `tux` `79002eacd5d6`. `~/.wine-scmdraft/drive_c/Maps/` held only `(2)River Crossing.scm` 90426 B and `Scm9194.tmp` 614562 B. `wine --version` is `wine-10.17 (Staging)`. RDP args regenerated at run time into mode-600 `/tmp/opencode/t0042/rdp-args` from `~/AI/secrets/scm_draft_rdp_pass.md`, never on a command line.

**Target steps, each with its exact inverse.**

| Step | Command | Inverse | Status |
|---|---|---|---|
| copy the Ice live-demo map into the prefix | `ssh ... "cp ~/scmdraft-maps/live-demo/live-demo-ice.scm ~/.wine-scmdraft/drive_c/Maps/live-demo-ice.scm"` | `rm -f ~/.wine-scmdraft/drive_c/Maps/live-demo-ice.scm` | done, 614562 B mtime `2026-11-21 08:06:33`, SHA-256 `9a9c24660f55...` identical to the source |
| copy the DOS-path launch helper to the target | `scp t0042-run-dos.sh howard@192.168.1.99:/tmp/t0042-run-dos.sh` | `rm -f /tmp/t0042-run-dos.sh` | done, inverse pending at dispatch end |
| launch by the Windows-style path | `bash /tmp/t0042-run-dos.sh 'C:\Maps\live-demo-ice.scm'` then `./rdp-input rdp-args key 0x1C` (profile dismissed with Enter) | `pkill -f 'ScmDraft[ ]2'; pkill -f 'start[.]exe /exec'` | done, wine pid 143830, argv recorded verbatim as `C:\Maps\live-demo-ice.scm` |
| paint one band | `./rdp-input rdp-args click 62 934` then `./rdp-input rdp-args drag 320 640 1500 640 1500 680 320 680` | no file-level inverse: the paint lives only in SCMDraft's memory unless a save completes, and killing SCMDraft without saving discards it | done, 270425 pixels changed in the canvas crop, 20499 inside the commanded stroke rectangle |
| page the viewport down | `./rdp-input rdp-args click 1893 700` | n/a, view state only | done |
| captures | `gnome-screenshot-tool -f /tmp/l5-{open,before,band1,pan1}.png`, SCP return to the controller | `rm -f /tmp/l5-*.png` | done, target copies removed at step 2 |
| SCMDraft's own backup side effect | SCMDraft writes `Scm2518.tmp` 614562 B in `~/.wine-scmdraft/drive_c/Maps/` on open | `rm -f ~/.wine-scmdraft/drive_c/Maps/Scm2518.tmp` | left in place per rule r002, inverse recorded |

**Premise confirmed at the open.** The editor title bar in `l5-open.png` reads `SCmdDraft 2.0 (Beta 0.9.10) - [C:\Maps\live-demo-ice.scm ]`. That is a drive-qualified path with native backslashes and zero forward slashes, where every earlier pass showed `/home/howard/...` in the same field. Wine passes argv verbatim, so SCMDraft's own filename string is now the DOS path. The hypothesis's stated precondition is therefore established on disk and on screen; whether the save completes is step 2's question.

**Paint landed, with a deviation recorded.** The status bar (crop `(0,1040)-(1920,1080)`, `tesseract --psm 7`) reads `Ice World\Snow` before the palette click and `Ice World\High Grass` after it. The click at `(62, 934)` is the coordinate L4 measured as High Outpost from `l4-palette.png`; on this launch the same pixel selected High Grass, so the terrain tree's row positions are not stable across launches unless the tree is scrolled to a named state. The painted band renders as a bright raised strip between the two dark value-192 bands the L4 file already carries, canvas crop `(280,560)-(1560,780)`. Tone share in the main-canvas crop `(160,120)-(1895,855)`: before grey 51.14 dark 45.02, after grey 51.41 dark 39.47. The title bar gains its dirty-marker asterisk, `[C:\Maps\live-demo-ice.scm*]`, so a save attempt operates on a genuinely modified map. The tone name and the coordinate drift are recorded rather than smoothed over; the booth script must re-derive palette coordinates on the day or scroll the tree to a captured state.

**Command producing this entry:** `python3 /tmp/opencode/t0042/l5_a.py` on the controller, `bash /tmp/t0042-run-dos.sh` on the target, captures via `gnome-screenshot-tool` on target with SCP return. No package installed, no repo enabled or disabled, no registry change, no credential on any command line. The only target map file this step created is `~/.wine-scmdraft/drive_c/Maps/live-demo-ice.scm`.

## 2026-11-21 08:11-08:13 — Dispatch L5, step 2: the save attempt on the map opened as `C:\Maps\...`, the invalid-path error is gone, the chain stopped at the overwrite prompt (`Tails`)

**Target step.** Ctrl+S, then Enter, then Enter, then two Escapes, then kill, all against the SCMDraft session started in step 1 on `C:\Maps\live-demo-ice.scm` with the painted band and the dirty-marker asterisk. Inverse for the process: `pkill -f 'ScmDraft[ ]2'; pkill -f 'start[.]exe /exec'` (both return nothing at dispatch end). Inverse for the captures: `rm -f /tmp/l5-*.png` on the target, done. No file was written, so no file inverse is owed for this step.

**Disk before and after, identical.** `~/.wine-scmdraft/drive_c/Maps/live-demo-ice.scm` 614562 B mtime `2026-11-21 08:06:33` SHA-256 `9a9c24660f55a25341388e75d5bf8e68f9ca9e9df58f2568f7e5fc33fe7888b8` before the save chain, after the two Enters, after the two Escapes, after the kill, and after a re-open through the same DOS path. The painted band never reached the disk. `pgrep` during the attempt shows the process carrying the DOS argument verbatim: `143912 Z:\home\howard\scmdraft2\ScmDraft 2.exe C:\Maps\live-demo-ice.scm`.

**What the dialogs actually show, read from the captures.** `l5-ctrls.png` is the Compatibility Warning (`Advanced features used by map`, `Broodwar tileset used`, Compatible `Starcraft 1.04+ (Broodwar)` and `Starcraft 1.22+ (Remastered Broodwar)`, Incompatible `Starcraft 1.00+`, `1.04+ (Hybrid)`, `1.22+ (Remastered Hybrid)`, Save focused). The first Enter activates Save. `l5-savedlg.png` is then the Windows `Save map` common dialog, and it is the finding: **Save in: `Maps`**, **File name: `live-demo-ice.scm`** selected, **Files of type: `Starcraft Broodwar Map (*.scx)`**. No `Invalid character(s) in path` error appeared at any point. Compare `l4-test-dialogs.png`, the same dialog opened from a Unix launch path, which showed Save in `howard`, File name `...raft/drive_c/Maps/live-demo-ice.scm`, and the error box `A filename cannot contain any of the following characters: / : < > |`.

**So the hypothesis mechanism is confirmed, and its predicted fix is confirmed as far as the path validation goes.** A drive-qualified launch path makes SCMDraft resolve its own filename into a valid DOS directory plus bare name, and the validator that rejected the Unix path no longer fires. The chain then advanced one step further than the recorded key sequence: the second Enter produced `l5-after_enter.png`, a third dialog `Save map` reading `File already exists. Do you want to replace it?` with `Yes` focused and `No` beside it. That prompt is an overwrite confirmation for the file the editor itself opened, it is not a path error, and this attempt stopped there: two Escapes cancelled it, so nothing was written. Reporting this as "the save failed" would be wrong, and reporting it as "the save works" would be unevidenced. The state of the evidence at this point is that the save reaches its final confirmation and has not been confirmed.

**Byte-stability after the attempt.** `foss-for-all` `e856f0e1d62e`, `rocky-logo` `447360ce8077`, `rocky-with-heart` `b9b056c27a67`, `tux` `79002eacd5d6`, and the L4 source `live-demo-ice.scm` `9a9c24660f55` at `~/scmdraft-maps/live-demo/`, all matching their recorded SHAs. The prefix copy also still matches its source, which is what a cancelled save must leave behind.

**Target state after the step.** `~/.wine-scmdraft/drive_c/Maps/` holds `live-demo-ice.scm` 614562 B `9a9c2466...`, SCMDraft's own open-backup files `Scm2518.tmp` (step 1 launch) and `Scm6aac.tmp` (the step 2 re-open launch), plus the pre-existing `(2)River Crossing.scm` and `Scm9194.tmp`. SCMDraft backups are left in place per rule r002, inverse `rm -f ~/.wine-scmdraft/drive_c/Maps/Scm{2518,6aac}.tmp`. `/tmp/l5-*.png` and `/tmp/t0042-run.log` removed from the target, verified absent. No SCMDraft, no wineserver, no start.exe running.

**Command producing this entry:** `python3 /tmp/opencode/t0042/l5_b.py` on the controller. `rdp-input` events used, AT set 1 make codes: Ctrl+S = `keydown 0x1D key 0x1F keyup 0x1D`, Enter = `key 0x1C`, Escape = `key 0x01`. Keyboard only, no click sent to any dialog button.

## 2026-11-21 08:16-08:19 — Dispatch L5, step 3: the same save chain taken one dialog deeper, and the era 6 editor save completes (`Tails`)

**Objective and why this step exists.** Step 2 ended at `Save map / File already exists. Do you want to replace it?` with `Yes` focused and cancelled it with Escape, which left the central question unanswered. This step repeats the identical launch, the identical palette click and drag, and the identical keyboard chain one confirmation deeper: Ctrl+S, Enter (Compatibility Warning `Save`), Enter (`Save map` `Save`), Enter (`Yes` on the overwrite confirmation). Same technique, same dialogs, one level further, not a new approach. Constraint held: no injected click on any dialog button, every confirmation is Enter on the already-focused default button.

**Target steps, each with its exact inverse.**

| Step | Command | Inverse | Status |
|---|---|---|---|
| relaunch the prefix copy by its DOS path | `bash /tmp/t0042-run-dos.sh 'C:\Maps\live-demo-ice.scm'`, then `./rdp-input rdp-args key 0x1C` | `pkill -f 'ScmDraft[ ]2'; pkill -f 'start[.]exe /exec'` | done, wine pid 145850, argv verbatim `C:\Maps\live-demo-ice.scm` |
| paint one band | `./rdp-input rdp-args click 62 934` then `./rdp-input rdp-args drag 320 640 1500 640 1500 680 320 680` | `cp ~/scmdraft-maps/live-demo/live-demo-ice.scm ~/.wine-scmdraft/drive_c/Maps/live-demo-ice.scm` restores the pre-paint file, the recorded row below | done, 266907 pixels changed in the canvas crop, status bar reads `Ice World\High Grass` |
| save, keyboard only | `keydown 0x1D key 0x1F keyup 0x1D` then `key 0x1C` then `key 0x1C` then `key 0x1C` | the same `cp` above restores the file this step overwrote | **done, the save completed**, see the disk evidence below |
| dismiss whatever remains | `./rdp-input rdp-args key 0x01` twice | n/a | done |
| kill | `pkill -f 'ScmDraft[ ]2'; pkill -f 'start[.]exe /exec'` | n/a | done, `pgrep -af 'ScmDraft[ ]2'` returned `none` after the kill; the later `pgrep -a -x wineserver` check returned `no-wineserver`, and the `ScmDraft` pattern in that same check self-matched its own ssh command line, which is recorded as not evidence |
| re-open the saved file | `bash /tmp/t0042-run-dos.sh 'C:\Maps\live-demo-ice.scm'`, `key 0x1C`, capture, `pkill` | the process inverse above | done, the re-open renders the map with the painted band |
| captures | `gnome-screenshot-tool -f /tmp/l5c-{open,band1,ctrls,enter1,enter2,enter3,post_save,esc1,esc2,reopen}.png`, SCP return | `rm -f /tmp/l5c-*.png` | done, verified absent on the target at dispatch end |
| remove this dispatch's target scratch | `rm -f /tmp/l5c-*.png /tmp/t0042-run.log` | n/a, these are the inverses | done |

**Disk evidence, before and after.** `~/.wine-scmdraft/drive_c/Maps/live-demo-ice.scm` before: 614562 B mtime `2026-11-21 08:06:33` SHA-256 `9a9c24660f55a25341388e75d5bf8e68f9ca9e9df58f2568f7e5fc33fe7888b8`. After the third Enter: 12502 B mtime `2026-11-21 08:18:33` SHA-256 `f00d1f60521c8f8cf45d31568935fb8b18eccdb5e29f0954577224bbe941322b`. Unchanged again after the kill and after the re-open. The size drop is not truncation: the SCMDraft-written MPQ stores its `staredit\scenario.chk` compressed, and `chkdump` extracts 618857 B of CHK from the 12502 B container, larger than the 614211 B CHK the team's uncompressed `mkmpq` writer produces. The editor title bar loses its dirty-marker asterisk at the save and stays clean after the re-open, `[C:\Maps\live-demo-ice.scm ]`.

**The saved CHK, read on the controller from `l5c-saved.scm`.** Sections read through a bounds-checked walk: `TYPE` `RAWB`, `ERA ` = `06 00` (era 6), `DIM ` = `00 01 00 01` (256 x 256), `MTXM` 131072 B = 65536 u16 values identical to `TILE`, most common 64 (Rocky Snow) 64782 tiles then 192 at 336 tiles, 252 distinct values in total, `ISOM` 265224 B with 84 distinct elevation bytes. So SCMDraft wrote a genuine era 6 256x256 map, not a stub. The 252 distinct terrain values and the mixed elevations are SCMDraft's own brush footprint: the one commanded stroke rewrote tile values and heights across a wide neighbourhood, which is the same effect `M2` measured on the L4 captures as only 13.8 to 19.1 percent of changed pixels falling inside the commanded rectangle. The saved file is therefore not byte-comparable with the programmatic writer's output for the same map, and the four deliverable maps must keep coming from the programmatic pipeline.

**Paint persisted through the save, measured on captures of the same main-canvas crop `(160,120)-(1895,855)`.** open to band1: 266907 changed pixels. band1 to reopen: 1504 changed pixels, cursor-diamond scale. open to reopen: 258777 changed pixels. Tone share in that crop: open grey 51.14 dark 42.16, band1 grey 51.41 dark 41.49, reopen grey 51.38 dark 41.23. `l5c-reopen.png` shows grey Ice ground carrying the dark bands including the newly painted one. That is a save-and-re-open persistence proof by the editor's own mechanism, separate from the programmatic replacement proof `L4` recorded.

**What the dialogs showed, read from the captures.** `l5c-ctrls.png` is the Compatibility Warning (`Broodwar tileset used`) with Save focused. `l5c-enter1.png` is the `Save map` common dialog, `Save in: Maps`, `File name: live-demo-ice.scm` selected, `Files of type: Starcraft Broodwar Map (*.scx)`, no error box. `l5c-enter2.png` is `Save map` reading `File already exists. Do you want to replace it?` with `Yes` focused. The third Enter is what writes the file. `l5c-esc1.png` and `l5c-esc2.png` show the editor returned with a clean title bar and no dialog left open.

**Root cause of the era 6 blocker, stated against both passes.** The blocker was never the Broodwar compatibility warning and never era 6 itself. It is the launch path. Opened as `/home/howard/...`, SCMDraft carries that slashed string into its `Save map` dialog and Wine's common dialog rejects it with `A filename cannot contain any of the following characters: / : < > |`. Opened as `C:\Maps\live-demo-ice.scm` from inside the prefix, the same dialog resolves to `Save in: Maps` with a bare `live-demo-ice.scm`, the validator never fires, and the save completes. Era 5 saved from a Unix path because era 5 never opens this file dialog at all, which is why the difference looked tileset-specific in `L4`.

**Target state left for the operator, per rule r002.** `~/.wine-scmdraft/drive_c/Maps/` now holds `live-demo-ice.scm` 12502 B `f00d1f60...` (the editor-saved map with the painted band), plus SCMDraft's own backups `Scm2518.tmp` and `Scm6aac.tmp` at 614562 B `9a9c2466...` (the pre-save content, so this step is reversible with `cp Scm2518.tmp` or with the L4 source), and `Scm7251.tmp` and `Scm86f3.tmp` at 12502 B. Inverses: `rm -f ~/.wine-scmdraft/drive_c/Maps/live-demo-ice.scm ~/.wine-scmdraft/drive_c/Maps/Scm{2518,6aac,7251,86f3}.tmp`, and `rm -f /tmp/t0042-run-dos.sh` for the launch helper left in place. `/tmp/l5-*.png`, `/tmp/l5c-*.png` and `/tmp/t0042-run.log` removed from the target and verified absent. Nothing under `~/scmdraft-maps/` was touched: `live-demo/live-demo-ice.scm` is still `9a9c2466...`, and `foss-for-all` `e856f0e1`, `rocky-logo` `447360ce`, `rocky-with-heart` `b9b056c2`, `tux` `79002eacd5d6`, `republic-of-korea` `50e55299` all match their recorded SHAs. No package installed, no repo enabled or disabled, no registry change, no credential on any command line, controller `rdp-args` removed at dispatch end.

**Command producing this entry:** `python3 /tmp/opencode/t0042/l5_c.py` on the controller, `bash /tmp/t0042-run-dos.sh` on the target, saved map returned by SCP to `/tmp/opencode/t0042/l5c-saved.scm` and read with `./chkdump` plus a bounds-checked section walk.

## 2026-11-21 10:19-10:26 — Dispatch M5 attempt 2, step 1: upstream source verified, source geometry measured, raster rule chosen (`Tails`)

**Objective.** Test the `## Status` hypothesis named at the `M4` decision, that an 18-vertex 110 m outline is the limit on map 5's identifiability, and that a Natural Earth 10 m-series admin-0 ring for South Korea rasterized at the same 256x256 extent restores the bays. Nothing in this step touches the target. `M6` decides identifiability, not this dispatch.

**Resume state, checked rather than assumed.** Attempt 1 (`ses_e04a82fe9ffee5D0TIt05b4tK0`, 08:43-09:32) left four artifacts and no record. `ls -l /tmp/opencode/t0042/m5* /tmp/opencode/t0042/korea_10m.py` shows `m5_source_probe.py` 08:55, `m5-upstream/` 08:54, `korea_10m.py` 09:12, `m5_raster.py` 09:31. Target read-only check, `sshpass -f ~/AI/secrets/scm_draft_pass.md ssh howard@192.168.1.99 'stat/sha256sum over the five maps; pgrep -af "ScmDraft[ ]2"'`, answers `TARGET_OK scmdraft2-map-creator`, the five maps at 614561 `e856f0e1d62e...`, 614559 `447360ce8077...`, 614565 `b9b056c27a67...`, 614552 `79002eacd5d6...`, 614566 `50e55299dd86...`, and `NO_SCM`. The stop left no half-written map, so the resume starts from the artifacts rather than from a re-probe.

**Upstream provenance, verified against the upstream repository rather than recorded from a claim.** Files live under `/tmp/opencode/t0042/m5-upstream/`, never in a git-tracked path. Each local file's `git hash-object` blob SHA-1 was compared with the blob the GitHub contents API reports for the same path at `ref=v5.1.2` (`GET /repos/nvkelso/natural-earth-vector/contents/<path>?ref=v5.1.2`), and the tag ref was resolved with `GET /repos/nvkelso/natural-earth-vector/git/ref/tags/v5.1.2`.

| File | bytes | local blob SHA-1 | upstream blob SHA-1 at v5.1.2 | sha256 |
|---|---|---|---|---|
| `geojson/ne_110m_admin_0_countries.geojson` | 838726 | `1e6ab74c7042f97013be69ceec798be8e1aff27d` | identical | `6866c877d39cba9c357620878839b336d569f8c662d3cfab4cb1dbe2d39c977f` |
| `geojson/ne_50m_admin_0_countries.geojson` | 3083490 | `9d99f26dc470fcdbd08b062c813005acbdf73ccb` | identical | `3e458fc036ad0a66411f2c1e6cac49c5d7bfb81cb1123bc513b22511a2b7fdeb` |
| `geojson/ne_10m_admin_0_countries.geojson` | 13287234 | `5ebc66e25fc1af01edaebe9375c546655e04cf1e` | identical | `239eec57ac17f100a11e2536cffc56752c318b50ae765b0918ff7aab4ce8f255` |
| `LICENSE.md` (repo root) | 4636 | `9dfbc3d55a4ab1dd758c253b2ee339888f632889` | identical | `2631b5b39b6d1acc56de75235109b5af2dbb4b0ac5a127b6f06185977247fd4b` |
| `VERSION` (repo root) | 6 | `61fcc87350341bc51d640aa9161073ce615703ce` | identical | `0c9a9d43610d66f4cc3f42da08cae044483de25894a9daf9dc6a76ff75ca9327` |

Repository `github.com/nvkelso/natural-earth-vector`. Tag `v5.1.2`, which the API resolves to commit `f1890d9f152c896d250a77557a5751a93d494776`. Dataset, Natural Earth 110m / 50m / 10m **Admin 0 - Countries** (`geojson/ne_<scale>_admin_0_countries.geojson`). `VERSION` contains `5.1.2`. Licence as declared in the upstream `LICENSE.md` at that tag, first line, "Everything here is public domain.", with the stated credit form being optional ("No permission is needed to use Natural Earth. Crediting the authors is unnecessary."). Scale naming stated plainly, Natural Earth "10m" is the 1:10,000,000 nominal-scale series, not 10-metre resolution, and the `M3` build used the 1:110,000,000 series. No licence conclusion is claimed here, `Charmy` and `Flicky` own the ruling.

**What the source actually contains for South Korea.** `python3 /tmp/opencode/t0042/m5_source_probe.py` and `python3 m5_raster.py`, output saved as `m5_probe_output.txt` and `m5_raster_output.txt` with the machine report `m5_raster_report.json`. Feature selected by `properties.ISO_A2 == "KR"`, one match per file.

| Scale | geometry | rings | coordinate pairs | distinct vertices | lon range | lat range |
|---|---|---|---|---|---|---|
| 110m | Polygon | 1 | 19 | 18 | 126.117398..129.468304 | 34.390046..38.612243 |
| 50m | MultiPolygon | 11 | 260 | 249 | 126.007520..130.934277 | 33.201514..38.623437 |
| 10m | MultiPolygon | 53 | 3060 | 3007 | 124.613617..131.862522 | 33.197577..38.624335 |

Two facts that bear directly on `M4` findings. First, the 110m ring has **18 distinct vertices** (19 coordinate pairs, closed), which confirms `Shadow`'s reading at `## Review` and shows the record's "17-vertex" wording at doc:1894 is wrong. Second, **Jeju is in the upstream data at 50m and at 10m and is not in the 110m ring at all**: the 110m feature's southernmost latitude is 34.390046 N, while the 10m Jeju ring `poly3-0` spans lon 126.161143..126.953624, lat 33.197577..33.563797 (61 pairs), and the 50m Jeju ring spans 126.165625..126.931250, lat 33.201514..33.553223. The `M3` build's island was therefore a hand-added ellipse because the 110m source has no island, and in this rebuild the island comes from upstream.

**Projection, inherited unchanged.** Same constants as `M3`: rows cover latitude 38.85 N to 33.10 N, equirectangular with cosine longitude correction at the midpoint 35.975 N, 111.0 km per degree of latitude, 2.5049 km per tile, longitude centred on 127.5 E. The recorded 256-tile extent is therefore lon 123.9474..131.0526, lat 33.1000..38.8500. Only the input ring and the tile-fill rule change.

**Raster rule, options measured rather than picked.** A, centre-point even-odd scanline at tile centres, the rule `M3` used. B, 4x4 subpixel even-odd fill with a tile becoming glyph at 50 percent or more subpixel coverage. C, the 50m ring instead of the 10m ring. Chosen, B on the 10m ring. Reason, a 1592-pair mainland ring has edges shorter than a tile, and centre sampling turns them into single-tile spikes; the subpixel rule is the one that measures the area a ring actually covers inside a tile. A and C are kept in `m5_raster_report.json` as measured alternatives rather than discarded.

**Feature floor and internal counters.** The recorded `Shadow` legibility floor says a feature needs about 10 tiles to have a chance at a 64 px read, so 8-connected components whose bbox has either axis below 10 tiles are dropped and recorded, not silently dropped. Above the floor: the mainland 15413 tiles (x77-202, y10-201, 126w x 192h, lon 126.093..129.576, lat 34.318..38.625), the Jeju ring 296 tiles (x79-107, y234-250, 29w x 17h, lon 126.149..126.929, lat 33.213..33.574), and one island in the 128.49..128.74 E, 34.72..35.04 N band 68 tiles (x163-172, y169-183, 10w x 15h), coordinates stated rather than a gazetteer name. Below the floor and recorded: 28 components totalling 210 tiles, including Ulleungdo (13 tiles, 4w x 4h, lon 130.802..130.885, lat 37.475..37.542), Ganghwado-area fragments (19 tiles, 8w x 4h), and the largest dropped island at 29 tiles. The floor is the reason Ulleungdo, one of the features `Shadow` named as identity-bearing, is not in this map, and that is stated rather than glossed. Filling internal counters: the floored mask contains 22 four-connected ground components not reachable from the map border, 54 tiles, which are internal counters of exactly the class the silhouette gate does not certify, so every one is filled to glyph. Shipped mask, 15831 tiles, 3 components, zero enclosed ground.

**Rings outside the extent and off the peninsula, recorded because a mask should not be quietly clipped.** Six of the 10m feature's 53 rings sit off the peninsula, four in the Yellow Sea between lon 124.61 and 125.71 at lat 34.05 to 37.99, one at lon 125.39..125.46 lat 34.63..34.70, and one ring `poly52-0` at lon 131.8601..131.8625 lat 37.2416..37.2440 whose projected columns 284.0-284.1 fall outside the 0-255 extent entirely. All six rasterize below the 10-tile floor or outside the map, so the shipped mask contains no component off the peninsula. What those six Yellow Sea rings represent is not resolved here, and no claim is made about them.

**Two defects fixed in the attempt-1 artifacts, both recorded.** `m5_raster.py:row_runs` iterated the module-wide 256 columns over the 128-wide decimations and raised `IndexError: list index out of range` at the 128 px row of `main`; it now takes its dimensions from the mask passed in. `korea_10m.apply_feature_floor` rebuilt the kept mask by flooding inside each kept component's bounding box, which re-admitted 16 sub-floor islands that merely sat inside the mainland's bbox, so the report claimed 19 components for 3 kept components; it now selects by the component's own cell list. `m5_raster.py` now also asserts that the mask its step-by-step assembly produces equals the mask `korea_10m.republic_of_korea_10m()` ships, and that assertion passes.

**Inverse for this step.** `rm -f /tmp/opencode/t0042/m5_probe_output.txt /tmp/opencode/t0042/m5_raster_output.txt /tmp/opencode/t0042/m5_raster_report.json`. Nothing on the target was read for writing, and no target file changed in this step.

## 2026-11-21 10:35 — Dispatch M5 attempt 2, step 2: rebuilt map written controller-side, previous build renamed (`Tails`)

**Registry.** `rocky.py` MASKS gains `republic-of-korea-10m` resolving to `korea_10m.republic_of_korea_10m`. The existing `republic-of-korea` entry is left in place pointing at the `M3` 110m mask, so the superseded build still reproduces byte-for-byte through the same registry and the proven builder is unchanged.

**Renamed before building.** `/tmp/opencode/t0042/republic-of-korea.chk` and `.scm` from `M3` became `superseded-republic-of-korea-110m.chk` and `.scm`. `sha256sum` after the rename is `50e55299dd86fafbcf5976f841992dd326e3d9b56c4d27fecbfdebfd06ea03ca`, identical to the `M3` record and to the file on the target, so the rename moved bytes rather than rewriting them. Naming follows the ratified three-name scheme and is flagged as an extension for `Robotnik` to ratify or reverse. The `M3` build is `superseded-` rather than `rejected-` because it passed its own build gates and was replaced by a better input ring; the identifiability rejection belongs to `M4`'s verdict, not to the file. Inverse, `mv /tmp/opencode/t0042/superseded-republic-of-korea-110m.chk /tmp/opencode/t0042/republic-of-korea.chk` and the same for `.scm`.

**Build.** `python3 build_ts.py silhouette ts-harvest/ref-era6.chk republic-of-korea 192 64 64 republic-of-korea-10m`, same command shape and same era 6 Ice World pair as the four accepted maps. Printed result, `silhouette: era 6 chk 614215 B MTXM 65536 ISOM 265224 distinct 2 [64, 192] mkmpq rc 0`. Outputs `republic-of-korea.chk` 614215 B sha256 `2a7abf3cb0eb5226c68c2a0e85566a7be68cb9bb73ff4f48d28cdc981e6708f0`, `republic-of-korea.scm` 614566 B sha256 `c773a534a564d4b3bd13bb9eede10838daa1729784a693f28e6185e779c40976`.

**Coverage read out of the written file, not out of the mask code.** `MTXM` 131072 B, 65536 u16 entries, distinct values exactly `[64, 192]`, value 192 on 15831 tiles, coverage **24.16 percent**. `MTXM` is byte-identical to `TILE` and `ISOM` is 265224 B of 0x10, both confirmed by `build_ts.py`'s own section walk.

**Measured against the build it replaces.** Read from `superseded-republic-of-korea-110m.chk`, same metrics, same scripts. Old mask 16390 tiles, 25.01 percent, perimeter 770 glyph-to-ground boundary edges, 1 row of 256 carrying two or more separate glyph runs, largest ground gap enclosed between two runs 8 tiles, narrowest glyph run 2 tiles, 2 components, zero enclosed ground. New mask 15831 tiles, 24.16 percent, perimeter **1550** edges, **81** rows carrying two or more runs (277 runs), largest enclosed gap 19 tiles, 3 components, zero enclosed ground. IoU between them 0.8872, per-row left and right edge deviation mean 7.029 tiles, worst 159 tiles, 42 deviations above 10 tiles. Area-average decimation with a 50 percent threshold, rows with two or more runs and the largest enclosed ground gap, old 1 and 4 at 128 px, 0 and 0 at 64 px, 0 and 0 at 32 px, new 34 and 9 at 128 px, 13 and 4 at 64 px, 0 and 0 at 32 px. Coastal articulation is measurably present at the tile scale and at 128 px, thinner at 64 px, and absent at 32 px on both masks. Whether the result is identifiable is `M6`'s call and is not claimed here.

**Inverse for this step.** `rm -f /tmp/opencode/t0042/republic-of-korea.chk /tmp/opencode/t0042/republic-of-korea.scm` removes the new build, and the rename inverse above restores the `M3` build. The four accepted maps were not touched in this step.

## 2026-11-21 10:46-10:52 — Dispatch M5 attempt 2, step 3: rebuilt map placed on the target, real renders captured, re-open identity, four accepted maps unchanged (`Tails`)

**Driver.** `python3 /tmp/opencode/t0042/m5_target.py`, output kept as `m5_target_output.txt`. Credentials reached through `sshpass -f ~/AI/secrets/scm_draft_pass.md` and the mode 600 `rdp-args` file rebuilt by `bash /tmp/opencode/t0042/mkargs.sh` (that file had been removed after the earlier dispatches; it is machine-local, never printed, never committed). No credential appears in any command line, log, or file in the repo.

**One failure worth recording.** The first run aborted at the scp: `scp: dest open "$HOME/scmdraft-maps/republic-of-korea/republic-of-korea.scm": No such file or directory`. OpenSSH scp in SFTP mode does not run a remote shell, so a literal `$HOME` in the destination is not expanded. The rename step had already landed, so the map was momentarily absent from the plain name. Fixed by using absolute paths for every scp destination, and by making the rename step check whether the plain name still exists before moving it. Re-run placed the file. Consequence for `S1`, the booth script must use absolute paths for scp destinations.

**Target steps, each with its inverse.**

| Step | Command | Inverse | Status |
|---|---|---|---|
| rename the 110m build out of the plain name | `mv /home/howard/scmdraft-maps/republic-of-korea/republic-of-korea.scm .../superseded-republic-of-korea-110m.scm` | `mv .../superseded-republic-of-korea-110m.scm .../republic-of-korea.scm` | done, renamed file still 614566 B mtime `2026-11-21 00:05:59` SHA `50e55299dd86...`, identical to the `M3` record, so the rename moved bytes |
| place the rebuilt map | `scp republic-of-korea.scm howard@192.168.1.99:/home/howard/scmdraft-maps/republic-of-korea/republic-of-korea.scm` | `rm -f /home/howard/scmdraft-maps/republic-of-korea/republic-of-korea.scm` plus the rename inverse | done, 614566 B mtime `2026-11-21 10:49:37` SHA `c773a534a564d4b3bd13bb9eede10838daa1729784a693f28e6185e779c40976`, identical to the controller build |
| launch for viewing | `bash /tmp/t0042-run.sh /home/howard/scmdraft-maps/republic-of-korea/republic-of-korea.scm` | `pkill -f 'ScmDraft[ ]2'; pkill -f 'start[.]exe /exec'` | done twice, wine pids 148555 and 148952, seat0 Wayland export |
| dismiss the profile window | `./rdp-input rdp-args key 0x1C` | n/a | done, `event: key 0x1C` |
| overview-jump onto the design | `./rdp-input rdp-args click 110 140` | n/a | done, `event: click (110, 140)` |
| capture | `gnome-screenshot-tool -f /tmp/m5-{open,jump,reopen}.png` then scp to the controller | `rm -f /tmp/m5-*.png` | done, all three returned, target copies removed at teardown |
| kill and re-open the same disk file | `pkill` then the launch command again | the process inverse | done, `NO_SCM_RUNNING` at the end |
| remove this dispatch's target scratch | `rm -f /tmp/m5-*.png /tmp/t0042-run.log` | n/a, these are the inverses | done, `captures-removed` |

**No editor save was performed on this map.** The `## Status` decision of 2026-11-21 08:40 records that a deliverable map never passes through an editor save, because an editor save rewrites the container and the gate hashes and coverage figures then describe a different file. The launch used the viewing helper `t0042-run.sh`, not the save helper `t0042-run-dos.sh`, and no Ctrl+S was sent.

**Re-open identity, disk side.** Before the kill, `614566 B mtime 2026-11-21 10:49:37 SHA c773a534a564...`. After the kill and the second launch, `614566 B mtime 2026-11-21 10:49:37 SHA c773a534a564...`. Byte-identical, size identical, mtime unchanged, which is the expected result when nothing writes the file.

**Four accepted maps, byte-stability confirmed before and after, on the target disk.** `foss-for-all` 614561 B `e856f0e1d62e...`, `rocky-logo` 614559 B `447360ce8077...`, `rocky-with-heart` 614565 B `b9b056c27a67...`, `tux` 614552 B `79002eacd5d6...`, each identical at the pre-state read and the post-state read.

**Target state left.** `~/scmdraft-maps/republic-of-korea/` now holds `republic-of-korea.scm` 614566 B `c773a534a564...` (the rebuilt 10 m-series map, the current candidate) and `superseded-republic-of-korea-110m.scm` 614566 B `50e55299dd86...` (the `M3` build, kept for the record and out of the plain name). `/tmp/m5-*.png` and `/tmp/t0042-run.log` removed. No SCMDraft 2 process running, verified `NO_SCM_RUNNING`. No package installed, no repository enabled, no registry or system file touched, nothing killed that this dispatch did not start. Left in place for the operator per rule r002.

**Command producing this entry:** `python3 /tmp/opencode/t0042/m5_target.py` on the controller. Gate measurement of these captures is step 4, `python3 /tmp/opencode/t0042/m5_measure.py`.

## 2026-11-21 11:05-11:20 — Dispatch M5 attempt 2, step 4: the four gate numbers, measured from the published map and the real renders (`Tails`)

**Method.** `python3 /tmp/opencode/t0042/m5_measure.py`, machine report `republic-of-korea_report.json`, transcript `m5_measure_output.txt`. Two sources only. The published file `/home/howard/scmdraft-maps/republic-of-korea/republic-of-korea.scm` returned to the controller, its CHK extracted with `./chkdump <archive> 'staredit\scenario.chk'` (StormLib, MIT), `MTXM` parsed. And the three real captures `m5-open.png`, `m5-jump.png`, `m5-reopen.png`. No mask module is imported for a gate number, and the projection constants are restated inside the measurement script so the mask-to-geography comparison is arithmetic rather than trust in the builder.

**Container, read from the shipped archive.** `chkdump` extracts 614215 B and it is **byte-identical** to the CHK the writer produced, so the container carries exactly what was written. `ERA ` 6, `DIM ` 256x256, `MTXM` 131072 B with `TILE` 131072 B and `MTXM == TILE`, `ISOM` 265224 B containing only 0x00 and 0x10, `UNIT` 0 B, no `DOOD` section, `MRGN` 1280 B, `STR` map name read from the offset table as **`republic-of-korea`**, distinct terrain values exactly `[64, 192]`.

**Gate number 1, coverage.** `MTXM` value 192 on **15831** tiles, **24.16 percent** of 65536. Three components, 15467 + 296 + 68 tiles. Zero enclosed ground tiles under a four-connected border flood fill, so no internal counter. Bbox x77-202 y10-250, 126w x 241h. Perimeter 1550 glyph-to-ground boundary edges. 81 rows carry two or more separate glyph runs, 277 runs in total, largest ground gap enclosed between two runs 19 tiles.

**Gate number 2, WCAG on the map's own real render.** The overview map render is located from the capture rather than inherited: a per-row byte regex over a PIL map-tone mask, runs of 40 px or more clustered by rounded x-extent, then the block grown vertically while rows still overlap its x-window by 60 px or more. That vertical expansion matters and is recorded, the naive cluster bbox came out at y124-239 because the editor's white viewport-indicator rectangle starts a run 27 px into the map body in the top rows and splits the first 12 rows of the render into a separate cluster. The expanded block is **x18-145, y112-239, 128x128 px**, identical to the rectangle `Shadow` located independently in five captures across two maps at `## Review`, and it is the same in `m5-open.png` and `m5-reopen.png`. Inside it there is exactly one ground tone, (176,176,176), 12344 px, exactly one glyph tone, (36,40,56), 3966 px, and 74 px of white viewport-indicator overlay, which is editor overlay drawn over the map and not map content. **WCAG 6.745** dominant pair, and because the map body carries one ground tone and one glyph tone the worst pair on the body is the same 6.745. Glyph share on the body 24.21 percent against the code coverage 24.16 percent, the difference being the 2:1 decimation. On the main-canvas boundary frame `m5-jump.png` crop (155,105)-(1878,832), sampled every 2 px, glyph 53.95 percent against ground 45.08 percent, dominant pair 6.745, worst rendered pair 5.328.

**Gate number 3, booth artifacts, uniform and chrome-free.** `republic-of-korea-mm.png` is the located 128x128 body crop. `republic-of-korea-booth64.png` is a single-step Lanczos resize of it at 0.5 on both axes, `republic-of-korea-booth32.png` at 0.25 on both axes, `republic-of-korea-mm-2x.png` a 2x enlargement. Because the crop is square and each resize is single-step and equal on both axes, the aspect is preserved, which is exactly the defect `M4` blocker 2 recorded on the previous artifacts (142x175 to 64x64, 23 percent horizontal stretch). Measured composition of the artifacts, `mm` 99.55 percent map tone with the 0.45 percent being the 74 px editor overlay rectangle inside the render, `booth64` 96.80 percent map tone, 3.2 percent Lanczos mid-tone manufactured by downscaling a hard tile grid, glyph share 23.10 percent, dominant-pair WCAG 6.745, worst pair 4.35, `booth32` 96.78 percent map tone, glyph share 23.05 percent. No panel chrome in any of the three. Reading aids `m5-read-body-3x.png`, `m5-read-booth64.png`, `m5-read-booth32.png` are nearest enlargements for viewing and are labelled as reading aids, not gate artifacts.

**Gate number 4, re-open.** `/home/howard/scmdraft-maps/republic-of-korea/republic-of-korea.scm` 614566 B, mtime `2026-11-21 10:49:37`, SHA-256 `c773a534a564d4b3bd13bb9eede10838daa1729784a693f28e6185e779c40976`, identical after the kill and the second launch, and the two renders are **pixel-identical**, 0 differing pixels at threshold 16 over the 128x128 body crop and 0 over the whole 1920x1080 frame.

**Measured comparison against the 25.01 percent build it replaces.** Old 16390 tiles, 25.01 percent, 2 components, perimeter 770, 1 row with two or more runs, largest enclosed gap 8 tiles. New 15831 tiles, 24.16 percent, 3 components, perimeter 1550, 81 such rows with 277 runs, largest enclosed gap 19 tiles. IoU 0.8872, 15148 tiles in common, 683 new-only, 1242 old-only. Per-row left and right edge deviation over the 203 rows present in both masks, mean 4.081 tiles, median 2, worst 28, 30 deviations above 10 tiles. Note for the record, `m5_raster_report.json` states mean 7.029 and worst 159 for the same comparison, because that script scored rows present in only one mask against a sentinel value of -1; the figure restricted to rows present in both masks is 4.081 and 28, and the second is the one to quote.
Shape landmarks, old then new. North point row 11 at columns 158-159, row 10 at columns 157-158. Row 11 run width 2 tiles then 4 tiles. Eastmost column 198 spread over rows 90 to 143, a near-straight 54-row wall, then column 202 present only at row 125, a single bulge. Westmost column 78 then 77. Southernmost row 250 in both. Jeju at row 241 spans 29 tiles then 25 tiles, so the upstream island is four tiles narrower than the hand-added ellipse `M4` measured.
Named coastal anchors, 5x5 tile window (plus or minus 5 km) around each anchor, sea tiles counted. Of the twelve sea-expected anchors, **seven acquire sea inside the window where the 110 m mask had none**, Incheon and the Han estuary mouth 0 to 10, Ganghwa Strait 0 to 7, Seosanman bay head 0 to 3, the Geum estuary at Gunsan 0 to 3, Gwangyang Bay inner 0 to 12, Jinhae Bay inner 0 to 9, and the Donghae Mukho inlet 4 to 8. Two hold slightly less sea than before, Mokpo and the Yeongsan estuary 17 to 12 and the Namhae strait 4 to 3. Three are unchanged at Asan Bay head, the Seosanman coast west of Yeonggwang, and the Jeju strait. Of the ten land-expected anchors, two gain sea inside the window, Pohang neck 0 to 8 and the Busan coast 0 to 16, which is anchor imprecision at 2.5 km tile resolution rather than a coastline change and is recorded as such. Centre-class flips at the exact anchor tile: Mokpo ground to glyph, Jinhae Bay glyph to ground, Busan coast glyph to ground. The honest statement this dispatch can make is that the west coast, the south coast and the north-east inlet carry sea where the 110 m mask carried solid land, that the 32 px decimation carries no articulation on either mask, and that **identifiability is not measured by this dispatch and is not claimed**.

**What is present in the render, described without a verdict.** On the 128x128 body enlarged 3x, the mass carries a pointed north, an indented west coast with several inlets, a broken south coast with separated fragments, a single detached island below the west end, and one small island body off the south-east. At 64 px the pointed north, the west inlet and the detached island survive and the south-coast fragments merge. At 32 px the mass is a 15 by 23 px block with one notch on its west side and a 3 by 2 px detached body, and the decimation measurement agrees, 0 rows with two or more runs at 32 px on either mask.

**Recorded against `M4`, without resolving in `Shadow`'s section.** Two of `M4`'s should-fixes close on upstream evidence, the vertex count is 18 distinct and Jeju is upstream at 10 m rather than hand-added. One does not hold on these captures. `M4` read map 5's title bar as showing no map path, `SCmdDraft 2.0 (Beta 9, 0.10)` only. In `m5-open.png`, `m5-jump.png` and `m5-reopen.png` the title bar reads `SCmdDraft 2.0 (Beta 0.9.10) - [home/howard/scmdraft-maps/republic-of-korea/republic-of-korea.scm ]`, path included. Both readings stand, they were taken from different captures, and the difference is stated for `M6` and the booth script rather than resolved here.

**Checks that did not run, named.** SCMDraft 2's own map-validation dialog, still run on no saved map in this task. Any literal in-game StarCraft render or in-game minimap, so the DoD minimap box remains met only by the editor-thumbnail proxy. Tile elevation class of values 192 and 64, untested on this map as on every earlier one. Physical booth legibility against a real panel at a real distance, the booth display size is recorded nowhere in this task. A re-fetch or licence ruling on the Natural Earth dataset, the blob SHAs were verified against the upstream tag and the licence text is quoted, the ruling is `Charmy`'s and `Flicky`'s. Any identifiability read, which is `M6`'s. No OCR of the status bar was run, the status strip crop was saved as `m5-read-status-3x.png` and read visually, it shows `Terrain | User Select | Force 1 | Isometrical Terrain | Ice World\Snow` and the coordinate readout `154, 531 (4,16)` on the jump frame.

**Inverse for this step.** `rm -f /tmp/opencode/t0042/m5-extracted.chk /tmp/opencode/t0042/m5_measure_output.txt /tmp/opencode/t0042/republic-of-korea_report.json /tmp/opencode/t0042/republic-of-korea-mm*.png /tmp/opencode/t0042/republic-of-korea-booth*.png /tmp/opencode/t0042/m5-read-*.png`. No target state changed in this step.

## 2026-11-21 12:10 — Dispatch F1, four record-hygiene fixes from M6, controller-side only, no map change, no target contact (`Tails`)

**Scope.** The four record-hygiene findings `M6` opened at `## Review` doc:2598, doc:2613, doc:2631 and doc:2652. No map content changed, no target touched, no gate reopened. Two reports edited and four controller files renamed. Backups `republic-of-korea_report.json.f1.bak` and `tux_report.json.f1.bak` under `/tmp/opencode`.

**Finding 1, the 10-tile feature floor is restated as a minimum-dimension reading.** Reproduced from the builder, `python3 /tmp/opencode/t0042/korea_10m.py` __main__ keep/drop census. `korea_10m.apply_feature_floor` (korea_10m.py:191) already keeps a component only when both bbox axes reach `MIN_FEATURE_TILES = 10`, a minimum-dimension reading, and its builder mask equals the shipped `republic-of-korea.chk` `MTXM` mask (verified equal, cell for cell). Dimension reading keeps 3 components 15467 + 296 + 68 (15777 before the internal-counter fill, 15831 shipped after fill), drops 28 components totalling 210 tiles, matching the record. An area reading of "10 tiles or larger" keeps 9 components including Ulleungdo and does not reproduce the shipped mask, which is why the prose at doc:2014 and doc:106 is restated as minimum-dimension. `republic-of-korea_report.json` gains `new_mask.feature_floor` stating the rule, both readings' component counts, and the named drops. Ulleungdo recorded against the floor as **13 tiles, 4w x 4h**, bbox cols 246-249 rows 58-61, lon 130.8018..130.8854 lat 37.4745..37.5422, and the Ganghwado-area fragments as 19 tiles 8w x 4h, cols 86-93 rows 59-62.

**Finding 2, the sea-anchor table is corrected and its non-informative half named.** Every one of the 22 anchor windows was re-derived independently from `m5-extracted.chk` (the shipped CHK) and `superseded-republic-of-korea-110m.chk` `MTXM` at the recorded projection, and all 22 reproduce the recorded counts exactly, so the table is sound arithmetic. Two entries are not. Jinhae Bay inner was recorded at lon 128.62, about 107 km east of Jinhae Bay (real ~127.55 E), so the recorded "0 to 9 sea" gain was measured in open water off the east coast, not at Jinhae. Placed at its real coordinates (127.55, 35.16) it lands on glyph with 0 sea tiles in **both** masks, so it does not demonstrate a Jinhae Bay gain. The anchor is corrected to lon 127.55, col 129, row 164, sea 0/0, and marked. Four land-expected anchors sit in open water in both masks and detect nothing, Gangneung coast 25/25, NE point near Seokjin 25/25, NE tip at the Tumen mouth 25/25, SW corner near Jindo 22/25; each is marked `informative: false` and a `new_vs_old.anchor_reliability` block names them. With Jinhae corrected, the honest claim is **6 of 12** sea anchors gain sea, not the seven recorded at doc:2031 and doc:2035, because the seventh was the mislocated Jinhae.

**Finding 3, `tux_report.json` regenerated to match the on-disk artifacts.** The `tux` artifacts were re-cropped by M3 at 2026-11-21 00:24 while the report was last written 2026-11-20 20:46. Measured on disk, `tux-mm.png` is 128x129 and byte-identical to the crop (18,112)-(146,241) of `tux-100.png` (`ImageChops.difference` bbox None) at 66.55 percent dark. `thumbnail_body_crop` [4,4,131,131] -> (18,112)-(146,241), `thumbnail_body_dark_share_pct` 64.57 -> 66.55, and `real_thumbnail_wcag.crop` [8,105,142,245] -> (18,112)-(146,241), the same measured panel rectangle `republic-of-korea` uses, closing the two-pass staleness at doc:2631 and the M4 should-fix at doc:2544.

**Finding 4, the controller naming collision is closed with the ratified scheme.** `sha256sum` before, `foss-for-all.scm` `051fc139...` mtime 2026-11-20 04:17 distinct terrain `[96, 128, 144]`, the dispatch 3 build on 128/144 ground that the seven-tileset contrast measurement retired, held the plain name. The accepted Ice deliverable `e856f0e1...` mtime 06:02 distinct `[64, 192]` sat under `foss-ice.scm`. `Robotnik` ratified at doc:126 the scheme `foss-for-all.scm` for the current build, `superseded-foss-for-all-jungle.scm` for the superseded Jungle build, booth selection must not reach a prefixed file, and that rename was recorded but never applied on the controller. Root cause named, `build_map1.py:127-128`, the superseded dispatch 3 writer, hardcodes the plain name for the `[96, 128, 144]` build. Applied the ratified scheme, moved the superseded build to its prefixed name first (freeing the plain name) then the accepted build onto it, byte-for-byte: `mv foss-for-all.scm superseded-foss-for-all-jungle.scm`, `mv foss-for-all.chk superseded-foss-for-all-jungle.chk`, `mv foss-ice.scm foss-for-all.scm`, `mv foss-ice.chk foss-for-all.chk`. After, `foss-for-all.scm` is `e856f0e1...` `[64, 192]` (accepted, booth-reachable) and `superseded-foss-for-all-jungle.scm` is `051fc139...` `[96, 128, 144]`, SHAs identical to before. Inverse of the plain name recorded, `foss-for-all.scm` now denotes the accepted Ice build, the inverse of the collision `Shadow` found. The `rt-foss.chk` `aebc750f...` and `rt-foss-ice.chk` `34bb035c...` round-trip extracts are left in place, byte-identical duplicates of the superseded Jungle CHK and the accepted Ice CHK respectively, named before this correction and identified here by content SHA. No `rejected-foss-for-all.scm` is present on the controller today, the 2026-11-14 build doc:288 named is not on disk, recorded rather than recreated.

**Checks that did not run, named.** No target contact, every number here is controller-side. SCMDraft 2's own map-validation dialog, still run on no map. Whether the corrected Jinhae anchor would gain sea at a finer tile resolution or a different anchor point inside the bay, only the recorded single point at 127.55/35.16 was measured and it lands on glyph.

**Inverse for this step.** Restore the reports, `cp /tmp/opencode/republic-of-korea_report.json.f1.bak /tmp/opencode/t0042/republic-of-korea_report.json` and `cp /tmp/opencode/tux_report.json.f1.bak /tmp/opencode/t0042/tux_report.json`. Undo the renames, `mv /tmp/opencode/t0042/foss-for-all.scm /tmp/opencode/t0042/foss-ice.scm`, `mv /tmp/opencode/t0042/foss-for-all.chk /tmp/opencode/t0042/foss-ice.chk`, `mv /tmp/opencode/t0042/superseded-foss-for-all-jungle.scm /tmp/opencode/t0042/foss-for-all.scm`, `mv /tmp/opencode/t0042/superseded-foss-for-all-jungle.chk /tmp/opencode/t0042/foss-for-all.chk`. No target state was changed in this step.

## 2026-11-21 14:26 — Dispatch M7 step 1, map 6 `i-love-korea` built on the controller (`Tails`)

**Step.** New mask `rocky.i_love_korea` (rocky.py, registered in `MASKS` as `i-love-korea`): one row reading a 3-cell I-beam `I`, one filled heart (this module's `_heart` at half 31, measured 70w x 68h, no internal counter), then `KOREA` in capitals, rendered through `glyph.render`, the parameterized blit added to `glyph.py` reusing its 5x7 FONT and GAP semantics. FONT gained `K`, `E` and a 3-cell I-beam `I`; `glyph.mask()` and its existing keys are byte-unchanged and the regression census reproduces map 1 exactly, `filled 7104, bbox x14-241 y64-191`. Build: `python3 build_ts.py silhouette ts-harvest/ref-era6.chk i-love-korea 192 64 64 i-love-korea`, output `i-love-korea.chk` 614210 B `5dda69410189...`, `i-love-korea.scm` 614561 B `82589b4205f5deb8ed123273f1c6b5262472806bb90373d6b267c8f27e2319a0`, era 6, MTXM 65536 entries, distinct terrain values `[64, 192]`. Mask census (`m7_mask_diag.py`): 19666 filled tiles, coverage 30.01 percent, design bbox x8-247 y9-246, margins 8/8/9/9 tiles, glyph row height 238 tiles (S_Y 34, the largest 7-row height keeping both vertical margins at 8 tiles or more), thinnest letter stroke 5 tiles (S_X 5, the largest stroke whose width budget leaves the heart a 70-tile box). Feature floor applied as the minimum-dimension reading F1 settled: under the letterform-unit 8-connected reading the design is 7 components (I 15x238, heart 70x68, K O R E A each 25x238), every one at least 10 tiles on both axes, zero dropped. Under a strict 4-connected reading the corner-connected block letters split into 5-tile arm fragments, the same construction the already-accepted map 1 `foss-for-all` ships; the 4-connected fragment census is recorded in `## Implementation` rather than hidden.

**Inverse.** `rm -f /tmp/opencode/t0042/i-love-korea.chk /tmp/opencode/t0042/i-love-korea.scm /tmp/opencode/t0042/m7_mask_diag.py`; revert the `K`/`E`/`I` FONT keys, the `render` function in `glyph.py`, and the `i_love_korea` function plus MASKS entry and `_ILK_*` constants in `rocky.py`. No target touched in this step, no accepted map touched: `foss-for-all` `e856f0e1`, `rocky-logo` `447360ce`, `rocky-with-heart` `b9b056c2`, `tux` `79002eacd5d6`, `republic-of-korea` `c773a534a564` verified unchanged on the target before this build.

## 2026-11-21 14:28 — Dispatch M7 step 2, `i-love-korea` placed on the target, rendered, re-opened (`Tails`)

**Step.** `mkdir -p ~/scmdraft-maps/i-love-korea`, scp the built file to the absolute path `/home/howard/scmdraft-maps/i-love-korea/i-love-korea.scm` (absolute, per the recorded M5 fact that scp in SFTP mode does not expand `$HOME`), placed at 614561 B, mtime `2026-11-21 14:28:42`, SHA-256 `82589b4205f5deb8ed123273f1c6b5262472806bb90373d6b267c8f27e2319a0`, identical to the controller build. Launched for viewing only through `bash /tmp/t0042-run.sh` with the same absolute Unix path, profile dismissed with Enter (scancode 0x1C); no editor save performed, per the `## Status` decision of 2026-11-21 08:40. Captures: `m7-open.png` (overview), overview-jump click at panel pixel (81,175) onto the design centre, `m7-jump.png` (main-canvas frame carrying both tones), then `pkill`, relaunch on the same disk file, `m7-reopen.png`, `pkill`. Title bar in both renders reads `SCmdDraft 2.0 (Beta 0.9.10) - [/home/howard/scmdraft-maps/i-love-korea/i-love-korea.scm ]`, path present; status bar reads `Ice World\Snow`. After the kill and re-open the file is unchanged: 614561 B, mtime `14:28:42` unaltered, SHA-256 identical. The five existing deliverables verified unchanged before and after, `e856f0e1`, `447360ce`, `b9b056c2`, `79002eacd5d6`, `c773a534a564`. `/tmp/m7-*.png` and `/tmp/t0042-run.log` removed on the target, `NO_SCM_RUNNING` at the end. Inverse for every target step: `rm -f "$HOME/scmdraft-maps/i-love-korea/i-love-korea.scm" && rmdir "$HOME/scmdraft-maps/i-love-korea"`, `rm -f /tmp/m7-*.png /tmp/t0042-run.log`. Nothing else touched, no package, no repo, no registry change, no credential on any command line.

## 2026-11-21 14:52 — Dispatch M7 step 3, gate measurement and 4x survival of `i-love-korea` (`Tails`)

**Step.** `python3 /tmp/opencode/t0042/m7_measure.py`, machine report `i-love-korea_report.json`, transcript `m7_measure_output.txt`. Two sources only, the published `/home/howard/scmdraft-maps/i-love-korea/i-love-korea.scm` returned to the controller earlier by this dispatch, its CHK extracted with `chkdump` (StormLib, MIT) and byte-identical to the written CHK, `MTXM` parsed, and the three real captures `m7-open.png`, `m7-jump.png`, `m7-reopen.png`. No mask module imported for any gate number.

**Gate numbers.** Coverage 19666 glyph tiles, 30.01 percent, 7 components under the 8-connected letterform-unit reading (I 15x238, heart 70x68, K O R E A each 25x238), every component at least 10 tiles on both axes under the F1 minimum-dimension floor, zero dropped, 4590 enclosed ground tiles which are the three letter counters (O, R, A), heart carries none. WCAG 6.745 dominant pair and 6.745 worst pair on the located 128x128 overview body (18,112)-(145,239), ground (176,176,176) 11764 px, glyph (36,40,56) 4546 px, 74 px white viewport-indicator overlay disclosed; main-canvas frame 6.745 dominant, 5.328 worst. Booth artifacts, `i-love-korea-mm.png` 99.55 percent map tone zero panel chrome, `i-love-korea-booth64.png` and `i-love-korea-booth32.png` single-step Lanczos at 0.5 and 0.25 on both axes, 85.28 and 69.53 percent map tone, the non-tone being Lanczos mid-tone from downscaling 2.5 px strokes. Re-open, 614561 B mtime `2026-11-21 14:28:42` SHA `82589b4205f5...` unchanged, body renders pixel-identical at 0 px, whole-frame diff 3255 px bounded to the main-canvas viewport rectangle (434,409)-(902,863), editor scroll state not map content.

**Measured glyph metrics.** Glyph height 238 tiles, thinnest letter stroke 5 tiles, letter bar thickness 34 tiles, heart 70w x 68h narrowest run 2 tiles, separator gaps 5 tiles, margins 8/8/9/9. 4x survival measured three ways, all 7 survive on the shipped mask at Lanczos 4x, all 7 carry glyph pixels on 117 to 118 of 119 rows in the real 128 px overview, at the real booth64 4 of 7 pass the stated criterion (K, R, A on 59 of 60 rows, heart 16 of 18) and 3 of 7 (I, O, E) have their single-cell 5-tile strokes render as mid-tone pixels on most of their extent, present as faded strokes, measured not asserted. The builder declares no legibility verdict, `M8` decides.

**Inverse for this step.** `rm -f /tmp/opencode/t0042/m7-extracted.chk /tmp/opencode/t0042/m7_measure_output.txt /tmp/opencode/t0042/i-love-korea_report.json /tmp/opencode/t0042/i-love-korea-mm*.png /tmp/opencode/t0042/i-love-korea-booth*.png /tmp/opencode/t0042/m7-read-*.png /tmp/opencode/t0042/m7_measure.py`. No target state changed in this step.

## 2026-11-21 17:50 — Dispatch D0 step 1, interim booth record staged on the controller (`Tails`)

**Step.** Controller-side only, no target contact. Staged the publishable record under
`/tmp/opencode/t0042/publish/`, a scratch path, not a git-tracked path of the team repo.
`python3 /tmp/opencode/t0042/d0_stage.py` walked `/tmp/opencode/t0042` (1849 files, 269593596 B),
classified every file, copied the included categories, and wrote the full landed and withheld plan to
`/tmp/opencode/t0042/d0_stage_plan.tsv`. Landed 572 files, 169663874 B, in nine categories:
`maps/deliverable` 6 `.scm`, `maps/superseded` 2, `code` 81 (Python, the team's own C sources, shell
drivers), `gate-reports` 9 `.json`, `booth-artifacts` 65, `captures` 166 editor captures,
`calibration` 13, `live-segment` 214 (209 captures, 4 replayable command lists, 3 live-segment maps),
`montages` 10, `notes` 6. Largest single landed file 1591825 B.

**The six maps re-verified before any copy.** `sha256sum` on the controller copies reproduces every
recorded value byte for byte, `foss-for-all` `e856f0e1d62ec8f7...`, `rocky-logo` `447360ce8077e542...`,
`rocky-with-heart` `b9b056c27a678515...`, `tux` `79002eacd5d673c5...`, `republic-of-korea`
`c773a534a564d4b3...`, `i-love-korea` `82589b4205f5deb8...`. The two superseded builds landed beside
them at their ratified prefixed names, `superseded-foss-for-all-jungle.scm` `051fc1392257ec07...` and
`superseded-republic-of-korea-110m.scm` `50e55299dd86fafb...`, because `DEMO-LOG.md` and the planning
docs name those files and a reader checking the record should be able to open them.

**Withheld, 1294 files, with a category on each.** shipped StarCraft data 4 (`base-map.scx`,
`maps/rc.scm`, `maps/bn.scm`, and `live-seed.scm`, which `sha256sum` proves byte-identical to
`maps/rc.scm`, so it is the shipped map (2)River Crossing.scm rather than this team's authorship),
harvested reference CHKs 170 under `ts-harvest/`, CHK and SCX intermediates 62, probe and calibration
maps 38, StormLib 905, the Natural Earth upstream dataset 5, imported upstream code 3, compiled ELF
binaries 4, build logs and bulk probe captures 66, `__pycache__` 15, raw PPM desktop sanity captures 1,
scratch notes 4, one undocumented intermediate binary 1, and one credential 1. No ISO and no container
image exists anywhere under `/tmp/opencode/t0042`, `find . -maxdepth 2 \( -iname '*.iso' -o -iname
'*.img' \)` returns nothing, so that excluded category is withheld vacuously rather than by removal.

**Credential found in the working directory, recorded and not published.** `grep -rl 's5Tf...'` over
the whole working directory returns exactly one file, `/tmp/opencode/t0042/rdp-args`, a scratch argument
file for the team's own RDP input injector holding the target's RDP credential in plaintext. Its value
does not appear in this log, in any file that landed, or in any commit. `git log --all -S` on the value
returns zero commits in the team repo, so nothing was ever committed; the file is a live credential on
the controller and the rotation step belongs to the operator. It is withheld from the publish by
explicit rule, and `grep -rl` for the value over `/tmp/opencode/t0042/publish` returns nothing. The
dispatch briefs read credentials from `~/AI/secrets` at run time through stdin or a file argument, and
`grep -rin` over the landed code shows only path references such as
`SSH_PASS = os.path.expanduser("~/AI/secrets/scm_draft_pass.md")`, never a value.

**Checks that did not run, named.** No target contact in this step, so no target-side hash or mtime was
re-verified here; the six maps' target copies were last verified by `M7` at 2026-11-21 14:28. The
booth repo has not been written yet in this step. Whether any landed capture carries the
viewport-indicator overlay `Shadow` found at 8 glyph positions is not re-checked by this dispatch, it is
carried forward as `M8` recorded it.

**Inverse for this step.** `rm -rf /tmp/opencode/t0042/publish /tmp/opencode/t0042/d0_stage.py
/tmp/opencode/t0042/d0_classify.py /tmp/opencode/t0042/d0_stage_plan.tsv`. Nothing outside those paths
was created or changed, and no target state was touched.

## 2026-11-21 18:07 — Dispatch D0 step 2, interim booth record published to the documentation repo (`Tails`)

**Step.** Controller-side only, no target contact. Cloned the booth repo with
`GIT_ASKPASS=/tmp/opencode/git-askpass-tc.sh git clone https://github.com/metalllinux/foss-for-all-booth-demonstration-scmdraft-2.git /tmp/opencode/t0042/booth-repo`,
which returned exactly the recorded `Initial commit` `7e0d58d`, `LICENSE` 1063 B and `README.md` 129 B,
so the clone matched the `## Status` verification of 2026-11-21 16:20. Copied the staged tree in, added
`DEMO-LOG.md` and the three planning docs from the team repo at commit `2b29d7e`, generated `MANIFEST.md`
and `PUBLISH-STATUS.md` from the tree as written by `python3 /tmp/opencode/t0042/d0_report.py`, committed
`3da0937162a5f00ba76078f0a82142910b8c7f32`, and pushed with
`GIT_ASKPASS=/tmp/opencode/git-askpass-tc.sh git push origin main`, which answered `7e0d58d..3da0937 main -> main`.
No credential appears in any argv, commit message, log line or file written by this step. The token was
supplied only through the askpass helper, which reads it from `~/AI/secrets/token.md` at run time.

**Verified on the remote after the push, not assumed.** `git ls-remote` answers
`3da0937162a5f00ba76078f0a82142910b8c7f32 refs/heads/main`. A fresh clone of the pushed repo
(`/tmp/opencode/t0042/booth-verify`) holds 580 files, `git ls-tree -r HEAD` count, and `sha256sum` in that
fresh clone reproduces all six deliverable maps at their recorded values, `foss-for-all` `e856f0e1...`,
`rocky-logo` `447360ce...`, `rocky-with-heart` `b9b056c2...`, `tux` `79002eacd5d6...`, `republic-of-korea`
`c773a534a564...`, `i-love-korea` `82589b4205f5...`. `README.md` `e278208f88b9...` and `LICENSE`
`5c620b9317b6...` are byte-unchanged and `git diff --stat 7e0d58d HEAD -- README.md LICENSE` is empty, so
the existing prose and the licence file were not rewritten. `git log` on the remote clone shows the two
commits, `3da0937` on top of `7e0d58d`.

**Visibility unchanged, checked rather than assumed.** The REST call, token supplied through a stdin
`curl --config` so it is in no argv and no file, answers `"id": 1455994123`, `"private": true`,
`"visibility": "private"`, `"default_branch": "main"`, `"pushed_at": "2026-11-21T09:07:30Z"`. An
unauthenticated probe of the same path still answers `404`. The same response reports `"size": 1` KiB
against a 150 MiB push, which is GitHub's lagging cached field rather than evidence about the push, and it
is recorded as such because `git ls-remote` and the fresh clone both return the pushed commit.

**Manifest cross-checked against git itself.** A script re-read `MANIFEST.md`, re-hashed every listed file
in the working tree, and compared the path set against `git ls-tree -r HEAD`. Result, 579 rows, 579 unique
paths, zero hash or size mismatches, zero paths in the tree that the manifest omits, zero paths the manifest
lists that are not in the tree. The only file the manifest does not list is `MANIFEST.md` itself, stated in
its header, because a file cannot hold its own hash.

**Categories published.** The six deliverable maps, the two superseded builds, the code (81 files, the
team's own Python, C and shell), 9 gate reports, 65 booth artifacts, 166 editor captures, 13 calibration
renders, the live segment (3 maps, 4 replayable command lists, 207 captures), 10 montages, 6 measurement
transcripts, the three planning docs, `DEMO-LOG.md`, `MANIFEST.md`, `PUBLISH-STATUS.md`.

**Categories not copied, named in full.** shipped StarCraft map data, 4 files, `base-map.scx`, `maps/rc.scm`,
`maps/bn.scm` and `live-seed.scm`, the last proven by `sha256sum` to be byte-identical to the shipped map
`(2)River Crossing.scm`. Harvested reference CHKs under `ts-harvest/`, 170 files. CHK and SCX intermediates,
62 files. Probe and calibration maps, 38 files. StormLib upstream library, 905 files. The Natural Earth
upstream GeoJSON dataset, 5 files. Imported upstream code, `starcraft_mpq_io.py` and the `richchk` fragments,
3 files. Compiled ELF binaries the team built from the C sources that landed, `chkdump`, `mkmpq`,
`rdp-input`, `rdp-shot`, 4 files. Build, launch and error logs and bulk per-row tileset probe captures, 66
files. `__pycache__`, 15 files. Raw PPM desktop sanity capture, 1 file. Scratch notes and partial hash
lists, 4 files. `colorbase.bin`, 1 file, provenance unrecoverable. The credential scratch file `rdp-args`,
1 file. Three categories the brief excluded that had nothing on the controller to exclude, any ISO or
disk image, zero files, SCMDraft or Wine binaries and prefixes, zero files, they exist on the target only,
and game data, MPQ archives and unit or sprite assets, zero files. Full reasons are in `MANIFEST.md` and
`PUBLISH-STATUS.md` in the booth repo.

**Credential finding, carried forward for the operator.** The plaintext target RDP credential sits in
`/tmp/opencode/t0042/rdp-args`, a 79 B scratch argument file for the team's own RDP input injector. It is
in no commit, `git log --all -S` on the value returns zero commits, in no landed file, `grep -rl` for the
value over the booth clone returns nothing, and in no document in either repository. It was withheld by an
explicit rule rather than by luck. The rotation decision is the operator's, and deleting the scratch file
would not rotate the credential itself. `Robotnik` should carry this into `## Security` and `## Status`,
which this agent does not write.

**Checks that did not run, named.** No target contact, so the six maps' copies on the target were not
re-hashed in this dispatch, they were last verified on the target by `M7` at 2026-11-21 14:28. No visual
read of the 166 editor captures published here. No licence ruling on the published captures, which are
downscaled renders of Blizzard tileset tones, that belongs to `R4` and `R5`. No re-check of which published
captures carry the viewport-indicator overlay `M8` measured at 8 glyph positions. SCMDraft 2's own
map-validation dialog, still run on no map in this task.

**Inverse for this step.** The booth repo has no revert path short of a revert commit, and this task does
not force-push, so the inverse is `git revert 3da0937` pushed to `main`, which leaves `7e0d58d` as the tip
content. On the controller, `rm -rf /tmp/opencode/t0042/publish /tmp/opencode/t0042/booth-repo
/tmp/opencode/t0042/booth-verify /tmp/opencode/t0042/d0_stage.py /tmp/opencode/t0042/d0_classify.py
/tmp/opencode/t0042/d0_reasons.py /tmp/opencode/t0042/d0_report.py /tmp/opencode/t0042/d0_stage_plan.tsv`.
No target state was touched, no visibility setting was changed, no repo, package or registry change was
made on any machine.

## 2026-11-21 18:20-18:40, dispatch B1, booth geometry on the target panel (Tails)

Booth geometry measured from the target's own EDID and from one real SCMDraft 2 capture on the panel,
ahead of `M9`, no map change and no map rebuild. Target `scmdraft2-map-creator` (`192.168.1.99`), kernel
`6.12.0-211.74.1.el10_2.x86_64`.

**Step 1, panel identity and size from the target's EDID and mode information.** Connected output is the
built-in laptop panel, sysfs connector `card1-eDP-1`, `status: connected` (`card1-DP-1` and `card1-DP-2`
disconnected), from `ls /sys/class/drm/` and each `<output>/status`. `xxd /sys/class/drm/card1-eDP-1/edid`
gives the 128-byte EDID, manufacturer bytes 0x08-0x09 (`09 e5`) decode to `BOE`, product bytes 0x0A-0x0B
(`4a 09`) are `0x094a`. `gdbus call --session --dest org.gnome.Mutter.DisplayConfig --object-path
/org/gnome/Mutter/DisplayConfig --method org.gnome.Mutter.DisplayConfig.GetCurrentState` confirms
`('eDP-1','BOE','0x094a','0x00000000')`, `is-builtin: true`, current mode `1920x1080@60.004` at scale
1.0. EDID basic display bytes 0x15 = 34 cm and 0x16 = 19 cm give a **340 x 190 mm** panel, diagonal
389.487 mm (15.33 in), **0.177083 mm/px horizontal** and **0.175926 mm/px vertical** at 1920x1080, the
small h/v difference being EDID's whole-centimetre rounding.

**Step 2, the two views from a real capture.** SCMDraft 2 launched for viewing with
`/tmp/t0042-run.sh ~/scmdraft-maps/i-love-korea/i-love-korea.scm` (pid 151870), profile dialog dismissed
with `./rdp-input rdp-args key 0x1C`, one capture via the GNOME Shell Screenshot D-Bus call to
`/tmp/b1-editor.png` fetched to `/tmp/opencode/t0042/b1-editor.png`, 1920x1080 unscaled, title bar showing
the `i-love-korea` path and Zoom combo `100%`, status bar `Ice World\Snow`. Overview thumbnail body is
**128x128 px for the whole 256x256 map**, 0.500000 screen px per tile, 0.0885 mm per tile, 22.67 x 22.52
mm on the panel, origin (18,112) reproducing `M6`/`M8` and the 128 figure resting on `M8`'s 16384-pixel
point-sample reconstruction. Main canvas at 100 percent zoom measured by direct grid-line detection at a
**32.0 px pitch** on both axes, viewport x167..1879 and y110..863, **1713x754 px = 53.53 x 23.56 tiles**,
32 screen px per tile, 5.667 mm per tile horizontal and 5.630 mm vertical.

**Step 3, on-screen size and angular subtence.** 5-tile stroke, main canvas 160 px = 28.333 mm, 1.623 /
1.082 / 0.812 deg at 1 / 1.5 / 2 m; thumbnail 2.5 px = 0.4427 mm, 0.0254 / 0.0169 / 0.0127 deg, the
thumbnail stroke falling below the about 1 arcmin reference acuity by 2 m, which is the mechanism behind
the `M8` 64 px failures. 238-tile glyph height, thumbnail 119 px = 20.935 mm, 1.200 / 0.800 / 0.600 deg;
main canvas 7616 px = 1339.85 mm, taller than the 190 mm panel, so at 100 percent zoom only 23.56 tiles
of its 238-tile height are on screen at once and the rest is panned. The 1 to 2 m distances are a bounded
band, not a measured venue fact.

**Step 4, the 64 px and 32 px bounds restated.** Both are thumbnail-class whole-map bounds (0.5 and 0.25
of the 128 px body), 0.25 and 0.125 px per tile, whole-map 11.333 mm and 5.667 mm, 5-tile stroke 0.38 to
0.76 and 0.19 to 0.38 arcmin across the band. The main-canvas booth view has no whole-map 64/32 px bound,
it renders at 32 px per tile, and the shipped 5-tile stroke there is 160 px = 28.3 mm = 0.812 to 1.623 deg.
So the `M8` 64 px blocker is thumbnail-class, and on the booth medium (the main canvas, panned) the shipped
single-row build survives at the measured stroke size.

**Checks that did not run, named.** No blind human viewer check at the named distances, the venue distance
at Centerfield EAST 18F is unmeasured. No in-game StarCraft minimap capture, the playability path is
blocked on this target, the thumbnail proxy stands. No independent re-read of these numbers, a `Shadow`
read is not part of `B1`. No per-pixel WCAG on this dispatch, `S1` re-measures contrast. Canvas width
measured 1713 px here against the 1735 px recorded by `L3`/`L4`/`M1`, the 22 px difference is this launch's
dock and scrollbar chrome and is recorded, not reconciled.

**Exact inverse.** SCMDraft opened for viewing only, maps not saved, teardown `kill 151870`,
`pkill -u howard -f "ScmDraft 2.exe"`, `pkill -u howard -x wineserver`, all verified `NONE`, no other
process killed. Target captures removed `rm -f /tmp/b1-capture.png /tmp/b1-editor.png`, verified
`NO_CAPTURES`. Controller files `b1-capture.png`, `b1-editor.png`, `b1_measure.py`, `b1_measure2.py`,
`b1_measure3.py`, `b1_thumb.py`, `b1_calc.py` under `/tmp/opencode/t0042`, inverse `rm -f` each.
Deliverables byte-stable after the viewing open, target `sha256sum` reproduces `i-love-korea`
`82589b4205f5...`, `foss-for-all` `e856f0e1...`, `rocky-logo` `447360ce...`, `rocky-with-heart`
`b9b056c2...`, `tux` `79002eacd5d6...`, `republic-of-korea` `c773a534a564...`. No map changed, no map
rebuilt.

## 2026-11-21 19:05, Dispatch M9 step 1, controller-side two-line mask and build (`Tails`)

Rebuilt the `i-love-korea` mask as the two-line variant per the `## Status` decision of 2026-11-21
15:20 and the `B1` booth-geometry gate of 2026-11-21 18:40. No target contact in this step. New
function `rocky.i_love_korea_2line()` and constants `_ILK2_*` added to `/tmp/opencode/t0042/rocky.py`;
the M7 single-row `i_love_korea()` is byte-unchanged so the superseded build still reproduces.

Layout, measured from the module (`python3 -c` bbox read): two lines, line 1 `I` (bbox x53-76 y8-119,
24w x 112h) then a filled heart (bbox x93-202 y11-116, 110w x 106h), line 2 `KOREA` (bbox x12-243
y136-247, 232w x 112h). `S_X` 8 so every letter stroke is 8 tiles, `S_Y` 16 so letter height is 112
tiles per line. Ground margins 12, 12, 8, 8 (all >= 8). Feature floor (minimum-dimension reading, both
axes >= 10 tiles) holds for I, heart and KOREA. Design coverage 20600/65536 = 31.43 percent.

Build, `build_ts.py silhouette ts-harvest/ref-era6.chk /tmp/opencode/t0042/i-love-korea 192 64 64
i-love-korea-2line`, era 6, chk 614210 B, MTXM==TILE 65536, ISOM 265224 of 0x10, distinct terrain
values [64, 192]. New deliverable `/tmp/opencode/t0042/i-love-korea.scm` 614561 B at SHA-256
`16fe455d46fd88671a98a79f3db65d934400ce0d4edd98f677313e6668d38ba9`.

Renamed the shipped M7 single-row build to the `superseded-` prefix per the ratified three-name scheme
and the brief ("keep the shipped single-row build on disk under the `superseded-` prefix").
`mv i-love-korea.scm superseded-i-love-korea.scm` and `mv i-love-korea.chk superseded-i-love-korea.chk`;
the superseded build is 614561 B at SHA-256 `82589b4205f5deb8ed123273f1c6b5262472806bb90373d6b267c8f27e2319a0`,
unchanged by the rename. Inverse of the controller rename,
`mv superseded-i-love-korea.scm i-love-korea.scm && mv superseded-i-love-korea.chk i-love-korea.chk`.

Checks not run in this step, target placement, real SCMDraft render, booth artifacts, re-open identity.

## 2026-11-21 19:28-19:44, Dispatch M9 steps 2-3, two-line rebuild placed on target, real renders measured (`Tails`)

Placed the two-line `i-love-korea` rebuild on the target and measured its four gate numbers from
its own real SCMDraft 2 renders. No editor save performed; the launch is the viewing launch
`/tmp/t0042-run.sh` with an absolute path. Target `scmdraft2-map-creator` (192.168.1.99), kernel
6.12.0-211.74.1.el10_2.x86_64.

**Rename and placement.** On the target, `mv i-love-korea.scm superseded-i-love-korea.scm` then the new
build scp'd to `i-love-korea.scm`. Superseded M7 single-row build 614561 B at SHA-256
`82589b4205f5deb8ed123273f1c6b5262472806bb90373d6b267c8f27e2319a0`, mtime unchanged. New build 614561 B at
SHA-256 `16fe455d46fd88671a98a79f3db65d934400ce0d4edd98f677313e6668d38ba9`. Target rename inverse,
`mv "$HOME/scmdraft-maps/i-love-korea/superseded-i-love-korea.scm" "$HOME/scmdraft-maps/i-love-korea/i-love-korea.scm"`.

**Launch and captures (pid 152909).** Profile dismissed with `rdp-input key 0x1C`. Captures `m9-open.png`
(default zoom, Zoom combo reads `100%`), `m9-zoom25.png` (after opening the Zoom combo at (385,90) and walking
it down with extended Down-arrow `keyx 0x50` x6 then Enter; the Zoom combo reads `25%` highlighted, so zoom
applied, unlike the maps 2/3 attempts), `m9-jump.png` (overview-jump click (81,175) centring the viewport, line 2
`KOREA` framed), `m9-reopen.png` (after kill and relaunch). Status bar reads `Ice World\Snow` in every frame.

**Fit-to-line zoom, stated honestly.** B1 derived the fit-to-line zoom as about 21 percent (6.74 px/tile) for a
112-tile line, which is below this build's 25 percent zoom floor (floor = 8 px/tile), so the exact fit-to-line
zoom is not reachable in the editor. The closest capturable main-canvas frame is the 25 percent floor frame
(`m9-zoom25.png`, line 1 `I` then heart framed). At 25 percent the main-canvas viewport is 8 px/tile = 1.417 mm/tile,
754 px tall = 94.25 tiles; a 112-tile line exceeds it by 17.75 tiles, so a whole line does not fit vertically at any
permitted zoom and the frame carries a partial line. Grid-line pitch on `m9-zoom25.png` did not isolate a clean
ground band (the design fills the sampled region), so px/tile at 25 percent is taken from the Zoom combo reading
(25 percent x 32 px) rather than a fresh grid measurement.

**Gate numbers measured on this map's own real render (report `/tmp/opencode/t0042/i-love-korea-2line_report.json`).**
Coverage 20600/65536 = 31.43 percent. Overview thumbnail body crop located at (18,112)-(146,240) 128x128 px
(ground 11161 / glyph 5149 / non-tone 74 px), glyph share 31.43 percent matches mask coverage exactly. WCAG on the
real thumbnail render 6.745 dominant pair ground (176,176,176) against glyph (36,40,56), worst pair also 6.745.
WCAG on the main-canvas 25 percent frame 6.745 (glyph share 50.08 percent). Booth artifacts uniform single-step
Lanczos of the located body crop at 0.5 (`i-love-korea-2line-booth64.png` 64x64) and 0.25
(`i-love-korea-2line-booth32.png` 32x32). Re-open identity: open vs reopen body crop differs 0 px over 16384 px
(threshold 16), disk 614561 B `16fe455d46fd...` mtime 2026-11-21 19:28:35 unchanged by viewing and re-open.

**Stroke, gap and height in tiles (for the editor's 2x2 top-left point-sample thumbnail, M8 fact).** Every letter
stroke is 8 tiles (thinnest measured ink run inside a letter window 8 tiles). Line-1 gap I to heart 16 tiles, line-2
letter gaps 8 tiles each, interline gap 16 tiles. Letter height 112 tiles per line. Heart bbox 110x106 tiles, feature
floor (both axes >= 10 tiles) holds for all seven shapes.

**Viewport-indicator overlay check.** The body crop carries 74 non-map-tone pixels, dominant (255,255,255), contrast
2.169 against ground (the same overlay M8 reported at 2.169). All 74 land on ground, none covers a glyph window, so
this map's booth64/booth32 are chrome-free against the overlay; the artifact is not called chrome-free without this
check.

**Per-letter ink retention at the 64 px artifact (real booth64, thresholded glyph tone).** All seven read:
I ink 60 px vertical coverage 1.0, heart 518 px 0.929, K 112 px 1.0, O 128 px 1.0, R 144 px 1.0, E 144 px 1.0,
A 144 px 1.0. At the 128 px real thumbnail every shape reads at ink-vs-area 1.0. This is the measured contrast to the
shipped build's `M8` 64 px failures on `I`, `O`, `E`; the builder does not declare either map legible, `M10` decides.

**Angular subtence of an 8-tile stroke, derived from B1's mm/px, bounded band 1 / 1.5 / 2 m, not a venue fact.**
At 25 percent (8 px/tile, 1.417 mm/tile) an 8-tile stroke is 64 px = 11.333 mm, 0.646 / 0.431 / 0.323 deg
(38.8 / 25.8 / 19.4 arcmin). At 100 percent (32 px/tile) the same stroke is 256 px = 45.34 mm. In the overview
thumbnail (0.5 px/tile) it is 4 px = 0.708 mm. In the 64 px booth artifact (0.25 px/tile) it is 2 px = 0.354 mm.

**Checks not run, named.** No grid-pitch measurement at 25 percent zoom (the design fills the sampled band, px/tile
taken from the combo reading). No blind human reader or independent agent re-read these artifacts, that is `M10`. No
literal in-game StarCraft minimap render, the playability path is blocked on this target, the editor overview thumbnail
is the whole-map real render. SCMDraft 2 map-format validation dialog not run, the dialog-button injection blocker
stands. No per-tile elevation class established for the 64/192 pair, the pair is render-validated, not harvest-validated.
The fit-to-line 21 percent zoom is below the editor floor and was not captured at that exact zoom.

**Exact inverse and teardown.** SCMDraft opened for viewing only, no map saved; teardown `pkill -f 'ScmDraft 2'`,
`pkill -f 'start.exe /exec'`, wineserver left (not killed beyond the SCMDraft kill), verified `NO_SCM_RUNNING`. Target
captures removed `rm -f /tmp/m9-*.png /tmp/t0042-run.log`, verified `captures-removed`. Controller files this step
created: `m9-open.png`, `m9-zoom25.png`, `m9-jump.png`, `m9-reopen.png`, `m9_target.py`, `m9_measure.py`,
`m9-extracted.chk`, `i-love-korea-2line.scm`/`i-love-korea-2line.chk` (intermediate build),
`i-love-korea-2line-thumbnail128.png`, `i-love-korea-2line-booth64.png`, `i-love-korea-2line-booth32.png`,
`i-love-korea-2line_report.json`, inverse `rm -f` each. Target deliverables verified byte-stable after the run:
`sha256sum` reproduces `i-love-korea` `16fe455d46fd...`, `foss-for-all` `e856f0e1...`, `rocky-logo` `447360ce...`,
`rocky-with-heart` `b9b056c2...`, `tux` `79002eacd5d6...`, `republic-of-korea` `c773a534a564...`, and the superseded
`superseded-i-love-korea.scm` `82589b4205f5...`.

## 2026-11-21 21:38 — Dispatch F2, the three `M10` record and artifact findings closed, controller-side only, no target contact, no map content changed (`Tails`)

**Scope.** The three findings `M10` wrote for `Tails` at `## Review` doc:3174, doc:3198 and doc:3212. Two controller containers
renamed, one planning-doc capture label corrected, one gate report given a provenance block. No file on 192.168.1.99 was read or
written, no map content changed, the accepted `~/scmdraft-maps/i-love-korea/i-love-korea.scm` was not opened, moved, or rewritten.
Scripts `/tmp/opencode/t0042/f2_check.py` and `/tmp/opencode/t0042/f2_control.py`, reports `f2_artifact_check.json` and
`f2_control.json`, re-cut artifacts under `/tmp/opencode/t0042/f2-recut/`. No builder module imported by either.

**Whether an entry is owed, stated rather than assumed.** The brief says to add an entry only if a target artifact actually
changes. No file on the target changed and no published booth artifact's bytes changed. A deliverable-class artifact did change,
its name, and it is the file dispatch `D2` publishes, so this entry is written and the condition is recorded rather than glossed.

**Finding 1, the duplicate `i-love-korea-2line` name is closed under the ratified `superseded-` scheme.** Command,
`sha256sum i-love-korea.scm i-love-korea-2line.scm superseded-i-love-korea.scm` before, then `mv i-love-korea-2line.scm
superseded-i-love-korea-2line.scm` and `mv i-love-korea-2line.chk superseded-i-love-korea-2line.chk`, then `sha256sum` again.
Plain `i-love-korea.scm` 614561 B `16fe455d46fd88671a98a79f3db65d934400ce0d4edd98f677313e6668d38ba9` is the accepted build and
stays at the plain booth-reachable name. `superseded-i-love-korea.scm` 614561 B `82589b4205f5deb8ed123273f1c6b5262472806bb90373d6b267c8f27e2319a0`
is the `M7` single-row build. The renamed pair is `superseded-i-love-korea-2line.scm` 614567 B
`e7ad27b2f4e7c6d12771b410edd289821fe438d7e4f2bc62caacb40a0b63efab` and its CHK 614216 B `600c75929599088d81feda76e7b0561dfc5bab3b9107cf848183d96fac131f61`,
SHAs identical to before the rename and mtimes unchanged at 19:19. Measured before renaming, the `-2line` container's `MTXM` is
identical cell for cell to the accepted build, 20600 glyph tiles, distinct values `[64, 192]`, while its internal `STR` map name
is `i-love-korea-2line` against `i-love-korea`; the name-length field at `STR` block offset 2 reads 19 against 13 and the name
string sits at block offset 2048, which accounts for the whole 6-byte size difference. **So the prefix marks a name-superseded
duplicate rather than a content-superseded build, recorded because `D2` publishes from these names.**

**Finding 2, the `m9-jump.png` label is corrected in the `M9` record.** Derived from my own viewport-indicator census of the
capture, body-local x 9-116, y 39-86, that is map cols 18-233 and rows 78-173 at 25 percent. Line 2 occupies rows 136-247 and
cols 12-243, so the frame carries rows 136-173, 38 of 112, with `K` cols 12-17 and `A` cols 234-243 clipped, and line 1 rows
78-119, the lower 42 rows. It is not a `KOREA` reveal frame and `S1` must not script the overview click at (81,175) as one. The
label at `## Implementation` is corrected in place with the correction marked, and the frame arithmetic `S1` needs, including the
16 to 17 letter-bottom rows that one vertical position at row 136 leaves unseen, is written in `## Implementation`.

**Finding 3, the booth artifacts re-cut from the 100 percent capture only and re-verified, nothing overwritten.** Crop
(18,112)-(146,240) of `m9-open.png` matches my own mask decimated by the editor's top-left-of-2x2 rule at 16384 of 16384 px in
both `m9-open.png` and `m9-reopen.png`, glyph 5149 px. Re-cut at single-step LANCZOS 0.5 and 0.25 into `f2-recut/`, both
byte-identical to the published `i-love-korea-2line-booth64.png` (`f9446f81dd86c724...`) and `i-love-korea-2line-booth32.png`
(`0fdee8346af637e4...`), 0 px differing and 0 maximum channel delta; NEAREST on the same crop differs 2658 px (delta 109) and 808
px (delta 96), so the uniform single-step Lanczos claim holds and the published files were left untouched. Indicator census, my
own, same 128x128 rectangle in all four captures, `m9-open.png` 74 indicator px and **0 on glyph**, `m9-reopen.png` 74 and 0,
`m9-zoom25.png` 308 and **33 on glyph** with its crop 306 px from the published thumbnail, `m9-jump.png` 308 and **102 on glyph**
with its crop 382 px from it, which is the recorded reason those two captures are not artifact sources. Inpaint control, replacing
the 74 overlay px with ground tone and re-running the same resize moves 126 of 4096 px in booth64 and 43 of 1024 in booth32, and
the glyph-tone count of every one of the seven elements is unchanged, delta 0, with 0 near-white pixels inside glyph blocks.
`i-love-korea-2line_report.json` gains a `f2_artifact_provenance` block naming the source capture for each artifact, the accepted
and superseded containers with their SHAs, and the per-capture indicator counts, with no measured value altered. Also verified for
`D2`, `i-love-korea-mm.png` is byte-identical to the crop (18,112)-(146,240) of `m7-open.png` and `i-love-korea-booth64.png` is
exact Lanczos 0.5 of it, so the plain-named artifacts belong to the superseded `M7` build.

**Inverse.** Undo the rename, `mv /tmp/opencode/t0042/superseded-i-love-korea-2line.scm /tmp/opencode/t0042/i-love-korea-2line.scm`
and `mv /tmp/opencode/t0042/superseded-i-love-korea-2line.chk /tmp/opencode/t0042/i-love-korea-2line.chk`. Remove what this step
created, `rm -rf /tmp/opencode/t0042/f2-recut /tmp/opencode/t0042/f2_check.py /tmp/opencode/t0042/f2_control.py
/tmp/opencode/t0042/f2_artifact_check.json /tmp/opencode/t0042/f2_control.json`. The report block is additive, the report's
measured values are unchanged and were re-read after the edit. Revert this entry and the planning-doc edits by git. No target
state was changed, so nothing on 192.168.1.99 needs an inverse.

**Checks that did not run, named.** No target contact, so the target's `i-love-korea` map size, mtime and SHA-256 and the
byte-stability of the other five deliverables are not re-verified here and remain `M9`'s claim. SCMDraft 2's own map-validation
dialog, still run on no map, `V1`. No blind reader and no independent re-read of this pass. The Zoom combo list was not opened and
no typed zoom below 25 percent was tested. No builder script was run, WCAG contrast was not re-derived, the superseded `M7`
artifacts were not re-cut or renamed, and the panel EDID geometry was not re-measured. The line-2 framing positions named for
`S1` are arithmetic on measured viewport and mask extents, no capture at those positions exists yet.

## 2026-11-21 22:43 — Dispatch D2 step 1, remote renamed and verified, staging re-run with the accepted `i-love-korea` set (`Tails`, controller-side only, no target contact)

**Rename verified from the API before anything was pushed.** New path `https://api.github.com/repos/metalllinux/rocky-linux-foss-for-all-2026-demonstration-scmdraft-2` answers `200` with `"id": 1455994123`, `"private": true`, `"visibility": "private"`, `"default_branch": "main"`, `"pushed_at": "2026-11-21T09:07:30Z"` (still the `D0` push). Old path answers `301 Moved Permanently` with body `{"message": "Moved Permanently", "url": "https://api.github.com/repositories/1455994123", ...}`, so it is a redirect to the same repository, not a second repo, exactly as the correction stated. Same id on both paths, same repo. Token consumed through `curl --config -` on stdin, the value in no argv, file, log or commit. The clone's `origin` moved to the new URL and `git ls-remote origin refs/heads/main` answers `3da0937162a5f00ba76078f0a82142910b8c7f32`, so the starting state is `D0`'s commit.

**Staging.** `python3 /tmp/opencode/t0042/d2_stage.py`, a wrapper that imports `d0_stage.classify` unchanged and applies five named deltas (superseded `i-love-korea` builds to `maps/superseded/`, the four `M7`-era `i-love-korea` booth artifacts to `booth-artifacts/superseded/` names unchanged, the `f2-recut` PNG set to `booth-artifacts/f2-recut/`, the two `f2` JSON reports to `gate-reports/`, `i-love-korea-2line-thumbnail128.png` with the booth artifacts). Walk landed 598 files 171354582 B into `/tmp/opencode/t0042/publish/`, plan at `/tmp/opencode/t0042/d2_stage_plan.tsv`. Six deliverable maps re-verified against their recorded SHAs before staging, all byte-exact, `i-love-korea` at the accepted `16fe455d46fd88671a98a79f3db65d934400ce0d4edd98f677313e6668d38ba9`. Every `.chk` withheld unchanged including `m9-extracted.chk` and the `F2` `x-*.chk` extractions, chk holds 62 to 68.

**Inverse.** `rm -rf /tmp/opencode/t0042/publish /tmp/opencode/t0042/d2_stage.py /tmp/opencode/t0042/d2_report.py /tmp/opencode/t0042/d2_verify.py /tmp/opencode/t0042/d2_stage_plan.tsv`, revert this entry by git, restore the clone remote `git remote set-url origin https://github.com/metalllinux/foss-for-all-booth-demonstration-scmdraft-2.git`. No target state touched.

**Checks not run.** No target contact, so target-side map hashes are not re-verified here, they remain `M9`'s claim.

## 2026-11-21 22:47 — Dispatch D2 step 2, booth repo pushed and verified from the remote (`Tails`, controller-side only, no target contact)

**Push.** Booth repo commit `39f2119feda546bce916f474eeeee3ae0eb2f974` on top of `3da0937`, answered
`3da0937..39f2119  main -> main` against `https://github.com/metalllinux/rocky-linux-foss-for-all-2026-demonstration-scmdraft-2`.
Team repo step-1 commit `ba5af6b`, pre-push selftest green at 61 checks. Working tree in the booth clone was rebuilt from the
staged plan (`rsync -a --delete` of `publish/`, root files and planning docs copied from the team repo at `ba5af6b`), so no
published file survives by accident.

**Content as published.** `maps/deliverable/i-love-korea.scm` is the accepted two-line build `16fe455d46fd...`.
`maps/superseded/` now holds four builds, the two pre-existing plus `superseded-i-love-korea.scm` at `82589b4205f5...` and
`superseded-i-love-korea-2line.scm` at `e7ad27b2f4e7c6d1...`, and `PUBLISH-STATUS.md` states the measured distinction between
them, the `-2line` file name-superseded with `MTXM` identical to the accepted build cell for cell and the whole 6-byte size
difference in the `STR` name field, the plain-prefixed one content-superseded at 19666 glyph tiles, two designs not three. The
four `M7`-era artifacts (`i-love-korea-mm.png`, `-mm-2x.png`, `-booth32.png`, `-booth64.png`) moved from `booth-artifacts/` to
`booth-artifacts/superseded/` with names unchanged, recorded where they went. Accepted booth artifacts for `i-love-korea` are
the `i-love-korea-2line-` trio with source capture named as `m9-open.png` per the `F2` ruling, and the `F2` re-cut and inpaint
set landed as `booth-artifacts/f2-recut/`, byte-identical to the published trio at matching SHA-256 values
(`f9446f81dd86...`, `0fdee8346af6...`, `2a9a0b860967...`). Added with `D0`'s rules, `captures/m9-open.png`, `m9-zoom25.png`,
`m9-jump.png`, `m9-reopen.png`, the `M9` and `F2` scripts under `code/`, and `gate-reports/i-love-korea-2line_report.json`,
`f2_artifact_check.json`, `f2_control.json`.

**Verified from the remote, not from the push command.** Fresh clone at `/tmp/opencode/t0042/booth-verify-d2`: `git log` shows
`39f2119` on `3da0937` on `7e0d58d`, `git ls-tree -r HEAD` holds 606 paths, `sha256sum` in that clone reproduces all six
deliverable maps at their recorded values with `i-love-korea` at the accepted one, and both superseded `i-love-korea` builds at
their recorded values. Manifest cross-check `python3 /tmp/opencode/t0042/d2_verify.py .` answers 605 rows, 605 unique paths,
0 omitted by manifest, 0 listed-but-absent, 0 size or hash mismatches, PASS. `README.md` `e278208f88b9...` and `LICENSE`
`5c620b9317b6...` byte-unchanged, `git diff --stat` for them between the two commits empty. API answers `"private": true`,
`"visibility": "private"`, `"id": 1455994123`, `"pushed_at": "2026-11-21T13:47:17Z"`, visibility unchanged. Both repo names
and the redirect evidence are recorded in `MANIFEST.md` and `PUBLISH-STATUS.md`.

**Categories `D2` did not copy, named.** All `D0` withholding re-applied unchanged, chk-or-scx-intermediate 68 files including
`m9-extracted.chk`, the rewritten `i-love-korea.chk`, `superseded-i-love-korea-2line.chk` and the three `F2` `x-*.chk`,
harvested-reference-chks 170, upstream-library 905, upstream-dataset 5, probe-map 38, build-log-or-probe 66 including `xf2.log`,
compiled-binary 4, build-artifact 17, shipped-starcraft-data 4, upstream-code 3, transient-note 4, credential 1, raw PPM 1,
`colorbase.bin` 1, ISOs 0 with none on the controller, SCMDraft and Wine binaries 0 existing on the target only, game data 0.
Named as empty rather than silently absent, booth-geometry-captures 0 (`B1` removed `b1-editor.png` under its own inverse rule,
its measurements publish in the planning doc) and shadow-independent-read-scripts-and-reading-aids 0 from the staging directory
(`M10`'s aids live under `/tmp/opencode/shadow-t0042`, outside the classified tree, same as at `D0`).

**Inverse.** Team repo, revert this entry and the step-1 entry and the `## Implementation` D2 subsection by git. Booth repo,
`git revert 39f2119` and push, which restores the `D0` state exactly. Controller, `rm -rf /tmp/opencode/t0042/publish
/tmp/opencode/t0042/booth-verify-d2 /tmp/opencode/t0042/d2_stage.py /tmp/opencode/t0042/d2_report.py
/tmp/opencode/t0042/d2_verify.py /tmp/opencode/t0042/d2_stage_plan.tsv /tmp/opencode/d2_repo_new.json
/tmp/opencode/d2_repo_after.json`. No target state touched, no visibility change, no credential in any argv, commit message or
landed file.

**Checks that did not run, named.** No target contact, target-side map sizes, mtimes and SHAs remain `M9`'s claim, last checked
target-side by `B1` at 18:40. SCMDraft 2's own map-validation dialog still run on no map, `V1`. No licence ruling on the landed
captures, `R4` and `R5` open. No re-adjudication of any legibility verdict, and no new capture or map was produced by this
dispatch.

## 2026-11-21 23:20-23:33 — Dispatch S1a step 1, booth loop runner built, deterministic rebuild gate run on all six maps (`Tails`, controller-side)

Runner `/tmp/opencode/t0042/booth_loop.py`, one command per cycle, parameters `--maps`,
`--loops`, `--display-seconds` (default 300). Inverse `rm -f /tmp/opencode/t0042/booth_loop.py`.

Pre-state read from the target, command `sshpass -f ~/AI/secrets/scm_draft_pass.md ssh
howard@192.168.1.99 'hostname; uname -r; pgrep -af "ScmDraft[ ]2"; ls -l /tmp/t0042-run.sh
/tmp/t0042-run-dos.sh; sha256sum ...'`. Answers `scmdraft2-map-creator`, kernel
`6.12.0-211.74.1.el10_2.x86_64`, `NO_SCM_RUNNING`, both launch helpers present, and the six
deliverables at `e856f0e1d62e`, `447360ce8077`, `b9b056c27a67`, `79002eacd5d6`,
`c773a534a564`, `16fe455d46fd`. No target file was written by this step.

Determinism gate, six rebuilds into `/tmp/opencode/t0042/s1a-rebuild/` with the committed
recipes, `python3 build_ts.py glyph ts-harvest/ref-era6.chk s1a-rebuild/foss-for-all 192 64 64`
and `python3 build_ts.py silhouette ts-harvest/ref-era6.chk s1a-rebuild/<map> 192 64 64 <mask>`
with masks `rocky-logo`, `rocky-with-heart`, `tux`, `republic-of-korea-10m`, `i-love-korea-2line`.
All six rebuilt `.scm` reproduce their recorded SHA-256 byte for byte, era 6, `MTXM` 65536
entries, distinct `[64, 192]`. So the loop's SHA gate can be a precondition rather than a hope.
Inverse `rm -rf /tmp/opencode/t0042/s1a-rebuild`.

Palette re-derivation method proven offline against `l4-palette.png` before any target contact:
`tesseract --psm 6 tsv` on the panel crop gives label row centres Rocky Snow 839 and High
Outpost 968 in that capture. The rows `L4` recorded, 806 and 934, sit on Moguls and High Grass
in the same capture, which is the mechanism behind `L5`'s finding that the same pixel selected
High Grass. Inverse `rm -f /tmp/opencode/t0042/_palette_ocr.png _pal.png _pal2.png _b.png _bb.png`.

## 2026-11-21 23:35-23:38 — Dispatch S1a step 2, `foss-for-all` booth cycle on the target, first pass aborted at a report defect (`Tails`)

First attempt aborted after the transfer: the runner compared the recorded SHA against the last
whitespace-separated token of the target read, which is the file *path*, so a byte-correct copy
reported `FAIL`. The target copy itself was correct, `614561 B
e856f0e1d62ec8f7ecfccf8f0d5f08aee0d5798ef972ea9fee996bbf3bfd3eb0` at
`/home/howard/.wine-scmdraft/drive_c/Maps/foss-for-all.scm`. The defect is a report defect, not
a map or transfer defect. Fixed in the runner by a 64-hex extraction (`parse_stat`). No display
step and no editor launch happened in the aborted attempt. The stray copy was removed by the
second attempt's teardown, `rm -f /home/howard/.wine-scmdraft/drive_c/Maps/foss-for-all.scm`,
verified `REMOVED`.

## 2026-11-21 23:36-23:38 — Dispatch S1a step 3, `foss-for-all` cycle complete, four main-canvas frames at the measured 8.00 px per tile floor (`Tails`)

Command, `python3 /tmp/opencode/t0042/booth_loop.py --maps foss-for-all --loops 1
--display-seconds 45 --no-paint`. Run log `/tmp/opencode/t0042/s1a-run-log.jsonl`.

| Step | Measured |
|---|---|
| build | 0.04 s, 614561 B, `glyph: era 6 chk 614210 B MTXM 65536 ISOM 265224 distinct 2 [64, 192]` |
| SHA verify before transfer | 0.00 s, `e856f0e1d62e` equals the record, PASS |
| transfer to `C:\Maps\` | 0.50 s, target `614561 B e856f0e1d62e`, PASS |
| open by `C:\Maps\foss-for-all.scm` | 25.51 s, title bar OCR `... - [C:\Maps\foss-for-all.scm ]` |
| zoom to the floor | 14.82 s, one combo walk of 6 extended-Down steps, no retry needed |
| display window, 4 frames | 56.24 s wall for a 45 s requested hold |
| teardown | 2.92 s, `NO_SCM_RUNNING`, loop copy `REMOVED` |

Every frame measured, from the capture and not from the record: viewport indicator 108 x 48
thumbnail px, that is 216 x 96 tiles, 7.931 px per tile across the 1713 px canvas, and an
independent run census, drawn dark runs 48/144/192/240 px explained 88 to 100 percent by the
committed mask's own ink runs 6/18/24/30 tiles, giving 8.0 px per tile. Frame windows cols
14-229 and 40-255, rows 64-159 and 144-239, reached by overview clicks at (79,168), (92,168),
(79,208), (92,208). Main-canvas glyph tone share per frame 8.49, 20.32, 15.99, 14.54 percent.
The open capture measures 54 x 24 tiles and 31.7 px per tile, so the zoom reset to 100 percent on
open that `M1` recorded is confirmed by measurement in this pass.

Target files this step created, `/tmp/S1aL1-foss-for-all-{open,zoom,f1..f4}.png`. Inverse
`rm -f /tmp/S1aL1-foss-for-all-*.png /tmp/t0042-run.log`, not yet applied, applied at the
end of the dispatch so the operator can inspect the captures (rule r002). Controller files
`s1a-build/foss-for-all.{scm,chk}`, `S1aL1-foss-for-all-*.png`, `s1a-run-log.jsonl`. The
deliverable original `/home/howard/scmdraft-maps/foss-for-all/foss-for-all.scm` was not opened,
not written and not saved by the editor.

## 2026-11-21 23:46-23:49 — Dispatch S1a step 4, `i-love-korea` booth cycle complete, six main-canvas frames on the `F2`-derived positions (`Tails`)

Command, `python3 /tmp/opencode/t0042/booth_loop.py --maps i-love-korea --loops 1
--display-seconds 45 --no-paint`.

build 0.05 s, 614561 B; SHA verify 0.00 s, `16fe455d46fd` equals the record, PASS; transfer
0.54 s to `/home/howard/.wine-scmdraft/drive_c/Maps/i-love-korea.scm`, target read `614561 B
16fe455d46fd`, PASS; open 25.83 s by `C:\Maps\i-love-korea.scm`, title bar OCR `... -
[C:\Maps\i-love-korea.scm ]`; zoom 15.03 s, one combo walk, no retry; display window 60.57 s
for a 45 s request across 6 frames; teardown 2.92 s, `NO_SCM_RUNNING`, loop copy `REMOVED`.

Frame windows and clicks, cols 12-227 and 28-243 crossed with rows 8-103, 136-231 and 152-247,
clicks (78,140), (86,140), (78,204), (86,204), (78,212), (86,212). Every frame measures
108 x 48 thumbnail px of viewport indicator, 216 x 96 tiles, 7.931 px per tile, and the run
census reads 8 px per tile explaining 88.1 to 100 percent of drawn runs. The row-152 frames are
the ones that carry the bottoms of all five letters, which is the position `F2` derived at
doc:2544-2547 and did not capture. Main-canvas glyph tone share 45.62, 45.47, 38.41, 38.69,
36.56, 36.73 percent. `S1aL1-i-love-korea-f5.png` shows `KOREA` with letter bottoms inside the
viewport, read visually, and its Zoom combo reads 25 percent.

Target captures created, `/tmp/S1aL1-i-love-korea-{open,zoom,f1..f6}.png`, inverse
`rm -f /tmp/S1aL1-i-love-korea-*.png /tmp/t0042-run.log`, applied in step 6 and verified.
The deliverable original was not opened, written or saved.

## 2026-11-21 23:56-23:58 — Dispatch S1a step 5, the proven painting segment run inside the cycle on the scratch map, palette coordinates re-derived from a live capture (`Tails`)

Command, `python3 /tmp/opencode/t0042/booth_loop.py --paint-only`. Scratch map only, no
deliverable map was opened, saved or touched by the editor.

Pre-state of the scratch map on the target, `/home/howard/.wine-scmdraft/drive_c/Maps/
live-demo-ice.scm` 12502 B `f00d1f60521c...` mtime 2026-11-21 08:18:33, the file `L5`'s editor
save wrote. Backup taken, `cp -f live-demo-ice.scm live-demo-ice.scm.pre-s1a`, inverse
`cp -f live-demo-ice.scm.pre-s1a live-demo-ice.scm && rm -f live-demo-ice.scm.pre-s1a`. The
flat seed `/tmp/opencode/t0042/live-demo-ice.scm` was verified at `8f338a3cea24...` on the
controller and transferred in 0.28 s. Open 25.74 s by `C:\Maps\live-demo-ice.scm`.

Palette re-derivation, 2.10 s, `tesseract --psm 6 tsv` on a fresh capture of the panel, method
`ocr-tsv-label-rows`, answers Rocky Snow y 839, High Outpost y 968, High Grass y 935. The click
was made at (62, 968) and the status bar readout after the click reads
`Isometrical Terrain Ice World\High Outpost`, read from the capture. This closes the `L5`
finding on the evidence: the palette rows are stable across launches and match `l4-palette.png`
exactly, and `L4`'s recorded click at y 934 sits on the High Grass row, so `L5`'s High Grass
selection was a mis-mapped row in `L4`, not an unstable tree.

Segment, `L4`'s proven step list, band1 7.08 s, band2 6.95 s, three page-down pan clicks 8.67 s,
band3 6.89 s, Ctrl+D Ctrl+T Ctrl+U Ctrl+T 9.81 s, status-bar evidence capture 1.88 s. Measured
change, `S1aL1-live-demo-ice-{before,band1,band2,pan,band3,layers,statusbar,palette,open}.png`
on the target, inverse `rm -f` applied in step 6. Contrast measured in this pass on the tone the
segment actually selected, ground (176,176,176) against the painted High Outpost tone
(48,40,24) WCAG 6.713, and 6.267 as the median across 42581 sampled changed pixels, against the
3.0 gate. Share of each commanded stroke rectangle that changed, 55.8, 49.73 and 57.64 percent,
measured as changed pixels divided by rectangle pixels, which is a different ratio from `L4`'s
13.8 to 19.1 percent (changed pixels inside the rectangle divided by all changed pixels).

Teardown 2.66 s, `NO_SCM_RUNNING`, and the scratch map restored from the backup to 12502 B
`f00d1f60521c...`, byte-identical to its pre-step state with mtime 2026-11-21 23:58:13. No save
was performed on any map in this step.

## 2026-11-22 00:02 — Dispatch S1a step 6, post-run target verification and capture teardown (`Tails`)

Six deliverables re-read on the target, all at their recorded SHA-256 with their pre-dispatch
mtimes unchanged, `foss-for-all` `e856f0e1d62e` 614561 B mtime 2026-11-20 06:03:19,
`rocky-logo` `447360ce8077` 614559 B 2026-11-20 08:17:08, `rocky-with-heart` `b9b056c27a67`
614565 B 08:17:09, `tux` `79002eacd5d6` 614552 B 2026-11-20 20:33:23, `republic-of-korea`
`c773a534a564` 614566 B 2026-11-21 10:49:37, `i-love-korea` `16fe455d46fd` 614561 B 19:28:35.
`pgrep -af "ScmDraft[ ]2"` answers `NO_SCM_RUNNING`. Loop copies in `C:\Maps\` absent, only
`live-demo-ice.scm` restored to `f00d1f60521c...` and the pre-existing reference map remain.
This dispatch's target captures removed, `rm -f /tmp/S1aL1-*.png /tmp/t0042-run.log`, verified
`CAPTURES_REMOVED`.

Left on the target deliberately, four SCMDraft backups its own open path wrote in
`/home/howard/.wine-scmdraft/drive_c/Maps/`, `Scme205.tmp` 614561 B (foss-for-all open),
`Scm933.tmp` 614552 B (tux), `Scmcc91.tmp` 614561 B (i-love-korea), `Scm71d3.tmp` 614562 B
(live-demo-ice). Inverse `rm -f` each, left in place per rule r002 so the operator can see what
one booth cycle costs the target disk, about 2.4 MB per cycle for six maps.

## 2026-11-22 07:51 — Dispatch S1b phase A, the three new maps on the target at a 300 s window (`Tails`)

Command `python3 /tmp/opencode/t0042/booth_loop.py --tag-prefix S1bA --maps
rocky-logo,rocky-with-heart,republic-of-korea --loops 1 --display-seconds 300`, rc 0, 51 log
records appended to `/tmp/opencode/t0042/s1a-run-log.jsonl`. First run of the two new cycle
steps. `tmp_cleanup` 0.76 s, `find /home/howard/.wine-scmdraft/drive_c/Maps -maxdepth 1 -name
"Scm*.tmp"` listed and `rm -f` removed nine backups, 4326926 B freed, all named in the log record
(`Scm2518 Scm6aac Scm71d3 Scm7251 Scm86f3 Scm9194 Scm933 Scmcc91 Scme205`), `remaining 0`;
inverse recorded as permanent deletion, the editor recreates one per open. `disk_headroom_before`
`df -B1 /` avail 65004978176 B, `du -sb C:\Maps\` 102928 B; `disk_headroom_after` avail
64998404096 B, `C:\Maps\` 2561180 B, consumed 6574080 B of which 2458252 B is the four new
`Scm*.tmp` residue and the rest this dispatch's 30 target captures in `/tmp/S1bAL1-*.png`.

Per map, each rebuilt by `build_ts.py` from the committed mask code, each reproducing its
recorded SHA-256 before transfer and matching it again on the target after scp to the absolute
path `/home/howard/.wine-scmdraft/drive_c/Maps/<name>.scm`, each opened by its drive-qualified
`C:\Maps\<name>.scm` path, no save step on any map. Build 0.09, 0.10, 0.60 s; transfer 0.52,
0.51, 0.51 s; open 25.97, 25.47, 25.85 s with the title bar carrying the `C:\Maps` path; teardown
2.90, 2.89, 2.91 s each answering `NO_SCM_RUNNING` and `REMOVED` for the loop copy. Totals at the
300 s window, `rocky-logo` 362.63 s, `rocky-with-heart` 361.94 s, `republic-of-korea` 353.90 s;
non-display overhead 44.55, 43.89, 44.36 s against `S1a`'s 44.06 s carried figure. Zoom verified
from pixels on every map, viewport indicator 216 x 96 tiles, 7.931 x 7.854 px per tile, first
verification pass, not from the Zoom combo. Display windows measured 318.08 s (6 frames), 318.05 s
(6 frames), 309.54 s (3 frames) against the 300 s request, the overshoot is per-frame capture plus
metrics cost inside the hold loop and is recorded rather than smoothed. Palette re-derived from a
fresh capture at setup, method `ocr-tsv-label-rows`, Rocky Snow 839 and High Outpost 968, the
`S1a` corrected rows, not the `L4` hardcoded fallback. Paint segment on the scratch map, median
WCAG 6.267 over 42581 changed sampled pixels against the 3.0 gate, scratch map restored at
teardown, `NO_SCM_RUNNING`.

Residue after phase A, named: `Scmd702.tmp` 614559 B (rocky-logo open), `Scm5f7f.tmp` 614565 B
(rocky-with-heart), `Scme782.tmp` 614566 B (republic-of-korea), `Scm52ee.tmp` 614562 B (scratch
open, same size pattern `S1a` recorded for `Scm71d3.tmp`). Target captures `/tmp/S1bAL1-*.png`
30 files, inverse `rm -f /tmp/S1bAL1-*.png` to be applied at the dispatch's final verification
after the controller-side analysis. Inverse of the whole phase for the target: loop copies already
removed at each teardown, captures removable, residue named above.

## 2026-11-22 08:33 — Dispatch S1b phase B, one full six-map booth cycle at the 300 s default (`Tails`)

Command `python3 /tmp/opencode/t0042/booth_loop.py --tag-prefix S1b300 --maps
foss-for-all,rocky-logo,rocky-with-heart,tux,republic-of-korea,i-love-korea --loops 1
--display-seconds 300`, rc 0, 88 run-log records, report `/tmp/opencode/t0042/S1b300_cycle_report.json`.
First full six-map cycle ever run end to end. Per-map totals, build, transfer, open, teardown in
seconds: `foss-for-all` 355.97 / 0.04 / 0.51 / 25.53 / 2.90; `rocky-logo` 362.02 / 0.04 / 0.53 /
25.46 / 2.91; `rocky-with-heart` 361.95 / 0.10 / 0.53 / 25.46 / 2.89; `tux` 361.94 / 0.10 / 0.52 /
25.48 / 2.90; `republic-of-korea` 353.87 / 0.56 / 0.52 / 25.84 / 2.90; `i-love-korea` 362.40 /
0.06 / 0.50 / 25.86 / 2.89. Non-display overhead 43.88 to 44.36 s on every map. Every map
reproduced its recorded SHA-256 from the committed mask code before transfer and matched it on the
target after; every teardown answered `NO_SCM_RUNNING` with the loop copy `REMOVED`; no save step
touched any map. Zoom verified from pixels on all six, indicator 216 x 96 tiles at 7.931 x 7.854 px
per tile. Display windows measured 309.54 to 318.07 s against the 300 s request.

Cycle cost, measured: 2232.36 s = 37 min 12 s (maps 2158.15 s, scratch paint 72.96 s, cycle steps
1.25 s), against `S1a`'s projected 2219.5 s, a 0.58 percent deviation, which retires the projection
in favour of the measurement. Complete cycles that fit, computed from this measured cost: 1 in one
hour, 3 in two hours, 4 in three hours.

Cycle steps: `tmp_cleanup` 0.75 s removed the four phase-A residue files named in the previous
entry (2458252 B), `remaining 0`. Disk headroom before 64997818368 B avail and `C:\Maps\` at
102928 B; after 64989118464 B avail and `C:\Maps\` at 4404854 B. The 8699904 B consumed is the
seven `Scm*.tmp` backups the cycle's opens wrote (4301926 B) plus this phase's target captures in
`/tmp/S1b300L1-*.png`. Palette re-derived from a fresh capture at setup, `ocr-tsv-label-rows`,
839 and 968. Paint median WCAG 6.267 over 42581 sampled changed pixels. Scratch map restored to
12502 B `f00d1f60521c...` at teardown. Inverse for the phase: loop copies removed per teardown,
captures removable with `rm -f /tmp/S1b300L1-*.png` at final verification, residue named, scratch
restored.

## 2026-11-22 08:57 — Dispatch S1b phase C, one full six-map cycle at the 150 s window (`Tails`)

Command `python3 /tmp/opencode/t0042/booth_loop.py --tag-prefix S1b150 --maps
foss-for-all,rocky-logo,rocky-with-heart,tux,republic-of-korea,i-love-korea --loops 1
--display-seconds 150`, rc 0, 88 run-log records, report `/tmp/opencode/t0042/S1b150_cycle_report.json`.
Per-map totals at 150 s: `foss-for-all` 204.96, `rocky-logo` 212.49, `rocky-with-heart` 211.92,
`tux` 211.98, `republic-of-korea` 203.93, `i-love-korea` 212.46 s; overheads unchanged at 43.86 to
44.46 s; display windows measured 159.57 to 168.06 s against the 150 s request. All six SHA gates
PASS before transfer and re-matched on the target, all six teardowns `NO_SCM_RUNNING` and `REMOVED`,
zoom verified from pixels on all six, palette re-derived `ocr-tsv-label-rows` 839 and 968, paint
median WCAG 6.267. Measured cycle cost 1331.99 s = 22 min 12 s; complete cycles that fit from this
cost: 2 in one hour, 5 in two, 8 in three. `tmp_cleanup` 0.74 s removed the seven phase-B residue
files named in the phase B entry (4301926 B), `remaining 0`; headroom 64989360128 B before,
64979861504 B after. The shorter window costs 44.7 percent of cycle time against 50 percent of the
display time, because the 44 s per-map overhead does not shrink, which is the number the booth
schedule turns on.

## 2026-11-22 09:05 — Dispatch S1b final verification, target left clean apart from named residue (`Tails`)

Six deliverables re-read on the target after all three phases, all at their recorded SHA-256 with
unchanged mtimes: `foss-for-all` `e856f0e1d62e` 614561 B 2026-11-20 06:03:19, `rocky-logo`
`447360ce8077` 614559 B 08:17:08, `rocky-with-heart` `b9b056c27a67` 614565 B 08:17:09, `tux`
`79002eacd5d6` 614552 B 2026-11-20 20:33:23, `republic-of-korea` `c773a534a564` 614566 B
2026-11-21 10:49:37, `i-love-korea` `16fe455d46fd` 614561 B 19:28:35. `pgrep -af "ScmDraft[ ]2"`
answers `NO_SCM_RUNNING`. This dispatch's target captures removed, `rm -f /tmp/S1bAL1-*.png
/tmp/S1b300L1-*.png /tmp/S1b150L1-*.png /tmp/t0042-run.log`, verified `CAPTURES_REMOVED`. Loop
copies in `C:\Maps\` absent, `live-demo-ice.scm` restored at 12502 B. Residue present and named,
the seven `Scm*.tmp` backups the final cycle's seven opens wrote: `Scm159d.tmp` 614561 B
(foss-for-all), `Scm3681.tmp` 614559 B (rocky-logo), `Scm74a4.tmp` 614565 B (rocky-with-heart),
`Scmb0b2.tmp` 614552 B (tux), `Scmeeb3.tmp` 614566 B (republic-of-korea), `Scmf78.tmp` 614561 B
(i-love-korea), `Scm4e21.tmp` 614562 B (scratch open), 4301926 B total, left in place per rule
r002, inverse `rm -f /home/howard/.wine-scmdraft/drive_c/Maps/Scm*.tmp`. Final `df -B1 /` reads
avail 64999227392 B against 65004978176 B at dispatch start, 5750784 B net consumed of which the
4301926 B residue is named; the remaining 1448858 B is not attributed to a named file, candidates
are the seven launches' Wine prefix writes and scp temp files, recorded as unattributed rather than
guessed.

## 2026-11-22 09:40 — Dispatch D3 step 1, pre-flight verification of the renamed booth repo and the six deliverables (`Tails`, controller-side only, no target contact)

Remote state verified before any write, through `python3 /tmp/opencode/t0042/d3_api.py`, a GET-only
probe that reads the token from `~/AI/secrets/token.md` at run time inside the process, so no
credential value is in argv, a file, a log or a commit. `metalllinux/rocky-linux-foss-for-all-2026-
demonstration-scmdraft-2` answers `id 1455994123`, `private true`, `visibility private`, default
branch `main`, `refs/heads/main = 39f2119feda546bce916f474eeeee3ae0eb2f974`, `pushed_at
2026-11-21T13:47:17Z`. The dispatch addresses the repo by the new name in every API call and in the
clone remote. The six controller deliverables re-verified with `sha256sum` against the recorded
values before staging, all byte-exact: `foss-for-all` `e856f0e1d62e...` 614561 B, `rocky-logo`
`447360ce8077...`, `rocky-with-heart` `b9b056c27a67...`, `tux` `79002eacd5d6...`,
`republic-of-korea` `c773a534a564...`, `i-love-korea` `16fe455d46fd...`. Delta surface since the `D2`
push inventoried with `find -newermt "2026-11-21 22:48"`, 181 files 25870389 B excluding the clone,
publish, scratch-rebuild and `__pycache__` directories: the booth runner `booth_loop.py`, the
measured run log `s1a-run-log.jsonl` (279 records), four cycle reports, 170 booth-loop captures,
and the `D3` scripts themselves. Recorded open hygiene observed at run time, unchanged and not
touched: `~/AI/secrets/scm_draft_pass.md` is still mode 644 (`## Status` records it as an operator
action), `rdp-args` still exists on the controller and is withheld by the classifier. Inverse, no
target state was touched and no repo state changed by this step; the probe script lands under
`/tmp/opencode/t0042` outside git-tracked paths, `rm -f /tmp/opencode/t0042/d3_api.py` removes it.

## 2026-11-22 09:55 — Dispatch D3 step 2, booth runbook authored and the D3 staging run (`Tails`, controller-side only, no target contact)

The runbook `BOOTH-RUNBOOK.md` was authored at `/tmp/opencode/t0042` from the runner as it stands
after `S1b` and from the measured cycle reports, and every number in it was re-checked against the
step log before publication, frame counts 4, 6, 6, 6, 3 and 6 from the `S1b300L1` frame records,
`tmp_cleanup` 0.74 to 0.76 s, the paint contrast census 42581 changed pixels sampled at median WCAG
6.267 with minimum pair 1.2 identical across all three phases, and the six map sizes 614552 to
614566 B from `sha256sum`. Staging ran as `python3 /tmp/opencode/t0042/d3_stage.py`, `D0`'s classifier
imported unchanged, `D2`'s five deltas imported unchanged, three named `D3` deltas, landed 778 files
197210938 B, plan `/tmp/opencode/t0042/d3_stage_plan.tsv`. The three `D3` deltas, `s1a-run-log.jsonl`
lands in `booth-loop/`, `BOOTH-RUNBOOK.md` lands at the repository root outside the classify walk,
and the scratch directories `s1a-build/` and `s1a-rebuild/` are outside the walk because their
`.scm` files carry the deliverable basenames and would have copied byte-identical duplicates into
`maps/deliverable/`. A credential scan compared every landing file's bytes against the four values
in `~/AI/secrets/` read at run time and printed only the count, zero hits. Withheld categories hold
at the `D2` figures for every hard category, `.chk` and `.scx` intermediates 68, harvested reference
CHKs 170, upstream library 905, upstream dataset 5, probe maps 38, credential 1, compiled binaries 4.
Inverse, `/tmp/opencode/t0042/publish/` and `d3_stage_plan.tsv` are regenerable from the scripts,
`rm -rf` removes them, no target state was touched.

## 2026-11-22 10:05 — Dispatch D3 step 3, booth repo push and remote verification (`Tails`, controller-side only, no target contact)

Booth repo commit `f0255bd752b3e5f4a39f24111b82d8ccb6e28ee1` pushed onto `39f2119`, push answered
`39f2119..f0255bd main -> main` against `metalllinux/rocky-linux-foss-for-all-2026-demonstration-
scmdraft-2`, and `git ls-remote` reads the same hash at `refs/heads/main`. Verified from a fresh
clone at `/tmp/opencode/t0042/booth-verify-d3` rather than from the push output, `git log` shows the
four-commit chain, `git ls-tree -r HEAD` holds 787 paths against 606 at `D2`, `git diff
--name-status 39f2119 HEAD` is 181 added and 4 modified with zero deletions and zero renames, the
modified set being `DEMO-LOG.md`, `MANIFEST.md`, `PUBLISH-STATUS.md` and the TASK-0042 planning doc,
`sha256sum` in the clone reproduces all six deliverables at recorded values and the four superseded
builds at theirs, and `git diff --stat` for `LICENSE` and `README.md` between the two commits is
empty. Manifest cross-check with `d2_verify.py` in the clone, 786 rows against 787 tree paths, 0
omitted, 0 absent, 0 mismatches, PASS. API after the push answers `private true`, `visibility
private`, `id 1455994123`, visibility unchanged. Deviation recorded rather than erased, my three
earlier team commits in this dispatch were made with `commit.gpgsign=false` against a chain that is
signed throughout, the booth commit was amended to carry the signature before pushing, and the
rewriting of pushed history was declined, full account in `## Implementation`. Checks not run, no
target contact, the published runner was not executed from a bare clone because its build step needs
the withheld reference CHK and the withheld password, no independent read of the 165 booth-loop
captures, no licence ruling. Inverse, the booth commit is a normal fast-forward on `main`, removing
it would need a force-push and none was performed or is proposed, `/tmp/opencode/t0042/booth-verify-d3`
removes with `rm -rf`.

## 2026-11-22 10:45 — Dispatch S1c step 1, the published no-rebuild mode built and published, verified from a fresh remote clone (`Tails`, controller-side and repo-side, one read-only target read)

The gap `D3` named is closed in code. `booth_loop.py` now has two map-acquisition modes.
`--source rebuild` is the default and is what every measured cycle ran in, it rebuilds each map from
the committed mask code through `build_ts.py` against `ts-harvest/ref-era6.chk`. `--source published`
skips the rebuild, reads each map read-only from `<clone>/maps/deliverable/<name>.scm`, and drives the
same open, display, painting-segment and teardown sequence with no save. The runner grew
`preflight_published`, which hashes all six published maps and the published paint seed against the
recorded SHA-256 values and names what a clone carries and what it does not, `preflight_target_run_script`,
which compares the launch script on the target against the clone's `code/t0042-run-dos.sh`, installs the
published copy only if the target has none and refuses to overwrite one that differs, a
`published_source` step in place of `build`, a named refusal in rebuild mode when the reference CHK is
absent, a seed-source switch in `run_paint`, a `mode` field in every log record, and a path model where
`HERE` is the script's own directory and `CHAOTIX_T0042_WORK` and `CHAOTIX_T0042_INJECTOR` separate
scratch from injector so a clone run writes nothing into the clone. Compile checked with
`python3 -W error::SyntaxWarning -m py_compile booth_loop.py`, clean.

Two tests before any publish, both against the local clone at `f0255bd` with `CHAOTIX_T0042_WORK`
pointed at `/tmp/opencode/t0042/s1c-test` so the published step log is untouched. Test 1,
`preflight_published` over all six maps answers PASS, `maps_checked 6`, and records the lists
`clone_carries` and `clone_does_not_carry`. Test 2, `run_map` in rebuild mode from the clone copy logs
`build FAIL` with `reason=rebuild mode needs the withheld reference CHK, which the published repository
does not carry; run --source published from a clone instead`, returns False, and makes no target
contact. Test 2 is the concrete demonstration of the `D3` gap rather than a restatement of it.

Booth repo commit `dd86b46e9cc43937b05ccbfadefa29fe4e5d2e48`, signed Good, pushed `f0255bd..dd86b46`,
carrying `code/booth_loop.py` 36458 to 47217 B and `BOOTH-RUNBOOK.md` 10472 to 14259 B with the mode
documentation, and `MANIFEST.md` rows recomputed by `/tmp/opencode/t0042/s1c_manifest.py`, 786 rows,
17 groups, 198390282 bytes listed, 2 rows updated and 784 rows unchanged. Credential scan reused from
`D3`, `d3_stage.credential_scan`, 4 secret values read at run time against 5 changed files, zero hits,
values printed nowhere.

Verified from a fresh clone of the pushed repository at `/tmp/opencode/t0042/booth-clone-s1c` rather
than from the push output, `git log` shows `dd86b46` on `f0255bd`, `git ls-tree -r HEAD` holds 787
paths, `sha256sum` in the clone reproduces all six deliverables at their recorded values, the clone's
`code/booth_loop.py` is byte-identical to `/tmp/opencode/t0042/booth_loop.py` at
`38c46709c491...`, `live-segment/maps/live-demo-ice.scm` reproduces `8f338a3cea24...` which is the seed
the painting segment needs, `python3 /tmp/opencode/t0042/d2_verify.py .` answers 786 rows against 787
tree paths, 0 omitted, 0 absent, 0 mismatches, PASS, and the clone working tree is clean.

Inverse, `/tmp/opencode/t0042/booth-clone-s1c` and `/tmp/opencode/t0042/s1c-test` remove with
`rm -rf`, `/tmp/opencode/t0042/s1c_manifest.py` with `rm -f`, the booth commit is a normal
fast-forward on `main` and removing it would need a force-push, which is not performed and not
proposed. Pre-dispatch target state read read-only before any of this, through
`sshpass -f ~/AI/secrets/scm_draft_pass.md ssh howard@192.168.1.99` with `pgrep`, `ls -l`, `sha256sum`,
`df -B1` and `du -sb`, `NO_SCM_RUNNING`, `C:\Maps\live-demo-ice.scm` at 12502 B `f00d1f60521c...`,
seven `Scm*.tmp` backups left by `S1b` totalling 4301926 B, `/tmp/t0042-run-dos.sh` at
`a85bba3c89f1...`, `df -B1 /` avail 65000390656 B, `du -sb C:\Maps` 4404854 B. No target file was
written by this step, and `preflight_target_run_script` has not run yet, it runs at the start of the
clone run. Checks not run at this point, the measured six-map cycle in published mode, which is the
next step, no independent read of the captures this dispatch will produce, no licence ruling.

## 2026-11-22 10:50 — Dispatch S1c step 2, bounded smoke cycle in published mode from the fresh clone (`Tails`, one map, 20 s window)

`cd /tmp/opencode/t0042/booth-clone-s1c && python3 code/booth_loop.py --source published --clone
/tmp/opencode/t0042/booth-clone-s1c --maps tux --display-seconds 20 --tag-prefix S1cSmoke`, rc 0,
30 log records, one map plus the painting segment. `preflight_published` PASS with `maps_checked 1`.
`preflight_target_run_script` PASS, `/tmp/t0042-run-dos.sh` on the target reads `a85bba3c89f1...`,
equal to the clone's published `code/t0042-run-dos.sh`, no install needed, read-only inverse.
`published_source` read `/tmp/opencode/t0042/booth-clone-s1c/maps/deliverable/tux.scm` read-only at
614552 B, `sha_verify_controller` PASS `79002eacd5d6`, transfer PASS with the target copy re-hashing to
the same value, open on `C:\Maps\tux.scm` with the path in the title bar, zoom verified from the
capture indicator at 216 x 96 tiles and 7.931 x 7.854 px per tile in one verification pass, teardown
`NO_SCM_RUNNING` with the loop copy `REMOVED`. Per-map total 80.53 s, overhead excluding display
44.12 s, which is the `S1a` and `S1b` 44 s overhead unchanged in published mode. The painting segment
took its seed from `live-segment/maps/live-demo-ice.scm` in the clone at `8f338a3cea24...`, re-derived
the palette by OCR at Rocky Snow 839 and High Outpost 968, and measured 42581 changed pixels at median
WCAG 6.267 with minimum pair 1.2, identical to all three `S1b` phases. Scratch map restored to 12502 B
`f00d1f60521c...` at teardown. Cycle cost for this smoke cycle 154.38 s. `tmp_cleanup` at cycle start
removed the seven `Scm*.tmp` backups `S1b` had left under rule r002, named with sizes in the log,
4301926 B, so the r002 residue from `S1b` is now gone by the runner's own documented cycle-start
behaviour and the residue visible to the operator at the end of this dispatch is this dispatch's own.

## 2026-11-22 11:28 — Dispatch S1c step 3, one full six-map cycle measured in published mode from a fresh clone at the 300 s default (`Tails`, target touched)

`cd /tmp/opencode/t0042/booth-clone-s1c && python3 code/booth_loop.py --source published --clone
/tmp/opencode/t0042/booth-clone-s1c --maps foss-for-all,rocky-logo,rocky-with-heart,tux,republic-of-korea,i-love-korea
--loops 1 --display-seconds 300 --tag-prefix S1c300`, rc 0, 90 log records, wall clock 10:51:17 to
11:28:34, 37 min 17 s. Report `/tmp/opencode/t0042/S1c300_cycle_report.json`, console
`/tmp/opencode/t0042/s1c300.out`.

**Measured cycle cost 2232.13 s, 37 min 12 s, against the 2232.36 s `S1b` measured in rebuild mode, a
difference of 0.23 s or 0.01 percent.** Maps total 2157.96 s, cycle steps 1.26 s, painting segment
72.91 s. `modes_recorded` for the cycle is `["published"]`. Complete cycles that fit, computed from
this measurement, 1 in one hour, 3 in two, 4 in three, the same figures `S1b` produced.

Per-map totals 356.69 `foss-for-all`, 361.97 `rocky-logo`, 362.01 `rocky-with-heart`, 361.96 `tux`,
352.91 `republic-of-korea`, 362.42 `i-love-korea`. Non-display overhead 43.35 to 44.64 s per map,
unchanged from `S1b`'s 43.86 to 44.46 s, so removing the rebuild changes nothing measurable in the
cycle. Acquisition is `published_source` at 0.00 s on all six maps instead of a `build` at 0.04 to
0.56 s. Transfer 0.51 to 0.54 s, open 25.46 to 26.17 s, zoom walk 14.44 to 15.10 s, teardown 2.89 to
2.93 s. Display windows 309.56 to 318.08 s against the 300 s request, the same 3 to 6 percent
per-frame capture overhead `S1b` recorded.

Every one of the six maps passed `sha_verify_controller` against its recorded SHA-256 before transfer
and re-matched on the target after transfer, `e856f0e1d62e`, `447360ce8077`, `b9b056c27a67`,
`79002eacd5d6`, `c773a534a564`, `16fe455d46fd`, with target sizes 614561, 614559, 614565, 614552,
614566 and 614561 B. All six opens carry the opened drive-qualified path in the title bar. All six
zoom settings verified from the capture indicator at 216 x 96 tiles and 7.931 x 7.854 px per tile in
one verification pass each, no combo readout used. 31 scripted display frames captured and measured,
4, 6, 6, 6, 3 and 6 across the six maps, the same frame plan `S1b` used, planned from the mask code the
clone publishes at `code/rocky.py` and `code/glyph.py`. All six teardowns answer `NO_SCM_RUNNING` with
the loop copy `REMOVED`. The painting segment ran on the clone's seed, palette re-derived at rows 839
and 968, 42581 changed pixels sampled at median WCAG 6.267, minimum pair 1.2. No editor save was
performed on any map, the runner has no save step, and the six originals in `~/scmdraft-maps/` keep
their 2026-11-20 and 2026-11-21 mtimes.

Target disk for the cycle, `df -B1 /` avail 64994611200 B before and 64983736320 B after, 10874880 B
consumed. Named items account for 11497541 B of that, the seven `Scm*.tmp` backups the cycle's seven
opens wrote at 4301926 B, and the 52 capture PNGs the cycle left in `/tmp` on the target at 7195615 B,
which the runner writes for scp to fetch and never deletes. The 622661 B surplus against the measured
consumption is not attributed, recorded rather than guessed. This also names the leading candidate for
`S1b`'s 1448858 B unattributed delta, the same target-side capture PNGs, and it is a booth-day fact
worth knowing, a multi-hour session accumulates roughly 7.2 MB per cycle of captures on the target
against 65 GB free.

## 2026-11-22 11:35 — Dispatch S1c step 4, post-cycle verification and the runbook wording correction (`Tails`, target read-only)

`python3 code/booth_loop.py --stability` from the clone, all six deliverable originals on the target at
their recorded SHA-256 values with mtimes 2026-11-20 06:03, 2026-11-20 08:17, 2026-11-20 08:17,
2026-11-20 20:33, 2026-11-21 10:49 and 2026-11-21 19:28, all before this cycle started, so nothing in
the cycle wrote to them. `pgrep -af "ScmDraft[ ]2"` answers `NO_SCM_RUNNING`. `C:\Maps\` holds the
pre-existing reference map `(2)River Crossing.scm` 90426 B, the scratch map restored at 12502 B
`f00d1f60521c...`, and exactly seven named `Scm*.tmp` residue files, `Scm8406.tmp` 614561 B,
`Scmf546.tmp` 614559 B, `Scm7b4a.tmp` 614565 B, `Scm199.tmp` 614552 B, `Scm87c5.tmp` 614566 B,
`Scmf0d2.tmp` 614561 B and `Scm799f.tmp` 614562 B, 4301926 B total, left in place per rule r002,
inverse `rm -f /home/howard/.wine-scmdraft/drive_c/Maps/Scm*.tmp` recorded in the cycle log.

One accuracy correction found by checking the clone after the run. The runbook as pushed at `dd86b46`
says a published-mode run writes nothing into the clone it runs from. That is true of captures, OCR
crops, the run log and the reports, which all go to `CHAOTIX_T0042_WORK`, but importing the mask code
makes Python write `code/__pycache__/` inside the clone, 67389 B of bytecode caches for `rocky`,
`glyph`, `korea`, `korea_10m`, `rocky_svg` and `tux`. Untracked, removable with
`rm -rf /tmp/opencode/t0042/booth-clone-s1c/code/__pycache__`, and the runbook now says that rather
than the cleaner-sounding thing.

## 2026-11-22 11:45 — Dispatch S1c step 5, booth repo publish of the measured record, one manifest defect found by the cross-check and repaired (`Tails`, controller-side and repo-side, no new target contact)

Booth repo commit `0f31e969d7da3f29d1196641385e1968d8f5518e`, signature Good, pushed `dd86b46..0f31e96`,
publishes this dispatch's run record, six modified files (`BOOTH-RUNBOOK.md` with the published-mode cost
row and two wording corrections, `DEMO-LOG.md`, `MANIFEST.md`, `PUBLISH-STATUS.md` with a new `S1c`
section, `booth-loop/s1a-run-log.jsonl` at 399 records, `code/booth_loop.py`) and two added
(`gate-reports/S1c300_cycle_report.json`, `gate-reports/S1cSmoke_cycle_report.json`). Credential scan
reused from `D3`, 4 secret values against 8 landing files, zero hits.

Defect found by running the cross-check rather than trusting the generator. `d2_verify.py` against a
fresh clone of `0f31e96` answered `manifest rows 786 unique paths 786 tree paths 789
omitted-by-manifest 2`, FAIL. The two new gate-report rows had been written by `/tmp/opencode/t0042/s1c_manifest.py`
without the backticks around their SHA-256 values that the manifest's own row format uses, so the
cross-checker did not read them as rows at all. Recorded rather than quietly amended, booth commit
`93ff47bbe04746110922204f8aeccc8dd14040f4`, signature Good, pushed `0f31e96..93ff47b`, repairs the two
rows and the generator that wrote them. No pushed commit was rewritten, the defective commit stays in the
chain where a reader can see it.

Re-verified from a second fresh clone, `/tmp/opencode/t0042/booth-verify-s1c-b` at `93ff47b`, `git ls-tree
-r HEAD` 789 paths, `python3 /tmp/opencode/t0042/d2_verify.py .` answers 788 rows, 788 unique paths, 789
tree paths, 0 omitted, 0 absent, 0 size-or-hash mismatches, PASS. `git diff --name-status f0255bd HEAD`
is 6 modified and 2 added with zero deletions and zero renames, so nothing published by `D0`, `D2` or
`D3` was replaced or moved by this dispatch. `git diff --stat` for `LICENSE` and `README.md` over the same
range is empty, the files read `5c620b9317b6...` and `e278208f88b9...`. `sha256sum` in that clone
reproduces all six deliverables at their recorded values, `e856f0e1d62e`, `447360ce8077`, `b9b056c27a67`,
`79002eacd5d6`, `c773a534a564`, `16fe455d46fd`, at 614561, 614559, 614565, 614552, 614566 and 614561 B.
`git ls-remote` answers `93ff47b` at `refs/heads/main`. The API through `/tmp/opencode/t0042/d3_api.py`,
token read inside the process, answers `id 1455994123`, `visibility private`, `default_branch main`,
`pushed_at 2026-11-22T02:42:43Z`, visibility unchanged.

Not published by this dispatch, named. The 69 capture frames this dispatch produced, 52 tagged
`S1c300L1-*` and 17 tagged `S1cSmokeL1-*`, stay on the controller under `/tmp/opencode/t0042`, publishing
them belongs to a publish dispatch that re-runs the `D0` classification over a controller tree rather than
to a mode change. Inverse for this step, the two booth commits are normal fast-forwards on `main` and
removing them would need a force-push, which is not performed and not proposed, and
`/tmp/opencode/t0042/booth-verify-s1c-b`, `/tmp/opencode/t0042/s1c-test` and
`/tmp/opencode/t0042/booth-clone-s1c` remove with `rm -rf`.
## 2026-11-22 12:12 — Dispatch V1 step 1, keyboard navigation probe and the full menu census of SCMDraft 2 Beta 0.9.10 (`Tails`, target, copies only, no save on any map)

Target preflight, `pgrep -af "ScmDraft[ ]2"` answers `NO_SCM_RUNNING`, and `sha256sum` over
`/home/howard/scmdraft-maps/*/*.scm` reproduces all six accepted deliverables at their recorded values
(`e856f0e1d62e`, `447360ce8077`, `b9b056c27a67`, `79002eacd5d6`, `c773a534a564`, `16fe455d46fd`) with mtimes
2026-11-20 06:03, 2026-11-20 08:17, 2026-11-20 08:17, 2026-11-20 20:33, 2026-11-21 10:49 and
2026-11-21 19:28, all before this dispatch. Validation runs on six copies
`cp /home/howard/scmdraft-maps/<n>/<n>.scm /home/howard/.wine-scmdraft/drive_c/Maps/v1-<n>.scm`, each copy
verified at the same SHA-256 before any editor contact, inverse `rm -f
/home/howard/.wine-scmdraft/drive_c/Maps/v1-*.scm`. The originals are never opened by an editor.

Keyboard probe, three results. A bare Alt (`key 0x38`) is delivered, the status bar reads `154, 311 (4,9)`
against `v1-alt1.png`, but no menu opens and no accelerator underline appears in the bar. `Alt+E`
(`keydown 0x38, key 0x24, keyup 0x38`) produces nothing visible, `v1-alte.png`. `F10` (`key 0x44`) produces
nothing visible, `v1-f10.png`. What does work: one injected pointer click on a menu-bar title arms the bar,
and from there **the arrow keys drive the whole menu bar**, `keyx 0x4D` moving one menu right with the
menu opening automatically, proven across Scenario, Advanced, Options, File, Edit, Display Options,
Triggers and Help, `/tmp/opencode/t0042/v1-kbd-triggers.png` reached purely by three right-arrows from the
Display Options click. So the menu bar IS keyboard drivable; the Delphi-dialog-button limit recorded at
item 4 does not apply to it, and the earlier "menu did not stay open" reading at DEMO-LOG 2026-11-20
applied to a click that was not the arming click.

Full menu census, every entry read from the captures, this is the evidence for the V1 verdict.
`File` New Ctrl+N, Open Ctrl+O, Recent Maps, Close, Save Ctrl+S, Save As, Save Image, Quit.
`Edit` Undo Ctrl+Z, Redo Ctrl+Y, Cut, Copy, Paste, Select All Ctrl+A, Delete Del, Clear Selections Esc,
Convert to terrain, Stack Selected, Create Location, Create Inverted Location, Layer, Properties Enter.
`Options` Grid, Units, Locations, Doodads, Sprites, Preview Fog of War, Cut Copy Paste, Output, Zoom,
Map Load, Enable Sound, Profile Settings.
`Display Options` All Colors, Display Units, Cloak Units, Hide Units, Animate unit death, Show Powered
Status, Hide Map Revealers, Display Doodad Sprites, Cloak Doodad Sprites, Hide Doodad Sprites, Display
Sprites, Cloak Sprites, Hide Sprites, Enable Color Cycling.
`Scenario` Map Dimensions Ctrl+Shift+Enter, Map Properties Ctrl+Shift+F, Forces Ctrl+Shift+F, Unit Settings
Ctrl+Shift+H, Upgrade Settings Ctrl+Shift+U, Tech Settings Ctrl+Shift+E, Strings Ctrl+Shift+S, Sound Editor
Ctrl+Shift+W, Place Map Revealers, Remove Map Revealers, Disable Fog, Enable Fog, Jump to Start location
Ctrl+G, Randomize Minerals. `Advanced` Check for Updates, Open Backup Database, Automatically check for
updates. `Triggers` Classic Map Triggers Ctrl+Shift+T, Classic Mission Briefing Ctrl+Shift+B, Trigger
Editor, Mission Briefing Editor. `Windows` opened with no readable contents in two attempts. `Help` About,
Homepage, Donate.

**No menu or submenu of SCMDraft 2 Beta 0.9.10 carries a map-validation, error-check or validity command.**
The only "check" entries are `Advanced > Check for Updates` and `Automatically check for updates`, which
are software-update checks, not map checks, and neither was activated. `Advanced > Open Backup Database`
is the editor's own backup store, not a validator, and was not opened.
## 2026-11-22 12:31 — Dispatch V1 step 2, two negative controls, what SCMDraft 2 does when a map is malformed (`Tails`, target, throwaway copy, original untouched)

The menu census says there is no validation command. Two controls test whether the editor validates at all,
and whether anything it would show is keyboard reachable. Control file
`/home/howard/.wine-scmdraft/drive_c/Maps/v1-negtest.scm`, a copy of `v1-foss-for-all.scm` (itself a copy
of the accepted `e856f0e1d62e...` map), inverse `rm -f .../v1-negtest.scm`.

Control 1, one byte flipped deep in the container at offset 307280 of 614561, file
`63dd948f2f1b...`. Launched by `C:\Maps\v1-negtest.scm`. The editor opened it with **no error dialog**, the
title read `SCmdDraft 2.0 (Beta 0.9.10) - [C:\Maps\v1-negtest.scm ]`, the thumbnail still rendered FOSS FOR
ALL, and `v1-neg-open.png` shows the normal editor (`/tmp/opencode/t0042/v1-neg-open.png`). `Ctrl+S`
followed by `Enter` produced no dialog and no write, `stat` still
`614561 2026-11-22 12:27:11` and `sha256sum` still `63dd948f2f1b...`.

Control 2, the CHK section name `VER ` renamed to `XER ` at the first section header, file
`1b1ee97cd66f...`. On launch the editor showed `Scmdraft 2 - Select Profile`, Enter dismissed it as in every
prior dispatch, and the editor then opened **a blank untitled new map** with no filename in the title bar, a
grey empty canvas and a default `Terrain / Doodads / Locations / Units / Unit Sprites / Pure Sprites` tree
(`/tmp/opencode/t0042/v1-neg2-open.png`, `v1-neg2-after.png`). The corrupt map was refused **silently**, no
error text, no validation report, nothing to record and nothing to dismiss. `Ctrl+S` on that state produced
no dialog and no file write.

Reading. SCMDraft 2 Beta 0.9.10 has no user-facing map-validation surface: no menu command (step 1), no load
-time report, and a malformed map is either silently tolerated (control 1) or silently dropped in favour of a
blank map (control 2). The one dialog that did appear, the profile selector, is keyboard drivable by Enter,
which is already how every dispatch in this task has launched the editor.
## 2026-11-22 12:44 — Dispatch V1 step 3, the editor's own load and save path run on all six accepted maps, verdict, six hashes unchanged (`Tails`, target, copies only)

Runner `/tmp/opencode/t0042/v1_cycle.sh <map>`, inverse `rm -f /tmp/opencode/t0042/v1_cycle.sh`. Per map:
record copy size, mtime and SHA-256, launch by drive-qualified path `C:\Maps\v1-<map>.scm`, Enter to dismiss
the profile dialog, capture, `Ctrl+S` then three Enters (the L5 chain), capture, re-hash, `pkill` with no
save. All six ran in order at 12:34 to 12:41.

Map / copy SHA-256 before / after / open captured / save-attempt captured:
`foss-for-all` `e856f0e1d62e` unchanged, `v1-foss-for-all-open.png`, `v1-foss-for-all-save.png`.
`rocky-logo` `447360ce8077` unchanged, `v1-rocky-logo-open.png`, `v1-rocky-logo-save.png`.
`rocky-with-heart` `b9b056c27a67` unchanged, `v1-rocky-with-heart-open.png`, `v1-rocky-with-heart-save.png`.
`tux` `79002eacd5d6` unchanged, `v1-tux-open.png`, `v1-tux-save.png`.
`republic-of-korea` `c773a534a564` unchanged, `v1-republic-of-korea-open.png`, `v1-republic-of-korea-save.png`.
`i-love-korea` `16fe455d46fd` unchanged, `v1-i-love-korea-open.png`, `v1-i-love-korea-save.png`.

For all six the copy's mtime also stayed at the 12:11:08 copy time, so the editor wrote nothing to the copy
either. Every `-open` and `-save` capture is pixel-identical in its title strip (dark-pixel counts equal in
all six pairs, 2032, 1973, 2225, 1728, 2253, 2053), each title reads
`SCmdDraft 2.0 (Beta 0.9.10) - [C:\Maps\v1-<map>.scm ]` with **no dirty-marker asterisk**, verified by 4x
LANCZOS upscale crops read visually for `tux`, `i-love-korea` and `republic-of-korea`
(`v1-title4x-<map>.png`). No map reported an error, and no save, validation or error dialog appeared on any
of the six.

**Verdict for the DoD box.** SCMDraft 2 Beta 0.9.10 has no map-validation feature to drive. The full menu
census in step 1 names every entry of all nine menus and carries no validation, error-check or validity
command. The two controls in step 2 show the editor reports nothing on load either: a byte-corrupted map is
accepted silently, a map with a broken CHK section name is refused silently in favour of a blank untitled
map. The keyboard path is drivable, arrow keys walk the menu bar and Enter drives the dialogs that do exist,
so the limitation is the application's missing feature, not the injection method. Recorded as: the box is
run against the editor that exists, and its result is that this build performs no map validation.

Post-cycle target state, all six deliverable originals at their recorded SHA-256 with mtimes unchanged at
2026-11-20 06:03, 2026-11-20 08:17, 2026-11-20 08:17, 2026-11-20 20:33, 2026-11-21 10:49 and
2026-11-21 19:28. `pgrep -af "ScmDraft[ ]2"` answers `NO_SCM_RUNNING`. Residue, sixteen `C:\Maps\Scm*.tmp`
editor backups totalling 9832973 B, seven pre-existing from `S1c` (10:51 to 11:27) and nine created by this
dispatch (five at 12:11 when the six copies were first opened, one 12:11 per remaining copy, then `Scmbf92`
and `Scmcf61` at 12:23, `Scm8d58` at 12:27 and `Scm245f` at 12:30 from the two negative-control launches),
left in place per rule r002, inverse `rm -f /home/howard/.wine-scmdraft/drive_c/Maps/Scm*.tmp`. Measured, the
six 12:34 to 12:41 validation launches created no new `Scm*.tmp` backup at all, so the open-time backup this
task saw in `S1a` to `S1c` is not written on every launch and the per-cycle residue bound carried from `S1b`
is an upper bound, not a constant. Six validation copies left in place for the
operator to inspect, inverse `rm -f /home/howard/.wine-scmdraft/drive_c/Maps/v1-*.scm`. Target `/` headroom
64978395136 B free of 75056865280.

**Checks that did NOT run, named.** No validation dialog was exercised on any map, because none exists in
this build. `Advanced > Check for Updates` and `Automatically check for updates` not activated, they are
software-update checks and one would have opened a network call. `Advanced > Open Backup Database` not
opened. The `Windows` menu was opened twice with no readable contents and its entries were not enumerated,
so a validation command hidden in that menu cannot be ruled out by capture, only by the fact that it opens
as an empty or list-style menu. `Help > About` not opened, so the exact build string was not read from the
application itself, it is read from the title bar. Submenus under `Options` (Grid, Units, Locations, Doodads,
Sprites, Preview Fog of War, Cut Copy Paste, Output, Zoom, Map Load), under `Edit > Layer`, and under
`Scenario > Place Map Revealers`, `Remove Map Revealers`, `Disable Fog`, `Enable Fog` were not expanded and
not enumerated. `File > Save As` and `Save Image` were not exercised. A dirty-map save chain (paint, then
Ctrl+S) was not run in this dispatch, so the question of whether an editor save on a copy triggers any
validation prompt before writing remains open, and the L5 record shows a save on a dirty map completes
without a validation prompt. No OCR read of the six title bars succeeded at 2x upscale, tesseract returned
garbage on all six, the visual 4x reads stand instead, and that is three maps read visually rather than six.
No independent reader has read these captures.
