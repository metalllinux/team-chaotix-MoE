# Compatibility layer for SCMDraft 2 on Rocky Linux 10.2

Depth: 1-pager. Written by `Tails` 2026-11-14 after live testing on target `192.168.1.99`.

## 1. Context

SCMDraft 2 0.9.10 is a PE32 (32-bit) Windows GUI application built in Delphi. The target is
`192.168.1.99`, Rocky Linux 10.2 x86_64, GNOME 49 Wayland, AMD Lucienne iGPU. No native Linux
build exists. The user's stated preference is Valve's Proton (GE-Proton specifically, since
no Steam account exists). The alternative is Wine from a package repo.

## 2. Options tested

### Option A — COPR Wine 10.17 (Staging)

Source: Fedora COPR project `forecastwolf157/Wine-test`, builds for Alma+epel 10 (ABI-compatible
with Rocky 10). NEVRA: `wine-10.17-1.el10.x86_64`. Dependencies from CRB (`mingw64-zlib`,
`mingw64-win-iconv`) and baseos.

How it runs SCMDraft 2: Wine 10.17's built-in WoW64 mode loads the 32-bit Windows PE inside
the 64-bit Wine process (log: `starting in experimental wow64 mode`). No 32-bit Linux loader
required. Wine's Wayland driver (`waylanddrv`) provides native Wayland windows.

Result: **WORKS.** SCMDraft 2 displayed its "Select Profile" dialog with the full splash
image, profile list, and buttons. Process stayed alive, rendering via Wayland. Screenshot:
`~/AI/demo-evidence/task0042-wine-scmdraft2.png`, 1609215 bytes, PNG 1920x1080 RGBA.

### Option B — GE-Proton 11-12 tarball

Source: GitHub release `GloriousEggroll/proton-ge-custom`, tag `GE-Proton11-12`, x86_64 asset.
SHA-512 verified: `2e37447902529c9fc39138dc0b3f24aed3513b59a190b825e6b4a668e49e2033bdf6b8a7998e8686e067bbb3f61f3a6633e2408f0cc96f6dad983bd18e2db31e`. 567 MB, 9007 files.

How it attempts to run SCMDraft 2: the `proton` script (Python) sets up the prefix and calls
`subprocess.call([wine_bin, "wineboot"])` and then `subprocess.call([wine_bin, exe])` without
bubblewrap (Steam Runtime launcher not found). GE-Proton's bundled `wine` binary (Wine 11.0
Staging, 64-bit ELF) immediately exec's `files/lib/wine/i386-unix/wine-preloader`, which is a
**32-bit Linux ELF** binary requiring `/lib/ld-linux.so.2` (the 32-bit glibc dynamic linker).

Result: **FAILS.** The 32-bit wine-preloader cannot load: `/lib/ld-linux.so.2: could not open`.
Root cause confirmed by `strace`: `execve(".../i386-unix/wine-preloader", ...) = 0` then
`open("/lib/ld-linux.so.2", O_RDONLY) = -1 ENOENT`.

Why `/lib/ld-linux.so.2` is absent: `glibc.i686` (the 32-bit glibc package that provides it) is
not available from any repository on this system: not in `baseos`, `appstream`, `extras`, `crb`,
`epel`, or RPM Fusion. Verified: `dnf list available glibc.i686` returns "No matching Packages"
across all enabled repos, and `rpm -q glibc.i686` returns "not installed".

Additional blocker (even if glibc.i686 were installable): GE-Proton's `proton run` normally
runs Wine inside a Steam Linux Runtime container via `steam-runtime-launcher-interface-0` or
bubblewrap. Without Steam installed and no Steam Runtime extracted, the sandbox environment is
absent. The GE-Proton documentation describes this as the expected deployment path.

## 3. Decision

**Wine 10.17 (COPR `forecastwolf157/Wine-test`).** Because it actually runs SCMDraft 2 on
Rocky Linux 10.2 Wayland, demonstrated by a captured screenshot showing the SCMDraft 2 window
rendered correctly. GE-Proton fails because its Wine 11.0 build requires a 32-bit Linux loader
that does not exist on Rocky 10, and its intended deployment path (Steam Runtime container)
requires a Steam installation that does not exist on the target.

The user's stated preference is Proton. Proton was tested first. It lost on the evidence. The
decision is Wine.

## 4. Consequences

- Repo trust: the COPR project `forecastwolf157/Wine-test` introduces GPG key
  `gpg-pubkey-465fccc2-68bd0e9e` (summary: `forecastwolf157_Wine-test (None)
  <forecastwolf157#Wine-test@copr.fedorahosted.org>`) to the target's trust set. This is a
  Fedora COPR project key (not a distribution key). Removal: `rpm --erase gpg-pubkey-465fccc2-68bd0e9e`.
  EPEL and RPM Fusion were tested and removed (Wine not available from them for EL 10).
- CRB enablement (`dnf config-manager --set-enabled crb`): a Rocky Linux official repository
  was disabled by default and is now enabled. This is Rocky's own repo, not third-party.
- Wine prefix at `~/.wine-scmdraft/`: a stateful directory. A future Wine update (via the COPR)
  could break the prefix if Wine changes its registry format. The NEVRA is recorded.
- GE-Proton tarball left at `~/.proton-test/`: 567 MB disk consumed, no security risk, removable
  with `rm -rf ~/.proton-test/`.

## 5. Reversibility

| Change | Inverse |
|---|---|
| COPR repo `forecastwolf157/Wine-test` enabled | `sudo dnf copr disable -y forecastwolf157/Wine-test` (removes `.repo` file and key) |
| CRB enabled | `sudo dnf config-manager --set-disabled crb` |
| Wine installed from COPR | `sudo dnf remove wine wine-core wine-desktop wine-alsa wine-cms wine-ldap wine-pulseaudio wine-smartcard wine-twain` |
| Wine prefix `~/.wine-scmdraft/` | `rm -rf ~/.wine-scmdraft/` |
| SCMDraft 2 extracted at `~/scmdraft2/` | `rm -rf ~/scmdraft2/` |
| EPEL installed (as prerequisite, not needed for final Wine path) | `sudo dnf remove epel-release` |
| RPM Fusion free/nonfree installed (not needed for final Wine path) | `sudo dnf remove rpmfusion-free-release rpmfusion-nonfree-release` |
| GE-Proton tarball at `~/.proton-test/` | `rm -rf ~/.proton-test/` |

Point of no return: none. Every change above is fully reversible.

## 6. Checks not run

- **Steam Runtime container path for GE-Proton**: not tested because Steam is not installed
  and no Steam Runtime tarball was extracted. This is the path that *could* make GE-Proton
  work, but it requires Steam installation and is out of scope (no Steam credentials exist).
- **Source-built Wine**: not tested. Not needed because the COPR package works.
- **Wine with game data loaded**: not tested in this item. Item 2's job.
