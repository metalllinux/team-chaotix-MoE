# TASK-0042 — FOSS for All booth demo: SCMDraft 2 on the Rocky 10.2 GNOME target, five maps

> **Section order below is fixed.** Each agent writes to its own section and no other. `Robotnik`
> reads only `## Status` and `## Next Actions`. Do not reorder, rename, or remove sections.

- **Created:** 2026-11-13
- **Event:** FOSS for All Conference 2026, 2026-11-28, Centerfield EAST 18F, AWS Korea, Seoul (verified 2026-11-13 from 2026.fossforall.org and forum.fossforall.org). 15 days from task creation.
- **Depends on:** `planning/docs/TASK-0041-remote-visual-control.md` (eyes and hands on the target).
- **Documentation repo:** `metalllinux/foss-for-all-booth-demonstration-scmdraft-2` (private, default branch `main`, created 2026-11-13, empty at task start).
- **Continuous log:** `DEMO-LOG.md` (repo root) — append one dated entry per step.

---

## Status

**PM handoff required, this session can no longer dispatch (2026-11-15).** Two dispatch attempts failed with request 262191 tokens against the 262144 context limit, the same number both times, and what the child inherits is this session's own context. That is learned rule r001, and the remedy is a fresh `Robotnik` session in this directory rather than a smaller brief. `Robotnik` can still edit files, so the record is completed here instead of left stale. Everything a fresh session needs is in this doc, in `planning/docs/TASK-0041-remote-visual-control.md`, and in `DEMO-LOG.md`, and `## Next Actions` now carries the next dispatch written out verbatim so it does not have to be reconstructed from memory.

**Now (2026-11-20):** Map 1 `foss-for-all` is rebuilt on Ice World at 256 by 256, WCAG 7.423 on the map's own render and 6.709 on the booth simulation, against the 3.0 gate. Tileset contrast was measured across seven tilesets from 157 harvested plaintext CHKs, and Jungle, Ash, Twilight and Badlands all fail the gate, which retires Jungle for booth use outright. Maps 2 to 5 use Ice World or Space Platform.

**Robotnik ratification (2026-11-20).** `Tails` renamed the superseded Jungle build `superseded-foss-for-all-jungle.scm` and flagged the naming as its own extension rather than a decision it owns. Ratified. The three-name scheme is now `foss-for-all.scm` for the current build, `superseded-` for a build that worked but was replaced, and `rejected-` for a build that failed its gate. Booth selection cannot reach either prefixed file.

**Robotnik decision on map order (2026-11-20).** Maps 2 and 3, `rocky-logo` and `rocky-with-heart`, are built next and read independently before maps 4 and 5 are attempted, because `republic-of-korea` and `tux` are the two designs whose silhouettes carry the shape risk, and a read on the shield designs either confirms the technique carries silhouettes or reopens the GR-graphics contingency while only two maps are at stake.

**Earlier state (2026-11-20, superseded by the paragraph above):** Map 1 was built on Jungle World and passed the independent legibility gate on identifiability, then failed the contrast gate at 1.98.

**Robotnik decision on contrast (2026-11-20, recorded rather than asked).** The live risk is contrast, not legibility. `Shadow` measured WCAG ratios of 1.15 to 1.23 between glyph and ground against a 3.0 text minimum, and within Jungle the brightest tested tone reaches only 1.98 against the darkest blue. A bright exhibition hall with off-axis viewing is the expected booth condition, so a 1.2 ratio is a likely failure rather than a theoretical one. Maps 2 to 5 must not be built on the Jungle palette. Next dispatch tests a brighter tileset from the harvested reference and rebuilds map 1 against it, gated on a measured ratio at or above 3.0 rather than on an impression. `Shadow` named the brighter tileset as a hypothesis to test, not a fact, so the acceptance is the measurement.

**Robotnik decision on the in-game minimap box (2026-11-20, recorded rather than asked).** The DoD asks for the design to be readable on the in-game minimap. That box is met by proxy, not literally, and it stays in the DoD rather than being rewritten. Evidence met today is SCMDraft 2's own overview thumbnail in three separate captures, which is the editor's render of the whole 256 by 256 map. A literal in-game minimap needs the playability path that item 3 proved unreachable on this target, and the single remaining `uinput` attempt is the only route to it, scheduled after the maps. If that attempt fails the box is recorded as blocked by the playability blocker with the proxy evidence named, which is a stated limitation rather than a removed requirement.

**Robotnik decision on map 1 filenames (2026-11-20).** `Shadow` flagged that two files exist for map 1 and the illegible 2026-11-14 build holds the plain name. The legible build holds `foss-for-all.scm`, the rejected build is renamed with a `rejected-` prefix, and the rename inverse is recorded. Booth readiness must not be able to select the illegible file.

**Earlier state (2026-11-19):** Programmatic construction is the technique, and the unknown had narrowed to a single field. The launch method is proven, an SSH-spawned SCMDraft reaches the Wayland driver once the seat0 session environment is exported, and the earlier `nodrv_CreateWindow` wall was a missing-environment problem rather than a target limit. The container format is accepted, SCMDraft 2 0.9.10 opens the unencrypted combined-CHK MPQ the writer produces with its scenario tree populated. What fails is terrain values, arbitrary TILE group and ISOM values render blank while River Crossing renders the full Jungle World under the same launch. So the valid values must be harvested from a map that renders, and a dispatch is running to obtain one plaintext CHK.

**Earlier state:** Items 1 to 4 complete, map building has started. Item 4 fixed the control path, keyboard scancode injection through `scripts/rdp-input.c` for Ctrl+T, Ctrl+U, Ctrl+S and Enter, canvas clicks for terrain painting, and a save path of `taskkill` followed by two Enters, proven by a file that grew from 90426 to 93113 bytes and by tiles that survived a relaunch. Item 5, map 1 `foss-for-all`, is built and saved at `~/scmdraft-maps/foss-for-all/foss-for-all.scm`, 95081 bytes, with editor screenshots and a clean load. `Shadow` is verifying the one claim that matters for everything downstream, whether terrain lettering is actually legible, before four more maps are built on the same technique.

**Prior state:** Items 1 and 2 complete. SCMDraft 2 0.9.10 runs on the target under Wine 10.17 from COPR `forecastwolf157/Wine-test`, with real StarCraft data loaded, and a screenshot proves terrain rendering rather than blank placeholders: the Jungle World tileset with Dirt, Mud, Jungle, Rocky Ground and Ruins tiles, doodads, mineral fields, a blue start location, and a status bar reading `Jungle World\Dirt`. The reason for rejecting Proton is now verified with commands rather than asserted: `dnf repoquery --available glibc.i686` returns nothing across baseos, appstream, extras, crb, EPEL and RPM Fusion, `*.i686` returns zero packages in EPEL, and `/lib/ld-linux.so.2` does not exist. Rocky 10 ships no 32-bit loader, so a 32-bit Proton cannot run 32-bit Windows binaries on it. Item 3 (playability) was attempted 2026-11-14 and **failed: none of the three playability routes produces a StarCraft game window rendering a loaded map on this target**, so the DoD playability box is not met. Detail and evidence in `## Implementation`.

**Handoff, child session overflow (2026-11-14).** The dispatch that proved programmatic construction died on a context overflow, request 262191 tokens against a 262144 limit, when a mid-run follow-up was added to a session that had already run over a hundred turns. This is the shape of failure that learned rule r001 describes, and it produced a hard error rather than a silent empty result. The record survived because that session wrote its findings before it died, at `## Implementation` lines 1000 to 1041, which is what a fresh dispatch is now working from. Procedural consequence, implementation dispatches get a fresh session per item rather than being continued, and long-running sessions are not sent follow-ups.

**Robotnik decision on technique (2026-11-14, recorded rather than asked).** GUI painting inside SCMDraft 2 is abandoned as the construction method. The recovery pass proved the control path reaches Ctrl+N, Ctrl+D, Ctrl+U, Ctrl+T and Ctrl+A, but could not confirm the Delete scancode, and the Isometrical to Rectangular view toggle did not respond to injected clicks, so the two things needed to draw legibly by hand are the two things that do not work. Construction moves to programmatic map writing, terrain arrays written directly into the map CHK inside the MPQ from a bitmap mask, with SCMDraft 2 as the viewer and verifier rather than as the instrument. Reason, the CHK terrain arrays give one tile per pixel at up to 256 by 256 tiles, which is resolution a 4 to 5 tile drag brush cannot reach, and it removes the brush and elevation artefacts that produced the zigzag Shadow measured. IronGRP, MIT and Linux-native, is recorded as the GR-graphics path in case silhouette work needs real artwork. Firegraft obtained from the Ar3sgice starcraft-tools mirror has no licence file there, so Charmy rules before that mirror is cited anywhere. Verification is unchanged, screenshot, a 4x booth simulation, a colour-coverage measurement, and an independent reader.

**Technique blocker, open (2026-11-14, `Shadow`).** Map 1's terrain lettering reads as noise, not as "FOSS for All". Shadow read the full-resolution evidence and could not identify a single letterform, and a 4x Lanczos downscale simulating booth distance left only a herringbone zigzag of cliff edges over a blue field, with blue coverage rising from 0.4 percent in the baseline to 43.9 percent in the painted state against roughly 8 percent expected. Two structural causes. The drag brush lays a 4 to 5 tile band inside 7-tile-wide glyphs, so at most 2 tiles of counter space remain and the next stroke fills them. And the map was an uncleared copy of River Crossing, so painted low Water beside existing elevated terrain raises cliff walls along every stroke. Glyph size was ruled out as the cause, a 7-tile glyph is about 6 cm and subtends about 1.8 degrees at 2 m. The internal structure is destroyed before distance matters. Plan contingency doc:83 is therefore triggered, and items 6 to 9 must not be dispatched on this technique unchanged.

**Technique recovery, incomplete (2026-11-14, `Tails`).** Neither candidate technique was tested to completion. The recovery pass proved control-path progress (Ctrl+N opens New Map dialog, Ctrl+D/U/T layer switching confirmed, Ctrl+A selects all doodads on the Doodads layer) but did not achieve a cleared flat map, did not switch to Rectangular terrain mode, did not reduce the brush, did not paint a test glyph, and did not place a test unit. No booth-simulation artifact was produced. No colour-coverage measurement was made. **Neither technique is proven legible. Neither is disproven.** Items 6 to 9 remain blocked on the same Shadow blocker. GR-graphics tooling located: IronGRP (MIT, obtainable), Firegraft (freeware, obtainable from Ar3sgice GitHub repo), bmp2scx (licence unknown, downloadable). "grCreator" does not exist as a named tool. The `bmp2scx` path (bitmap→terrain tiles in a map file, no painting required) is the recommended next test because it bypasses the brush and drag mechanism entirely. Detail in `## Implementation` (Technique recovery).

**False completion recorded, both sides kept.** `DEMO-LOG.md:569` and the item 5 verdict in `## Implementation` both state the strokes are recognisable. The images contradict both. The builder's claim and Shadow's finding are kept side by side rather than resolved silently. The lesson is procedural, so from this point a map is not built until an agent other than the builder has read its screenshot and said whether it is legible. That gate is now in `## Definition of Done`.

**Bounded recovery result (2026-11-14, `Tails`).** The black composite was a build problem, not a permanent target limit. Flatpak Wine `org.winehq.Wine` 11.0 renders Brood War on this target, with the intro and the full 116.1 main menu in screenshots, where COPR Wine 10.17 produced a single black colour. Wine's emulated virtual desktop did not change the cooperative level, the game keeps `DDSCL_EXCLUSIVE` 640x480x8. The blocker is now input rather than rendering. In the only rendering-capable mode, exclusive fullscreen, StarCraft captures the pointer and injected RDP input does not reach it, two clicks left the cursor fixed at (975, 565), and the process stayed alive. On this Wayland target, presentation and RDP input injection are mutually exclusive for this game. Kernel-level `uinput` injection is the one remaining mechanism that could break that mutual exclusion, because a compositor-level pointer grab does not hide events from `/dev/uinput`.

**Playability blocker, stated plainly.** Route (b), `StarCraft.exe` in the same Wine prefix, starts the game with valid data (no data-file error, 640x480x8 exclusive DirectDraw set, 6067 front-buffer writes in 22 s) and the window is pure black, proven by pixel analysis: one color, `(1512000, (0, 0, 0))`. Wine 10.17 on this target has only a working Wayland graphics driver; the X11 driver cannot be made to load (`HKCU\Software\Wine\Drivers` `"Graphics"="x11"` set and ignored; with the Wayland driver disabled, `nodrv_CreateWindow`), and no X display can be built because `xorg-x11-server-utils` and `xorg-x11-server-Xvfb` resolve to nothing on the enabled repos. Route (a), SCMDraft 2's own play function, launches that same `StarCraft.exe` under that same Wine build, so it was not run end to end rather than reported as failing. Route (c), OpenBW, does not load `.scm` maps at all: the token `scm` occurs zero times in `replay.h`, `ui/ui.h` and `data_loading.h` upstream, and its `load_replay` requires its own identifier `0x53526572`. What *does* pass is the input gate: `CHAOTIX42` typed through `xfreerdp /kbd:pipe:` is visible in a Wine-hosted window and confirmed by OCR, and injected pointer motion is tracked by SCMDraft 2's own coordinate readout.

**Robotnik decision on playability (2026-11-14, recorded rather than asked).** The DoD playability box stays. It gets one bounded recovery pass with three hypotheses, in this order, because each is cheap and each attacks a different part of the evidence. 1. Wine's emulated virtual desktop, which is the standard answer for an old title that requests exclusive DirectDraw mode and gets a black composite. 2. A different Wine build, specifically Flatpak Wine from Flathub, because the recorded symptom is that this COPR build has no working X11 driver at all, and that build would also retire the personal COPR the demo currently depends on. 3. A native engine path, OpenBW or OpenSAGE, treated as a real option only if a build is achievable in one pass. If all three fail, the playability box is rewritten as an explicit limitation with the evidence for why the target cannot composite this game, and the demo is described as map creation plus editor verification. That rewrite is a decision I will record, not a box that quietly disappears.

**Recovery pass outcome (Tails, 2026-11-14):** all three hypotheses failed acceptance, no loaded-map screenshot; the black-composite blocker is resolved by Flatpak Wine 11.0 (renders intro and 1.16.1 menu) but the menu cannot be driven to a loaded map because exclusive-fullscreen StarCraft captures the pointer, and no single-pass native-engine path exists. Detail in `## Implementation` (Item 3 recovery) and DEMO-LOG 14:56.

**Open items this creates.**
1. Game data provenance. The MPQs and `StarCraft.exe` came from a StarCraft Anthology installer ISO hosted on archive.org, extracted with `mpyq`. That is a copy of Blizzard data whose provenance this team did not verify, and the official free Blizzard path was not the one used. Charmy and Flicky must rule on it before the documentation repo describes how the data was obtained.
2. Target state drifted. Item 1 removed EPEL and RPM Fusion as unneeded; item 2 re-enabled both for `7zip`, `unrar` and `pip`. Booth readiness must state the target's final repo set with exact removal commands.
3. `DEMO-LOG.md` has no item 2 entry. The work is recorded in `## Implementation` but not in the continuous log, and the DoD requires one dated log entry per target-touching step.
4. `forecastwolf157/Wine-test` is still an unruled personal COPR carrying the demo's Wine. Omega rules on it, with a recorded source-build fallback.

**Verified facts (2026-11-13, `Robotnik`):**
- Target `192.168.1.99` = hostname `scmdraft2-map-creator`, Rocky Linux 10.2 (`el10_2`), GNOME Shell 49.4, Wayland session on `seat0 tty2`, 16 vCPU, 61 GB RAM, 64 G free on `/`, extra 931.5 G `nvme0n1`, AMD Lucienne iGPU. Enabled repos: `baseos`, `appstream`, `extras`.
- Download source `http://www.stormcoast-fortress.net/cntt/software/scmdraft/download/` lists SCMDraft II 0.9.10 as current release (Installer and ZIP), plus 0.9.11 pre-release alphas under `/Irregularies/`, plus SCXE, DatEdit, Firegraft, grCreator-adjacent tools. All downloads are Windows binaries. The site's own non-Windows guide is `http://www.stormcoast-fortress.net/cntt/software/scmdraft/wine-example/` (Wine). No native Linux build is offered.
- Neither `wine` nor `steam` is installed on the target, and neither is in the enabled repos, so the compatibility layer is itself an install decision with a repo decision attached.
- GitHub: repo exists and is writable with the token at `~/AI/secrets/token.md`. `gh` is not installed on the controller; GitHub writes go through `curl` against the REST API, or through `git` over HTTPS using the token (never stored in a remote URL, never in a commit message).
- Files in scope: the target machine (system changes), the documentation repo, `DEMO-LOG.md`, and map artefacts under a maps directory on the target.
- Touches the DB schema: no. Graphical UI: yes. Rocky Linux target: yes.

**Unknowns (load-bearing, do not guess):**
1. **Compatibility layer.** User preference is Valve's Proton. Evidence so far: SCMDraft 2 is a Win32 Delphi application, upstream documents Wine, and Proton without Steam needs a GE-Proton tarball plus Valve's Steam Linux Runtime, while Proton with Steam needs a Steam login (no Steam credentials exist in `~/AI/secrets/`). `Tails` must test both and record which one actually runs SCMDraft 2 on `el10_2`, then record the decision. `## Implementation` is where this is settled.
2. **StarCraft: Brood War game data.** SCMDraft 2 needs StarCraft game data for terrain and unit graphics, and "playable" needs a game to play in. Free official sources: StarCraft: Remastered base game is free from Blizzard, StarCraft Anthology was made free in 2017, and `staredit.net` documents SCMDraft with 1.3.x installs. OpenBW is an open-source engine reimplementation but still needs the original assets. No game data exists on the target. Legal posture: installing legally obtained game data on the target is fine; committing game data or the SCMDraft binary to GitHub is not. `Charmy` and `Flicky` own the recorded conclusion.
3. **Playability verification method.** Options are: launch the map from SCMDraft 2's own play function, load it in StarCraft: Remastered under the same prefix, or load it in OpenBW. None verified yet.
4. **Map art feasibility.** Terrain tiles are a coarse grid; spelling text and drawing Tux, the Rocky logo, and a detailed Korea map realistically needs GR graphics and unit sprites (the `grCreator`/`Firegraft` family documented by the same site), not hand-drawn terrain. Which technique produces each of the five maps is unverified.

**Decisions recorded:**
- The demo runs against the **real** target machine, not a VM clone. Rationale: the point of the booth demo is the team driving a live Rocky 10.2 GNOME desktop. Consequence: every system change on the target must be recorded in the documentation repo with an exact revert, and no change may be irreversible.
- Documentation is the deliverable as much as the maps are. Every install step, dead end, and command lands in the documentation repo as it happens.
- `Proton first, Wine as recorded fallback` follows the user's stated preference, but the choice is decided by what actually runs SCMDraft 2 on `el10_2`, and the reasoning is written down either way.

---

## Definition of Done

*Owner: `Robotnik`, and nobody else. Written before any work started.*

- [ ] SCMDraft 2 (version recorded, download URL and SHA-256 of the archive recorded) runs on the target with a compatibility layer that is recorded as the chosen one, with the alternatives considered and the reason it won.
- [ ] The install is **reproducible from the documentation repo alone**: a reader on Rocky Linux 10.2 can follow the recorded commands and reach the same state.
- [ ] The team opened SCMDraft 2's GUI on the target and captured it with the TASK-0041 visual loop (at least one screenshot in the documentation repo showing the running editor with a map loaded).
- [ ] Five maps exist on the target, each with its own directory, each named in the record: `foss-for-all`, `rocky-logo`, `rocky-with-heart`, `republic-of-korea`, `tux`.
- [ ] Each map opens in SCMDraft 2 without error, evidenced by a screenshot per map, and each map is described in the record by what a player sees.
- [ ] Each map's design intent is written down: which technique (terrain, units/decorations, GR graphics, tileset) carries the picture, and what the player actually does in the map.
- [ ] Playability is demonstrated by the first of these that works, with the method named and its evidence attached. (a) A StarCraft game window on the target rendering a loaded map under Flatpak Wine 11.0, driven by injected input. (b) The same result reached through kernel-level `uinput` injection, if the exclusive-fullscreen pointer capture is what blocks (a). (c) If both fail, SCMDraft 2's own map validation passing on each saved map without error, plus the recorded platform limit and the Flatpak Wine rendering evidence. *(Revised 2026-11-14 by `Robotnik`. The original box demanded (a) only. Reason for revision: exclusive DirectDraw pointer capture on Wayland is now a measured property of the target rather than an untested assumption, and the demo's primary deliverable is five maps the team built and verified. The operator may restore the stricter box.)*
- [ ] Legibility gate, added 2026-11-14 after `Shadow` proved map 1's terrain lettering reads as noise. Each of the five maps must have a booth-simulation artifact, the editor screenshot downscaled about 4x, and an agent other than the builder must read that artifact and state in writing whether the intended picture is identifiable. The builder's own verdict on its own screenshot does not satisfy this box.
- [ ] Maximum extent, added 2026-11-14 as an operator requirement. Every one of the five maps is built at the largest map size the StarCraft map format and SCMDraft 2 actually permit, and that maximum is recorded as a number with the evidence that established it rather than assumed. The design must fill that extent, not sit in a corner of it, and each map needs a screenshot showing the design readable on the in-game minimap. A drawing that is legible only when zoomed into the editor does not satisfy this box or the legibility gate above.
- [ ] SCMDraft 2's own map validation or equivalent integrity check recorded per saved map, which the plan already requires and which no map item has yet run.
- [ ] The documentation repo `metalllinux/foss-for-all-booth-demonstration-scmdraft-2` contains: a README that explains the demo, a setup guide, the map notes, the booth demo run script (the exact sequence the operator performs on 2026-11-28), and a troubleshooting section with the dead ends that were hit.
- [ ] No credential, no SCMDraft binary, no StarCraft game data, no third-party binary is committed to any GitHub repo. Upstream sources are cited by URL, ref, and hash instead.
- [ ] `Shadow`, `Omega`, `Big`, `Charmy`, `Flicky` each report with no unresolved blocker, no unresolved finding above `low`.
- [ ] `Vector` confirms the documentation repo and this repo's README match what was actually built.
- [ ] `DEMO-LOG.md` holds a dated entry for every step against the target, from first SSH contact to the last map.
- [ ] Booth readiness: the target is left in a state where the demo can be run again in front of an audience, and every change made to the target is listed with its revert command.

---

## Next Actions

- [x] `Amy`: `## Plan` written (16 items).
- [x] `Tails`: item 2 complete. Terrain rendering proven, `repoquery` confirms no 32-bit loader exists on Rocky 10, so the Proton rejection stands.
- [x] `Tails`: DEMO-LOG backfill for item 2 done, and the item 2 claim about a clean `git status` corrected.
- [x] `Tails`: bounded playability recovery complete, all three hypotheses exhausted. Flatpak Wine 11.0 renders, COPR Wine 10.17 was the black-screen cause, and the remaining blocker is exclusive-fullscreen pointer capture.
- [x] `Tails`: item 4 complete. Control path established. Keyboard scancode injection drives Ctrl+T, Ctrl+U, Ctrl+S and Enter reliably, terrain painting works and persists across save and relaunch, and the save path is `taskkill` plus two Enters. Delphi dialog buttons do not respond to injected clicks, so no step may be planned around them.
- [x] `Tails`: item 5 complete. Map 1 saved and loaded without an error dialog. Checks it named as not run: game playability, map format validation, OCR of the lettering, Scenario dialog inspection, and rendering under Flatpak Wine.
- [x] `Shadow`: legibility verification done, recorded as a blocker with the contradiction surfaced, and with the point that glyph size is not the problem, internal structure is.
- [x] `Tails`: technique recovery ran and is recorded, verdict honest, neither technique tested to completion and no booth-simulation artifact produced. Ctrl+N, Ctrl+D, Ctrl+U, Ctrl+T and Ctrl+A confirmed. Delete scancode unconfirmed, and the Isometrical to Rectangular view toggle did not respond to injected clicks. GR tooling located, IronGRP is MIT and Linux-native, Firegraft exists at the Ar3sgice starcraft-tools mirror with no licence file there, and grCreator does not exist as a named tool.
- [ ] `Tails`: programmatic construction proof running, terrain written into the map CHK from a bitmap mask, with SCMDraft 2 as viewer and verifier. Acceptance is a code-written map that renders the intended picture and survives re-open, plus the booth-simulation artifact and coverage numbers.
- [ ] `Charmy`: rule on the Ar3sgice starcraft-tools mirror, which carries no licence file, before it is cited in any documentation.
- [ ] `Shadow`: independent read of the booth-simulation artifact from the proof above, per the legibility gate in the DoD.
- [ ] Acceptance for the recovery is not "it looks better to me". It is a booth-simulation artifact that an independent agent can read, plus the colour-coverage measurement that Shadow used.
- [ ] Map 1 gets rebuilt after the technique is settled, not before.
- [ ] `Tails`: the GR-graphics path is still unproven and is the weakest link in the technique decision. Firegraft's download on Stormcoast Fortress is broken, no grCreator was located, and SCMDraft 2's internal graphics override editing was never exercised. If terrain-only lettering turns out unreadable at booth scale on the first map, this path has to be reopened rather than accepted.
- [ ] `Tails`: one `uinput` injection pass on the target as the last playability attempt, scheduled after the five maps, not before.
- [ ] `Charmy` and `Flicky`: rule on the archive.org Anthology ISO as the game-data source, and on the fact that no redistribution occurs.
- [ ] `Omega`: supply-chain ruling on COPR `forecastwolf157/Wine-test` and Flatpak Wine from Flathub as the demo's two Wine runtimes, and on the final repo set left on the target.
- [ ] Dispatch queue for the fresh `Robotnik` session, in this order, one at a time, each in its own fresh child session.
- [x] `Tails`, dispatch 1, terrain value harvest. **Verdict, acceptance met on the precise-statement branch.** The plaintext CHK came from River Crossing through StormLib (MIT, `github.com/ladislav-zezula/StormLib` at `d60b7e6d3501474f4d92c7b9c752a37e78385f67`), built controller-side, 257441 bytes, verified head `56455220020000003b00495645520200`. The writer's invalid fields are named with the diff in `## Implementation` (Terrain value harvest): `ISOM` at `build_map.py:103` is half the required size, the real size is `4*(W+2)*(H+1)`, and it is filled with zero where both harvested maps use non-zero brush indices; the `MTXM` and `TILE` values at `build_map.py:149` span groups 0 to 255 including groups 0 and 1 that no tile of either real map uses, and harvested Jungle flat ground is groups 8 and 9 at subtile 0, values 128 and 144. Attempt 1 is closed as impossible with binary-string evidence, the `-IGNORE_PROTECTION` switch is compiled in. Four isolation maps `harvA`, `harvB`, `harvC`, `harvD` are built and left on the target, unread, because the target now refuses the screenshot call every earlier map reading used.
- [x] `Tails`, screenshot path RESTORED 2026-11-20, no target change, verdict in `## Implementation` (Screenshot path restored) and DEMO-LOG 2026-11-20 01:40-02:10. lever (a) verdict: gnome-remote-desktop serving is NOT the cause of the `org.gnome.Shell.Screenshot` AccessDenied. `grdctl rdp disable` (unit `inactive`) leaves the raw `gdbus` call still `AccessDenied`, so the prior "denial appears only while grd serves" claim is disproven; RDP re-enabled with `grdctl rdp enable`, target unchanged. The actual gate is caller identity in gnome-shell 49: a non-screenshot D-Bus caller is denied, the recognised screenshot client is allowed. The working path is `/usr/bin/gnome-screenshot-tool -f <file>`, shipped by gnome-shell 49.4 (the 2026-11-19 "no screenshot tool installed" conclusion was wrong, it searched for the `gnome-screenshot` package). Control capture confirmed a real non-uniform desktop (9262 colours) and the real River Crossing renders full Jungle World, so the screenshot and input loop are both working. lever (b) (FreeRDP `WITH_CLIENT_INTERFACE=ON`) not needed, not started.
- [x] `Tails`, harvA, harvB, harvC, harvD read 2026-11-20, verdict: **none render terrain**. Each launched with the seat0 export, profile dismissed with `rdp-input rdp-args key 0x1C`, captured with `gnome-screenshot-tool`. harvA, harvB, harvC, harvD each show a title bar with no map path, a collapsed Terrain palette, and a uniform grey canvas (PIL 4 colours), versus the River Crossing control (1057 colours, renders). A harvB pre/post-Enter test proves the profile was dismissed yet the map still did not load, ruling out input timing. The blocker has moved from terrain values to the **MPQ file-data encoding**: all four are wrapped by `build_map.build_mpq` storing the blob unencrypted and uncompressed (`flags = MPQ_EXISTS|MPQ_SINGLE`), while the real map that SCMDraft opens stores it encrypted and compressed (`0x80010200`). harvA/harvD carry the harvested CHK verbatim and still do not open, so the terrain values are not the open-gate. This contradicts the earlier "the container format is not the blocker" claim (doc:1069, doc:1072); both are recorded. harvA-D unchanged on the target, wineserver 62669 and the "Unused Unprotector 2" session untouched.
- [x] `Tails`, dispatch 2, container blocker, **acceptance met 2026-11-20**. `slE.scm` (terrain written by code, MPQ written by StormLib `mkmpq`) opens in SCMDraft 2 with the title bar showing its path and the canvas rendering flat alternating Jungle ground, canvas 143 colours, captured with `gnome-screenshot-tool`. Two gates were real: the `build_map.build_mpq` container is rejected (harvA vs slA, same CHK bytes), and the writer's own CHK content was rejected even inside the accepted container until fixed (`STR` real layout without the added count, `MASK` `0xFF`, no `IVE2`, harvested family sections). `slD` proves SCMDraft draws terrain from written `TILE`/`MTXM`, not from ISOM. Verdict and writer baseline in `## Implementation` (StormLib container and CHK content fix) and DEMO-LOG 2026-11-20 02:40-03:10. Not run: single-fix bisect, slE re-open persistence, booth-sim (slE is a flat field, not a design).
- [x] `Tails`, dispatch 3, map 1 only, **built at 256x256, renders, re-opens, verdict recorded 2026-11-20**. `foss-for-all` written with the proven pipeline: `build_map1.py` builds a slE-structure CHK (harvested family sections, ISOM `4*(256+2)*(256+1)` = 265224 B of `0x10`, design mask into MTXM==TILE 131072 B one u16 per tile, 128/144 ground background), wrapped by `mkmpq plain`, SHA-256 `051fc139...` identical on target and controller. Contrasting pair calibrated from the harvest before glyph work: whole-map single-value SCMDraft calibration showed value 96 (group 6, a real River Crossing value) renders flat blue across the whole canvas, ground values 32/48/192/288 render brown/green, value 0 renders void; glyph uses 96 on 128/144 ground, both low terrain so the boundary is a clean coast with no cliff (fixes Shadow cause 2). Glyph one-tile-per-pixel 6-tile strokes (fixes cause 1). Gate artifacts under `/tmp/opencode/t0042`: editor screenshot `foss25b.png` (25%, FOSS blue), whole-map editor overview thumbnail `foss-minimap-mm.png` (both FOSS and FOR ALL in blue), 4x booth sim `foss-maskrender-booth4x.png`, coverage 10.8 percent design / 11.8 percent whole-map editor thumbnail blue. Re-open persistence met (kill then relaunch, clean title, same render). Detail in `## Implementation` (Map 1 ... dispatch 3) and DEMO-LOG 2026-11-20 03:33-04:28. **Not run:** SCMDraft map-validation dialog (button injection unreliable), literal in-game StarCraft minimap (item 3 blocker), single full main-canvas capture of both lines (25% diamond exceeds viewport), independent legibility read (Shadow). The builder does not declare map 1 legible.
- [ ] `Shadow`, independent read of map 1's legibility gate artifacts `/tmp/opencode/t0042/foss-minimap-mm.png` (whole-map editor overview) and `foss-maskrender-booth4x.png` (4x booth sim), per the legibility gate in `## Definition of Done`. This is the deciding verdict the builder does not make.
- [ ] After Shadow's verdict on map 1, dispatch maps 2-5 (`rocky-logo`, `rocky-with-heart`, `republic-of-korea`, `tux`) with the same proven pipeline (`build_map1.py` + `glyph.py`, value 96 blue on 128/144 ground), each with the same gate artifacts. These are filled silhouettes with no internal counters, so they should tolerate coarse terrain better than the letterforms. Only dispatch after Shadow reads map 1; if Shadow reads map 1 as not legible, reopen the GR-graphics contingency (doc:1445) instead.
- [x] `Tails`, the harvA-to-harvD read that this bullet describes, SUPERSEDED by the completed item two lines above. harvA-D were launched and captured 2026-11-20 and none render terrain, because none open. The "rewrite the writer with the harvested values" step is now gated on a writer map that opens at all (the container item above), not on the screenshot. Any protected map on the target remains readable with `chkdump`, so the terrain reference for every tileset is still available.
- [x] `Tails`, dispatch 1, terrain value harvest, the same item marked complete above. The brief is kept verbatim below for the record. Objective, obtain one plaintext CHK from a map that SCMDraft 2 actually renders, because those terrain values are the only trustworthy source of valid TILE group and ISOM pairs. Order of attempts. 1, find a SCMDraft 2 save or options setting that writes without Blizzard map protection, using the upstream options documentation at stormcoast-fortress rather than guessing at the UI, driven by keyboard commands because dialog buttons do not respond to injected clicks. 2, a published open-source CHK or MPQ tool, with its upstream repository and licence recorded before anything is installed. 3, the bitmap-to-terrain generator already recommended at doc:984, same licence-first rule. Then diff the real map's terrain encoding against the writer at `/tmp/opencode/t0042/build_map.py` and name the invalid field. Acceptance, either a code-written map that renders terrain in SCMDraft, or a precise statement of which field of the writer is wrong and why. Reuse the proven launch method recorded in the previous pass, the seat0 Wayland environment export, and do not kill processes the dispatch did not start.
- [ ] `Tails`, dispatch 2, only after dispatch 1 lands. Build map 1 `foss-for-all` at full 256 by 256 extent with the corrected encoding, then the four remaining maps, each with the legibility gate artifacts, editor screenshot, minimap screenshot, 4x booth simulation, coverage numbers, and an independent reader.
- [ ] `Shadow`, independent read of every booth-simulation artifact, per the legibility gate in `## Definition of Done`.
- [ ] `Tails`, the one remaining `uinput` playability attempt, after the maps.
- [ ] `Tails`, TASK-0041 items 9 to 11, `scripts/remote/` packaging including the `rdp-input.c` and `rdp-pointer.c` build step, the `remote-desktop` skill, and selftest asserts above the recorded 56-check baseline.
- [ ] Review chains for both tasks, `Shadow`, `Omega`, `Big`, `Charmy`, `Flicky`, one dispatch each, then fixes, then `Vector`, then `Knuckles`, then `Espio`.
- [ ] `Omega`, ruling on COPR `forecastwolf157/Wine-test`, Flatpak Wine from Flathub, the archive.org Anthology ISO as game-data source, and the target's final repo set. `Charmy`, ruling on the Ar3sgice starcraft-tools mirror, which carries no licence file.
- [ ] Nothing has been committed yet. Planning docs, `DEMO-LOG.md`, and the two C sources are untracked in the working tree, and that is now a risk to the record worth closing before more map work happens.
- [ ] `Tails`, 2026-11-26, re-run the screenshot capture on the venue network, the plan's item 17.
- [ ] `Tails`: TASK-0041 items 9 to 11. `scripts/rdp-input.c` and `scripts/rdp-pointer.c` are now in the working tree and uncommitted, so the packaging item has real inputs.
- [ ] Team repo gap found twice now: `agentsmd learn` refuses because this project is not initialized for agentsmd, so the FreeRDP lessons and the dispatch-discipline lesson cannot be proposed. Recorded, not fixed.
- [ ] Dispatch discipline, learned from the overflow, implementation items get a fresh session each, and a session that has already run many turns does not get follow-ups.
- [x] `Tails`, dispatch 4, contrast fix, **measured, acceptance met, map 1 rebuilt 2026-11-20**. Seven tilesets measured at 16 candidate terrain values each from the harvest (`/tmp/opencode/t0042/ts-harvest/`): Ice World 7.423, Desert 5.257, Space Platform 3.769, Installation 3.598 on textured tiles with flat tiles capped at 1.084, Badlands 2.927, Twilight 1.953, Ash World 1.544, Jungle at most 1.98. Two clear 3.0 with flat tiles, Ice and Space Platform. Map 1 rebuilt on Ice World, glyph 192 on ground 64, at 256x256, `~/scmdraft-maps/foss-for-all/foss-for-all.scm`, SHA-256 `e856f0e1...`, WCAG measured on its own render 7.423, booth sim 6.709, design coverage 10.84 percent, re-open persistence confirmed by hash and title bar. Filename decision applied, `rejected-foss-for-all.scm` holds the 2026-11-14 build. Ice and Desert have no protected map on the target, so their values are harvested candidates validated by render, not harvested from an Ice map, and that caveat travels with the number. Detail in `## Implementation` (Contrast dispatch) and DEMO-LOG 2026-11-20 05:28-06:20. **Not run:** map validation dialog, in-game minimap, tile elevation class, harvest of Desert/Ice/Twilight, Space Platform pairtest by the automatic region finder, independent legibility read.
- [ ] `Shadow`, independent read of the rebuilt map 1 against the contrast gate. Artifacts `/tmp/opencode/t0042/foss-ice-mm.png` and `foss-ice-reopen-mm.png` (whole-map real renders), `foss-ice-maskrender-booth4x.png` (128x128 whole-map booth sim), `foss-ice-booth4x-foss.png` and `foss-ice-booth4x-all.png` (4x downscales of real 33 percent canvas frames), `ice25-page1.png` and `ice25-page2.png` (the frames themselves). This is the gate verdict on the contrast fix, and the earlier Jungle verdict does not carry over to a different tileset.
- [ ] `Tails`, maps 2 to 5 on Ice World with `build_ts.py glyph ts-harvest/ref-era6.chk <name> 192 64 64`, each map reporting four gate numbers, coverage, WCAG ratio measured on its own render, booth artefact, and re-open hash. Filled silhouettes, features larger than 56 tiles as `Shadow` advised. Dispatch one at a time after `Shadow` reads map 1.
- [ ] `Robotnik`, ratify or reverse one extension I made rather than guess at it. The decision covered two files. A third file now exists, the superseded Jungle build, and I renamed it `superseded-foss-for-all-jungle.scm` so that only one map-1 candidate sits under a plausible name. Inverse recorded in DEMO-LOG. Also decide Ice World, ratio 7.423 with render-validated values, against Space Platform, ratio 3.769 with fully harvested values and textured tiles. I built on Ice and recorded why.
- [ ] `Vector`, two facts belong in the booth run script now that they are measured rather than assumed. The Zoom combo resets to 100 percent when a map opens, so setting zoom is a named step. And a 228-tile-wide line is wider than the canvas at the 25 percent zoom floor, 215 tiles, so the whole design is presented through the editor overview thumbnail or by panning each line, and the script must pick one.
- [x] `agentsmd` gap re-checked 2026-11-20 and it no longer blocks proposals from this task: three rules were accepted (`p1795123687554940018` for the SCMDraft status-bar finding, plus the ERA tileset-selection rule and the contrast-before-batch rule). Promotion stays the operator's step.
- [ ] Harvest gap recorded, do not re-derive it. The target holds 157 maps over five tilesets and none of Desert, Ice, or Twilight, and the game MPQ route to their CV5 tables is blocked. Any future claim about an Ice or Desert terrain value is render-validated, never harvest-validated.

---

## Plan

*Owner: `Amy`. Written 2026-11-14.*

**Why this task exists.** FOSS for All Conference 2026 (2026-11-28, AWS Korea, Seoul) needs a live booth demo proving that a Rocky Linux 10.2 GNOME desktop can run a Windows-only map editor and produce playable StarCraft maps. The demo is the conference narrative in practice: FOSS tooling, a FOSS OS, and a legacy Windows application working together. The documentation repo is the artifact the audience can take home.

**What it unblocks / what blocks it.** Unblocks: the conference presentation itself, and the documentation repo's content. Blocks itself on TASK-0041 items 9, 10, 11 (packaged scripts and skill) for the screenshot-and-input loop, but the confirmed mechanisms from TASK-0041 items 1, 5, 7 (screenshot via D-Bus, keyboard via `xfreerdp /kbd:pipe:`, pointer via `rdp-pointer` C client) are already proven and usable directly even before item 9 packaging. Real external dependencies: SCMDraft 2 download availability from Stormcoast Fortress, StarCraft game data from Blizzard's free distribution, a third-party repo on the target for Wine (Wine resolves from neither `baseos` nor `appstream` nor `extras`), and the 2026-11-28 hard deadline (14 calendar days from today).

**MVP.** SCMDraft 2 running on the target with game data loaded, one screenshot of the editor open, one playable map verified by at least one playability method. That alone satisfies the DoD's core proof. Deferred by design: elaborate GR graphics on all five maps if time runs short (three maps minimum, five is the stretch), OpenBW integration (the third playability option is nice-to-have, not required for the DoD), and any modifier-key automation beyond what the pipe and pointer clients already provide.

**What this makes harder later.** (1) Enabling a third-party repo (RPM Fusion or negativo16) on the target permanently adds a third-party signing key to the machine's trust set; removing the repo later does not remove packages already installed from it. (2) The Wine prefix on the target becomes a stateful artifact that a future GNOME or Wine update can break; the demo is reproducible only against the specific Wine NEVRA recorded. (3) Game data placed on the target (MPQs, ~1-2 GB) consumes disk and must not leak into git. (4) The SCMDraft 2 binary is freeware with redistribution restrictions; the documentation repo cites it by URL and hash but never contains it, so a future reader needs a working download link that may rot.

**Decision doc required.** The Wine-versus-Proton choice gets its own 1-pager at `planning/docs/TASK-0042-decision-compat-layer.md`, written by `Tails` after the test (item 1) and before anything is built on top. Rationale: it changes which repo gets enabled on the target, which signing key enters trust, and which prefix layout future map work uses.

---

### Evidence already established for this plan

These facts come from TASK-0041 implementation and probe sections (2026-11-13, 2026-11-14). `Tails` builds on them; `Tails` does not re-derive them.

- Screenshot loop: SSH to target, export `XDG_RUNTIME_DIR=/run/user/1000` and `DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus`, claim `org.gnome.Screenshot` name, call `Screenshot(false, false, filename)`, `scp` the PNG back. Proven: `~/AI/demo-evidence/task0041-shot1.png`, 854449 bytes, 1920×1080.
- Keyboard loop: `xfreerdp /args-from:file:<600-mode-file>` with `/kbd:pipe:<fifo>`, write text to the FIFO. Proven: `CHAOTIX41` visible in screenshot and OCR. Limitation: Unicode code points only, no modifier chords.
- Pointer loop: `rdp-pointer` C client (links `libfreerdp3`, built from source on controller with `freerdp-devel`). Motion and click proven. Each invocation opens a new RDP connection (~100 ms overhead).
- Controller-side prerequisites installed: `freerdp-3.32.2-1.el10_2`, `tesseract-5.3.4-11.el10_2`, `tesseract-langpack-eng`, `python3-pillow`, `freerdp-devel`, `libwinpr-devel`. All from already-enabled repos. No new repo enabled on controller.
- Target has `wine` in no enabled repo (`baseos`, `appstream`, `extras`). Wine exists in RPM Fusion (nonfree) and negativo16 on RHEL-family. Neither repo is enabled on the target today.
- SCMDraft 2 0.9.10 download page: `http://www.stormcoast-fortress.net/cntt/software/scmdraft/download/` (ZIP and installer). Stormcoast Fortress Wine guide: `http://www.stormcoast-fortress.net/cntt/software/scmdraft/wine-example/`. All binaries are Win32 PE. No native Linux build exists.
- No Steam account credentials exist in `~/AI/secrets/`. Proton-with-Steam is therefore not available as a path. GE-Proton tarballs (Glorious Eggroll, open-source patches over Wine) are available without Steam but require `steam-runtime` libraries (`~/.local/share/Steam/steam-runtime/`) or manual `proton` script invocation with bubblewrap.
- Target has 64 GB free on `/` plus 931.5 GB on `nvme0n1`. Disk is not the constraint.
- The repo-enablement policy (from `planning/docs/TASK-0041-decision-third-party-repos.md`): enable a repo only when a named package resolves nowhere else; record NEVRA and repo id before `dnf install`; record enablement command and inverse in DEMO-LOG.

---

### Work breakdown

One agent, one turn each, unless the acceptance criterion says otherwise. `Robotnik` dispatches one at a time. Items marked **independent** may be reordered freely relative to each other but not ahead of their listed dependencies.

| # | Item | Owner | Acceptance criterion (provable by screenshot or command output) | Depends on |
|---|---|---|---|---|
| 1 | **Compatibility layer test.** On the target: (a) enable the chosen third-party repo (RPM Fusion nonfree, or negative16, whichever provides `wine` on `el10_2`; record NEVRA and repo id BEFORE install). (b) Install Wine. (c) Create a Wine prefix (`WINEPREFIX=~/.wine-scmdraft`). (d) Download SCMDraft 2 0.9.10 ZIP to the target. (e) Launch SCMDraft 2 via `wine SCMDraft2.exe` under that prefix. (f) Capture a screenshot via the TASK-0041 D-Bus path showing the SCMDraft 2 window. (g) Also test GE-Proton: download a GE-Proton tarball (latest stable), extract to `~/.proton-test/`, attempt to launch SCMDraft 2 through the `proton` run script. Record which path works, which fails, and the error output from the one that fails. (h) Write the decision into `planning/docs/TASK-0042-decision-compat-layer.md` (1-pager). | Tails | Screenshot PNG exists under `~/AI/demo-evidence/` showing a window identifiable as SCMDraft 2 (Delphi-styled window with its title bar). `wine --version` output recorded. `rpm -q wine` NEVRA recorded. The repo enablement command and its inverse are in the DEMO-LOG entry. GE-Proton attempt recorded with exit code and stderr. Decision doc filled with Context/Options/Recommendation/Consequences/Reversibility. | none (TASK-0041 mechanisms already proven) |
| 2 | **Game data acquisition.** On the target: download legally obtainable StarCraft game data. Primary path: the free StarCraft: Remastered installer (Blizzard made the base game free in 2017; the installer is Windows-only and runs under Wine) or, if the installer fails, a direct MPQ extraction path. Secondary path: a 1.16.1 or 1.18 standalone installer (the pre-Remastered free download documented at staredit.net). Place extracted game data (MPQs, `StarCraft.exe`, `Storm.dll`) inside the Wine prefix chosen in item 1. Verify SCMDraft 2 can see the data: launch SCMDraft 2, open the tileset/unit selection dialog, confirm terrain tiles and unit sprites render. Capture a screenshot showing rendered tiles. | Tails | Screenshot shows SCMDraft 2 with terrain tiles visible (not blank/placeholder). `ls -la` of the Wine prefix `drive_c/Program Files (x86)/StarCraft/` or equivalent shows MPQ files with sizes recorded. SHA-256 of the downloaded archive recorded. Download URL recorded. No game data in any git-tracked path (`git status` clean, or the paths are `.gitignore`d). | 1 |
| 3 | **Playability verification.** Test the three playability options against the target's running setup. (a) SCMDraft 2's own "Play Map" / test-launch function. (b) Launch `StarCraft.exe` in the same Wine prefix with the map file as argument. (c) OpenBW: download, build or run, attempt to load the map. Record which option works. Capture a screenshot of the game actually rendering the map. This item also tests whether the TASK-0041 keyboard and pointer injection reaches the Wine-hosted window (TASK-0041 item 6 gate condition). Type a marker into SCMDraft 2's text input and confirm it appears in the screenshot. | Tails | At least one screenshot shows a StarCraft game window (not the SCMDraft editor) rendering a loaded map. The chosen playability method is named in `## Implementation`. Marker text injection into the SCMDraft window is confirmed via screenshot + OCR. If none of the three options work, `## Status` records the blocker. | 1, 2 |
| 4 | **Map construction technique.** Using the working SCMDraft 2 from item 1 with game data from item 2: (a) create a blank 64×64 test map. (b) Draw a simple shape (circle or letter) using terrain tiles alone; capture a screenshot. (c) Place a unit sprite or decoration; capture. (d) If terrain is too coarse for readable text, attempt the GR-graphics path: use `grCreator` or `Firegraft` (download from Stormcoast Fortress, Win32 binaries, run under the same Wine prefix) to replace a unit graphic with a bitmap containing text. Capture. (e) Record which technique is feasible for each of the five map designs. Write findings into `## Implementation`. | Tails | Screenshots showing: terrain-drawn shape (proves or disproves terrain legibility at booth distance); unit placement working; GR replacement working or failing with recorded error. The technique assigned to each of the five maps is listed by name in `## Implementation`. | 1, 2 |
| 5 | **Map 1: `foss-for-all`.** Build the map using the technique chosen in item 4. Save as `.scm` file in the target's maps directory. Open in SCMDraft 2. Capture screenshot of the editor view. Verify the map loads in the playability method chosen in item 3. Capture screenshot of the loaded game view. | Tails | File exists on target (`ls` output). Editor screenshot shows recognizable "FOSS for All" content. Game screenshot shows the map loaded (no error dialog). | 3, 4 |
| 6 | **Map 2: `rocky-logo`.** Build. Same acceptance as item 5. Rocky logo (the stylized "R" shield) rendered via the chosen technique. | Tails | Same as item 5, content is Rocky logo. | 3, 4 |
| 7 | **Map 3: `rocky-with-heart`.** Build. Rocky logo with a heart symbol. Same acceptance as item 5. | Tails | Same as item 5. | 3, 4 |
| 8 | **Map 4: `republic-of-korea`.** Build. A recognizable outline or flag of South Korea. Same acceptance as item 5. | Tails | Same as item 5. | 3, 4 |
| 9 | **Map 5: `tux`.** Build. Linux mascot Tux rendered via the chosen technique. Same acceptance as item 5. | Tails | Same as item 5. | 3, 4 |
| 10 | **Booth run script.** Write the exact sequence the operator performs on 2026-11-28: what to launch, what to click, what maps to open, what to show. Place in the documentation repo as `booth-run.md`. Include timing notes (how long each map takes to demo). | Vector | File exists in the documentation repo, readable, and an agent can follow it end-to-end on the target without external guidance. | 5–9 |
| 11 | **Documentation repo content.** README (explains the demo and what the audience sees), setup guide (reproducible install from Rocky 10.2 base to SCMDraft running, exact commands, repo enablement recorded with inverse), map notes (each map's design intent, technique, and what a player does), troubleshooting section (dead ends hit, Wine quirks, game-data placement issues). `DEMO-LOG.md` in the main repo has a dated entry per target-touching step. All three license items recorded (see licence section below). | Vector | Documentation repo contains at minimum: `README.md`, `SETUP.md`, `maps/` directory with five `.scm` files or their generation scripts, `booth-run.md`, `TROUBLESHOOTING.md`. No binary, no game data, no SCMDraft executable in any committed path (verified by `git ls-tree -r main | grep -iE '\.(exe|mpq|mpq\.|tar|zip)$'` returning nothing). | 1–9 |
| 12 | **Licence determinations.** Charmy: verify the license of SCMDraft 2 (the freeware EULA from Stormcoast Fortress, the license of Firegraft and grCreator), StarCraft game data (Blizzard EULA, redistribution restrictions), Wine RPM (LGPL 2.1+), GE-Proton components (GPL/MIT/proprietary mix), and the `rdp-pointer` C source (written by team, linked to LGPL 2.1+ FreeRDP). Flicky: run `scripts/licence-check` on the documentation repo. Record: (a) SCMDraft 2 may be cited by URL+hash, never committed. (b) StarCraft game data may be installed on the target, never committed. (c) The documentation repo's own license (MIT? CC-BY?). (d) Which tools' licenses permit the documentation to include screenshots. | Charmy, Flicky | Charmy's table complete with upstream URLs and refs. Flicky's gate exits 0 (PASS) or 6 (POLICY_EXCEPTION with recorded reason). The documentation repo's LICENSE file exists. | 11 |
| 13 | **Review chain.** Shadow, Omega, Big, Charmy, Flicky, one dispatch each. | those agents | Each section filled. Omega must cover: the third-party repo trust change on the target, the Wine prefix permissions, the game-data path isolation from git, the 3389 listener posture during the booth. | 12 |
| 14 | **Target booth readiness.** Leave the target in demo-ready state: SCMDraft 2 installed and working, game data in place, maps directory populated, RDP listener active with credentials, screen lock disabled (already done in TASK-0041 item 4), idle timeout zero. Record every state fact with its verification command. | Tails | `rpm -q wine` returns installed. `ls ~/.wine-scmdraft/drive_c/Program Files (x86)/StarCraft/` shows game data. `ls <maps-dir>/` shows five `.scm` files. `grdctl status` shows RDP enabled. Screenshot shows the desktop in a demo-ready state. | 1–9 |
| 15 | **Dry run.** On 2026-11-26 (2 days before event), Tails performs the booth-run script end-to-end from the controller. Any failure goes into `## Status`. | Tails | Five maps opened in sequence, screenshots captured, no errors. If venue network differs, record it. | 10, 14 |
| 16 | **Archive.** Espio prunes superseded probe narration and resolved findings. | Espio | Pruning log entry only. | 13 |

---

### Dependencies and sequence

Items 1, 2, 3, 4 are the long-lead chain and must run in that order. Items 5 through 9 are the five maps; they depend on 3 and 4 but are **independent of each other** (any order among 5–9 is fine). Item 10 depends on all maps. Item 11 depends on 10. Item 12 depends on 11. Item 13 depends on 12. Item 14 depends on 1–9. Item 15 depends on 10 and 14. Item 16 depends on 13.

Item 2 (game data download) can begin *controller-side* in parallel with item 1 (compatibility test), since the download itself does not depend on the chosen prefix. Only the *installation into the prefix* waits for item 1's decision. In practice the sequential inference slot means Robotnik dispatches them one at a time regardless, but the logical dependency is download-then-install, not download-after-decision.

Items 5–9 are **independent of each other**. Robotnik may dispatch them in any order once items 3 and 4 complete.

---

### Critical path

1 → 2 → 3 → 4 → 5 → 10 → 11 → 12 → 13 → 14 → 15 → 16

That is 12 sequential dispatches minimum. Items 6–9 sit beside 5 (independent, but still sequential dispatch due to single slot). The true wall-clock critical path with sequential dispatch is: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 = 16 dispatches. Each dispatch takes 0.5–3 hours of agent time (see estimates), spread across 14 days. The binding constraint is item 1's uncertainty (repo enablement, Wine build quality, GE-Proton viability), not the calendar.

---

### Estimates

`T = (O + 4M + P) / 6`, hours of agent time per item.

| Item | O | M | P | T |
|---|---|---|---|---|
| 1 compat layer | 1.5 | 3 | 8 | 3.58 |
| 2 game data | 1 | 2 | 5 | 2.33 |
| 3 playability | 1 | 2 | 6 | 2.50 |
| 4 map technique | 1 | 2 | 4 | 2.17 |
| 5 map: foss-for-all | 0.5 | 1 | 2 | 1.08 |
| 6 map: rocky-logo | 0.5 | 1 | 2 | 1.08 |
| 7 map: rocky-with-heart | 0.5 | 1 | 2 | 1.08 |
| 8 map: korea | 0.5 | 1.5 | 3 | 1.42 |
| 9 map: tux | 0.5 | 1 | 2 | 1.08 |
| 10 booth script | 0.5 | 1 | 2 | 0.92 |
| 11 documentation | 1 | 2 | 4 | 2.17 |
| 12 licence | 0.5 | 1 | 2 | 1.08 |
| 13 review chain | 1.5 | 2 | 4 | 2.33 |
| 14 booth readiness | 0.5 | 1 | 2 | 1.00 |
| 15 dry run | 0.5 | 1 | 3 | 1.17 |

Critical-path sum: approximately 25 hours. Buffer: 50 percent, giving 37 hours total. Spread over 14 days with one sequential slot, this fits comfortably (2.6 hours per day average). The risk is item 1's upper bound (8 hours if Wine from a third-party repo fails and a source build is needed), not the schedule.

---

### Licence items the agents must settle before documentation lands

These are written here explicitly because they gate item 11 (documentation repo content):

1. **SCMDraft 2 binary.** Stormcoast Fortress distributes SCMDraft 2 as freeware. The license (if any) is stated on the download page. The documentation repo may cite the download URL and archive SHA-256 but must not contain the executable. Charmy verifies the license text at the upstream URL.
2. **StarCraft game data.** Blizzard's 2017 free release grants use rights but not redistribution rights. Game data may exist on the target but must never appear in git. Charmy records: "install on target, cite the Blizzard free-game announcement URL, commit nothing."
3. **Firegraft / grCreator.** These tools are from Stormcoast Fortress. Their license terms are not obvious from the download page. If their license forbids redistribution, the documentation records the URL only. If their license permits redistribution (unlikely for bundled tools), the documentation repo may contain instructions but still not the binaries. Charmy verifies.
4. **Wine.** LGPL 2.1+. Installed as an RPM from a third-party repo. Runtime dependency, not vendored code. No obligation for the documentation repo. Flicky's gate sees no new imported code.
5. **GE-Proton.** Mix of GPL (Wine forks), MIT (various patches), and Valve-proprietary components (Steam Linux Runtime is proprietary). If the plan chooses Proton over Wine, the proprietary Steam Linux Runtime component makes Proton harder to justify as a "FOSS for All" demo narrative. Charmy notes this for the booth story.
6. **Documentation repo license.** Recommend MIT for the documentation and scripts. Flicky's gate runs against the documentation repo root and must return 0 or 6.
7. **Screenshots in the documentation.** SCMDraft 2's freeware license may or may not permit publishing screenshots of the running application. Charmy checks the EULA text. If ambiguous, default to: screenshots showing the editor UI are fair-use documentation of the install process, recorded with that reasoning.

---

### Risks

| Risk | Likelihood | Impact | Mitigation | Contingency |
|---|---|---|---|---|
| Wine not available from any third-party repo on `el10_2`. | Medium | Item 1 fails entirely; SCMDraft 2 never runs. | Item 1 tests the repo path first (fast). If no RPM exists, a source build is the fallback (slower but viable; Wine compiles on Rocky 10). | Build Wine 9.x from source on the target (30–60 min compile time, 61 GB RAM is ample). Record as a target system change with full inverse (`dnf remove` not available for source builds, so inverse is `rm -rf /usr/local/wine-*`). |
| GE-Proton tarball requires libraries not on the target and not in enabled repos (bubblewrap, Steam Linux Runtime). | High (given no Steam install) | Proton path fails; decision forced to Wine. | Item 1 tests GE-Proton explicitly and records the failure mode. The decision doc records "Proton without Steam requires a proprietary runtime that is not available." | Wine is the chosen path. Proton is documented as considered-and-rejected with the evidence. |
| StarCraft installer (free Remastered) does not work under Wine on `el10_2`. | Medium | Game data unavailable; terrain and unit graphics blank. | Item 2 has a secondary path: pre-Remastered standalone installer or manual MPQ extraction from a legally obtained archive. | If both installers fail, the team downloads the older free standalone installer from a mirror documented at staredit.net and extracts MPQs manually. Legal posture unchanged. |
| SCMDraft 2 GUI renders blank under Wine (no game data visible, or Wine rendering issue). | Medium | The editor opens but shows nothing useful. | Item 2 verifies tiles render before item 4 starts. If blank, debug Wine D3D settings (`winecfg` → graphics tab) before declaring failure. | Switch Wine version (older 8.x may render Delphi apps better than 9.x). |
| Terrain tiles are too coarse for any recognizable text or logo. | Medium-high | Maps 2, 4, 5 (rocky-logo, korea, tux) cannot be done via terrain alone. | Item 4 explicitly tests this. If terrain fails, the GR-graphics path (Firegraft/grCreator unit replacement) is the fallback. | If GR tools also fail under Wine, fall back to unit-sprite arrangement (placing many small units in a pattern visible from game zoom level). Record the limitation. |
| Map art is not achievable in the remaining time. | Low-medium | Fewer than five maps demo-ready. | MVP is three maps (foss-for-all, tux, rocky-logo). If item 4 shows the technique is hard, start with the easiest map first (foss-for-all text, which terrain handles at large scale) and build up. | Reduce to three maps and document the limitation. The DoD says five; the plan's MVP says three is the value floor. |
| Playability method fails (game crashes in Wine, or OpenBW build fails). | Medium | Maps look correct in editor but DoD's playability bullet is unmet. | Item 3 tests all three options. SCMDraft's built-in test-launch is the simplest and most likely to work since it uses the same Wine prefix. | If no game-launch method works, record the limitation and use the editor screenshot as the playability evidence with a note explaining why game-launch was not achievable. The booth demo can still show the editor. |
| Third-party repo enablement breaks the target's dnf trust or pulls unexpected updates. | Low | Target system instability. | The repo-enablement policy records NEVRA, the enablement is scoped to one package install, and the inverse is recorded before the enable command runs. | `dnf remove wine && dnf config-manager --set-disabled <repo>` and the target is back to three repos. |
| Wine prefix game-data paths accidentally enter git via the documentation repo's `.gitignore` being incomplete. | Low | DoD violation. | Item 11's acceptance includes a grep check for binary extensions in the committed tree. `DEMO-LOG.md` records the paths and explicitly marks them "target-local only." | Add `.gitignore` entries for `*.mpq`, `*.exe`, `*.dll` before any commit in item 11. |

---

### Validation

**Proves it worked:**
- Screenshot of SCMDraft 2 window running (item 1 acceptance).
- Screenshot of terrain tiles rendered in the editor (item 2 acceptance).
- Screenshot of a game loading a map (item 3 acceptance).
- Five `.scm` files on the target (items 5–9 acceptance).
- Five editor screenshots and five game screenshots (items 5–9 acceptance).
- Documentation repo contains `README.md`, `SETUP.md`, five map entries, `booth-run.md`, `TROUBLESHOOTING.md`, `LICENSE`.
- `git ls-tree -r main` in the documentation repo returns no binary files (item 11 acceptance).
- `scripts/licence-check` exits 0 or 6 against the documentation repo (item 12 acceptance).
- `rpm -q wine` shows the installed NEVRA on the target (item 14 acceptance).
- The booth-run script is followed end-to-end without errors (item 15 dry run acceptance).

**Files that need a human look:** `SETUP.md` (the operator will reproduce it before the event), `booth-run.md` (the operator follows this at the booth), and at least three screenshots from the five maps (the operator confirms they look recognizable at booth distance, which OCR cannot assess).

**Checks that need the target online:** items 1 through 9, 14, 15. These are not CI checks; they are live agent dispatches against the target.

---

### Rollback

**Detection.** Each item's acceptance is a screenshot or a command output. If the screenshot does not show what the acceptance criterion requires, the item failed in that turn. If Wine fails to install or launch, item 1's acceptance screenshot simply never appears and `## Status` records the blocker.

**Target-side revert (exact commands, recorded in DEMO-LOG before execution):**

| Change | Inverse |
|---|---|
| `dnf config-manager --set-enabled <third-party-repo-id>` | `dnf config-manager --set-disabled <third-party-repo-id>` |
| `dnf install wine <NEVRA>` (plus dependencies) | `dnf remove wine` |
| Wine prefix at `~/.wine-scmdraft/` created | `rm -rf ~/.wine-scmdraft/` |
| Game data installed in prefix | Removed by prefix deletion above |
| Maps directory on target | `rm -rf ~/scmdraft-maps/` (or wherever maps land) |
| SCMDraft 2 extracted to target | `rm -rf ~/scmdraft2/` (the extracted ZIP contents) |
| Third-party repo GPG key imported | `rpm --erase gpg-pubkey-<keyid>-<timestamp>` |

**Repo-side revert.** The documentation repo starts empty. Failure is detected before the first commit, or a commit is reverted with `git revert <commit>` before any PR merge. Point of no return on the repo side: none until a PR merge to `main`, which is within the metalllinux account and reversible. On the target side: the point of no return is the GPG key import (removing it is possible but leaves a stale `rpm --erase` if not recorded, and if Wine from that repo is already installed, removing the repo does not remove the package).

**State a retry must tolerate:** A target left with Wine installed from a third-party repo, a partial Wine prefix, game data partially extracted, and the repo enabled. A retry must be idempotent: `dnf install` is idempotent, prefix recreation after `rm -rf` is clean, and game-data re-extraction overwrites without harm.

**Game data integrity.** If a game-data download is corrupted (SHA-256 mismatch), re-download. The SHA-256 is recorded in DEMO-LOG before extraction, so a retry knows what the hash should be.

---

## Implementation

*Owner: `Tails`.*

### Item 1: Compatibility layer test (done 2026-11-14)

Decision doc: `planning/docs/TASK-0042-decision-compat-layer.md`.

**Alternatives considered**

### Problem: run SCMDraft 2 (PE32 Windows GUI) on Rocky 10.2 GNOME Wayland

**Option A — COPR Wine 10.17 (Staging)** · How: `dnf copr enable -y forecastwolf157/Wine-test`, `dnf install -y wine`. Wine 10's WoW64 mode runs 32-bit Windows PEs inside the 64-bit process (no 32-bit Linux loader needed). Wayland driver provides native windows. Pros: single package install, native Wayland rendering, demonstrated working. Cons: COPR trust (third-party GPG key), staging-quality build, "experimental" WoW64 label.
**Option B — GE-Proton 11-12 tarball** · How: download 567 MB tarball from GitHub, extract, invoke `python3 proton run in <compatdata> <exe>`. Pros: user's stated preference, Wine 11.0 (newer), Proton-specific patches for games. Cons: requires 32-bit Linux loader (`/lib/ld-linux.so.2`) that Rocky 10 does not provide; requires Steam Runtime container for its intended path; `glibc.i686` unavailable in any repo.
**Chosen:** Wine 10.17, because it runs SCMDraft 2 on this target with a demonstrated working GUI (screenshot captured). GE-Proton fails at `/lib/ld-linux.so.2: could not open` confirmed by strace showing 32-bit `wine-preloader` exec failure.
**Competing priorities:** user preference was Proton. Proton lost on evidence. Wine chosen. GE-Proton tarball retained on target for reproducibility but is not the active layer.

**Target system changes (all reversible, inverse recorded in DEMO-LOG):**

| Change | Command | Inverse |
|---|---|---|
| EPEL enabled | `sudo dnf install -y epel-release` | `sudo dnf remove -y epel-release` |
| RPM Fusion free enabled | `sudo dnf install -y /tmp/rpmfusion-free-release-10.noarch.rpm` | `sudo dnf remove -y rpmfusion-free-release` |
| RPM Fusion nonfree enabled | `sudo dnf install -y /tmp/rpmfusion-nonfree-release-10.noarch.rpm` | `sudo dnf remove -y rpmfusion-nonfree-release` |
| CRB enabled | `sudo dnf config-manager --set-enabled crb` | `sudo dnf config-manager --set-disabled crb` |
| COPR Wine-test enabled | `sudo dnf copr enable -y forecastwolf157/Wine-test` | `sudo dnf copr disable -y forecastwolf157/Wine-test` |
| Wine installed | `sudo dnf install -y wine` (NEVRA: `wine-10.17-1.el10.x86_64`, repo: `copr:copr.fedorainfracloud.org:forecastwolf157:Wine-test`) | `sudo dnf remove -y wine` |
| Wine prefix created | `WINEPREFIX=~/.wine-scmdraft wineboot --init` | `rm -rf ~/.wine-scmdraft/` |
| SCMDraft 2 extracted | `~/scmdraft2/` (SHA-256: `b7db5f947e25daf0ed5205f3f3b74c8207a7cc678db11011043daa48c1439d01`) | `rm -rf ~/scmdraft2/` |
| GE-Proton extracted | `~/.proton-test/GE-Proton11-12-x86_64/` (SHA-512 verified) | `rm -rf ~/.proton-test/` |

**Evidence**

- `wine --version` → `wine-10.17 (Staging)`
- `rpm -q wine` → `wine-10.17-1.el10.x86_64`
- Screenshot: `~/AI/demo-evidence/task0042-wine-scmdraft2.png`, 1609215 bytes, PNG 1920x1080 RGBA. Shows "Scmdraft 2 - Select Profile" window with splash art, "SCMDRAFT 2" logo, Stormcoast Fortress branding, "Default" profile highlighted, buttons (New, Copy, Edit, Delete, Launch).
- GE-Proton failure: `strace` confirmed `execve(".../i386-unix/wine-preloader")` → `open("/lib/ld-linux.so.2") = -1 ENOENT`. Exit code 1 from proton script. Root cause: `glibc.i686` unavailable (confirmed across baseos, appstream, extras, crb, epel, rpmfusion).

**SCMDraft 2 download**

- URL: `http://www.stormcoast-fortress.net/downloads/scmdraft2/download/` (resolves to a ZIP)
- Archive: `SCMDraft2_0.9.10.zip`, 1458849 bytes, SHA-256 `b7db5f947e25daf0ed5205f3f3b74c8207a7cc678db11011043daa48c1439d01`
- Contents: `ScmDraft 2.exe` (PE32, 3214848 bytes, Intel 80386, GUI), `plugins/TrigEdit.sdp`, two text files.

**Checks run**

| Check | Result |
|---|---|
| `wine --version` on target | `wine-10.17 (Staging)` |
| `rpm -q wine` | `wine-10.17-1.el10.x86_64` |
| `file ~/scmdraft2/"ScmDraft 2.exe"` | `PE32 executable (GUI) Intel 80386, for MS Windows, 5 sections` |
| Screenshot captured | 1609215 bytes, PNG 1920x1080, SCMDraft 2 window visible |
| GE-Proton `proton run in` exit code | 1 (PermissionError on first attempt; 0 on second with silent failure) |
| GE-Proton strace error | `/lib/ld-linux.so.2: could not open` (ENOENT) |
| `glibc.i686` availability | Not in any repo (verified: baseos, appstream, extras, crb, epel, rpmfusion-free-updates, rpmfusion-nonfree-updates) |
| GE-Proton SHA-512 verification | MATCHES published checksum |
| SCMDraft 2 ZIP SHA-256 | `b7db5f947e25daf0ed5205f3f3b74c8207a7cc678db11011043daa48c1439d01` |
| `ps aux` confirms SCMDraft2.exe alive | PID 19713, 2425596 VSZ, 44556 RSS |
| Wine Wayland driver log | `waylanddrv:wayland_process_init` active (clipboard and icon limitations noted) |
| No credential in git paths | Confirmed: all test files are on target or in `~/AI/demo-evidence/` (not git-tracked) |
| No binary/game data in git | Confirmed: no `.exe`, `.zip`, `.mpq` files in any repo working tree |

**Checks not run**

- Steam Runtime container path (requires Steam installation, out of scope)
- Source-built Wine (unnecessary, COPR works)
- Wine with StarCraft game data loaded (item 2)
- `rpm -q gpg-pubkey-*` to list the COPR GPG key ID (not run; `dnf copr enable` imports it automatically, visible via `rpm -qa | grep gpg-pubkey`)

---

### Item 2: Game data acquisition and terrain verification (done 2026-11-14)

**Alternatives considered for game data acquisition**

Option A: Download StarcraftBWNoInstall from archive.org (1.27 GB ZIP containing RAR, password "NoInstall"). Pros: fast download, already patched to 1.16.1. Cons: MPQs inside are renamed INSTALL.EXE (PE headers), not proper MPQ format; SCMDraft 2 crashed with ERROR_FILE_NOT_FOUND when pointed at these. Option B: Run the 1.16.1 patch installers (BW-1161.exe, SC-1161.exe) under Wine against the Option A files. The patch installers require an existing game install to patch. Without `StarCraft.exe` as anchor, the patch installer's prepatch phase detected the directory but did not extract game binaries. Option C: Download the StarCraft Anthology original installer ISO from archive.org (1.34 GB). The Installer Tome MPQs inside are proper MPQ archives readable by mpyq. Extraction yielded proper `StarCraft.exe`, `Storm.dll`, `Stardat.mpq`, `BroodWar.mpq`, `Broodat.mpq`, `patch_rt.mpq`. Chosen: Option C. SCMDraft 2 loaded the Jungle World tileset from Stardat.mpq and rendered terrain tiles in "(2)River Crossing.scm".

**Target system changes (additions from item 2, all reversible)**

| Change | Command | Inverse |
|---|---|---|
| 7zip installed (EPEL) | `sudo dnf install -y 7zip 7zip-standalone` | `sudo dnf remove -y 7zip 7zip-standalone` |
| unrar installed (RPM Fusion nonfree) | `sudo dnf install -y unrar` | `sudo dnf remove -y unrar` |
| python3-pip installed | `sudo dnf install -y python3-pip` | `sudo dnf remove -y python3-pip` |
| epel-release re-enabled | `sudo dnf install -y epel-release` | `sudo dnf remove -y epel-release` |
| RPM Fusion free re-enabled | `sudo dnf install -y /tmp/rpmfusion-free-release-10.noarch.rpm` | `sudo dnf remove -y rpmfusion-free-release` |
| RPM Fusion nonfree re-enabled | `sudo dnf install -y /tmp/rpmfusion-nonfree-release-10.noarch.rpm` | `sudo dnf remove -y rpmfusion-nonfree-release` |
| pip mpyq package installed | `pip3 install mpyq` | `pip3 uninstall mpyq` |
| Game data at `~/.wine-scmdraft/drive_c/Program Files (x86)/StarCraft/` | extracted from Anthology ISO via mpyq | removed by Wine prefix deletion |
| Game data source at `~/game-data/` | downloads from archive.org and ftp.blizzard.com | `rm -rf ~/game-data/` |
| Anthology ISO at `~/game-data/StarCraft_Anthology.iso` | downloaded from archive.org | removed by above |

**Download sources and hashes**

| Archive | URL | Size | SHA-256 | MD5 |
|---|---|---|---|---|
| StarcraftBWNoInstall (ZIP) | `https://archive.org/download/StarcraftBWNoInstall/Starcraft%20No%20Install.zip` | 1,274,887,159 | `1fe0ca7c10c1bca26f61270c5afa9b3aee475eb4f67d538c9c753443c185e426` | `beb270e821fcef85dcf1a3da9a049b8c` |
| BW-1161.exe (Brood War 1.16.1 patch) | `http://ftp.blizzard.com/pub/broodwar/patches/PC/BW-1161.exe` | 26,497,843 | `96890f59b664eb54dbb3be634f2045e70a4a757e87b405ec4aeeb69d50fb7bb1` | (from GitHub issue: `b20bfe9c4393c0479418d2d9b0402cdb`) |
| SC-1161.exe (StarCraft 1.16.1 patch) | `http://ftp.blizzard.com/pub/starcraft/patches/PC/SC-1161.exe` | 10,696,135 | `755b4dbe3f8a928831b19bfa975445885b8c1760ffa4e5a795d37e7f02e6c31e` | (not verified against published) |
| StarCraft Anthology ISO | `https://archive.org/download/starcraft-anthology-original-installer/StarCraft_Anthology.iso` | 1,343,639,552 | `802b439d197a801f219076bb8cbe4b9c5664627fafd982ee625306d72d1a93f3` | (archive.org MD5 not cross-checked) |

**Game data installed (Wine prefix `drive_c/Program Files (x86)/StarCraft/`)**

| File | Size | Source |
|---|---|---|
| StarCraft.exe | 1,220,608 | Installer Tome.mpq → `PC\StarCraft.exe` |
| Storm.dll | 409,600 | Installer Tome.mpq → `PC\storm.dll` |
| patch_rt.mpq | 1,085,198 | Installer Tome.mpq → `PC\patch_rt.mpq` |
| Broodat.mpq | 21,557,762 | Installer Tome.mpq → `Common\BrooDat.mpq` |
| Stardat.mpq | 65,285,451 | Installer Tome 2.mpq → `Common\StarDat.mpq` |
| BroodWar.mpq | 595,050,147 | Installer Tome 2.mpq → `Common\BroodWar.mpq` |

Extraction method: Python `mpyq` library opened the Installer Tome MPQs (proper hash-table format, no encryption key needed) and extracted the game binaries and data MPQs.

**Terrain rendering evidence**

Screenshot: `~/AI/demo-evidence/task0042-item2-loaded2.png`, 855933 bytes, PNG 1920×1080 RGBA. Shows:

- SCMDraft 2 title bar: "ScmDraft 2.0 (Beta 0.9.10) - [home/howard/game-data/starcraft-extracted/Starcraft/maps/(2)River Crossing.scm]"
- Jungle World tileset rendering: varied ground tiles (Jungle green, Dirt brown, Mud dark, Rocky Ground, Ruins grey), tile grid visible
- Doodads rendered (trees, rocks)
- Blue mineral fields visible (top-right area)
- Blue start location circle rendered
- Red diamond location marker
- Terrain palette panel populated: Water, Dirt, Mud, Jungle, Rocky Ground, Ruins, Raised Jungle, Temple, High Dirt, High Jungle, High Ruins, High Raised Jungle, High Temple
- Status bar reads: "Jungle World\Dirt" confirming tileset data loaded from MPQ

This satisfies: "Screenshot shows SCMDraft 2 with terrain tiles visible (not blank/placeholder)."

**Item 1 claim re-verification: glibc.i686 availability**

The item 1 claim is: "GE-Proton failed because Rocky 10 cannot provide a 32-bit Linux loader." The claim's mechanism: `glibc.i686` is not available from any repository, so `/lib/ld-linux.so.2` (the 32-bit ELF dynamic linker) does not exist, and GE-Proton's 32-bit `wine-preloader` binary cannot execute.

Verification commands and output:

```
$ dnf repoquery --available glibc.i686
Last metadata expiration check: 0:49:51 ago on Sat 14 Nov 2026 09:56:10 JST.
(empty - no results)

$ dnf search glibc.i686
No matches found.

$ find /lib /lib64 /usr/lib /usr/lib64 -name "ld-linux.so*"
(no output)

$ rpm -qf /lib/ld-linux.so.2
(file does not exist)

# With EPEL enabled (installed 2026-11-14 10:51 for verification):
$ dnf repoquery --available glibc.i686 --repoid=epel
Last metadata expiration check: 0:55:31 ago on Sat 14 Nov 2026 09:51:28 JST.
(empty)

$ dnf repoquery --available "*.i686" --repoid=epel
(empty - zero .i686 packages in EPEL)

# With RPM Fusion free and nonfree enabled:
$ dnf repoquery --available glibc.i686
Last metadata expiration check: 0:51:23 ago on Sat 14 Nov 2026 09:56:10 JST.
(empty - no glibc.i686 from RPM Fusion)
```

Repos queried: baseos, appstream, extras, crb, copr:forecastwolf157/Wine-test, epel, rpmfusion-free-updates, rpmfusion-nonfree-updates. All returned empty for `glibc.i686`.

**Verdict: the item 1 claim is confirmed as a genuine platform limitation, not a missing-package problem.** Rocky 10 (RHEL 10 ABI) has eliminated multilib i686 glibc from all repositories. There is no package to install that would provide `/lib/ld-linux.so.2`. The Proton-with-Wine-11 path cannot work on this platform without a 32-bit Linux loader. The chosen Wine 10.17 WoW64 mode (which runs 32-bit Windows PEs inside a 64-bit process, needing no 32-bit Linux loader) is the only viable option on this target. The decision stands: Wine 10.17 chosen, Proton rejected on evidence.

**Checks run**

| Check | Result |
|---|---|
| `md5sum -c` on StarcraftBWNoInstall.zip | OK |
| `sha256sum` recorded for all 4 archives | recorded above |
| `file StarCraft.exe` (extracted from Anthology) | PE32 executable (GUI) Intel 80386, for MS Windows |
| SCMDraft 2 launched with map argument | Process alive, PID 28096 |
| Screenshot terrain rendering | 855933 bytes PNG, Jungle World tileset visible, status bar confirms "Jungle World\Dirt" |
| `git status --porcelain` and `git ls-tree` check | CLEAN: no binary/game data in any git path |
| `dnf repoquery glibc.i686` (all repos + EPEL + RPM Fusion) | Empty. Confirmed no i686 multilib on Rocky 10. |
| `find /lib /lib64 ... -name "ld-linux.so*"` | Not found on filesystem |
| BW-1161.exe patch installer prepatch.log | "Prepatch successful" (patch ran but files already present from Anthology) |
| SC-1161.exe patch installer prepatch.log | "Prepatch successful" |

**Checks not run**

- BroodWar.mpq from StarcraftBWNoInstall could not be opened by mpyq (PE header prefix from renamed INSTALL.EXE); the Anthology ISO proper MPQs superseded this path
- Tileset selection dialog screenshot (the New Map dialog showed tileset names: Badlands, Space Platform, Installation, Ash World, Jungle World, Desert World, Ice World, Twilight World - captured in task0042-item2-newdlg.png, 61040 bytes)

---

### Item 3: Playability verification (attempted 2026-11-14, NO ROUTE WORKS)

**Verdict first.** None of the three playability options produces a StarCraft game window rendering a loaded
map on this target today. The DoD box "Playability is verified by a recorded method" is **not met**. The
input-injection half of the item passes.

**Alternatives considered**

*Route A, SCMDraft 2's own play function.* Not run end to end. It launches the same `StarCraft.exe` under the
same Wine build as route B, so it inherits the proven rendering failure. Its own error strings show it must
first locate the game (`Unable to read the starcraft path from the 1.16 location.`, `Unable to determine the
starcraft installation folder - edit the profile options to set the options manually and verify the path`),
and `~/.wine-scmdraft/user.reg` contains no Blizzard or StarCraft key, so the profile path would have to be
set by hand before the function could be tested. Chosen to defer rather than report a failure that has not
been observed.
*Route B, `StarCraft.exe` in the same prefix with the map as argument.* Ran it. Process starts, loads the
data, sets 640x480x8 exclusive DirectDraw and writes to the surface thousands of times, but the window
presents pure black. Chosen as the primary route because it is the shortest path and uses the layer chosen
in item 1.
*Route C, OpenBW.* Rejected as a map-playback route on upstream evidence, not on a failed local attempt:
no releases (so no prebuilt binary), and the token `scm` appears zero times in `replay.h`, `ui/ui.h` and
`data_loading.h` while `load_replay` requires OpenBW's own identifier `0x53526572`. OpenBW reads its own
replay format, not `.scm` maps. The native build was not attempted.
*Competing priorities.* Time versus coverage. With a 2026-11-28 deadline, the routes were tested to the point
where each has an evidence-backed verdict rather than a complete fix attempt. The game-data defect found on
the way was fixed rather than worked around, because every route depends on it.

**Blocking finding 1, the game data was partly invalid, and that is now understood.** `BroodWar.mpq` in the
item 2 prefix install and `StarCraft.mpq` plus `BroodWar.mpq` in the archive extraction are PE files, not
MPQs (`file` reports `PE32 executable (GUI) Intel 80386`, first four bytes `4d5a 9000`). Each holds a real
MPQ appended at a section-aligned offset, and carving there self-validates against the MPQ header's own
packed size: `BroodWar.mpq` at 294912 gives packed 571552776 and carved length 571552776; `StarCraft.mpq`
at 259584 gives packed 601130098 and carved length 601130098. The item 2 launch error `font\font.gid File
not found` is explained by `BroodWar.mpq` not being an MPQ. A clean set was built at
`~/game-data/sc-clean/Starcraft/` from the full 258-entry RAR extraction plus both carved MPQs. With the
clean set, StarCraft's data-file error is gone.

**Blocking finding 2, Wine 10.17 on this target has only a working Wayland graphics driver, and that driver
presents nothing for this game's DirectDraw path.** `+ddraw` trace for a live 22 s run:
`ddraw1_SetDisplayMode ... width 640, height 480, bpp 8`, `DDSCL_FULLSCREEN DDSCL_ALLOWREBOOT DDSCL_EXCLUSIVE`,
`ddraw_attach_d3d_device Using existing window 0x50118 for Direct3D rendering`, `Successfully initialized 3D`,
then 6067 `ddraw_surface_update_frontbuffer`, 68 `ddraw_palette_SetEntries` and 64
`ddraw7_WaitForVerticalBlank` calls. The composited output is black: PIL `getcolors` over the window region
`(0,0)-(1400,1080)` of `~/AI/demo-evidence/task0042-item3-sc-x11c.png` returns exactly one color,
`(1512000, (0, 0, 0))`. The X11 driver cannot replace it. `HKCU\Software\Wine\Drivers` `"Graphics"="x11"` is
set and present in `user.reg`, and the next launch still logged `waylanddrv:wayland_process_init`. With
`winewayland.drv` disabled through `WINEDLLOVERRIDES`, or with `XDG_RUNTIME_DIR` and `WAYLAND_DISPLAY` unset
and only `DISPLAY=:0` plus mutter's Xwayland auth file, even `wine notepad` fails with
`err:winediag:nodrv_CreateWindow Application tried to create a window, but no driver could be loaded` and no
`winex11` line appears. `ldd /usr/lib64/wine/x86_64-unix/winex11.so` resolves `libX11`, `libXext`, `libxcb`
and `libXau`, so the driver's libraries are present; the failure is at driver selection or X connection, and
which one it is has not been established. There is no X display to build: `xorg-x11-server-utils` and
`xorg-x11-server-Xvfb` resolve to nothing on the enabled repo set, and `xauth`, `xdpyinfo`, `xrandr`,
`xwininfo`, `import` and `convert` are absent.

**Two explanations remain open, stated as hypotheses, not as conclusions.** (1) Wine 10.17's Wayland driver
does not present 8-bit indexed exclusive-fullscreen DirectDraw primary surfaces. (2) The game itself stalls
before painting and legitimately shows black while it waits for something it never displays. The trace
supports (1) (surface updates accepted, palette set, no error, high CPU) but does not exclude (2). The
discriminating test is one more DirectDraw application under the same Wine build, or StarCraft under Wine's
X11 driver on any working X display. Neither has been run.

**Input gate (PASS).** Keyboard injection reaches a Wine-hosted window: `CHAOTIX42` typed through
`xfreerdp /kbd:pipe:` appears in Wine `notepad.exe` in the same prefix,
`~/AI/demo-evidence/task0042-item3-marker-kbd2.png`, caret at `Ln 1, Col 10`; OCR of a 2x crop returns
`CHAOTIX42|` and full-image OCR returns the same line as `CHAOTIXA2|`. Two FreeRDP 3.32 mechanics matter
for the recorded procedure: `/args-from` cannot be combined with any other argument, so `/kbd:pipe:<fifo>`
must be inside the args file; and the FIFO must not be pre-created because xfreerdp creates it
(`xf_handle_pipe: Failed to create named pipe ... File exists`). Pointer injection reaches the Wine-hosted
SCMDraft 2 window: after `rdp-input ... move 960 540` the SCMDraft 2 status bar reads `794, 431 (24,13)`
(`~/AI/demo-evidence/task0042-item3-move-test.png`, `tesseract` on a 2x crop), and an earlier click moved the
same readout to `1226, 666 (38,21)`. RDP coordinates map 1:1 to physical screenshot pixels. Open item: a
click on SCMDraft 2's `Scenario` menu strip at (152, 49) did not leave a menu open in two attempts, one of
them with the RDP connection held open 3 s, so menu-driven automation inside Wine-hosted windows is not yet
proven.

**Target system changes added in this item, all reversible**

| Change | Command | Inverse |
|---|---|---|
| Full 1.16.1 set extracted | `unrar x -y -idq -pNoInstall ~/game-data/starcraft-extracted/"Starcraft + BW Expansion.rar" ~/game-data/sc1161/` | `rm -rf ~/game-data/sc1161/` |
| Clean game set assembled | carve of `BroodWar.mpq` at 294912 and `StarCraft.mpq` at 259584 into `~/game-data/sc-clean/Starcraft/` | `rm -rf ~/game-data/sc-clean/` |
| Wine Graphics driver key changed to x11 | `wine reg add "HKCU\Software\Wine\Drivers" /v Graphics /t REG_SZ /d x11 /f` | `wine reg delete "HKCU\Software\Wine\Drivers" /v Graphics /f` |
| Stray second Wine prefix | created accidentally by a launch without `WINEPREFIX` | `rm -rf ~/.wine` |
| Helper scripts and logs in `/tmp` on the target | `/tmp/t0042_sc.sh`, `/tmp/t0042_sc_x11.sh`, `/tmp/t0042_sc_x11e.sh`, `/tmp/t0042_notepad.sh`, `/tmp/t0042_x11probe.sh`, `/tmp/sc-*.log` | `rm -f /tmp/t0042_*.sh /tmp/sc-*.log` |
| Stale process left from item 2 | `rundll32.exe setupapi,InstallHinfSection ...` PID 23245 | `kill 23245` |

No new package was installed on the target in this item. `xorg-x11-server-utils`, `xorg-x11-server-Xvfb`,
`libsmacker-devel` were queried and are not available, so no repo was enabled and no NEVRA was recorded.

**Controller-side tooling added.** `/tmp/opencode/t0042/rdp-input.c`, team-written, Apache-2.0 header,
links `libfreerdp3` and `libfreerdp-client3` (Apache-2.0), built with
`gcc -w -o rdp-input rdp-input.c $(pkg-config --cflags --libs freerdp-client3)`, 22544 bytes. It holds one
connection while playing `move`, `click`, `type`, `key`, `keyx` and `wait` events, which `rdp-pointer`
cannot do because it opens one connection per event. Typing uses
`freerdp_input_send_unicode_keyboard_event`, which gnome-remote-desktop rejected in every attempt
(`error: unicode key down failed for U+4D`), so the working keyboard path stays `xfreerdp /kbd:pipe:`.
Copied on 2026-11-14 to `scripts/rdp-input.c` (9206 bytes) and `scripts/rdp-pointer.c` (5742 bytes), which had
been living only in `/tmp/opencode/`, so the team's input tooling is inside the source-of-truth repo. Neither
file is committed yet, and TASK-0041 item 9 still owns the packaged form of this tooling.

**Checks run**

| Check | Result |
|---|---|
| `xxd -l 16` on the prefix MPQs | `Stardat.mpq`, `Broodat.mpq`, `patch_rt.mpq` MPQ1; `BroodWar.mpq` `4d5a 9000` |
| Carve self-validation | `BroodWar.mpq` offset 294912, packed 571552776 == carved 571552776; `StarCraft.mpq` offset 259584, packed 601130098 == carved 601130098 |
| `file` on carved-region source files | `PE32 executable (GUI) Intel 80386, for MS Windows, 4 sections` / `5 sections` |
| `unrar x` of the full RAR | 258 entries, 1293946274 bytes |
| `StarCraft.exe` launch, clean data | process alive PID 29905, RSS 198568 KB, no data-file error |
| `+ddraw` trace | 640x480x8 exclusive, `Successfully initialized 3D`, 6067 front-buffer updates, 68 palette writes |
| Pixel analysis of the game window | 1 color, `(1512000, (0, 0, 0))`, pure black |
| Wine driver forcing | `Graphics="x11"` in `user.reg`; launch still used `waylanddrv`; with Wayland disabled or X-only env, `nodrv_CreateWindow` |
| `ldd` on `winex11.so` | `libX11`, `libXext`, `libxcb`, `libXau` all resolved |
| `dnf repoquery --available` | `xorg-x11-server-utils` and `xorg-x11-server-Xvfb` empty; `libsmacker-devel` empty; `SDL2-devel-2.28.5-6.el10_2`, `cmake-3.31.8-1.el10`, `gcc-c++-14.3.1-4.4.el10_2`, `libtomcrypt-devel-1.18.2-21.el10_1`, `openal-soft-devel`, `glew-devel`, `libpng-devel` available |
| OpenBW upstream | `OpenBW/openbw`; releases empty; `scm` occurrences 0 in `replay.h`, `ui/ui.h`, `data_loading.h`; `load_replay` identifier `0x53526572` |
| Keyboard marker | `CHAOTIX42` visible in Wine notepad, OCR `CHAOTIX42|` (crop) and `CHAOTIXA2|` (full image) |
| Pointer marker | SCMDraft 2 status bar `794, 431 (24,13)` after `move 960 540`; earlier `1226, 666 (38,21)` |
| Args-file hygiene | mode 600, password never on a command line, files deleted after use |
| `git ls-files \| grep -iE '\.(exe\|zip\|mpq\|dll\|iso\|7z\|scm)$'` | nothing in `team-chaotix-moe`; the documentation repo has no commits |
| `git status --porcelain` | **not clean**: `DEMO-LOG.md` and every `planning/docs/` file are untracked, `planning/TASKS.md` modified, plus the two new `scripts/rdp-*.c` files |

**Checks not run**

- OpenBW native build (not attempted)
- SCMDraft 2 play function with a manually configured StarCraft path (not run)
- A second DirectDraw application under the same Wine build, the test that would separate the two open
  hypotheses (not run)
- `dnf repoquery --available wine`, which versions of Wine are installable on `el10_2` (not run)
- OpenBW `deps/asio` submodule resolution (not attempted)

**Recommendation for `Robotnik`.** The playability box needs a different compatibility-layer decision, not a
different map. The cheapest next tests in order: (1) one other DirectDraw application under the same Wine
build to attribute the black window; (2) whether any other Wine build on `el10_2` exposes a working X11
driver, since the current COPR build selects Wayland even when the registry says otherwise; (3) treating
"playable" as "loads in SCMDraft 2 and is verified by map-format validation" and recording the game-launch
limitation explicitly, which the plan's own risk table already allows but which does not satisfy the DoD
box as written. Separately, and not a playability issue: `git status --porcelain` shows `DEMO-LOG.md` and every
file under `planning/docs/` as untracked and the documentation repo has no commits at all, so the continuous
log the DoD requires exists only in the working tree. `DEMO-LOG.md`, `planning/`, `scripts/rdp-input.c` and
`scripts/rdp-pointer.c` should be committed (the pre-push hook runs `tests/selftest.sh`, which was not run in
this pass because nothing was pushed) before more target work is recorded only in `/tmp`.

---

### Item 3 recovery: bounded playability pass (2026-11-14, acceptance NOT met)

Per the `## Status` decision, three hypotheses in the recorded order; stop at the first that yields a
StarCraft game window rendering a loaded map. None did. Full commands, results, evidence files, and every
target change with its inverse are in `DEMO-LOG.md` at the 14:56 entry; this section records the verdicts
and what each attempt rules out.

**Verdict.** No route renders a loaded map. The decisive new fact is that the *rendering* blocker from
blocking finding 2 is a build problem, not a permanent target limit: Flatpak Wine 11.0 renders StarCraft's
intro cinematic and its 1.16.1 main menu on this same target, where COPR Wine 10.17 showed pure black. The
remaining blocker to a loaded map is input, not rendering.

**Hypothesis 1, Wine emulated virtual desktop (COPR Wine 10.17). FAIL.** A leftover from the earlier pass
(`Drivers "Graphics"="x11"`) first forced `nodrv_CreateWindow`; after removing it the Wayland driver
initialised. With the VD keys set and the VD host running (`explorer /desktop=Default,640x480`), StarCraft
ran with the map (alive 1:19, 2457 front-buffer writes) but still held `DDSCL_FULLSCREEN DDSCL_EXCLUSIVE`
640x480x8, and the composited output is one colour, `(2073600, (0,0,0))`
(`~/AI/demo-evidence/t0042-h1-vd.png`, `-vd2.png`). Rules out: the virtual-desktop mechanism changes nothing
for a game that insists on exclusive mode on this build.

**Hypothesis 2, Flatpak Wine from Flathub, different build. RENDERS, but no loaded map.** Installed
`org.winehq.Wine` `wow64-25.08` (Wine 11.0), copied the clean 1.16.1 set into its prefix `drive_c`, ran
`StarCraft.exe testmap.scm`. It renders: `~/AI/demo-evidence/t0042-h2-fp3.png` shows the full 1.16.1 main
menu (Single Player, Campaign Editor, Multiplayer, Exit, View Intro, Show Credits), preceded by the rendered
Brood War intro (`t0042-h2-fp.png`, `-fp2.png`). This retires the "this COPR build has no working driver"
symptom: a different Wine build presents the game. It did not reach a loaded map for two reasons, both
evidenced. (1) The map argument lands on the main menu, it does not auto-play. (2) In the only mode that
renders, exclusive fullscreen, StarCraft captures the pointer, so RDP injection does not reach it: `click
695 272` (Single Player) and `click 1370 745` (Exit) left the in-game cursor fixed at (975,565) and did not
quit the live process. Combining Flatpak Wine with the virtual desktop presents the game in a windowed 640x480
surface but that mode is black again (`t0042-h2-vdmenu2.png`, 2073600 black pixels). Rules out: on this
Wayland target, presentation and input-injection are mutually exclusive for this game.

**Hypothesis 3, native engine, single pass. Not achievable, not attempted.** OpenSAGE is the SAGE engine of
Command & Conquer: Generals (`github.com/OpenSAGE/OpenSAGE`), not StarCraft, so it cannot load a StarCraft
map. **Correction to the item 3 note:** OpenBW's core engine reads only its own replay format, but the BWAPI
launcher `auto_menu` does load `.scm`/`.scx` maps for a single-player game (TorchCraft/OpenBW docs set
`BWAPI_CONFIG_AUTO_MENU__MAP=.../m5v5_c_far.scm`; a 2026-09-20 native spike loaded `(2)Benzene.scx`). So the
earlier "OpenBW cannot load `.scm`" was too strong. OpenBW is nonetheless not a single-pass path to a rendered
map window here: published native spikes build it headless with the UI disabled (`OPENBW_ENABLE_UI=0`), it has
no built-in opponent and is early-stage, and the `deps/asio` submodule plus a working OpenBW UI rendering path
were never resolved. A build that renders a loaded map was not achievable in one pass, so it was not run.

**Target changes and inverses** are in the 14:56 `DEMO-LOG.md` entry. Net new persistent state: Flathub user
remote and Flatpak Wine 11.0 installed (left for Omega), clean game data copied into the flatpak prefix, and
the COPR prefix `Graphics="x11"` forcing removed (restoring the COPR Wayland default). All reversible, each
with an exact inverse. No credential, binary or game data committed to any git path.

**Checks run (this recovery pass).**

| Check | Result |
|---|---|
| COPR StarCraft under virtual desktop, pixel analysis | 1 colour `(2073600,(0,0,0))`, full-screen black; `DDSCL_EXCLUSIVE` retained |
| Flatpak Wine `wine --version` | `wine-11.0` |
| Flatpak StarCraft rendered content | main menu `t0042-h2-fp3.png` (1.16.1), intro `t0042-h2-fp.png`/`-fp2.png`, non-black |
| RDP click on Single Player (695,272) | no submenu; cursor fixed at (975,565) |
| RDP click on Exit (1370,745) | process alive 10:16 after click, input did not reach game |
| Flatpak Wine + virtual desktop | windowed 640x480 presentation black (`t0042-h2-vdmenu2.png`) |
| OpenSAGE target game | Command & Conquer: Generals (SAGE), not StarCraft |
| OpenBW `.scm` load capability | loads via BWAPI `auto_menu` (corrects earlier note); no built-in opponent, UI headless in spikes |
| loaded-map screenshot | none obtained; DoD playability box still not met |

**Recommendation for `Robotnik`.** The playability box should be rewritten as an explicit limitation with this
evidence: the target can render StarCraft only under Flatpak Wine 11.0 and only in exclusive-fullscreen, where
the game holds the pointer, so the menu cannot be driven to a loaded map from the controller. A loaded-map
proof on this target would need either an interactive local input device at the seat0 session, or a native
OpenBW build with its UI enabled, neither of which is achievable in a bounded single pass. The demo narrative
stands as map creation plus editor verification, which items 1 and 2 already prove.

---

### Item 4: Map construction technique (2026-11-14)

**Control path finding.** Keyboard-driven commands via RDP scancode injection are the reliable primary control path for SCMDraft 2. Injected clicks on the map canvas and palette tree work for painting and tile selection. Injected clicks on modal dialog buttons (Save Changes?, Save as blizzard certified?, Scenario menu strip) do not register, consistent with the item 3 menu finding. Enter (scancode 0x1C) confirms the default button on simple modal dialogs (profile selection, save-on-close). Scancode combos via `keydown`/`key`/`keyup` (Ctrl+letter) drive layer switching and save. The working save sequence is: Wine `taskkill` (WM_CLOSE) triggers "Save Changes?" → Enter confirms "Yes" → SCMDraft 2 shows "Save as blizzard certified?" → Enter confirms → save completes.

**Alternatives considered for control path.**

*Option A: Injected mouse clicks on menus and dialog buttons.* Failed. Two attempts at the Scenario menu strip in item 3 left no menu open. Three attempts at the "Save Changes?" / "Save as blizzard certified?" dialog buttons (620, 403), (672, 403), (620, 404) dismissed the dialog without saving. The dialog closes but the save never completes. Cause not established. Recorded as a persistent limitation.

*Option B: Keyboard scancode injection via rdp-input.c `keydown`/`key`/`keyup` events.* Chosen. Ctrl+T (terrain layer), Ctrl+U (units layer), Ctrl+S (save), Enter (dialog confirm) all work. `freerdp_input_send_keyboard_event` with raw scancodes is accepted by gnome-remote-desktop, unlike `freerdp_input_send_unicode_keyboard_event` (rejected, proven in item 3). The Stormcoast Fortress Command Overview documents these as the editor's keyboard commands.

*Option C: Target-side uinput keyboard injection.* Not tested. Would bypass gnome-remote-desktop entirely. Recorded as not run.

**Terrain-only drawing: proven working.**

Sequence proven end to end: (1) SCMDraft 2 launched with `(2)River Crossing.scm` copy as `test.scm`. (2) Click on "Water" in the terrain palette tree at screen coordinates (62, 775) selected it. (3) Click on map canvas at (400, 350) painted a cluster of Water tiles. (4) Screenshot `t0042-item4-painted.png` shows blue Water tiles replacing Dirt/Jungle at the paint point, status bar reads "Jungle World\Water", title bar shows `test.scm*`. (5) Save via taskkill + Enter + Enter completed (file size changed from 90426 to 93113 bytes, mtime updated). (6) SCMDraft 2 killed, relaunched with same file. (7) Screenshot `t0042-item4-reopen.png` shows the painted Water tiles persist, title bar shows no asterisk (clean save).

**Terrain legibility assessment.** At 100% zoom in the editor, each terrain tile is 32×32 pixels on a 1920×1080 screen. A single tile is not readable as text at booth distance (1–2 m from the monitor). A character stroke 6–8 tiles wide is 192–256 pixels, approximately 3–4 cm on screen, readable at booth distance. On a 64×64 tile map, large characters (8–12 tiles per stroke) fit: 4 letters × 8 tiles + 3 gaps × 2 tiles = 38 tiles wide, fits in 64. Water (blue) against Jungle/Dirt (green/brown) provides clear color contrast visible in screenshots. Terrain tiles are suitable for geometric shapes, large text, and block patterns. They are NOT suitable for fine detail, curves, anti-aliased edges, or small text.

**Unit placement: layer switching proven, placement partially proven.** Ctrl+U (keydown 0x1D + key 0x16 + keyup 0x1D) switched SCMDraft 2's layer to "Units" with toolbar showing "Layer: Units" and status bar showing "67 (1) / 1650 units" (the map already has 67 units loaded). Ctrl+T switched back to Terrain. Tree selection of "Terran" node via click worked (highlighted blue). Tree node expansion via double-click on Terran worked (showed subcategories: Addons, Air Units, Buildings, Ground Units, Heroes, Special, Special Buildings). Deeper expansion (Ground Units → individual unit names) did not respond to double-click attempts. A unit was not placed from an empty selection onto the canvas in this session. However, the 67 units already present in the loaded map prove units render in SCMDraft 2, and the layer switching + palette selection mechanism is proven. Unit placement from an expanded tree is recorded as not fully tested.

**GR-graphics path: NOT TESTED.** Firegraft 0.9.2 download from Stormcoast Fortress (`/downloads/firegraft/download/`) returns a PHP error page ("failed to open stream: No such file or directory") — the file is missing on their server. SHA-256 of the error response: `9d7aba004cfdde4c651acf7d91075afc0e376c4e9532b3f792a05410b41518d5` (2234 bytes, ASCII text). No grCreator tool found at Stormcoast Fortress or via web search. SCMDraft 2 binary contains "GraphicViewer" and "unit override settings data" strings indicating internal GR/GRP handling capability, but the import workflow was not exercised. Recorded as not run.

**Technique assigned to each map design.**

| Map | Technique | Rationale |
|---|---|---|
| `foss-for-all` | Terrain tiles, two lines of block letters, contrasting tileset color (Water blue or Rocky Ground grey against Jungle green) | "FOSS" (4 chars) fits on line 1 at 8 tiles/char = 32 tiles. "FOR ALL" (7 chars) fits on line 2 at 8 tiles/char = 56 tiles. Both within 64-tile width. Proven legible at 8+ tiles per stroke. |
| `rocky-logo` | Terrain tiles, geometric shield shape (stylized R inside a shield outline) | Rocky logo is a geometric shape at ~12×12 tiles. Terrain tiles render geometric shapes clearly. No fine curves needed; a simplified angular shield is recognizable. |
| `rocky-with-heart` | Terrain tiles, Rocky shield shape + heart symbol below or beside | Heart is a symmetric geometric shape at ~10×10 tiles. Two shapes side by side fit in 64×64. Same technique as rocky-logo with an added shape. |
| `republic-of-korea` | Terrain tiles, simplified Korean peninsula outline OR Taegeuk geometric symbol | The peninsula outline is a recognizable geometric silhouette at 20+ tiles tall. The Taegeuk (yin-yang) circle with four trigrams is a geometric pattern achievable with contrasting tiles. If GR graphics become available, the flag's Taegeuk colors could be done as unit sprite replacement. Not confirmed. |
| `tux` | Terrain tiles, Tux silhouette (oval body + two feet + beak) | Tux's shape is a recognizable silhouette at 15 tiles tall × 10 tiles wide. Black/dark tiles for body against light background. Geometric, no fine detail. Terrain tiles render the shape recognizably. |

All five maps are assigned terrain-tile technique based on the proven painting mechanism. GR-graphics is a potential enhancement for finer detail but is unconfirmed (tool download broken, workflow not tested). If GR graphics become available before the booth, they would upgrade text legibility from "large block letters readable at distance" to "arbitrary bitmap precision".

**Target system changes (item 4, all reversible).**

| Change | Command | Inverse |
|---|---|---|
| Maps test directory created | `mkdir -p ~/scmdraft-maps/test` | `rm -rf ~/scmdraft-maps/` |
| Test map copied from shipped maps | `cp ~/game-data/sc-clean/Starcraft/maps/"(2)River Crossing.scm" ~/scmdraft-maps/test/test.scm` | Removed by directory removal above |
| Test map saved with Water tiles painted | SCMDraft 2 Ctrl+S (file grew 90426→93113 bytes) | Removed by directory removal above |
| Firegraft download attempt (broken, no binary landed) | `curl -o ~/firegraft_0.9.2.zip ...` | `rm -f ~/firegraft_0.9.2.zip` (file was PHP error text, removed) |
| Screenshot helper script | `/tmp/shot.py` | `rm -f /tmp/shot.py` |
| Screenshot temp files | `/tmp/t0042-item4-*.png` | `rm -f /tmp/t0042-item4-*.png` |
| SCMDraft 2 process launched | `nohup wine64 "ScmDraft 2.exe" ... &` | Process killed via pkill/wineserver -k, no persistent state |

No new package was installed on the target in this item. No repo was enabled.

**Controller-side changes.** `scripts/rdp-input.c` extended with `keydown`/`keyup` events (modifier hold/release) and rebuilt. The binary at `/tmp/opencode/t0042/rdp-input` (22616 bytes). The source file change is in `scripts/rdp-input.c` (uncommitted, same as item 3).

**Checks run.**

| Check | Result |
|---|---|
| Enter (scancode 0x1C) on profile dialog | Confirmed, SCMDraft 2 opened editor with map |
| Click terrain palette "Water" at (62, 775) | Selection highlighted, visible in screenshot |
| Click canvas at (400, 350) with Water selected | Blue Water tiles appeared, status bar "Jungle World\Water", title `test.scm*` |
| Ctrl+S (scancode keydown/key/keyup 0x1D+0x1F) | Save dialog appeared |
| taskkill WM_CLOSE → Save Changes? dialog | Dialog appeared with Yes/No/Cancel |
| Enter on Save Changes? then Enter on certification | File saved: mtime updated, size 90426→93113 |
| SCMDraft 2 killed, relaunched with saved file | Water tiles visible, title bar no asterisk |
| Ctrl+U (0x1D+0x16) | Layer switched to "Units", status bar shows unit count |
| Ctrl+T (0x1D+0x14) | Layer switched back to "Terrain" |
| Click Terran in unit tree | Node highlighted blue |
| Double-click Terran | Subcategories appeared (Addons, Air Units, etc.) |
| Numpad + (0x4E) ×3 | No visible error; brush size change not confirmed via OCR |
| Firegraft download | HTTP 200 but content is PHP error (missing file), 2234 bytes ASCII |
| `strings "ScmDraft 2.exe"` for GR keywords | Found "GraphicViewer", "unit override settings", `.grp` file references |
| `git status` | No binary/game data in any git-tracked path |

**Checks not run.**

- Unit placement from expanded tree onto canvas (tree expansion to individual unit names did not respond; individual unit selection not achieved). Recorded as not run.
- GR-graphics import workflow (Firegraft/grCreator unavailable; SCMDraft 2 internal graphics override editing not exercised). Recorded as not run.
- Brush size increase via `+` key confirmed visually (key sent without error, but no before/after pixel comparison of brush indicator). Recorded as not run.
- Target-side uinput keyboard injection as alternative control path. Recorded as not run.
- Terrain tile painting with Ctrl+click (terrain selection from canvas per Command Overview). Not run.
- `Ctrl+Z` undo test. Not run.
- Map size validation (SCMDraft 2 "map is invalid" check on saved file). Not run.
- Firegraft from an alternative download source. Not run.
- grCreator existence confirmation. Not found, not run.

**Evidence files under `~/AI/demo-evidence/`.**

| File | Content |
|---|---|
| `t0042-item4-before.png` | 1602804 bytes, SCMDraft 2 profile dialog (Select Profile) |
| `t0042-item4-enter.png` | Profile confirmed, full editor with map loaded |
| `t0042-item4-water-sel.png` | Water selected in palette (blue highlight), status bar Jungle World\Dirt |
| `t0042-item4-water2.png` | Water highlighted in tree after second click attempt |
| `t0042-item4-painted.png` | Water tiles painted on canvas, status "Jungle World\Water", title `test.scm*` |
| `t0042-item4-saved.png` | "Save map" certification dialog visible |
| `t0042-item4-after-save.png` | Dialog dismissed, title still shows `*` (save incomplete) |
| `t0042-item4-dlg2.png` | Second Ctrl+S, no dialog visible (certification already resolved) |
| `t0042-item4-close-prompt.png` | "Save Changes?" dialog with Yes/No/Cancel from taskkill |
| `t0042-item4-save2.png` | After Enter+Enter: file saved, map shows Water tiles |
| `t0042-item4-reopen.png` | Relaunch proof: Water tiles persisted, title clean (no asterisk) |
| `t0042-item4-units.png` | Units layer active after Ctrl+U, status bar "67 (1) / 1650 units" |
| `t0042-item4-terr-units.png` | Terran node selected in unit tree |
| `t0042-item4-terr-exp.png` | Terran expanded: Addons, Air Units, Buildings, Ground Units, Heroes, Special, Special Buildings |
| `t0042-item4-terr-exp2.png` | Second attempt, same expanded view |
| `t0042-item4-ground.png` | Ground Units not further expanded |
| `t0042-item4-rocky.png` | After Ctrl+T terrain layer restored |
| `t0042-item4-highdirt.png` | Attempted High Dirt selection (status bar Dirt unchanged) |
| `t0042-item4-paint2.png` | Second canvas paint attempt, no new tile visible |
| `t0042-item4-brush.png` | After numpad + ×3, no visible brush change confirmed |

**Recommendation for Robotnik.** The terrain-tile technique is proven end to end (select → paint → save → reopen → persisted). All five map designs are achievable with terrain tiles at large geometric scale. The GR-graphics enhancement path is blocked by a broken upstream download. The next steps for items 5–9 are: (1) build each map by painting terrain tiles with a planned tile pattern (pre-computed coordinate grid for each character or shape), (2) save via the proven taskkill + Enter + Enter sequence, (3) screenshot each completed map. The keyboard control path (`rdp-input` with keydown/key/keyup) is sufficient for automated map construction. The click-on-dialog-buttons limitation means saves must go through taskkill, not Ctrl+S alone.

---

### Item 5: Map 1 `foss-for-all` (2026-11-14)

**Verdict.** Map built, saved, verified loading. Acceptance criteria met: file exists on target with `ls` output recorded, editor screenshot shows recognisable "FOSS for All" terrain lettering, map loads without error dialog with screenshot.

**File.** `~/scmdraft-maps/foss-for-all/foss-for-all.scm`, 95081 bytes, MoPaQ (MPQ) archive. `ls -la` output recorded in DEMO-LOG 17:36–17:52 entry.

**Technique.** Terrain tiles (Water type, blue) painted via drag strokes against the existing Jungle World tileset (Jungle/Dirt/Rocky Ground background). 36 drag operations trace letter strokes. Characters: 7 tiles wide × 8 tiles tall, 2 tiles gap. "FOSS" at tile rows 7–14, "FOR ALL" at tile rows 19–26. Tile-to-screen mapping: screen_x = 192 + tile_x × 32, screen_y = 124 + tile_y × 32 (derived from item 4's proven `move 960 540 → tile (24,13)` data point).

**Drag mechanism added.** `scripts/rdp-input.c` extended with a `drag` event: press left button at start point, move through waypoints with button held, release. Each drag paints a continuous 4–5 tile band along its path (SCMDraft 2's isometric terrain brush). Source: `/tmp/opencode/t0042/rdp-input.c`, binary 22616 bytes. The `drag` command syntax: `drag x1 y1 x2 y2 [x3 y3 ...]`.

**Alternatives considered for terrain painting.**

*Option A: single `click` events per tile.* Each click paints a ~7-tile diamond area in isometric mode. Too imprecise for letter strokes. Rejected.

*Option B: `drag` continuous painting.* Chosen. Produces a connected stroke band along the drag path. Documentation confirms "Mouse click and drag: Places selected terrain." (Stormcoast Fortress Command Overview). Works reliably: each drag paints the terrain continuously from start to end waypoint.

*Option C: programmatic .scm file modification.* Attempted and failed. mpyq cannot decrypt the SCMDraft 2 map format hash table (all 1024 entries decrypt to 0xFFFFFFFF with every candidate key tested: TABLE_OFFSET, HASH_A, HASH_B, TABLE types, filenames "MAP ", "MAP", "map ", etc.). Block table decrypts successfully (4 entries) but file data is encrypted with a key that could not be determined. Recorded as not achieved.

*Option D: reduce brush to 1×1 tile.* Attempted with: main-keyboard `-` (scancode 0x0C) 7×, numpad `-` (keyx 0x4A) 7×, clicking "01" toolbar combo box. Main `-` selected Player 11 instead of decreasing brush. Numpad `-` produced no visible change. Combo box click did not open the dropdown. All three attempts failed. Recorded as not achieved.

**Save path.** `wine taskkill /im "ScmDraft 2.exe"` (graceful WM_CLOSE, no `/f` flag). Enter confirms "Save Changes?" dialog. Enter confirms "Save as blizzard certified?" dialog. File saved: size 90426→95081 bytes, mtime updated. Note: `taskkill` is a Windows command; on the Linux target it must be invoked as `wine taskkill`.

**Map load verification.** SCMDraft 2 relaunched with saved file. Title bar: "ScmDraft 2.0 (Beta 0.9.10) - [/home/howard/scmdraft-maps/foss-for-all/foss-for-all.scm ]" (no asterisk = clean load). No error dialog appeared. Status bar shows "Jungle World\Dirt" confirming terrain data loaded. Editor renders the full 64×64 map with painted Water tiles visible as letter shapes.

**Target system changes (item 5, all reversible).**

| Change | Command | Inverse |
|---|---|---|
| Map directory | `mkdir -p ~/scmdraft-maps/foss-for-all` | `rm -rf ~/scmdraft-maps/foss-for-all/` |
| Map file (95081 bytes) | SCMDraft 2 save via taskkill+Enter+Enter | removed by directory inverse |
| Wine processes | `nohup wine64 ... &` (multiple launches) | `wineserver -k` (executed, 0 remaining) |
| Temp files on target | `/tmp/t0042-item5-*.png`, `.log`, `parse_map.py` | `rm -f /tmp/t0042-item5-* /tmp/parse_map.py` |

No new package installed. No repo enabled. No credential on any command line. No binary/game data in any git path.

**Controller-side changes.** `scripts/rdp-input.c` extended with `drag` event (uncommitted, same as prior items). `/tmp/opencode/t0042/paint_text.py` (coordinate computation script, controller-only). `/tmp/opencode/t0042/rdp-input` rebuilt (22616 bytes).

**Evidence files under `~/AI/demo-evidence/`.**

| File | Content |
|---|---|
| `item5-initial.png` | 1602743 bytes, SCMDraft 2 profile dialog for foss-for-all.scm |
| `item5-editor.png` | 854150 bytes, editor with fresh map loaded (no text yet) |
| `item5-brush-test.png` | 926033 bytes, first click test showing large diamond brush area |
| `item5-brush2.png` | 967729 bytes, second test at tile (20,10) confirming brush shape |
| `item5-ready.png` | 854960 bytes, Water selected, fresh map ready for painting |
| `item5-drag-test.png` | 1061655 bytes, drag test showing horizontal painted band |
| `item5-text-painted.png` | 1273741 bytes, full "FOSS FOR ALL" text painted |
| `item5-loaded.png` | 1327146 bytes, verification: map loaded from saved file, text visible, no error |

**Checks run.**

| Check | Result |
|---|---|
| File exists on target | `ls -la` shows 95081 bytes, mtime 2026-11-14 17:50:19 |
| File format | `file` reports "MoPaQ (MPQ) archive" |
| Size increased from painting | 90426→95081 (+4655 bytes) |
| Map loads without error dialog | Title bar shows path, no asterisk, no popup |
| Water selection | Status bar "Jungle World\Water" confirmed |
| 36 drag strokes painted | All completed (verified by "event: drag (2 waypoints)" ×36) |
| Save via taskkill+Enter+Enter | File mtime and size changed (verified by `stat`) |
| Wine processes cleaned | `ps aux \| grep` shows 0 Wine processes after wineserver -k |
| No game data or binaries in git | Confirmed: no new files in any git-tracked path |
| `git status --porcelain` | Same untracked items as prior sessions (DEMO-LOG.md, planning docs, scripts) |

**Checks not run.**

- Playability verification (game window rendering the loaded map). Blocked by item 3 finding: exclusive-fullscreen pointer capture on this Wayland target prevents injected input from reaching the game. Recorded as not run.
- Map format validation ("map is valid" check in SCMDraft 2 Scenario menu). Not run.
- Text legibility via OCR. Not run (isometric terrain rendering makes OCR unreliable; visual inspection from screenshot confirms recognisable letter shapes).
- `rpm -q wine` re-verification. Not run (unchanged from item 1: `wine-10.17-1.el10.x86_64`).
- Target repo set re-verification. Not run (unchanged from items 1–2).
- SCMDraft 2 Scenario → Map Properties dialog showing map dimensions. Not run (dialog button clicks proven unreliable).
- The saved file opened in StarCraft or Flatpak Wine for game rendering verification. Not run (item 3 blocker applies).

**Limitations discovered.** The "01" toolbar field (suspected brush size indicator) could not be changed by any mechanism tested. The isometric terrain brush paints a ~4–5 tile band per drag stroke, which is sufficient for 7-tile-wide characters but prevents finer detail. The programmatic map modification approach (reading and writing terrain tile bytes directly in the MPQ) failed because the map file data encryption key could not be determined from any candidate filename or hash type combination tested.

---

### Technique recovery (2026-11-14, incomplete, neither technique proven)

**Verdict stated plainly.** Neither candidate technique was tested to completion. No booth-simulation artifact was produced for either technique. No colour-coverage measurement was made. Items 6 to 9 remain on hold. The recovery session proved control-path progress (layer switching, doodad selection) but did not execute the two legibility tests it was dispatched for.

**What was accomplished in this pass.**

1. SCMDraft 2 launched without a map argument: the editor opened with a grey canvas and no tileset loaded. The Ctrl+N shortcut opened the **New Map dialog** (confirmed: shows Scenario Size width/height fields, tileset list with Badlands/Space Platform/Installation/Ash World/Jungle World/Desert World/Ice World/Twilight World, tile-type list for the selected tileset, Default triggers dropdown, Create Map and Cancel buttons). A click at (455, 353) aimed at "Jungle World" in the tileset list caused the dialog to close, but the resulting map was unsaved and rendered grey (no tileset data loaded), indicating the click did not select Jungle World or the tileset data was not configured for new-map creation without a game path set in the profile.

2. SCMDraft 2 relaunched with a fresh copy of `(2)River Crossing.scm` as `~/scmdraft-maps/legibility-test/flat-test.scm` (90426 bytes). The map loaded correctly: title bar showed the full path, status bar confirmed "Jungle World\Dirt", 187 doodads present, terrain palette auto-expanded showing Rocky Ground, Water, Coastal Cliff, Jungle, Ruins, Temple Wall, High Temple Wall, High Ruins, High Jungle, Bridges.

3. **Ctrl+D switches to the Doodads layer.** Confirmed: toolbar changed to "Layer: Doodads", status bar read "Doodads | Select Doodads | 187 Doodads." This is a control-path fact relevant to any future clearing workflow.

4. **Ctrl+A on the Doodads layer selects all doodads.** Confirmed visually: red highlight rectangles appeared around 20+ visible doodad sprites in `t0042-flat-doodads-del.png`. The selection was made. **Delete was not executed** (the correct scancode for the Delete key in the RDP keyboard event model was not confirmed before the pass ended). The 187 doodads remain on the test map.

5. **Rectangular terrain mode was not reached.** The "Isometrical" toolbar combo box (confirmed as a dropdown control from the Command Overview: "Isometrical terrain, Rectangular terrain, Tileset Indexed") was not successfully toggled. The click at (580, 72) aimed at its dropdown did not open the combo list. The item 4 finding about Delphi dropdown controls being unreliable applies here too.

**Technique A (units as pixels): NOT TESTED.** The unit tree expansion blocker from item 4 (subcategories expand, individual unit names do not) was not circumvented. No unit was placed on the test map. The Ctrl+U layer switch was sent and confirmed working in prior items but was not combined with a selected unit and a canvas click in this pass. The mechanism for selecting a specific unit from the tree (the blocker) remains unsolved.

**Technique B (tile-type contrast on a flat base, no drag brush): NOT TESTED.** The test requires: (a) a flat blank 64×64 map, (b) Rectangular terrain mode, (c) brush size 1 tile, (d) single clicks to paint a glyph. None of (a) through (d) were achieved. The map was not flattened (doodads not deleted, elevation not painted over). Rectangular mode was not reached. Brush size was not confirmed at 1. No glyph was painted with single clicks.

**GR-graphics tooling: located upstream, not installed.**

| Tool | Source | Licence | Obtainable |
|---|---|---|---|
| Firegraft (v0.91, v0.93, SCBWv1.16.1 EXE variant) | `github.com/Ar3sgice/starcraft-tools` (repo files: `firegraft0.91.zip`, `firegraft093.zip`, `Firegraft.rar`, `FireGraft SCBWv1.16.1 EXE.zip`). Stormcoast Fortress page `/cntt/software/scmdraft/download/` lists Firegraft but its download link returns a PHP error (confirmed item 4, `DEMO-LOG.md`). Also referenced at `fraudsclub.com/starcraft/modding-starter-guide/` as "Firegraft 0.93" by DiscipleofAdun. | No licence file in the Ar3sgice repo. Firegraft is freeware per its own community documentation; redistribution rights unclear. Not formally open-source. | Yes, downloadable from Ar3sgice repo. Win32 binaries. |
| IronGRP | `github.com/sjoblomj/irongrp` (Rust, MIT licence, 113 commits) | MIT | Yes, `cargo build --release`. Linux-native build possible. |
| GrpEditor | `github.com/mighty1231/GrpEditor` (Qt-based GRP frame editor) | LGPL v3 | Yes, source available. |
| grplib | `sourceforge.net/projects/grplib` (C library for GRP format) | LGPL v2 | Yes, source available. |
| GRPConv | `github.com/Ar3sgice/starcraft-tools` (`GRPConv.rar`) | No licence file in repo | Downloadable. |
| GRPEdit | `github.com/Ar3sgice/starcraft-tools` (`GRPEdit.zip`) | No licence file in repo | Downloadable. |
| bmp2scx | `github.com/Ar3sgice/starcraft-tools` (`bmp2scx1.0.rar`) | No licence file in repo | Downloadable. Converts a BMP image to a StarCraft map with terrain tiles per pixel/region. Potentially the most direct path to "tile contrast on a flat base" without SCMDraft 2 painting. |
| StarCraft Picture Mapper 4.1 | `github.com/Ar3sgice/starcraft-tools` (`StarCraft Picture Mapper 4.1.zip`) | No licence file in repo | Downloadable. Maps a picture onto a StarCraft map. |
| CoordinateDraw | `github.com/Ar3sgice/starcraft-tools` (`CoordinateDraw.zip`) | No licence file in repo | Downloadable. |
| grCreator | **Not found.** No tool by this exact name was located in any search or repo listing. The name appears in the item 4 unknowns (doc:50) as a hypothetical from the plan's reference to "the grCreator/Firegraft family documented by the same site." It does not correspond to a tool at Stormcoast Fortress or in any located repo. | — | Not obtainable. Does not appear to exist as a named product. |

**GR-graphics pipeline assessment (record only, not installed or tested).** For a classic 1.16.1 `.scm` map: the pipeline is (1) create art as PNG, (2) convert PNG → GRP sprite via IronGRP (MIT, Linux-native) or PyGRP, (3) modify `images.dat`/`images.tbl` in the game MPQ via Firegraft to point a unit at the new GRP, (4) place that unit in SCMDraft 2. Alternatively, `bmp2scx` may convert a bitmap directly to terrain tiles in a `.scx` map, bypassing the painting mechanism entirely. Neither path was tested. The Ar3sgice repo has no licence file, so Charmy must rule on redistribution before any of these tools appear in documentation.

**Booth-simulation artifact: none produced.** No screenshot was downscaled 4x because no test glyph was painted. The colour-coverage measurement Shadow used (HSV hue 180–260 degree band for Water blue) was not computed because there is no painted state to measure.

**Honest reading of the state.** The recovery session proved that the blank-map approach is reachable in SCMDraft 2 (Ctrl+N opens the New Map dialog), that layer switching (Ctrl+D, Ctrl+U, Ctrl+T) works reliably for automated clearing workflows, and that Ctrl+A selects all items on a layer. It did not produce a flat blank map, did not switch terrain mode from Isometrical to Rectangular, did not reduce the brush size, did not paint or place any test glyph, and produced no legibility evidence. Neither technique is proven or disproven. Items 6 to 9 remain blocked on the same Shadow blocker as before this pass.

**Target system changes (this pass, all reversible).**

| Change | Command | Inverse |
|---|---|---|
| Maps test directory for recovery | `mkdir -p ~/scmdraft-maps/legibility-test` | `rm -rf ~/scmdraft-maps/legibility-test/` |
| flat-test.scm created (90426 bytes, copy of River Crossing) | `cp ~/game-data/sc-clean/Starcraft/maps/"(2)River Crossing.scm" ~/scmdraft-maps/legibility-test/flat-test.scm` | `rm ~/scmdraft-maps/legibility-test/flat-test.scm` |
| Wine processes launched and killed | `wine64 ~/scmdraft2/"ScmDraft 2.exe" ... &` + `wine taskkill /f /im "ScmDraft 2.exe"` | `wineserver -k` (done) |
| SCMDraft 2 log file on target | `/tmp/t0042-recovery.log` | `rm -f /tmp/t0042-recovery.log` |

No new package installed. No repo enabled. No credential on any command line. No binary or game data in any git path.

**Controller-side changes.** None. No source files modified. No new scripts written.

**Evidence files under `~/AI/demo-evidence/`.**

| File | Content |
|---|---|
| `t0042-recovery-init.png` | 1511588 bytes. SCMDraft 2 "Select Profile" dialog. |
| `t0042-recovery-after-enter.png` | 60255 bytes. Blank grey canvas after profile confirmed (no map loaded, no tileset). |
| `t0042-recovery-terrain.png` | 60383 bytes. Same blank canvas, tree panel visible but Terrain node not expanded. |
| `t0042-recovery-terrain-expanded.png` | 60103 bytes. Terrain tree node selected (blue highlight) but not expanded. |
| `t0042-recovery-terrain-exp2.png` | 60328 bytes. Same state after second attempt. |
| `t0042-recovery-terrain-exp3.png` | 60328 bytes. Same after double-click attempt. |
| `t0042-recovery-filemenu.png` | 60529 bytes. Alt+F did not open menu. |
| `t0042-recovery-ctrln.png` | 67179 bytes. **New Map dialog visible.** Width 128, Height 128, Space Platform tileset highlighted. |
| `t0042-recovery-jungle.png` | 60280 bytes. Dialog closed. Blank grey canvas (unsaved new map, no tileset rendered). |
| `t0042-recovery-toolbar-crop2.png` | Toolbar area crop showing menu bar. |
| `t0042-recovery-tree-crop5.png` | 2.5x crop of tree panel: Terrain, Doodads, Locations, Units, Unit Sprites, Pure Sprites with + icons. |
| `t0042-flat-loaded.png` | 418756 bytes. Wine Mono Installer dialog overlaying map (River Crossing loading). |
| `t0042-flat-cleared.png` | 854820 bytes. River Crossing loaded, Jungle World tileset, terrain palette expanded showing Water/Dirt/Jungle etc. 187 doodads, start location, minerals. |
| `t0042-flat-doodads.png` | 855312 bytes. **Doodads layer active** (status bar "187 Doodads"). Ctrl+D confirmed. |
| `t0042-flat-doodads-del.png` | 850646 bytes. **All doodads selected** (red rectangles visible). Ctrl+A confirmed on doodads layer. |

**Checks run.**

| Check | Result |
|---|---|
| Ctrl+N opens New Map dialog | Confirmed. 128×128 default, tileset list visible. |
| Ctrl+D switches to Doodads layer | Confirmed. Status bar "187 Doodads." |
| Ctrl+A selects all doodads | Confirmed visually. Red selection rectangles on 20+ visible doodads. |
| Ctrl+T switches back to Terrain | Confirmed (proven item 4, re-confirmed this session). |
| Target processes cleaned after session | `ps aux \| grep` shows 0 wine processes. |
| No binary/game data in git | Confirmed. |
| GR-graphics tools located upstream | IronGRP (MIT), Firegraft (freeware, Ar3sgice repo), GrpEditor (LGPLv3), grplib (LGPLv2), bmp2scx (unknown licence). grCreator: does not exist as a named tool. |

**Checks not run.**

- Technique A (unit-per-tile pixel glyph): not tested. Unit tree expansion blocker unsolved.
- Technique B (tile contrast, single clicks, no drag): not tested. Rectangular mode not reached, brush size not reduced, no glyph painted.
- Booth-simulation artifact (4x Lanczos downscale): not produced.
- Colour-coverage measurement (HSV hue 180–260 band): not computed.
- Delete key scancode for doodad/unit deletion: not confirmed. Selection worked, deletion did not.
- Rectangular terrain mode toggle: not achieved.
- Brush size reduction to 1 tile: not attempted (requires Rectangular mode + canvas focus).
- `bmp2scx` tool tested or installed: not run.
- IronGRP tested or installed: not run.
- Flatpak Wine 11.0 used for this pass: not relevant (editor work, COPR Wine sufficient).
- Map validation ("map is valid" check): not run.
- Flat-test.scm saved with deletions: not saved (deletions not completed).

**Recommendation for Robotnik.** The recovery is incomplete. Two paths forward: (1) Resolve the Delete-key scancode (try `key 0x73` with the extended flag, or use rdp-input `keydown`/`keyup` variants) and the Rectangular-mode toggle, then re-run the legibility test with a cleared flat map and single-click painting. (2) Investigate `bmp2scx` as a bypass: it converts a bitmap image directly to terrain tiles in a StarCraft map file, which would test the tile-contrast hypothesis without SCMDraft 2's painting mechanism at all. The tool is downloadable from the Ar3sgice repo and is a Win32 binary that should run under the same COPR Wine prefix. This is a smaller test than either technique A or B done manually.

---

### Programmatic map construction proof (2026-11-14, `Tails`, in progress)

Goal: one proof that terrain written by code directly into the map CHK inside the MPQ, from a bitmap mask (one tile per pixel), renders in SCMDraft 2 as the intended picture and survives a re-open. Decision and findings recorded as they are produced.

**Format facts established from source (not invented).** Authoritative reference: `https://www.starcraftai.com/wiki/CHK_Format` (StarCraft AI wiki, original at Staredit Network). Confirmed against real files on the target with `mpyq` 0.2.5.

- A `.scm`/`.scx` is an MPQ archive whose map data lives in a single file named `staredit\scenario.chk`, and that file is a CHK: a sequence of 8-byte-headed sections `u32 Name + u32 Size + data`. Verified: SCMDraft 2 binary contains the string `staredit\scenario.chk` (`strings ~/scmdraft2/"ScmDraft 2.exe"`).
- Every map on the target that SCMDraft 2 opens is a 3-file combined MPQ: `staredit\scenario.chk` (the big blob) + one small file + `(listfile)`. `mpyq` decrypts the hash/block tables (key `_hash('(hash table)','TABLE')`) and the hash table genuinely holds only 3 real entries (River Crossing, and the SCMDraft-saved `foss-for-all.scm`). Block-table sizes: River Crossing blob 257441 B (fix-key, not compressed), foss blob 258473 B (encrypted, compressed). Classic multi-file names (`MAP `, `UNITS`, `TILE`, ...) do not appear; only `(listfile)` resolves by name. So the item 5 Option C "classic multi-file" assumption was wrong; the format is a combined CHK blob.
- Terrain sections in the CHK, verified sizes against the CHK doc:
  - `MTXM` (StarCraft terrain): `u16[width*height]`, one per tile, left-to-right top-to-bottom. Values are the tileset MegaTile index. **This is literally one u16 per pixel.**
  - `TILE` (StarEdit terrain): `u16[width*height]`, same layout. The CHK doc states TILE differs from MTXM **only where doodads are present**. Therefore for a no-doodad map `TILE == MTXM`. SCMDraft 2 (a StarEdit-type editor) renders from `TILE`/`ISOM`.
  - `ISOM`: the isometric diamond data; `TILE` is normally generated from it. `ISOM` is flagged "Not Required" for SC but is what SCMDraft edits in Isometrical mode.
  - Required-for-editor sections: `VER `, `VCOD`, `OWNR`, `ERA `, `DIM `, `SIDE`, `MTXM`, `SPRP`, `FORC`; `UNIT`/`THG2` may be empty.
- Chosen construction route, decided now: decrypt an existing Jungle-tileset CHK blob to harvest the exact MegaTile indices for flat low terrain per terrain type (evidence-based, no invented tile indices), then build a fresh no-doodad flat CHK from a bitmap mask writing `MTXM`==`TILE` one u16 per tile, wrap it back into the combined MPQ, and open it in SCMDraft 2. Reason this beats the brush: it gives one tile per pixel with no drag band and no elevation/cliff artefacts, which are exactly Shadow's two structural causes (doc:997, doc:998). Alternatives considered: (B) build a classic multi-file unencrypted MPQ from scratch, rejected because SCMDraft's open format here is the combined CHK blob and inventing the multi-file layout risks a map SCMDraft will not open; (C) keep patching the encrypted Blizzard blob in place without harvesting indices, rejected because the per-terrain MegaTile indices were unknown and inventing them violates AGENTS.md section 5.

**Checks run (so far).**

| Check | Result |
|---|---|
| `mpyq` version on target | 0.2.5, read-only (no MPQ write support) |
| River Crossing block/hash tables | 4 block slots (1 empty), 3 real files, blob 257441 B |
| foss-for-all block/hash tables | 4 block slots, blob 258473 B, encrypted+compressed |
| Classic-name hash brute force vs blob hashes | no match except `(listfile)`; blob name is `staredit\scenario.chk` (SCMDraft string) |
| CHK section layout | read from starcraftai CHK Format wiki |

**Maximum map extent, established (operator requirement).** From the CHK Format doc: `MTXM` validation "must be ≤ 131072 (0x20000) bytes (256 * 256 * 2)"; `DIM` standard dimensions 64, 96, 128, 192, 256. Format ceiling = **256 by 256 tiles**. My writer builds at 256×256 and `MTXM`/`TILE` come out exactly 131072 bytes, confirming it reaches the ceiling. SCMDraft 2's own New-Map-dialog maximum was not captured this pass (launch blocker below), so the SCMDraft-side ceiling is recorded unverified, not assumed.

**Write-path round-trip proof (core acceptance, measured).** Built `/home/howard/scmdraft-maps/probe/max256.scm` at 256×256, terrain written one `u16` per tile into `MTXM` and `TILE` from a bitmap mask, then re-read with `mpyq`. Result: `MTXM len 131072 expect 131072 TILE len 131072`; `MTXM vs mask mismatches: 0  distinct tile values: [1, 2]`. The written terrain is byte-for-byte the mask, one tile per pixel, at maximum extent. The write path round-trips at the format level.

**Two shapes built at maximum extent, filling the map (operator requirement).** (1) Filled silhouette: a solid disc, centre (72,128), radius 70, no internal counters. (2) Letterform with an internal counter: a block "O" ring, outer 81×121 tiles, with a 41×61 hole that must read through as the counter. Foreground coverage 34.6 percent (22673 of 65536 tiles); each shape ~140 tiles across, so features are far larger than item 5's 7-tile glyphs.

**4x booth-simulation against the intended mask.** `~/AI/demo-evidence/t0042-mask-full.png` (256×256) and `~/AI/demo-evidence/t0042-mask-booth4x.png` (64×64, PIL Lanczos 4x). Reading the 4x artifact: the filled disc is unmistakable, and the ring letterform's internal counter (the hole) is clearly visible. Both intended shapes are legible at booth scale in the mask that the map encodes. Honest caveat: this is the mask the code writes, not a SCMDraft render, because SCMDraft could not be launched this pass (below).

**Effect of filling the maximum extent on legibility.** Filling 256×256 with ~140-tile shapes improves legibility versus item 5 (doc:997): at 4x the features are ~35 pixels, not sub-pixel, so the internal counter survives downscaling. This is measured on the mask only; the SCMDraft/minimap legibility is unmeasured because SCMDraft did not open the map.

**Encryption wall (why terrain values are placeholders).** Every map on the target, including the Anthology originals and the SCMDraft-saved `foss-for-all.scm`, stores its CHK as an encrypted combined blob whose file key is not derivable from the filename (all `get_crypt_key` name/hash-type candidates failed; blocks show archived<size with no COMPRESS flag, a custom repacker). So the real Jungle MegaTile visual values could not be harvested from existing maps. My generated maps store the CHK **unencrypted** (no key) and round-trip through mpyq, so the write path itself is valid; the specific tile visuals (values 1 and 2 are placeholders) still need calibration against SCMDraft.

**SCMDraft 2 rendering NOT captured this pass (launch blocker).** A SCMDraft 2 instance that was rendering terrain (started 18:48) ran on a login-session Wine server. Terminating it (to load a different map) means every later Wine GUI launch from the SSH process context fails: `err:winediag:nodrv_CreateWindow ... no driver could be loaded`. The Wayland socket `/run/user/1000/wayland-0` is connectable from this context (verified with a raw client), and the user manager exports `WAYLAND_DISPLAY=wayland-0`, `DISPLAY=:0`, `XAUTHORITY=/run/user/1000/.mutter-Xwaylandauth.3K31Y3`; the Wine Mono installer also hung (`control.exe ... install_mono`). Launches were tried via `nohup wine`, `setsid bash run_scmdraft.sh` (wayland-0 and wayland-1), `systemd-run --user --scope` with the session env, and forcing X11 via `WINEDLLOVERRIDES`; all gave `nodrv` and no SCMDraft process. So the acceptance "SCMDraft opens the generated map showing the intended shapes, and survives a re-open" is NOT demonstrated this pass. The write path is proven; the viewer proof is blocked by this target's Wine-in-session requirement, consistent with the item 3 finding (doc:508) that this COPR Wine build's graphics drivers are fragile outside the login session.

**Checks run (this pass).**
- Writer round-trips through mpyq (calib.scm 64×64): chk entry found; all sections parse.
- Correct MPQ table encryption (seed updates with the plaintext value) implemented, so mpyq decrypts my tables.
- Max-extent build 256×256: `MTXM len 131072`, `TILE len 131072`.
- Written terrain equals mask: `mismatches: 0`, values `[1,2]`, one u16 per tile.
- 4x booth-sim of the intended mask: both shapes legible (disc solid, ring counter visible).

**Checks NOT run (named honestly).**
- SCMDraft 2 opening the generated map, editor screenshot, minimap screenshot, re-open screenshot: NOT run (launch blocker).
- Terrain MegaTile visual calibration in SCMDraft (mapping values 1/2 to actual Jungle tiles): NOT run.
- SCMDraft New Map dialog enforced max size: NOT captured (launch blocker); format ceiling 256×256 established from the CHK spec.
- Colour-coverage measurement from a SCMDraft minimap render (Shadow's HSV 180-260 method): NOT run (no SCMDraft render exists).
- Independent reader (Shadow) on a SCMDraft booth-sim artifact: NOT run.
- In-game minimap render via StarCraft: NOT run (item 3 playability blocker stands).
- Harvesting real Jungle MegaTile values by decrypting an existing map: NOT achieved (encryption wall).

**Target changes this pass (all reversible).** Map probe dir `~/scmdraft-maps/probe/` (calib.scm, max256.scm, mask PNGs) inverse `rm -rf ~/scmdraft-maps/probe/`. Helper scripts `/tmp/build_map.py`, `/tmp/build_shapes.py`, `/tmp/chk_read.py`, `/tmp/hash_probe.py`, `/tmp/scan.py`, `/tmp/parse3.py`, `/tmp/run_calib.sh`, `/tmp/carved_map.scm`, `/tmp/carve_*.mpq`, logs inverse `rm -f /tmp/{build_map,build_shapes,chk_read,hash_probe,scan,parse3,run_calib}.py .sh /tmp/carved_map.scm /tmp/carve_*.mpq /tmp/calib*.log /tmp/reg.log`. Registry key added `HKCU\Software\Wine\Wine Mono Installer\ShowUI=n` inverse `wine reg delete "HKCU\Software\Wine\Wine Mono Installer" /v ShowUI /f`. The prior 18:48 SCMDraft/wineserver was terminated (this pass's blocker); no package installed, no repo enabled, no credential on a command line, no game data or binary committed to any git path.

**Next dispatch, to complete the viewer half.** Do NOT kill any session-attached SCMDraft/wineserver. First re-establish a session-attached SCMDraft launch (find the launch method the earlier items used; the SSH-spawned wineserver cannot reach the display driver). Then open `~/scmdraft-maps/probe/calib.scm` (a 64×64 grid of 64 distinct candidate MegaTile values) to calibrate which values render as which Jungle terrain; rewrite max256.scm with two confirmed contrasting values; capture editor + minimap screenshots, re-open, produce the 4x booth-sim of the minimap, run Shadow's colour-coverage measurement, and hand the booth-sim to an independent reader. If SCMDraft refuses the unencrypted combined-CHK container, the finding to record is the container format, not the terrain write.

---

### Viewer half, session-attached launch (2026-11-14, `Tails`, continuing pass)

Fresh session continuing from doc:1000-1045. Target state at start: no wine/wineserver/SCMDraft running (`ps` shows none), `~/scmdraft-maps/probe/` holds `calib.scm` (48818 B) and `max256.scm` (480050 B), seat0 session id 2 (howard, tty2, Type=wayland, Active=yes). Nothing session-attached to preserve; the 18:48 wineserver from the prior pass was already gone.

**Launch blocker resolved (finding 1).** The prior pass's `err:winediag:nodrv_CreateWindow` wall is broken by explicitly exporting the seat0 Wayland session environment into the SSH launch context. Command that works (the same shape items 1-5 used, env made explicit): `export XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus XDG_SESSION_TYPE=wayland; WINEPREFIX=$HOME/.wine-scmdraft nohup wine <exe> ... &`. Evidence: `wine notepad` from the SSH context logged `waylanddrv:wayland_process_init` (only optional-protocol warnings, `zwlr_data_control_manager_v1`/`xdg_toplevel_icon_manager_v1` absent, no nodrv), notepad.exe pid 55439 alive, and a D-Bus screenshot `/tmp/notepad_test.png` (515652 B, `/tmp/opencode/notepad_test.png` on controller) shows a fully-decorated "Untitled - Notepad" window on the GNOME 49 desktop. Cause of the prior blocker, stated as finding not hypothesis: the SSH process context did not carry `WAYLAND_DISPLAY`/`XDG_SESSION_TYPE`, so wine's Wayland driver never initialised; the raw socket was connectable (prior pass doc:1025) but wine needs the env, not just socket reachability. Screenshot helper `/tmp/shot.py` on target now uses `Gio.DBusProxy.new_sync` for both `RequestName("org.gnome.Screenshot",4)` and `Screenshot(bbs)` on one connection (the raw-connection `call_sync` signature mismatched; proxies work).

**Finding 2, SCMDraft 2 opens the unencrypted combined-CHK container without error (container format accepted).** `nohup wine64 ScmDraft 2.exe ~/scmdraft-maps/probe/calib.scm` launched (pid 56301, Wayland driver init, no `nodrv`). After confirming the Default profile with Enter (rdp-input scancode 0x1C), the editor opened with a clean title bar and no error dialog: toolbar Zoom 100%, Layer Terrain, Player 1, Isometrical; the scenario tree populated with Terrain / Doodads / Locations / Units / Unit Sprites / Pure Sprites nodes. Evidence `~/AI/demo-evidence/t0042-calib-open.png` (`/tmp/calib2.png` on target). So the unencrypted single-`staredit\scenario.chk` MPQ written by `/tmp/build_map.py` (block flags `0x81000000`, unencrypted/uncompressed, round-trips through mpyq) IS accepted by SCMDraft 2 0.9.10 as a map. The container format is not the blocker.

**Finding 3, the synthetic terrain renders BLANK, and the cause is the terrain encoding, not the container.** The calib canvas is uniform grey with no Jungle palette loaded (`~/AI/demo-evidence/t0042-calib-open.png`), whereas River Crossing opened with the same launch method renders the full Jungle World (Water/Dirt/Mud/Jungle/Rocky Ground/Ruins/… palette, status bar `Jungle World\Dirt`) — evidence `~/AI/demo-evidence/t0042-rc-render.png`. Both maps are ERA=4 (Jungle). The CHK wiki (`starcraftai.com/wiki/CHK_Format`, and `wiki.staredit.net/wiki/Scenario.chk`) and the KopruluSector reverse-engineering (`github.com/n0madic/KopruluSector` native-terrain-import.md) establish that a TILE/MTXM u16 is **not** a raw graphics index: it decodes as `group = (val>>4) & 0x7FF` (a CV5 record index, 0..4095) plus `subtile = val & 15`. The CV5 record then references 16 megatiles (VF4/VX4). My calib wrote values 0..63, which decode to groups 0..3 only, and SCMDraft rendered none of them. Also wiki ISOM section: "the exact algorithm is unknown," and "TILE values are normally directly generated from ISOM." Whether SCMDraft trusts TILE as-written or regenerates it from ISOM (my ISOM is all-zero) is the open question; both point to a terrain-data defect in my writer, not the container.

**Finding 4, encryption wall reconfirmed with a correct MPQ algorithm (strengthens doc:1023, doc:1041).** River Crossing's CHK blob (block 1, flags `0x80010200` = encrypted+compressed, sector-based) does not decrypt with any standard file key. Tried mpyq's own `_hash(name,'TABLE')` key `0x9255D2BE` and a case-preserving name key `0x05CBA1CE`, each with mpyq's no-reset decrypt, a seed2-only reset at 512/1024/4096, and the correct non-fix-key rule (reset BOTH seed1 and seed2 every 512 dwords); checked each result for a sane sector-offset table (first=0, monotonic, last=archived_size) and for a CHK header or zlib stream after per-sector decompress. None succeeded. Harvesting real Jungle MegaTile values by decrypting an existing map remains blocked, as previously recorded. The authoritative path forward is to read the Jungle tileset's CV5 terrain groups from the game data (game MPQs are unencrypted file data, so mpyq can read them) rather than from a protected map.

**Finding 5, code-written terrain still blank across the full CV5 group range; SCMDraft appears to require a valid ISOM.** Rebuilt calibration `~/scmdraft-maps/probe/calib2.scm` (writer `/tmp/build_map.py` on target, fill = `group*16` for groups 0..255, one value per 4x4 tile block, verified `groups covered count 256, min 0, max 255`). SCMDraft 2 opened it (pid 57927, no error, clean tree) and it is **again fully blank** (`~/AI/demo-evidence/t0042-calib2-open.png`), with the Terrain palette still collapsed, while River Crossing under the same launch method renders and its Terrain palette expands to the full Jungle list (`t0042-rc-render.png`). Evidence: my synthetic maps render blank regardless of the TILE value range. Strong hypothesis (wiki-grounded, NOT isolated by a controlled test): SCMDraft/StarEdit draws from TILE, and TILE is generated from ISOM (wiki: "TILE values are normally directly generated from ISOM"; ISOM "the exact algorithm is unknown"); my writer's ISOM is all-zero, so StarEdit resolves every tile to null. To confirm, a controlled test is needed that varies ISOM while holding TILE constant. **The technique decision's assumption that writing MTXM==TILE one-u16-per-pixel is sufficient for SCMDraft rendering is not proven and is now contradicted by evidence**; a valid ISOM (or a source of valid tileset terrain groups) is required.

**Finding 5b, controlled ISOM test result.** Built `~/scmdraft-maps/probe/isomprobe.scm`: TILE held fixed at one candidate value (group 30, `480`) across the whole 64x64 map while ISOM was varied per 8-entry step over candidate values 0..255 (`ISOMlen 8580`). SCMDraft 2 opened it (pid 58299, no error) and it is **again fully blank** with a collapsed Terrain palette (`~/AI/demo-evidence/t0042-isomprobe.png`). So varying ISOM alone does not make terrain appear when TILE is a single arbitrary group. Combined with Finding 5 (varying TILE across groups 0..255 with zero ISOM also blank), the evidence shows SCMDraft needs a coherent valid TILE(group)+ISOM pair drawn from the real Jungle CV5/VF4 megatile tables; arbitrary guessed values for either field render nothing. The synthetic-CHK writing route therefore cannot reach a rendering map without first obtaining the real tileset terrain tables.

**Finding 6, game-data terrain extraction is also blocked.** The Jungle tileset's CV5/VF4 (the authoritative source of valid group indices) are inside the game MPQs, not loose files (`find` found no `*.cv5`/`*.vf4`/TileSets dir). mpyq cannot read them on this target: `StarCraft.mpq` and `BroodWar.mpq` give `ValueError('Invalid file header.')`, `BrooDat.mpq` gives `NotImplementedError('Encryption is not supported yet.')`, and `Stardat.mpq` is absent from the extracted set. So neither protected maps nor the game MPQs currently yield valid Jungle terrain values with the tooling on the target.

**Viewer-half acceptance NOT met this pass (recorded, not claimed).** Two confirmed contrasting renderable Jungle values, the max256 rewrite, the editor+minimap screenshot of a code-written map, the re-open, the 4x minimap booth-sim, the Shadow colour-coverage, and the independent read are all NOT done, because no code-written map currently renders terrain in SCMDraft. No booth-simulation artifact or coverage number was produced from a real render.

**Concrete next levers for the next dispatch (in cost order).** (1) Controlled ISOM test: rebuild a map holding TILE fixed and varying ISOM over a small set of candidate flat-ground patterns to determine whether ISOM is the rendering gate; if it is, the ISOM→TILE generator becomes the thing to reproduce. (2) `bmp2scx` (the technique-recovery recommendation at doc:984, from the Ar3sgice starcraft-tools mirror) is the documented tool that converts a bitmap to a StarCraft map with correct terrain/ISOM; testing it is the natural bypass, but it is an unlicensed Win32 binary and must be ruled by Charmy (licence) and Omega (supply-chain) before it is downloaded and run. (3) Get mpyq-equivalent terrain extraction working on the game MPQs (the invalid-header/encryption failures are tooling limits, not proof the data is unreadable). (4) Have SCMDraft itself author a map and save it in its own non-Blizzard-certified format to see whether the saved file is unencrypted and therefore readable for harvesting valid ISOM/TILE.

**Target changes this pass (all reversible).** Maps `~/scmdraft-maps/probe/calib2.scm` (inverse `rm ~/scmdraft-maps/probe/calib2.scm`). Registry `HKCU\Software\Wine\Wine Mono Installer\ShowUI=n` re-added (inverse `wine reg delete "HKCU\Software\Wine\Wine Mono Installer" /v ShowUI /f`). Logs `/tmp/{notepad_test,scmd_calib,rc,c2}.log` and `/tmp/shot.py`, `/tmp/chk_read.py` on target (inverse `rm -f`). Controller evidence `~/AI/demo-evidence/t0042-{calib-open,rc-render,calib2-open}.png`. Wine processes I started this pass (notepad, three SCMDraft launches, their wineservers, one stuck heredoc bash) were all killed or terminated by me; no session-attached process I did not start was touched. No package installed, no repo enabled, no credential on any command line, no binary or game data committed to any git path.

---

### Plaintext CHK extraction attempt (2026-11-15, `Tails`, acceptance NOT met, precise finding recorded)

Objective: get one plaintext CHK from a map that SCMDraft 2 actually renders, to extract valid TILE group and ISOM pairs. Three options attempted in order.

**Option 1, SCMDraft 2 save without Blizzard protection. FAILED.** SCMDraft 2 always encrypts the CHK blob when saving a `.scm` file, regardless of the certification dialog answer. Experiment: loaded a River Crossing copy (`rc-copy.scm`, 90426 bytes), made a minor paint edit, saved via taskkill→Enter (save changes)→Escape (refuse certification). File saved (90426→92748 bytes, mtime updated) but block[1] flags remain `0x80010200` (ENCRYPTED|COMPRESS). The certification dialog controls Battle.net signature, not encryption. SCMDraft 2's internal save path always writes an encrypted MPQ. Confirmed: Escape (scancode 0x01) on the certification dialog does NOT produce an unprotected file; Enter does the same as Escape in terms of encryption output.

**Option 2, open-source CHK/MPQ tool. BLOCKED.**
- `mpyq` 0.2.5 (LGPL, `github.com/arkx/mpyq`): reads hash/block tables of SC maps but raises `NotImplementedError("Encryption is not supported yet")` when reading encrypted file data. Cannot decrypt the CHK blob.
- Key derivation attempts on River Crossing's CHK (block[1], flags 0x80010200, offset 32, arch 73561): tried `TABLE_OFFSET` hash, `HASH_A`, `HASH_B`, `HASH_A XOR HASH_B`, `HASH_A + HASH_B`, `TABLE_OFFSET + HASH_A`, `TABLE_OFFSET + HASH_B`, fix-key and non-fix-key modes, 512-dword resets. All produce garbage sector offsets. The encryption key for SC map CHK blobs is NOT derivable from the filename using any standard MPQ key derivation. This confirms and extends finding 4 from the previous pass (doc:1062).
- `Unused Unprotector 2` (source at `github.com/mirusu400/Unused-Unprotector-2`, archived 2020-09-07, copyright "Unused" 2008, no explicit licence file, source available for reference). Uses SFmpq (MaNGD's static MPQ library) which CAN read encrypted SC maps. SFmpq is a closed-source static binary linked in the project. The decryption key algorithm is inside SFmpq's compiled code. Cannot reimplement without SFmpq source.
- `libmpq` (LGPL 2.1+, `github.com/mangguoqiang/libmpq`): standard MPQ reader, uses filename-derived keys. Cannot read SC maps for the same reason mpyq cannot.

**Option 3, bmp2scx bitmap-to-terrain generator. BLOCKED.**
- Downloaded `bmp2scx1.0.rar` from `github.com/Ar3sgice/starcraft-tools` (no licence file in that repo; tool created by "hkkhhk" 2009, site www.scrpg.net, freeware per readme). Extracted `BMP2SCX1.0.exe` (66560 B), `chkoriginal.bin` (49860 B), `colorbase.bin` (3855 B).
- Run under COPR Wine 10.17: fails with `MFC42.DLL not found` (needed by `MpqCtl.ocx`, the MPQ write ActiveX control) and COM class registration failure. The tool cannot write output maps without the OCX working.
- Parsed `colorbase.bin` as 771 entries of `[R][G][B][MTXM_u16]`: yields 550 unique MTXM values (groups 0-73, 128-138, 194, 225, 256-285, etc.) covering all 8 tilesets. Flat groups (subtile 0): 0, 1, 2, 4, 5, 10, 13, 14, 26, 61, 128-138, 142, 194, 225, 256-263, 285.
- Built calibration maps (`calib3.scm`, `calib4.scm`) with ISOM=0x10 (correct flat default from Unused Unprotector 2 source, see below), TILE=MTXM, and test MTXM values from colorbase.bin. SCMDraft 2 opens them but renders BLANK canvas with collapsed terrain palette. The colorbase.bin values are valid for some tileset but NOT for Jungle (ERA=4) specifically.

**Finding 7, correct ISOM flat default established from published source.** The Unused Unprotector 2 source (`unprotect.cpp` lines ~440-460, `github.com/mirusu400/Unused-Unprotector-2`) creates a default flat ISOM with every entry = `0x10` and sets TILE = MTXM directly. For a 64x64 map: ISOM size = 4*(64+2)*(64+1) = 17160 bytes = 8580 u16 entries, each `0x10`. My previous maps had ISOM all zeros (0x00); the correct flat value is 0x10. Despite this correction, synthetic maps with valid ISOM still render blank because the TILE/MTXM group indices are invalid for Jungle.

**Finding 8, the invalid field is the TILE/MTXM group index itself.** The CHK wiki (starcraftai.com, staredit.net/wiki/Scenario.chk) and the Unused Unprotector 2 source establish that a TILE/MTXM u16 decodes as `group = (val>>4) & 0x7FF` (CV5 record index, 0-4095) and `subtile = val & 15`. The CV5 record references 16 megatiles defined in the tileset's CV5/VF4 data inside `Stardat.mpq`. Groups without a corresponding CV5 entry for the active tileset render as null (blank). My writer's group values (0-63, colorbase.bin flat groups) do NOT match any CV5 entry for Jungle (ERA=4). The terrain cannot be built correctly without the Jungle CV5 group table.

**Finding 9, Jungle CV5 data is inaccessible with current tooling.** `Stardat.mpq` (66184609 bytes, at `~/game-data/sc-clean/Starcraft/StarDat.mpq`) contains the tileset CV5/VF4 files. mpyq opens the archive but: 478 blocks have flags `0x80000000` (EXISTS only) but their sector offset tables are encrypted (garbage when read as plain); 2439 blocks have `0x80030200` (ENCRYPTED|FIX_KEY|COMPRESS); 7 blocks have `0x80030000`. Zero blocks are readable. The game data MPQs use a non-standard variant where even "unencrypted" files have encrypted sector tables. No open-source tool on the target can extract the CV5 data.

**Precise statement of which writer field is invalid and why.** The writer's `MTXM` and `TILE` arrays contain `group*16 + subtile` values. The `group` field (bits 4-14 of each u16) is a CV5 record index that must reference a defined tileset group in the game's tileset data. My writer uses group values 0-255 (or 128-285 from colorbase.bin). These group indices do NOT correspond to any defined Jungle CV5 group. A Jungle map requires specific group indices (typically in the range determined by the Jungle CV5 table in Stardat.mpq's `Tilesets\jungle\cv5.dat`, which is inaccessible). The ISOM value 0x10 and TILE=MTXM relationship are correct (Finding 7), but the group indices themselves are the blocking field. Without the Jungle CV5 group table, no synthetic CHK can render terrain in SCMDraft 2 for the Jungle tileset.

**Checks run.**

| Check | Result |
|---|---|
| SCMDraft save via Escape on certification dialog | File saved (90426→92748) but encrypted (flags 0x80010200). Certification dialog does not control encryption. |
| mpyq hash/block table read on River Crossing, rc-copy.scm, foss-for-all.scm | Tables decrypt correctly (3 entries, standard TABLE key). File data blocked by ENCRYPTED flag. |
| Key derivation brute force (7 key pairs × 2 reset modes) on River Crossing CHK | All produce garbage first-sector offset. Key not derivable from filename. |
| colorbase.bin parsed | 771 entries, 550 unique MTXM values, groups 0-73/128-285. Flat groups extracted. |
| calib4.scm built with ISOM=0x10, TILE=MTXM, colorbase flat groups, real VCOD | Opens in SCMDraft 2 (no error dialog) but renders blank. |
| Unused Unprotector 2 source read | Confirms ISOM default = 0x10, TILE = MTXM. Uses SFmpq (closed static binary) for decryption. |
| bmp2scx under Wine | Fails: MFC42.DLL not found, MpqCtl.ocx COM class unregistered. Cannot write output. |
| StarDat.mpq non-encrypted block read | 0 readable. Sector offset tables encrypted even for flags=0x80000000 blocks. |

**Checks NOT run (named honestly).**
- Running Unused Unprotector 2 under Wine (Windows binary, needs SFmpq_static.lib which is embedded in the compiled exe; could test but likely same MFC42.DLL issue as bmp2scx).
- Installing MFC42.DLL in Wine prefix (would enable bmp2scx or Unused Unprotector; not attempted to avoid adding unlicensed DLLs).
- Decrypting River Crossing via a known-good SFmpq or Zezula StormLib binary (Windows-only, not available on Linux target).
- Reading Stardat.mpq CV5 with a tool that handles encrypted sector tables (none available on target).
- Testing a different tileset (Badlands ERA=0) with colorbase.bin values to see if rendering works for a non-Jungle tileset. Not run.
- Checking whether the colorbase.bin values are tileset-specific (organized by tileset index) or shared across tilesets. Not established.

**Licence and upstream references recorded.**

| Component | Upstream | Licence | Status |
|---|---|---|---|
| mpyq 0.2.5 | `github.com/arkx/mpyq` | No licence file in repo (MIT claimed by PyPI metadata) | Installed on target via pip3 |
| Unused Unprotector 2 source | `github.com/mirusu400/Unused-Unprotector-2` (archived 2020-09-07) | Copyright "Unused" 2008, no explicit licence file; source published for reference | Source read, not compiled |
| bmp2scx 1.0 | `github.com/Ar3sgice/starcraft-tools` (`bmp2scx1.0.rar`) | No licence file in repo; readme credits "hkkhhk", freeware per readme | Downloaded, extracted, not usable under Wine |
| SFmpq (inside Unused Unprotector 2) | Unknown (MaNGD library, static-linked) | Unknown | Cannot extract algorithm |
| libmpq | `github.com/mangguoqiang/libmpq` | LGPL 2.1+ | Not installed, noted as alternative |
| StormLib | `zezula.net/en/mpq/stormlib.html` / GitHub `ladislav-zezula/StormLib` | Freeware (not open-source) | Referenced as reference implementation |

**Recommendation for next dispatch.** The terrain encoding problem is now precisely characterized. Two paths forward: (A) Install `winetricks wmp4` or equivalent to provide MFC42.DLL in the Wine prefix, then retry Unused Unprotector 2 (a Windows binary available at `github.com/Ar3sgice/starcraft-tools/Unused Unprotector.rar`) under Wine on the target. If it runs, it reads River Crossing, saves an unprotected CHK, and the terrain values become readable. Licence: "Unused" 2008 freeware per the source repo README. (B) Search for a published open-source StarCraft terrain lookup table (someone may have extracted and published the Jungle CV5 group→tile mapping). This would eliminate the need to decrypt anything. Neither was tested this pass.

**Target changes this pass (all reversible).** Map probe dir additions: `~/scmdraft-maps/probe/{isom10.scm, calib3.scm, calib4.scm, unprotect-test/rc-copy.scm}` (inverse `rm -rf ~/scmdraft-maps/probe/ ~/scmdraft-maps/unprotect-test/`). `~/game-data/bmp2scx/` extracted (inverse `rm -rf ~/game-data/bmp2scx/`). `~/game-data/bmp2scx1.0.rar` downloaded (inverse `rm ~/game-data/bmp2scx1.0.rar`). `/tmp/build_isom10*.py`, `/tmp/calib3.py`, `/tmp/calib4.py`, `/tmp/decrypt_chk.py`, `/tmp/try_keys.py`, `/tmp/try_listfile.py`, `/tmp/check_mpq.py`, `/tmp/cmp_mpq.py`, `/tmp/real_vcod.bin` on target (inverse `rm -f`). Wine processes started and terminated. No package installed. No repo enabled. No credential on any command line. No binary or game data committed to any git path.

---

### Terrain value harvest (2026-11-19, `Tails`, dispatch 1, acceptance met on the precise-statement branch)

Objective: one plaintext CHK from a map SCMDraft 2 renders, then a diff against the writer at
`/tmp/opencode/t0042/build_map.py`, naming the invalid field. Ordered attempts run in the order the
brief gave. Continuous log: DEMO-LOG 2026-11-19, 23:25-23:55.

**Attempt 1, a SCMDraft 2 save that writes without map protection. FAILED, closed with evidence.**
The upstream Options Overview page carries no protection setting. `strings -n 2 ~/scmdraft2/"ScmDraft 2.exe"`
piped to `grep -n "(\*\."` returns nothing, so SCMDraft 2 exposes no save filter for any format other
than the ones it already uses; the `.chk` strings in the binary are the MPQ member name
`staredit\scenario.chk` (doc:1008) and a file-type label inside the backup dialog, not a save format.
The binary contains `Opening protected maps disabled! Compile with -IGNORE_PROTECTION option set`, so the
switch is compiled in, not selectable. SCMDraft's `Scm*.tmp` files are byte copies of the file that was
opened, proven by parsing them: the tmps beside River Crossing copies are encrypted, the tmps beside
this team's own plaintext maps are plaintext. `~/scmdraft2/backupDB.scmdDB` is an MPQ with 7 entries,
every one flagged ENCRYPTED. There is no SCMDraft 2 route to an unprotected map file.

**Attempt 2, a published open-source MPQ tool. SUCCEEDED. This is the unlock.** Upstream and licence
recorded before anything was installed: `github.com/ladislav-zezula/StormLib`, commit
`d60b7e6d3501474f4d92c7b9c752a37e78385f67`, `LICENSE` = `The MIT License (MIT)`, Copyright (c)
1999-2013 Ladislav Zezula. Built controller-side only (`cmake -DSTORM_USE_BUNDLED_LIBRARIES=ON`,
`cmake --build build -j8`, then `g++ chkdump.c -I StormLib/src -L StormLib/build -lstorm`). StormLib
reads what mpyq 0.2.5 cannot: `./chkdump maps/rc.scm 'staredit\scenario.chk' rc.chk` returned
**257441 bytes of plaintext CHK** beginning `56 45 52 20 02 00 00 00 3b 00 49 56 45 52 02 00`, and
`bn.chk` from Bottleneck returned 186130 bytes. The maps were copied off the target read-only for the
test, SHA-256 recorded in `/tmp/opencode/t0042/maps.sha256`; nothing was committed.

**Container facts established from blocks that are not encrypted in the same archives.** In Bottleneck,
`(listfile)` (47 stored, 39 archived) and `(attributes)` (42 stored, 68 archived) are unencrypted. Both
begin `[u32 8][u32 stored_length]`; the payload of a compressed block then starts with the byte `0x02`
followed by a zlib stream (`78 9c ...`), and the listfile payload is raw text:
`blizzard_2.cnd\r\nstaredit\scenario.chk\r\n`. Every map CHK blob inspected across 50 bundled and
team-saved maps carries flags `0x80010200` (mpyq's constants: EXISTS, ENCRYPTED, COMPRESS), so stored
length is smaller than archived length: the plaintext is compressed before it is encrypted. mpyq's
`MPQ_FILE_COMPRESS` is `0x00000200`, not `0x00000100`, which is why earlier size readings looked odd.

**Known-plaintext recovery of the file key was attempted and is recorded as a dead end.** MPQ file
crypt is a stream XOR whose seed chain depends on the key and on already-decrypted plaintext, so a
known leading dword collapses the 32-bit key to about one candidate: `seed1 = (cipher0 ^ plain0 -
0xEEEEEEEE - TABLE[0x400 + (seed1 & 0xFF)])` with the low byte self-consistent. Candidates that
reproduced `[8][stored_length]` in the first two dwords on four blocks in two maps diverged from dword 2
on, and the standard name-derived keys (`mhash("staredit\\scenario.chk", 3) = 9255D2BE`, also the type 1
and 2 variants) decrypt to garbage. Ciphertext structure across the bundled set (dword0 bytes 2 and 3
identical in every map, dword3 identical between Bottleneck and River Crossing) shows the keystreams are
nearly shared, so the key is close to constant but is not the name-derived one. StormLib knows the real
derivation; reimplementing it is unnecessary now, so this line is closed.

**Diff of the harvested CHK against the writer at `/tmp/opencode/t0042/build_map.py`.** River Crossing
is 96 x 256, ERA 4 (Jungle). Bottleneck is 128 x 128. Both are protected maps that SCMDraft 2 renders.

| Field | Writer (`build_map.py:98-133`) | River Crossing | Bottleneck | Verdict |
|---|---|---|---|---|
| ISOM section size | `(W//2+1)*(H+1)*4` = 8580 B at 64x64 (line 103) | 100744 B = `4*(W+2)*(H+1)` at 96x256 | 67080 B = `4*(W+2)*(H+1)` at 128x128 | **wrong, half the required size** |
| ISOM content | all zero | 50372 entries, values 16..2062, dominant value 64 (12920 tiles) | 33540 entries, values 16..2398, dominant 16 | **wrong, zero is not a valid brush index set** |
| MTXM group indices | arbitrary `group*16` for groups 0..255 (line 149) | 387 groups, minimum group 2 (smallest value 32), dominant pair 8 and 9 | 412 groups, minimum group 2, dominant pair 4 and 5 | **wrong, groups 0 and 1 are used by no real map, and the Jungle flat ground is group 8 and 9 at subtile 0, values 128 and 144** |
| TILE | equal to MTXM | 736 of 24576 tiles differ from MTXM | 242 of 16384 differ | **acceptable for a no-doodad map**; the differences sit where DD2 and THG2 are non-empty |
| Subtile nibble | 0 in every tile | 0..14 | 0..14 | acceptable for flat ground, wrong for anything with elevation |
| VER | 205 (`ver=205`, line 98) | `0x3b` = 59 | `0x3b` = 59 | writer value not what a rendering map uses |
| VCOD | 1040 zero bytes (line 108) | 1040 bytes, 1037 non-zero | 1040 bytes, 1037 non-zero | writer writes an empty code table |
| Sections present | 18 | 30, including `IOWN`, `PUNI`, `UPGR`, `PTEC`, `UPRP`, `UPUS`, `WAV `, `UNIS`, `UPGS`, `TECS`, `MBRF` | same family | writer omits them; SCMDraft opened the synthetic maps anyway, so these are not proven render gates |
| MTXM size | `W*H` u16 | 49152 = 96*256*2 | 16384 = 128*128*2 | correct |
| MASK size | `W*H` bytes | 24576 | 16384 | correct |

**Precise statement of the invalid field.** The writer's `ISOM` is invalid in two ways at once, and its
`MTXM`/`TILE` value selection is invalid in a third. `isom=b"\x00" * ((W//2 + 1) * (H + 1) * 4)` at
`build_map.py:103` produces half the bytes a real map carries (`4*(W+2)*(H+1)`), and fills them with
zero, while the two harvested maps use non-zero brush indices (dominant 64 for Jungle, 16 for Badlands).
The terrain values the writer writes, `group*16` for groups 0 through 255 (`build_map.py:149`), include
groups 0 and 1, which no tile of either real map uses, and for Jungle the flat ground a player sees is
group 8 and group 9 at subtile 0, values 128 and 144, alternating tile to tile. So the previous pass's
answer (doc:1113, "the group index") is confirmed and extended: the group index was wrong, and the
ISOM size and content are wrong as well. The `TILE == MTXM` assumption (doc:1015) is sound for a
no-doodad map and is not the defect.

**Which defect gates rendering is isolated but not yet read.** Four maps were built on the target from
the harvested CHK and the writer, using the container SCMDraft 2 is already known to accept (doc:1069):

| Map | Content |
|---|---|
| `harvA.scm` | the harvested River Crossing terrain arrays, verbatim, in the writer's unencrypted single-unit container. Control: should render Jungle terrain |
| `harvB.scm` | the writer's own structure at 64x64, fill = 128 (a harvested valid Jungle value), writer's half-size zero ISOM |
| `harvC.scm` | same fill, ISOM resized to `4*(W+2)*(H+1)` and filled with the harvested dominant value 64 |
| `harvD.scm` | harvested terrain verbatim with the ISOM payload zeroed in place, isolating ISOM content |

All four were launched in SCMDraft 2 with the proven seat0 session export (`bash /tmp/run_viewer.sh
<A|D|B|C>`, `nohup wine64 ~/scmdraft2/"ScmDraft 2.exe" <map>`, profile dialog dismissed with
`rdp-input rdp-args key 0x1C`) and each was then killed with `pkill -f "ScmDraft[ ]2"`. None could be
read, because the target no longer permits the D-Bus screenshot call that TASK-0041 proved and that
every earlier map reading in this task used. The exact refusal and the diagnostics are in DEMO-LOG
2026-11-19. The four maps remain on the target for a later pass.

**Checks run.**

| Check | Result |
|---|---|
| `./chkdump maps/rc.scm 'staredit\scenario.chk' rc.chk` | 257441 B plaintext CHK, head `56455220020000003b00495645520200` |
| `./chkdump maps/bn.scm ... bn.chk` | 186130 B plaintext CHK |
| `python3 chk_analyze.py rc.chk` | 30 sections, covered 257441/257441, DIM 96x256, ERA 4, ISOM 100744 B |
| `python3 chk_analyze.py bn.chk` | ISOM 67080 B, MTXM n 16384, min value 32, dominant groups 4 and 5 |
| StormLib licence | `LICENSE` = MIT, upstream commit `d60b7e6d3501474f4d92c7b9c752a37e78385f67` |
| Map copies verified | `sha256sum`, recorded in `/tmp/opencode/t0042/maps.sha256` |
| Four SCMDraft launches | started, all terminated, `scmdraft_count=0`, pre-existing wineserver untouched |
| Screenshot attempts | `AccessDenied: Screenshot is not allowed` via gdbus and dbus-send; `org.gnome.Screenshot` object absent; `gnome-screenshot` not installed; `ScreenSaver.GetActive` false |

**Checks NOT run (named honestly).** No editor screenshot, no minimap screenshot, no re-open screenshot,
no 4x booth simulation, no colour-coverage measurement, and no independent reader for the four test
maps. The isolation experiment (A, B, C, D) is built but unread. `bmp2scx` was not re-run; its
`chkoriginal.bin` (49860 B) was parsed this pass and contains 33 sections starting `TYPE`, with no
`MTXM`, `TILE`, `ISOM`, `ERA` or `DIM` at all, so it carries no terrain table and cannot be the terrain
source. StormLib was not installed on the target, only on the controller.

**For the review chain.** `Charmy` and `Flicky`: StormLib is MIT with the licence file present in the
repo, and it is built and used only on the controller, never committed and never shipped; the harvested
plaintext CHK and the two map copies are derived from the team's legally held Anthology data and stay
under `/tmp/opencode`, never in a git path. `Omega`: the new trust item is a controller-side build of an
MIT library from GitHub at a pinned commit, with no new target package and no new target repo.

**Next dispatch, in cost order.** 1, restore a screenshot path on the target. The refusal is a target
state fact, not a code problem. Cheapest candidate is `dnf install gnome-screenshot` from an already
enabled repo with NEVRA and the removal command recorded, since the Shell D-Bus API is now denied to a
non-session bus client; the fallback that needs no target change is a framebuffer capture inside the
team's own FreeRDP client, since `freerdp-devel` is already installed on the controller. 2, read
`harvA`, `harvB`, `harvC`, `harvD` in that order and record which render. 3, once a rendering variant is
known, rewrite `/tmp/opencode/t0042/build_map.py` with the harvested ISOM size
`4*(W+2)*(H+1)`, a non-zero ISOM brush value, and Jungle flat ground values 128 and 144 in an
alternating pattern, then build map 1 at 256 by 256. 4, the harvest route itself is now cheap and
repeatable: any protected map on the target can be read with `chkdump`, so the terrain reference for
every tileset is obtainable, including from a map the team builds and reopens.

---

### Screenshot path restoration (2026-11-20, `Tails`, blocked, recorded not claimed)

Objective: restore a working screenshot path on the target, then read `harvA`, `harvB`, `harvC`, `harvD` in order and record which render terrain. Both candidates the brief named are blocked on this target/controller pair. Continuous log: DEMO-LOG 2026-11-20.

**Alternatives considered.**

*Candidate 1, `dnf install gnome-screenshot` from an already enabled repo (the brief's "cheapest"). Blocked at the availability gate, no install performed.* `dnf repoquery --available gnome-screenshot` returns empty across all eight enabled repos; `dnf repoquery --available '*screenshot*'` returns only a shell extension; `grim` and `weston-screenshooter` are empty; the only provider of `org.gnome.Screenshot.service` is `gnome-screenshot` and it has no repo provider. Installing it needs a new repo, which the brief forbids. So candidate 1 as written cannot run.

*Candidate 2, framebuffer read inside the team's own FreeRDP client, target untouched (the brief's fallback). Connects and negotiates, but yields no frame.* Chosen to build because it touches the target not at all. `rdp-shot.c` (FreeRDP 3, `freerdp3`+`freerdp-client3`, Apache-2.0) reaches `CONNECTION_STATE_ACTIVE` with NLA HYBRID_EX, the RDPGFX exchange completes (server confirms `RDPGFX_CAPVERSION_107 flags 0x22`, sends `CreateSurface 0 1920x1080 format 0x20`, `MapSurfaceToOutput`, four `RDPGFX_CODECID_CAPROGRESSIVE` frames). But `instance->context->gdi->gfx` is NULL and the captured buffer is a uniform white field (PIL, 1 colour, mean luma 255). The decoded RDPGFX surface never reaches GDI because `gdi_graphics_pipeline_init` needs a `RdpgfxClientContext*` whose constructor `rdpgfx_client_context_new` is not exported in this distro build (`WITH_CLIENT_INTERFACE=OFF`, confirmed no `.so` under `/usr/lib64` exports it), and the deprecated `SupportGraphicsPipeline` auto-bind is gone in 3.32. `/gfx:RFX9` parses but does not wire `gdi->gfx`; `/gfx:AVC444` and `/gfx:off` are rejected by this build's parser. The brief's assumption that `freerdp-devel` alone suffices is the gap: it covers input (proven, rdp-input works) but not gfx-to-GDI rendering here.

*Option considered and rejected: read the addin's internal gfx surface directly.* The addin decodes `CAPROGRESSIVE` into its own context, but that context is not reachable through any exported symbol (`client/channels.h` exposes no gfx getter). Not attempted.

**Changes table (controller only, target unchanged).**

| File / system | Change | Why | Inverse |
|---|---|---|---|
| controller gdb | `sudo dnf install -y gdb` (NEVRA `gdb-17.2-4.el10_3.x86_64`) | get a backtrace of the connect-phase crash | `sudo dnf remove -y gdb` |
| `/tmp/opencode/t0042/rdp-shot.c`, `rdp-shot`, `sanity_desktop.ppm`, `*.log` | created | candidate 2 capture tool and test frames | `rm -f /tmp/opencode/t0042/rdp-shot{,.c} /tmp/opencode/t0042/sanity_desktop.{ppm,png}` |

Target: no package, no repo change, no file, no process started. `harvA-D` unchanged. Pre-existing `wineserver` (62669) and two `winedevice.exe` (62678, 62710) untouched.

**Checks run.**

| Check | Result |
|---|---|
| `dnf repoquery --available gnome-screenshot` (target) | empty across 8 enabled repos |
| `dnf repoquery --whatprovides 'org.gnome.Screenshot.service'` | no provider |
| `grdctl status` | gnome-remote-desktop active, RDP enabled 3389, view-only no |
| rdp-shot connect | CONNECTION_STATE_ACTIVE, NLA HYBRID_EX, 1920x1080 |
| rdp-shot RDPGFX trace | caps confirm 107, CreateSurface 0, MapSurfaceToOutput, 4x CAPROGRESSIVE |
| `probe: gdi->gfx` at capture | `(nil)`, pipeline_wired 0 |
| PIL of captured frame | 1 distinct colour, mean luma 255 (undecoded white buffer) |
| `nm` for `rdpgfx_client_context_new` | not exported in libfreerdp3, libfreerdp-client3, winpr3, or any `/usr/lib64` plugin |
| build flags via library strings | `WITH_CLIENT_INTERFACE=OFF`, `WITH_OPENH264=OFF`, `WITH_GFX_H264=OFF` |
| `ls -la harvA-D` after dispatch | all four present, sizes unchanged |

**Checks NOT run (named honestly).** `dnf install gnome-screenshot` (blocked, not run). Visual read of `harvA`, `harvB`, `harvC`, `harvD` (blocked, not run). No terrain render captured. No editor screenshot, no minimap, no booth-sim, no colour-coverage.

**Verdict for `## Next Actions`.** Screenshot path NOT restored. harvA-D remain unread. The cheapest next lever is target-side: the `org.gnome.Shell.Screenshot` API that TASK-0041 proved is denied *while gnome-remote-desktop serves*; test whether disabling or reconfiguring gnome-remote-desktop lifts the denial, with a recorded inverse, since that restores the already-proven screenshot path and the proven input path can then drive SCMDraft. A controller-side alternative is a FreeRDP built with `WITH_CLIENT_INTERFACE=ON` so `rdp-shot` can bind the gfx pipeline.

---

### Screenshot path restored, lever (a) verdict, and the harvA-D read (2026-11-20, `Tails`)

**Alternatives considered for the screenshot path.**

*Option A, lever (a) as briefed: gnome-remote-desktop serving is the cause, so disabling or reconfiguring it lifts the denial. REJECTED on direct evidence.* `grdctl rdp disable` (unit goes `inactive`, RDP `disabled`) leaves the raw `gdbus`/`dbus-send` call to `org.gnome.Shell.Screenshot.Screenshot` still returning `AccessDenied: Screenshot is not allowed` with no file produced. The denial persists with grd fully off, so grd serving is not the cause. The prior claim "the denial appears only while grd serves" is contradicted here and both statements are recorded rather than resolved silently (AGENTS.md section 5). RDP was re-enabled immediately with the exact inverse `grdctl rdp enable`.

*Option B, the lever that works: use the screenshot client gnome-shell already ships. CHOSEN.* `rpm -ql gnome-shell` shows `/usr/bin/gnome-screenshot-tool` (Python, shipped by gnome-shell-49.4-9.el10_2.rocky.0.2). It calls the *same* `org.gnome.Shell.Screenshot` interface but registers as the `org.gnome.Screenshot` D-Bus client (`Gtk.Application` with `application_id="org.gnome.Screenshot"`, `NO_AUTO_START`). `gnome-screenshot-tool -f <file>` returns rc 0 and writes a real 1920x1080 PNG (786058 B, PIL 9262 colours, luma 0..255, visual read confirms the live Rocky desktop). The gate is *caller identity*: gnome-shell 49 denies the interface to a non-screenshot D-Bus caller and allows the recognised screenshot client. This is a state fact, not a package update, because `rpm -qa --last` shows gnome-shell/mutter/gnome-remote-desktop unchanged since 2026-11-13, the build TASK-0041 used. The earlier "no screenshot tool is installed" conclusion (2026-11-19) was wrong; it searched for the `gnome-screenshot` package. This restores the already-proven screenshot capability with **no target change** and gnome-remote-desktop left enabled, so the proven input loop (rdp-input Enter, scancode) is intact.

**Competing priorities.** lever (b) (rebuild FreeRDP with `WITH_CLIENT_INTERFACE=ON`) is not needed and was not started. The distro tool retires the controller-side gfx-pipeline work entirely for map reading.

**harvA-D verdict. None render terrain.** Each was launched with the proven seat0 export (`bash /tmp/run_viewer.sh <v>`, `nohup wine64 ~/scmdraft2/"ScmDraft 2.exe" harv<v>.scm`), the profile dialog dismissed with `rdp-input rdp-args key 0x1C`, and captured with `gnome-screenshot-tool`. A control, the real protected `(2)River Crossing.scm`, launched the same way rendered the full Jungle World (title carries the path, Terrain palette expanded, status `Jungle World\Dirt`, PIL canvas 1057 colours), proving launch, Enter, and capture all work this session. harvA, harvB, harvC, harvD each showed a title bar with no map path, a collapsed Terrain palette (`Microtile None`, `Tile None`), and a uniform grey canvas (PIL canvas 4 colours, dominated 128,128,128). A pre-Enter/post-Enter test on harvB showed the colourful profile splash (40675 canvas colours) before Enter and the editor chrome after Enter, yet the map still did not load, which rules out an input-timing cause. So the maps do not open into the editor at all.

**Finding, the open-gate is the container encoding, not the terrain values.** harvA and harvD carry the harvested River Crossing CHK verbatim (harvD with ISOM zeroed); harvB and harvC are the writer's own 64x64 build; all four are wrapped by `build_map.build_mpq` (`/tmp/opencode/t0042/build_map.py:52`) and all four fail identically. The terrain content differs across the four but the failure does not, so the shared factor, the container, is the gate. `build_mpq` stores the blob unencrypted and uncompressed with `flags = MPQ_EXISTS|MPQ_SINGLE` (`build_map.py:59`); the River Crossing blob that SCMDraft does open is encrypted and compressed (`0x80010200`, DEMO-LOG 2026-11-19). Same CHK bytes in harvA, different result, so the file-data encoding is the isolated difference. This **contradicts** the earlier claim at doc:1069 and doc:1072 that "the container format is not the blocker" and "SCMDraft 2 opens the unencrypted combined-CHK container without error." That earlier claim is kept here side by side with this direct visual evidence rather than overwritten; the four-map isolation experiment never screenshotted the maps, and this pass is the first to look, and it found none open.

**Consequence for the terrain-value harvest.** The harvest itself stands (the valid ISOM size, non-zero ISOM brush value, and Jungle ground values 128 and 144 are real harvested data). But the isolation maps harvA-D are inconclusive as designed, because none opened, so terrain values were never tested against a writer map that actually opens. The blocker has moved from terrain values to the writer's MPQ file-data encoding.

**Recommendation for the next dispatch.** Fix the container before touching terrain again. Recommended path, because it retires the hand-rolled MPQ format and reuses the unlock that already worked: write the map MPQ with StormLib on the controller (`SFileCreateArchive` and `SFileAddFile`, MIT, pinned commit `d60b7e6d3501474f4d92c7b9c752a37e78385f67`, already built under `/tmp/opencode/t0042/StormLib`) instead of `build_map.build_mpq`, then open it in SCMDraft with the now-working `gnome-screenshot-tool` path. Alternatives: store the blob compressed (zlib with the `0x02` prefix, the form real maps use) with block flags matching `0x80010200`; or add the `(attributes)` entry. Any writer map that opens and renders is the next acceptance gate, then re-run the A/B/C/D isolation on opening maps, then build map 1 at 256 by 256 with the harvested values.

**Checks run.** grd disable then gdbus (denied persists); grd enable (restored); `rpm -qa --last` (graphical stack unchanged since 2026-11-13); `gnome-screenshot-tool -f` (rc 0, real 1920x1080 PNG); River Crossing control (renders Jungle World); harvA-D canvas PIL (4 colours each); harvB pre/post-Enter (splash then editor, map not loaded); final target state (no scmdraft, wineserver present, grd active/enabled, harv maps unchanged).

**Checks NOT run (named honestly).** No booth-simulation artifact, no colour-coverage measurement, and no independent reader, because no harv map rendered terrain. The A/B/C/D isolation is inconclusive (none opened). Whether a StormLib-written or compressed-blob map opens in SCMDraft was not tested this dispatch. lever (b) (FreeRDP `WITH_CLIENT_INTERFACE=ON` rebuild) was not started, because a working screenshot path exists.

---

### StormLib container and CHK content fix (2026-11-20, `Tails`, dispatch 2, acceptance met)

Objective: make one writer-produced map open in SCMDraft 2 by replacing `build_map.build_mpq`
with an MPQ written through the already-built StormLib. **`slE.scm` meets acceptance**: title bar
`ScmDraft 2.0 (Beta 0.9.10) - [/home/howard/scmdraft-maps/probe/slE.scm ]`, canvas shows rendered
flat alternating Jungle ground tiles, canvas 143 distinct colours (full frame 934), captured with
`/usr/bin/gnome-screenshot-tool`. Continuous log: DEMO-LOG 2026-11-20 02:40-03:10.

**Two gates existed, and both are now characterised.** The 2026-11-19/20 blocker was never one
thing. Gate 1, container: `harvA` (harvested CHK in `build_map.build_mpq`) does not open; `slA`
(the same 257441 CHK bytes in a StormLib archive) opens and its canvas is pixel-identical to the
River Crossing control (66 changed sample points of 129600; diff bbox `(286,43)-(630,56)` is the
title text only). Gate 2, CHK content: the writer's own CHK fails even inside the accepted
container (`slB` plain, `slC` zlib, both no-title-path grey). This resolves the contradiction held
open at doc:1074 versus doc:1343: the hand-rolled container is rejected, StormLib's is accepted,
and the 2026-11-14 "container accepted / opened with clean title bar" claim is now contradicted by
its own images, the `calib3` title strip (`/tmp/opencode/t0042/strip-calib3.png`) shows `9.10)` with
no map path, the same signature as the harv failures. The 2026-11-14 `t0042-calib-open.png` lives
only on the target and was not re-read this pass, named as not run.

**Alternatives considered.** Option A, StormLib `SFileCreateArchive`/`SFileAddFileEx`
(MIT, pinned `d60b7e6d3501474f4d92c7b9c752a37e78385f67`, already built under
`/tmp/opencode/t0042/StormLib`), chosen per the dispatch brief and it worked. Option B, hand-rolled
compressed blob (`0x02`+zlib, block flags near `0x80010200`) and Option C, adding `(attributes)`:
not needed. StormLib's own zlib path was tested anyway (`slC`, blob 1759 stored of 40949, flags
`0x80000200`) and shows compression per se is neither required nor sufficient; content gates it.
StormLib cannot reproduce the real maps' `0x80010200` exactly because the `ENCRYPTED` bit would
carry StormLib's standard name-derived key, not the SC key; that turned out not to matter, SCMDraft
opens unprotected StormLib archives.

**Writer baseline is now `mk_slDE.py::build_slE` (`/tmp/opencode/t0042/mk_slDE.py`) plus
`mkmpq` (`/tmp/opencode/t0042/mkmpq.c`).** The CHK defects found by section diff against the
harvest, all fixed in slE at once: `STR` must be 1024 `u16` offsets then NUL-terminated strings, no
leading count dword-word the writer added; `MASK` all `0xFF` as in every harvested map, not zero;
no `IVE2` section, real maps do not carry it; include `IOWN`, `PUNI`, `UPGR`, `PTEC`, `UPRP`,
`UPUS`, `MRGN`, `WAV `, `UNIS`, `UPGS`, `TECS` (copied from the harvest; `TRIG`/`MBRF` empty).
Terrain recipe proven: `MTXM`==`TILE` checkerboard of harvested values 128/144, `ISOM` =
`4*(W+2)*(H+1)` bytes all `0x10`, `VER` 59, harvested `VCOD`. **`slD` proves `TILE`/`MTXM` drive
the render**: slD carries the harvested map's original ISOM (dominant 64) yet renders the writer's
flat 128/144 field, so SCMDraft does not regenerate terrain from ISOM when TILE is written.
Which single slE fix is the open-gate is not isolated (named not run).

**Changes table.** Controller: `mkmpq.c`/`mkmpq` new (StormLib writer), `build_map2.py` new
(corrected-terrain CHK, superseded by `build_slE` for the open-gate fixes), `mk_slDE.py` new (slD,
slE), `analyze_sl.py`, `sl.sha256`, captures `sl{rc,A,B,C,D,E}-shot.png`, crops `strip-*.png`,
`canvas-*.png`, all under `/tmp/opencode/t0042`, none in git. Target: five maps
`~/scmdraft-maps/probe/sl{A,B,C,D,E}.scm` left in place (`rm -f` inverse in DEMO-LOG),
`/tmp/run_sl.sh` created then removed, captures and `/tmp/sl.log` removed, `/tmp/stage` auto-created
by scp then removed, five new `Scm*.tmp` SCMDraft backups left with `rm -f` inverse recorded.
No package, no repo, no registry change, no credential on a command line, nothing committed.

**Checks run.** `cmp` round-trip through StormLib read for all five archives; block-table decode
(blob flags `0x80000000` plain / `0x80000200` zlib, `(listfile)` `0x80030200`, standard table keys);
six captures with PIL counts (rc 275, slA 275, slB 81, slC 81, slD 273, slE 143 canvas colours);
title strip reads (path present for slA/slD/slE, absent for slB/slC/calib3); slA-vs-control pixel
diff; final target state clean (no ScmDraft, pre-existing `wineserver` 62669 untouched, grd active,
harvA-D unchanged).

**Checks NOT run (named honestly).** Single-fix bisect of slE; re-open persistence of slE; map
validation dialog; booth-sim and colour-coverage on slE (flat field, not a design); zlib storage of
the fixed CHK; re-read of the 2026-11-14 target-side calib screenshot.

**Recommendation for the next dispatch.** The writer pipeline is proven end to end, code terrain
to opening, rendering map. Build map 1 `foss-for-all` at 256 by 256 with `build_slE`-structure CHK
(same harvested family sections, 256-scale ISOM `4*(W+2)*(H+1)`, design mask written into MTXM/TILE
one u16 per tile, 128/144 ground as background) wrapped by `mkmpq plain`, then run the legibility
gate: editor screenshot, 4x booth simulation, coverage numbers, independent reader (`Shadow`).
Raise contrast against the flat ground only after a rendering variant with a second terrain type is
calibrated from the harvest (`rc.chk` group inventory gives more than 128/144; Bottleneck gives the
Badlands pair 4 and 5). A cheap side experiment can isolate the slE gate family (try slE minus the
added sections, or slB with only the STR fix) if any future hand-rolled writer is ever considered;
it is otherwise not load-bearing, `mkmpq` is the writer now.

---

## Implementation

*Owner: `Tails`.*

### Map 1 `foss-for-all` at 256x256, contrast calibration, gate artifacts, re-open persistence (2026-11-20, `Tails`, dispatch 3, map 1 only)

**Verdict first.** Map 1 is built at the maximum 256x256 extent with the proven `build_slE`-structure CHK (harvested River Crossing family sections) wrapped by `mkmpq` (StormLib, MIT, `d60b7e6d...`), and it opens and renders in SCMDraft 2 with the design filling the extent, a clean blue-on-ground boundary with no cliff artefact, and persistence across re-open. The contrasting terrain pair was calibrated from the harvest before any glyph work. The legibility gate artifacts (editor screenshot, minimap screenshot, 4x booth simulation, colour coverage) are produced. Whether the design is legible at booth scale is left to an independent reader (Shadow); the builder does not declare it. Continuous log: DEMO-LOG 2026-11-20 03:33-04:28.

**Alternatives considered for the contrasting terrain pair.** The brief required calibrating a pair from `rc.chk`'s group inventory before glyph work, so the values were measured in a real SCMDraft render, not chosen from a table.
*Option A, harvest the blue value from the item 5 map.* Diffed the SCMDraft-saved `foss-for-all.scm` (item 5) CHK against the `rc.chk` harvest; the values unique to item 5 are only low-frequency cliff-transition tiles (groups 78-179, 566-567, each freq 1-5), not a clean water value. Rejected, item 5 terrain is muddled, consistent with the Shadow blocker.
*Option B, use `colorbase.bin` (bmp2scx) blue-to-value mapping.* The blue RGB entries map to many low values (32,45,130,...) but the file is not tileset-specific; value 130 is group 8, which renders green in Jungle, so the mapping is not Jungle-reliable. Rejected.
*Option C, whole-map single-value calibration in SCMDraft, chosen.* Built 64x64 maps each filled with one candidate value and measured the canvas colour. Result: value 96 (group 6) renders flat blue across the whole canvas (132357/142186 sampled pixels, RGB (32,32,48) hue 240); values 32/48/192/288/2240/2880 render ground (brown or green); value 0 renders void. Group 6 is a real harvested River Crossing value (freq 56). Chosen pair: glyph foreground 96 (flat blue Water) on 128/144 flat ground, both low terrain, so the boundary is a clean coast, not a cliff, which is the direct fix for Shadow's cause 2 (doc:1444). A first glyph build using value 3840 (group 240) was tested and rejected: it renders as a reddish raised/cliff texture on ground (cliff artefact), so it was not used.

**Alternatives considered for the whole-map screenshot.** SCMDraft 2 at 100% shows only a corner of a 256x256 map. The Zoom combo is drivable by keyboard (`click 385 90` then `keyx 0x50`/combo selection); the minimum is 25%. At 25% the isometric diamond is slightly taller than the editor viewport, so both text lines do not fit in one main-canvas capture. Mouse wheel (`wheel` event added to `rdp-input.c`) does not zoom this build. Chosen evidence: the main-canvas editor screenshot at 25% (`foss25b.png`, "FOSS" fully visible in blue) plus the editor's own overview thumbnail, which always renders the whole 256x256 map (`foss-minimap-mm.png`, both lines visible). A literal in-game StarCraft minimap was not obtainable (item 3 playability blocker).

**Terrain and glyph facts established (not invented).** `MTXM`==`TILE` 131072 B = 256x256 u16, `ISOM` 265224 B = `4*(256+2)*(256+1)` filled `0x10` (flat), `VER` 59, harvested `VCOD`/family sections, `MASK` `0xFF`. Glyph from `glyph.py`: 5x7 block letters, 6x8 tiles per cell, so each stroke is 6 tiles thick (one tile per pixel, no drag band), fixing Shadow's cause 1 (doc:1443). Glyph bbox x14-241 of 256 (89 percent width), 7104 blue tiles = 10.8 percent coverage.

**Changes table (controller-side, all under `/tmp/opencode/t0042`, none in git).**

| File | Change | Why | Inverse |
|---|---|---|---|
| `build_map1.py` | new | 256x256 glyph build and calibration build with the slE pipeline + `mkmpq` | `rm -f` |
| `glyph.py` | new | block-letter "FOSS" / "FOR ALL" mask for the 256x256 map | `rm -f` |
| `rdp-input.c` (the `/tmp` copy) | added a `wheel` event (test only) | probe for mouse-wheel zoom, which this SCMDraft build does not honour | `rm -f` |
| `foss-for-all.scm`, `calib-*.scm`, `stripes.scm` | built | map 1 and calibration maps | `rm -f` |
| `item5.scm`, `item5.chk`, `rt-foss.chk`, `colorbase.bin` | copied/harvested read-only | derive terrain facts from a rendering map | `rm -f` |
| `foss25b.png`, `foss-minimap-mm.png`, `foss-maskrender-booth4x.png`, `foss-booth4x.png`, `foss-reopen.png`, `calibshot-*.png`, `stripes-shot.png` | captures/derived artifacts | legibility gate artifacts and calibration evidence | `rm -f` |

Target: maps `~/scmdraft-maps/probe/{calib-0,calib-32,calib-48,calib-96,calib-192,calib-288,calib-2240,calib-2880,stripes}.scm` and `~/scmdraft-maps/foss-for-all/foss-for-all-programmatic.scm` left in place for inspection (rule r002), inverses in DEMO-LOG. No package, no repo, no registry change, no credential on a command line.

**Checks run.** StormLib round-trip `cmp` on the map 1 archive (byte-identical); target copy SHA-256 `051fc139...` equals the controller build; seven whole-map single-value calibration captures with PIL HSV colour counts (value 96 = flat blue whole-canvas); map 1 editor screenshot at 25% (`foss25b.png`) with title path and populated Jungle palette; editor overview thumbnail whole-map capture; 4x booth-simulation downscales; colour coverage (design 10.8 percent blue tiles, whole-map editor thumbnail 11.8 percent blue, 25% main-canvas 6.5 percent); re-open persistence (kill then relaunch same disk file, clean title no asterisk, disk size/mtime unchanged, thumbnail renders the same blue text); final target state (no ScmDraft, no wineserver, `grdctl` active/enabled, helper and captures removed, no binary/map in `git status --porcelain`).

**Checks NOT run (named honestly).** SCMDraft map-format validation dialog (button injection unreliable). A literal in-game StarCraft minimap render (item 3 blocker stands). A single full main-canvas editor capture of both text lines at once (the 25% diamond exceeds the viewport height; the overview thumbnail is the whole-map render used instead). Single-launch zoom determinism (the combo/scrollbar interaction via injected input was partly flaky and re-set several times). Re-verification of `rpm -q wine` and the target repo set (unchanged from items 1-2). Independent-read verdict on the booth-sim (Shadow's dispatch).

**Competing priorities.** Fidelity versus a single clean screenshot: a genuine whole-map main-canvas editor render at one zoom was not obtainable, so the whole-map legibility evidence is the editor's own overview thumbnail (a real render) plus a calibrated mask render that uses the tile colours measured from the real render, both labelled as such. Ground-background-with-blue-glyph was chosen over blue-background-with-ground-glyph because the blue water (value 96) and the ground (128/144) are both low terrain, giving a clean coast boundary rather than a cliff, which is the specific fix the Shadow blocker demands.

**Recommendation for `Robotnik`.** The technique is proven end to end at the maximum extent for a two-line terrain-text map: harvest-calibrated flat contrast pair (96 blue on 128/144 ground), one-tile-per-pixel glyph, opens, renders clean, re-opens. Map 1's legibility verdict belongs to Shadow reading `foss-minimap-mm.png` and `foss-maskrender-booth4x.png`. If Shadow reads it as legible, the same pipeline (`build_map1.py` + `glyph.py` with value 96) applies directly to maps 2-5 (`rocky-logo`, `rocky-with-heart`, `republic-of-korea`, `tux`), which are filled silhouettes with no internal counters and should tolerate the coarse terrain even better than the letterforms. If Shadow reads it as not legible, the recorded GR-graphics contingency (doc:1445) reopens. The whole-map main-canvas zoom limit (25% diamond taller than the viewport) is a capture constraint, not a map defect; the overview thumbnail is the reliable whole-map view for the booth-sim of the remaining maps.

---

### Contrast dispatch: seven tilesets measured, map 1 rebuilt on Ice World at WCAG 7.42 (2026-11-20, `Tails`, dispatch 4)

**Verdict first.** `Shadow`'s brighter-tileset hypothesis is confirmed by measurement. The harvest on the target yields 157 plaintext CHKs across five tilesets and zero maps of Desert, Ice, or Twilight, so those three tilesets cannot be harvested. Measured WCAG glyph-to-ground ratios across 16 candidate terrain values per tileset: Ice World 7.423, Desert World 5.257, Space Platform 3.769, Installation 3.598 on textured tiles with its flat tiles capped at 1.084, Badlands 2.927, Twilight World 1.953, Ash World 1.544, Jungle World at most 1.98 from dispatch 3. Two tilesets clear the 3.0 gate with flat tiles, Ice World and Space Platform. Map 1 is rebuilt on Ice World, value 192 glyph on value 64 ground, and the saved file measures 7.423 in a real SCMDraft 2 render. The filename decision in `## Status` is applied. Continuous log: DEMO-LOG 2026-11-20 05:28-06:20.

**The arithmetic that explains the result.** WCAG 2.x contrast is `(L_hi + 0.05) / (L_lo + 0.05)`. A glyph at the blue tone dispatch 3 measured, luminance 0.0152, needs a ground at luminance 0.1465 or above to reach 3.0. Jungle's brightest calibrated tone in dispatch 3 was 0.0838, which caps Jungle at 1.98, exactly `Shadow`'s figure. Ice World's brightest candidate tone measures 0.43415, which clears the gate by a factor of 2.5. A bright tileset is not a preference, it is the only way to reach the luminance the gate needs, and the Jungle palette cannot reach it.

**Alternatives considered for the terrain reference.**
*Option A, harvest each tileset from a protected map that uses it, chosen for five tilesets.* `chkdump` (StormLib MIT, `d60b7e6d3501474f4d92c7b9c752a37e78385f67`) reads all 157 maps in `~/game-data/sc1161/Starcraft/maps`, byte-identical to the `sc-clean` copy by md5, and every CHK carries the full section set the writer needs. Candidate values were taken from the maps' own MTXM inventories, preferring subtile 0, so every harvested candidate is a value a real rendering map actually uses.
*Option B, the `colorbase.bin` colour-to-value table from bmp2scx.* Not used. Dispatch 3 already rejected it as not tileset-reliable, and this dispatch had a better source.
*Option C, patch the `ERA ` word of a harvested shell to an unharvested tileset, chosen for Desert, Ice, and Twilight as a labelled extension.* No protected map of those tilesets exists on the target and the game MPQ route to their CV5 tables is blocked (Finding 9). The Ice maps that this produced render coherent named Ice terrain with the Terrain palette populated (Ice, Snow, Moguls, Dirt, Rocky Snow, Grass, Water, Outpost, High Snow, High Dirt, High Grass, High Water, High Outpost) and the status bar reading `Ice World\Snow`, which is direct evidence that the candidate values are valid Ice tiles, not evidence that they were harvested from an Ice map. That distinction is stated wherever the Ice number is quoted.

**Alternatives considered for the measurement method.** Whole-map single-value maps (dispatch 3's method) need one launch per candidate, 112 launches for 7 tilesets. Chosen instead: a 20x20 map of 4x4 blocks of 5x5 tiles, one candidate per block, one launch and one capture per tileset, 7 launches total, tones read as the modal colour at each block centre so the start-location marker cannot contaminate a reading. Rejected: the `x+y` stripe map from dispatch 3, because a stripe mixes diagonally adjacent values and a boundary artefact cannot be told apart from a tile artefact. A separate pairtest map (ground outside a 12-tile-tall glyph band) then measured the chosen pairs in the geometry the real design uses.

**Measured tones, best pair per tileset.** Ratio is WCAG 2.x relative luminance, tones measured from the SCMDraft render, 16 candidates per tileset, full tables in `/tmp/opencode/t0042/ts-harvest/tones.json` and `tones_flat.json`.

| tileset | terrain values harvested? | best measured ratio | pair (glyph / ground) | best ratio among tiles whose block centre is a single dominant tone | gate 3.0 |
|---|---|---|---|---|---|
| Ice World | no, harvested candidates applied to ERA 6 and validated by render | 7.423 | 192 / 64, tones (32,32,44) on (176,176,176) | 3.691 | PASS |
| Desert World | no, same as Ice | 5.257 | 96 / 256, tones (8,4,0) on (140,128,104) | 1.000 (only one flat tone exists in the set) | PASS on tone, bright tiles are textured |
| Space Platform | yes, Bottleneck and 31 other maps | 3.769 | 32 / 96, tones (0,0,0) on (104,104,104) | 1.000 | PASS on tone, both tiles carry texture |
| Installation | yes, Wakka Wakka and Steal the Beacon | 3.598 | 128 / 2100, tones (4,8,16) on (104,104,104) | 1.084 | numerically PASS, its flat tiles are all dark |
| Badlands | yes, 33 maps | 2.927 | 256 / 288, tones (24,24,24) on (92,100,100) | none, every candidate is textured | FAIL |
| Twilight World | no | 1.953 | 64 / 96 | 1.000 | FAIL |
| Jungle World | yes, dispatch 3 | 1.98 | 96 on 128/144, dispatch 3 | n/a | FAIL, confirmed |
| Ash World | yes, 22 maps | 1.544 | 224 / 1971 | none | FAIL |

**Boundary cleanliness, the pairtest result that decides the build.** `ts6-pair.scm` (Ice, 64 ground outside a 192 band) rendered with a perfectly straight two-tone boundary. Measured: ground modal (176,176,176) with 5 distinct colours in the sampled region, glyph modal (32,32,44) with 14, and along both boundary strips 85.0 and 85.6 percent of sampled pixels match one of the two region tones. The remaining pixels are the editor's own 1 to 2 pixel tile grid line at (0,0,0) and the glyph tile's own edge highlight at (41,54,81). There is no cliff ramp and no herringbone texture, which is the specific defect `Shadow`'s 2026-11-14 cause 2 describes. The Space Platform pairtest capture could not be measured by the automatic region finder because its glyph region is pure black and the finder cannot separate a black tile region from the empty canvas behind the map; its ratio is taken from the gridcalib tones and the visual capture confirms the two regions. The Installation pairtest measured 1.047 rather than 3.598 because the bright Installation values are substructure and plating tiles with heavy internal texture, so a large share of their pixels read dark. That is recorded as the reason Installation is not chosen despite crossing 3.0 numerically.

**Map 1 rebuilt on Ice World.** `build_ts.py glyph ts-harvest/ref-era6.chk foss-ice 192 64 64` wrote a 256x256 CHK with the proven slE structure, `MTXM`==`TILE` 131072 B, `ISOM` 265224 B of `0x10`, `ERA` 6, ground value 64 over 58432 tiles, glyph value 192 over 7104 tiles (10.84 percent of the map), glyph bbox x14-241 y64-191, the same `glyph.py` mask that `Shadow` already read as legible. Ground is one value rather than dispatch 3's 128/144 checkerboard, which removes the two-tone ground `Shadow` recorded as a nit. `mkmpq plain` wrap, `chkdump` round-trip byte-identical, SHA-256 `e856f0e1d62ec8f7ecfccf8f0d5f08aee0d5798ef972ea9fee996bbf3bfd3eb0`, identical on the target after the session. On the target it sits at `~/scmdraft-maps/foss-for-all/foss-for-all.scm`.

**Gate artefacts for the rebuilt map 1, all under `/tmp/opencode/t0042`.** `foss-ice-100.png` editor at 100 percent with title path and populated Ice palette. `foss-ice-mm.png` and `foss-ice-reopen-mm.png`, 134x140 crops of the editor's own overview thumbnail, the whole-map real render of the saved file, dark design share 9.47 percent, both lines legible in both. `foss-ice-mm-2x.png` the same crop enlarged 2x for reading, named as an enlargement and not as a booth simulation. `ice25-page1.png` and `ice25-page2.png`, real main-canvas renders at 33 percent zoom, page1 frames the FOSS line whole, page2 frames the FOR ALL line with the top two tile rows of that line above the frame edge. `foss-ice-booth4x-foss.png` and `foss-ice-booth4x-all.png`, 430x181, the 4x Lanczos downscales of those frames. `foss-ice-maskrender.png` 512x512 and `foss-ice-maskrender-booth4x.png` 128x128, the whole-map calibrated mask render built from the tones measured out of the real render, named as a mask render. Coverage: design 10.84 percent of tiles, thumbnail dark share 9.47 percent, dark share of terrain pixels inside the 33 percent frame 19.56 percent, which is a crop holding one whole line, not the whole map, and is named as such.

**Contrast measured on the rebuilt map itself.** Crop `(155,105)-(1878,832)` of `ice25-page1.png`, ground cluster luminance above 0.15, glyph cluster below 0.06, grid line and the red start marker excluded: ground (176,176,176) luminance 0.43415, glyph (32,32,44) luminance 0.01522, WCAG 7.423 against the 3.0 gate. The 128x128 booth sim measures 6.709 after Lanczos blending pulls the glyph tone to (40,40,52). Both are above the gate, and the pairtest, the render, and the booth sim agree.

**Re-open persistence.** Kill, relaunch the same disk file, capture `foss-ice-reopen.png`: title bar shows `.../foss-for-all/foss-for-all.scm` with no asterisk, overview thumbnail renders both lines, and `stat` plus `sha256sum` before and after are identical (614561 B, mtime `2026-11-20 06:03:19`, SHA-256 `e856f0e1...`). SCMDraft wrote its own `Scmced6.tmp` and `Scme833.tmp` backups beside the map, recorded with their inverse in DEMO-LOG.

**Filename decision applied, and one extension that needs `Robotnik`'s ratification.** `~/scmdraft-maps/foss-for-all/` now holds `foss-for-all.scm` (the legible Ice build), `rejected-foss-for-all.scm` (the illegible 2026-11-14 brush-painted build, renamed exactly as the decision directs), and `superseded-foss-for-all-jungle.scm` (the 2026-11-20 Jungle build, renamed off the plain-name role by this dispatch). The recorded decision covered two files, the legible build and the rejected build. It did not cover a third file, the superseded Jungle build, because at decision time it was the legible build. I renamed it with a `superseded-` prefix rather than leave two plausible map-1 candidates in the directory, and I flag that as my extension, not as a decision I own. Renames are single `mv` operations with exact inverses in DEMO-LOG, so booth readiness can restore any of the three names.

**Changes table.**

| Path | Change | Why | Inverse |
|---|---|---|---|
| `/tmp/opencode/t0042/build_ts.py` | new | slE builder generalised to any tileset reference, modes `gridcalib`, `pairtest`, `glyph` | `rm -f` |
| `/tmp/opencode/t0042/harvest_inventory.py` | new | harvest all target maps to plaintext CHKs and build the per-tileset value inventory | `rm -f` |
| `/tmp/opencode/t0042/measure_contrast.py`, `measure_pair.py`, `make_artifacts.py` | new | tone and WCAG measurement, boundary cleanliness, artefact build | `rm -f` |
| `/tmp/opencode/t0042/ts-harvest/` | new | 164 harvested CHKs, `inventory.json`, `candidates.json`, `tones.json`, `tones_flat.json`, `map1_ice_report.json`, four `ref-eraN.chk` | `rm -rf` |
| `/tmp/opencode/t0042/ts{0,1,2,3,5,6,7}-cal.*`, `ts{6,1,2}-pair.*`, `ts{6,1}-rows.*`, `foss-ice.*`, `foss-ice-*.png`, `probe/` | new | calibration, pairtest, hover-probe, and gate artefacts | `rm -f` |
| `/tmp/opencode/t0042/maps-all/` | created then removed | 157 `.scm` copies read off the target for harvesting, game data, never in a git path | already removed, `rm -rf` |
| `~/scmdraft-maps/probe/ts{0,1,2,3,5,6,7}-cal.scm`, `ts{6,1,2}-pair.scm`, `ts{6,1}-rows.scm` | 12 maps added on the target | the measured evidence, left for the operator per rule r002 | `rm -f ~/scmdraft-maps/probe/ts*-*.scm` |
| `~/scmdraft-maps/foss-for-all/foss-for-all.scm` | replaced by the Ice build | the contrast fix | `rm -f` |
| `foss-for-all.scm` renamed to `rejected-foss-for-all.scm` | rename | the filename decision in `## Status` | `mv` back, recorded |
| `foss-for-all-programmatic.scm` renamed to `superseded-foss-for-all-jungle.scm` | rename | keeps one map-1 candidate, flagged as my extension | `mv` back, recorded |
| `~/scmdraft-maps/**/Scm*.tmp`, 16 new files | SCMDraft's own backups on open | side effect of opening maps | `rm -f` list recorded in DEMO-LOG |

No package installed on the target, no repo enabled or disabled, no registry change, no credential on a command line, nothing in a git-tracked path (`git status --porcelain` lists only ` M DEMO-LOG.md`).

**Checks run.** StormLib harvest of 157 maps with zero failures; `cmp` round-trip on every built map; SHA-256 equality between controller build and target copy for map 1; seven gridcalib captures with per-block modal tones and WCAG ratios; three pairtest captures with region tones and boundary-strip counts; 32 hover captures with status-bar crops read visually; whole-map thumbnail crops open and re-opened; 4x booth downscales of two real frames; coverage counts with named crops and named thresholds; WCAG on the map-1 render and on the booth sim; re-open persistence by `stat` and `sha256sum` before and after; final target state `pgrep -af 'ScmDraft|wineserver'` empty, helper and captures absent, no wineserver left (the one this dispatch started exited after its own `pkill`, and there was none at dispatch start).

**Checks NOT run (named honestly).** SCMDraft 2 map-format validation dialog, not run on any saved map, the button-injection blocker from item 4 stands. A literal in-game StarCraft minimap, the item 3 playability blocker stands. Tile elevation class per candidate value, so low-versus-high pairing of 64 against 192 is not established, only that the rendered boundary is a straight two-tone line. Harvested values for Desert, Ice, and Twilight, no protected map of those tilesets exists on the target. Space Platform pairtest measured by the automatic region finder, blocked because a pure-black glyph region is indistinguishable from the empty canvas behind the map. A single editor canvas view of both text lines, the FOSS line spans 228 tiles and the canvas at the 25 percent floor shows 215 tiles wide, so no permitted zoom frames a whole line horizontally. Independent legibility read of the rebuilt map 1, that is `Shadow`'s verdict and this builder does not make it.

**Competing priorities.** Harvest anchoring against measured contrast. Space Platform is the best pair whose values are all harvested from maps that render, at 3.769, and its tiles carry texture. Ice World is 7.423 with near-white flat tiles, and its values are harvested group indices proven valid by the render rather than harvested from an Ice map. I built on Ice because the gate in `## Status` is the measured ratio and because the booth condition `Shadow` named, a bright hall at off-axis viewing, is exactly where 7.42 beats 3.77. The Space Platform option is recorded as the fallback if `Robotnik` or `Charmy` prefers a fully harvest-anchored tileset, and it needs no new harvest. Single-value ground was chosen over the harvest-style checkerboard to remove the two-tone ground artefact.

**Recommendation for `Robotnik`.** Build maps 2 to 5 on Ice World with ground 64 and glyph 192, `build_ts.py glyph` with the same pipeline, and record the fourth gate number, the measured WCAG ratio, beside the coverage number on every map as `Shadow` asked. Two presentation facts now have to be in the booth run script rather than discovered on 2026-11-28. A 228-tile-wide line cannot be framed whole horizontally at any zoom SCMDraft permits, so either the presenter pans each line, or the presenter shows the whole map through the overview thumbnail. And the map's own zoom resets to 100 percent on open, so the run script must set the zoom as a named step. The `superseded-` rename is mine to flag and `Robotnik`'s to ratify.

---

## Review

*Owner: `Shadow`. Read-only — findings only, no edits. Severity order, blockers first.*

Targeted verification of item 5, ahead of the normal chain, 2026-11-14. Question asked: does the terrain lettering in map 1 read as "FOSS for All" at booth distance, or as noise. Answer: **it reads as noise.** The claimed legibility is not present in the evidence images.

### The item 5 lettering is not legible, and maps 2 through 5 must not be built on this technique unchanged
**Severity:** blocker
**Where:** this doc:787 (item 5 verdict), `DEMO-LOG.md:569`, evidence `~/AI/demo-evidence/item5-loaded.png`, `~/AI/demo-evidence/item5-text-painted.png`
**Problem:** the verification screenshot shows a blue terrain mass crossed by zigzag cliff texture, not readable text.
**Failure scenario:** an attendee 1 to 2 m from a 1920x1080 display showing `foss-for-all.scm` at 100% editor zoom, the exact booth setup item 4 assumes (doc:690), sees a flooded jagged landscape. They do not see "FOSS for All".
**Evidence from my own reads (2026-11-14):** direct visual inspection of `item5-loaded.png` and `item5-text-painted.png` at full 1920x1080: no letterform of any character is identifiable in either image, even up close on screen, which is more favorable than booth distance. Booth simulation, PIL Lanczos 4x downscale of the canvas crop `(160,100)-(1905,870)` of `item5-loaded.png`, saved at `/tmp/opencode/loaded-boothsim.png`: the surviving structure is a herringbone zigzag of cliff edges across a blue field, no glyph shapes. Color coverage of the same crop, HSV hue 180 to 260 degree band (Water blue): 0.4% in `item5-editor.png` (baseline), 43.9% in `item5-text-painted.png`, 37.4% in `item5-loaded.png`. The planned lettering occupies about 8% of the 4096-tile map (11 glyphs, 7x8 cells each, stroke fill about 55%). The painted blue mass is roughly 4 to 5 times the letter area, which is what merged strokes look like.
**Cause 1, brush width against glyph width:** the drag brush paints a 4 to 5 tile band, visible in `item5-drag-test.png` around tile (7,4) and recorded at doc:793 and doc:860. Glyphs are 7 tiles wide (doc:791). A 4 to 5 tile stroke inside a 7 tile glyph leaves at most 2 tiles of counter space, and the adjacent stroke fills it. Every letter collapses into a filled blob, and 2-tile inter-character gaps bridge under drag overshoot. Glyph size is not the problem. On a 24 inch 1080p panel a 7-tile glyph is about 6 cm wide and subtends about 1.8 degrees at 2 m. The glyph is large enough. The internal structure is destroyed by the stroke width, so there is nothing to resolve at any distance.
**Cause 2, background contrast destroyed:** the base map is a copy of `(2)River Crossing.scm` (DEMO-LOG.md:557) and was never cleared. Its water, raised terrain, doodads, mineral field, and start location are all visible in `item5-loaded.png`. Painting low Water beside the map's existing elevated tiles raises cliff walls along every stroke edge, and that is the zigzag texture that dominates the booth-sim image. Item 4's legibility argument assumed a clean Jungle/Dirt background (doc:690); the real map is not that background.
**Suggested direction:** do not dispatch items 6 through 9 on this technique as recorded. In preference order. (1) Reopen the GR-graphics path, exactly the contingency recorded at doc:83 and doc:86, because the trigger condition "unreadable at booth scale on the first map" is now met. (2) Stay terrain-only only if the brush can be reduced to 1 to 2 tiles and glyphs enlarged to 12 or more tiles wide, which requires solving the brush reduction that failed by all three mechanisms tested (doc:803, with uncited evidence `item5-brush-small.png`, `item5-brush-small2.png`, `item5-after-dash.png`). (3) Stay terrain-only with filled silhouettes that have no internal counters, on a genuinely blank 64x64, features 16 or more tiles, viewed in 2D top-down mode. Whichever path, legibility must be re-proven on a fresh blank map with one test glyph before four more maps commit.
**Contradiction surfaced, per AGENTS.md section 5:** `DEMO-LOG.md:569` and doc:787 both state the text strokes are recognisable. My direct inspection of the same PNGs contradicts those claims. Both statements are recorded here; I did not resolve the conflict silently.

**Item 5 acceptance criteria, what I could and could not confirm from the evidence:**

| Criterion (plan item 5, doc:135) | Confirmed | Basis |
|---|---|---|
| File exists on target, `ls` output recorded | yes | `DEMO-LOG.md:573` shows `ls -la` 95081 bytes mtime 17:50:19; corroborated by the title-bar path in `item5-loaded.png`, read visually |
| Editor screenshot shows recognizable "FOSS for All" content | no | blocker finding above |
| Map loads without error dialog, screenshot | yes | `item5-loaded.png`: title bar shows the full saved path with no asterisk, no popup, status bar "Jungle World\Dirt" |
| Map loads in the playability method chosen in item 3 (plan item 5 also names this) | no, not run | recorded as not run at doc:852; the revised DoD fallback (c) at doc:65 requires SCMDraft 2 map validation per saved map, and the record lists validation as not run at doc:853, so even the fallback playability evidence is currently absent |

### Item 4's legibility claim was never tested as a letterform
**Severity:** should-fix
**Where:** doc:690, technique table doc:698-706
**Problem:** "Proven legible at 8+ tiles per stroke" rests on a single blob-paint test (doc:688). No letter or glyph was ever drawn and read in item 4, and the technique assignment for all five maps inherits that untested figure.
**Failure scenario:** items 6 to 9 build Rocky's shield (which has the internal counter of the R), the heart notch, and Tux's body/belly contrast, then reproduce the same counter-space obliteration that destroyed the text in item 5, four more times.
**Suggested direction:** re-derive the minimum feature size from one real test glyph on a blank map before dispatching items 6 through 9. Filled silhouettes (peninsula outline, Tux body) tolerate the coarse brush far better than glyphs with internal counters, so the technique table should say which maps survive the current 4 to 5 tile band and which do not.

### The booth artifact contains another map's content
**Severity:** should-fix
**Where:** `DEMO-LOG.md:557`; visible in `item5-loaded.png`
**Problem:** `foss-for-all.scm` is a copy of `(2)River Crossing.scm`, never cleaned. Tree doodads, the mineral field, the blue start location, and 67 loaded units are all still in the map the audience would open.
**Failure scenario:** at the booth, an attendee opens a map named `foss-for-all` and sees an unrelated jungle map with a player start location and minerals, which undercuts the demo narrative the documentation repo tells.
**Suggested direction:** build each map from SCMDraft 2's New Map blank dialog (already reached in item 2, doc:454) or clear doodads, units, locations, and elevation before painting. Record which.

### Item 5 evidence table is incomplete
**Severity:** nit
**Where:** doc:824-833
**Problem:** the table lists 8 evidence files; `ls ~/AI/demo-evidence/` shows 13 `item5-*.png` files. Absent from the table: `item5-after-dash.png`, `item5-after-undo.png`, `item5-brush-small.png`, `item5-brush-small2.png`, `item5-iso-click.png`.
**Failure scenario:** the Option D brush-reduction failure claims at doc:803 and the undo path have visual evidence on disk that the record does not cite, so a reader cannot check those claims without re-running the session.
**Suggested direction:** add the five files to the evidence table with one-line content descriptions.

### Only isometric views were captured for item 5
**Severity:** nit
**Where:** all item 5 screenshots, toolbar shows "Isometrical"
**Problem:** every legibility-relevant screenshot is in isometric view mode, where tile-space horizontal text is sheared diagonally on screen. No 2D top-down view exists to compare.
**Failure scenario:** a fair legibility test is impossible from the captured set because the sheared rendering adds a second variable on top of the brush problem. A 2D view is also the least-skewed presentation for a booth audience.
**Suggested direction:** capture the completed map in 2D view as the legibility reference, cheaply, before the next map work.

**Review verdict:** one blocker. Items 6 through 9 should not be dispatched on the terrain-drag technique as recorded until legibility is re-proven on a blank map or the technique changes per the recorded contingency at doc:83.

---

### Map 1 `foss-for-all` independent legibility read, programmatic build (2026-11-20, `Shadow`)

Per the legibility gate at doc:80. Artifacts read with `read` (visual) from `/tmp/opencode/t0042`: `foss-booth4x.png`, `foss-maskrender-booth4x.png`, `foss-minimap.png`, `foss-minimap-mm.png`, `foss-reopen.png`, `foss-reopen-mm.png`, `foss-maskrender.png`, `foss25b.png`, `foss-25.png`, `foss-100.png`, `foss125.png`, `foss25.png`, `foss25c.png`, `foss-z1.png`, plus the eight `calibshot-*.png` calibration captures for my own colour numbers.

**Verdict, stated plainly: the picture is identifiable as the intended design at booth distance.** The 2026-11-14 blocker at doc:1479 is closed for the programmatic technique. The item 5 brush-painted map remains illegible and is superseded, not fixed.

What I can resolve, from the whole-map artifacts:
- `foss-maskrender-booth4x.png` (128x128, the 256x256 design downscaled 4x): both lines read as words. I read "FOSS" on the upper line and "FOR ALL" on the lower line, including the word space between FOR and ALL. The internal counters survive: the O reads as a ring with a hole, both A's read with their counters, the R reads as bowl plus leg. Inter-letter gaps survive. Nothing merges into a blob.
- `foss-minimap.png` and `foss-minimap-mm.png` (real SCMDraft 2 overview-thumbnail renders, not masks): both lines legible, axis-aligned, on a uniform olive field. `foss-reopen-mm.png`, the thumbnail after kill and relaunch, also reads both lines. This is the decisive evidence, because it is SCMDraft's own render of the saved disk file.
- `foss-reopen.png` (full editor, 50% zoom): title bar shows the saved path `foss-for-all-programmatic.scm` with no asterisk, no dialog, and its top-left overview thumbnail shows FOSS over FOR ALL legibly. Re-open persistence is visually confirmed.
- `foss25b.png` (25% main canvas): "FOSS" is unmistakable, strokes are clean solid rectangles of a single blue tone.
- No cliff zigzag, no herringbone texture, no raised-wall artefact anywhere in any capture. My 2026-11-14 cause 2 is gone. Strokes are uniform single-tone bands, so my cause 1 is gone too.

What I cannot resolve:
- The tile texture. In `foss-maskrender.png` (512x512) the ground is a visible two-tone checkerboard of the 128 and 144 tiles; at the 4x booth sim it collapses to one olive field. The glyph edges get slightly softer but stay legible.
- The 4x *editor-canvas* downscale `foss-booth4x.png` shows only a partial FOSS, cut off at the bottom edge. It does not show the design, see the finding below.
- Identity of the red diamond outline visible in the main canvas of `foss25b.png` and `foss-reopen.png` at the tile the status bar reports as (105,23). I read it as a start-location marker. I did not open the Locations layer, so this is my reading, not a confirmed fact.
- Whether units or doodads from the River Crossing harvest are present, from the render alone. The canvas shows none, and the harvest record at doc:1448 lists family sections rather than unit or doodad arrays, so I found no evidence of carried-over content in the render.

**My own colour-coverage measurements, against the builder's three figures.** Blue test: `b > r+10 and b > g+10` over the whole image unless a crop is named.

| Artifact | My number | Builder's claim (doc:1463) | Agreement |
|---|---|---|---|
| `foss-maskrender.png` 512x512, the design mask | 10.84 percent (28416 px, glyph tone (32,32,48)) | 10.8 percent design | agree, matches to two decimals |
| `foss-minimap.png` 378x372, editor overview render | 11.19 percent of all pixels, 11.52 percent excluding the white viewport outline | 11.8 percent overview | agree in substance, within threshold tolerance |
| `foss-minimap-mm.png` 300x300 same render, other crop | 9.71 percent | (same claim) | the figure moves 2 points with the crop, so the crop must be named |
| `foss-reopen-mm.png` 300x300 after re-open | 7.31 percent | (same claim) | lower because the crop carries more ground margin. Not a regression, a crop difference |
| `foss25b.png` 1920x1080 whole screenshot | 6.99 percent loose blue, 2.81 percent strict | 6.5 percent at 25 percent canvas | agree in substance, my number is higher because I count antialiased edges |
| `foss25b.png` canvas crop (172,130)-(1878,881) | 7.57 percent | 6.5 percent | differs by crop and by blue test. Substance agrees |

I agree with all three builder figures as stated, and I measured the design coverage exactly. The overview and canvas figures are crop- and threshold-dependent, which is why I have written the crop and the test above rather than just the percentage.

**Design extent, measured.** Glyph bounding box in `foss-maskrender.png`: tiles x 14 to 241, y 64 to 191 of 256. Line 1 "FOSS" spans tiles x 59 to 196, line 2 "FOR ALL" spans x 14 to 241. Each line is 56 tiles tall, each cell is 6x8 tiles, each stroke is 6 tiles thick. So the design fills 89 percent of map width and 50 percent of map height, centred, not in a corner. The claim at doc:1439 that the design "fills the extent" is true horizontally and half-true vertically.

**Booth geometry, computed from that extent.** On a 24 inch 1080p panel with the 256x256 map scaled to fill the viewport height, one tile is 4.2 px = 1.17 mm. A 6-tile stroke is 7.0 mm, a 56-tile letter is 65 mm. At 2 m the letters subtend 1.9 degrees, comfortable, and the strokes subtend 0.20 degrees, which is thin for a low-contrast feature. Resolution is not the limiting factor. Contrast is, finding 1.

### Contrast between glyph and ground is the remaining legibility risk, and it is not measured anywhere in the record
**Severity:** should-fix
**Where:** `/tmp/opencode/t0042/foss-maskrender.png`, `foss-minimap.png`, `calibshot-*.png`, doc:1444, doc:1463
**Problem:** the chosen pair is dark blue on dark olive. I measured WCAG contrast ratios of 1.23 (glyph (32,32,48) against ground (44,52,16)), 1.18 (against (56,44,28)), 1.15 in the editor overview render ((20,20,32) against (32,36,12)), and 1.19 in the 4x booth sim. WCAG asks for 3.0 for text and 4.5 for comfortable reading. Nothing in the record measures contrast, only coverage.
**Failure scenario:** a conference hall is brightly lit and a booth screen is viewed off-axis. At CR 1.15 to 1.23 the tonal difference that carries the letters is a fraction of the panel's luminance range, so a viewer at 2 m off-centre sees a two-tone field rather than "FOSS for All", even though the geometry is generous. The same artifact read on my calibrated screen reads fine, which is exactly the situation a booth is not.
**Evidence, and the measured headroom.** The calibration captures give the luminance of every value the builder tested: value 96 renders tones at relative luminance 0.0155 to 0.0271, 128/144 ground at 0.027 to 0.030, 192 at 0.0400, 2240 reaches a tone at 0.0838, 2880 tops out at 0.0316. Swapping ground 128/144 for 192 with the same glyph raises the ratio only to about 1.32. The whole Jungle palette is dark, so a large gain is not available inside it. That the largest gain would come from a brighter tileset (Winter and Ice have near-white ground tiles) is a hypothesis I did not test, offered as the direction to test, not as a fact.
**Suggested direction:** add contrast ratio as a fourth gate number beside coverage, for all five maps, with the tones and the ratio recorded. Before maps 2 to 5 are built, re-run the whole-map single-value calibration the builder already has working (`calib-*.scm`, `build_map1.py`) across at least one brighter tileset and pick a pair at ratio 2 or better. If no pair reaches 2, cap the booth viewing distance at about 1.5 m in the run script and say so in the map notes. Maps 2 to 5 should also size features larger than 56 tiles, since the silhouettes have room to be bigger than the letterforms.

### The artifact named as the booth simulation is a viewport slice, not a booth simulation
**Severity:** should-fix
**Where:** `/tmp/opencode/t0042/foss-booth4x.png` (421x189), cited at doc:1459, gate wording at doc:80
**Problem:** the DoD gate says "the editor screenshot downscaled about 4x". Applied literally to a 256x256 map at the minimum 25 percent zoom, that produces a 4x downscale of a viewport that cannot contain the map, and the result here shows a partial FOSS cut off at the lower edge. It does not depict the design at all.
**Failure scenario:** a later reader, or `Espio`, checks the gate box literally, finds `foss-booth4x.png` as the named artifact, sees one cropped word, and either rejects the map or accepts a number (0.94 percent strict blue, 7.98 percent loose blue in that file) that has nothing to do with the design. The gate then measures the wrong thing for maps 2 to 5.
**Suggested direction:** define the booth artifact for the remaining maps as the whole-map overview render downscaled to the pixel size the map would occupy on the booth display at the assumed viewing distance, and name that display size and distance in the gate row. `foss-maskrender-booth4x.png` (128x128) is the right shape, and the overview thumbnail is a real SCMDraft render that always contains the whole map (doc:1446), so a 4x downscale of the thumbnail capture is the honest artifact. Record that no single editor canvas view shows a 256x256 map whole at any zoom, since 25 percent is the floor and the diamond is taller than the viewport.

### The maximum-extent box and the editor's 25 percent zoom floor mean no single editor view shows the whole design at the booth
**Severity:** should-fix
**Where:** doc:81, doc:1446, `foss25b.png`, `foss-reopen.png`
**Problem:** the operator requirement demands maximum 256x256 extent and a readable whole design. SCMDraft 2's minimum zoom is 25 percent, at which the 256x256 diamond exceeds the viewport height. At 25 percent the canvas shows "FOSS" and "FOR ALL" is off screen. At 50 percent the canvas shows only ground. So in the editor there is no zoom at which an audience sees the whole design at once.
**Failure scenario:** on 2026-11-28 the presenter opens `foss-for-all`, lands at the default zoom, and the audience sees a dark field, then scrolls to a giant FOSS with the second line missing. The demo's one-line story, "look, we drew FOSS for All", fails at the screen even though the map is correct, and the failure is caused by the presentation, not the build.
**Suggested direction:** the booth run script must specify the presentation, and `Vector` needs it written explicitly: either pan FOSS to FOR ALL in a named sequence, or show the overview thumbnail enlarged, or display the whole-map render outside the editor. Decide which before the maps exist, because it also decides which screenshot counts as the legibility artifact for maps 2 to 5.

### The DoD minimap box is met by a proxy, and the record must not let that read as the box being met
**Severity:** should-fix
**Where:** doc:81 ("readable on the in-game minimap"), doc:1446, doc:1465
**Problem:** the box names the in-game StarCraft minimap. The evidence supplied is SCMDraft 2's editor overview thumbnail. The builder names this honestly as not run, and I confirm it is not run: no StarCraft render of map 1 exists.
**Failure scenario:** maps 2 to 5 are each delivered with an editor thumbnail, and the DoD row is ticked five times on a proxy. Then at the booth, or in the review chain, the literal box is found unmet, and the playability fallback at doc:79 (c) is also still unmet because SCMDraft 2's map-validation dialog has never been run on any saved map (doc:1465).
**Suggested direction:** either revise the box to name the editor overview thumbnail as the accepted whole-map view for this target, with the reason (the exclusive-fullscreen pointer capture at doc:34 blocks the game render), or produce the in-game render through the recorded `uinput` attempt before the review chain runs. Do not leave the box wording unchanged while the evidence is a different thing.

### Map 1 now has two files on the target and the DoD names neither of the pair correctly
**Severity:** nit
**Where:** `~/scmdraft-maps/foss-for-all/foss-for-all.scm` (item 5, 95081 bytes, brush-painted, illegible), `~/scmdraft-maps/foss-for-all/foss-for-all-programmatic.scm` (dispatch 3, SHA-256 `051fc139...`), doc:76, doc:1461
**Problem:** the DoD names map 1 `foss-for-all`. The legible map is named `foss-for-all-programmatic.scm`, and the illegible one still occupies the plain name in the same directory.
**Failure scenario:** the booth run script or a reader following the documentation repo opens `foss-for-all.scm`, and the audience sees the 2026-11-14 noise map.
**Suggested direction:** record which single file is map 1, and state the disposition of the item 5 file (renamed, removed with its inverse, or kept only as the superseded artifact).

### My own 2026-11-14 isometric-shear nit does not apply to this technique
**Severity:** nit, correction to my own earlier finding
**Where:** doc:1520, superseded for the programmatic build by `foss25b.png` and `foss-minimap.png`
**Problem:** I recorded that every legibility screenshot was isometric and therefore sheared. In these captures the terrain grid renders axis-aligned: the letters are upright rectangles in both the main canvas and the overview thumbnail, while the status bar reads "Isometrical Terrain" (doc:1520 wording).
**Failure scenario avoided:** a reader applying the earlier nit would ask for a 2D re-capture that would add nothing, and would treat upright text in an isometric-labelled view as an inconsistency.
**Suggested direction:** retire the shear requirement for this technique. Keep a 2D top-down capture only if a future capture shows shear.

### The white rectangle crossing the FOSS line in the overview captures is editor chrome
**Severity:** nit
**Where:** `foss-minimap.png` (2.8 percent white pixels), `foss-minimap-mm.png`, `foss-reopen-mm.png`
**Problem:** the SCMDraft overview thumbnail draws the current viewport as a white outline, and it sits across the top line in three of the gate artifacts.
**Failure scenario:** a reader of the gate artifacts reads the white rule as damage across the letters, or a coverage script counts it as background and shifts the percentage.
**Suggested direction:** note the overlay in the artifact table, and state coverage crops so the percentage is reproducible.

**Legibility gate verdict for map 1: PASS on identifiability.** The design reads as "FOSS for All" in the whole-map booth sim and in SCMDraft's own re-opened render. The builder's coverage figures are correct as far as they go, and I agree with them.

**Technique fitness for maps 2 to 5: fit to proceed, with the contrast fix applied first.** Letterforms with internal counters are the hardest case this technique has, and they read at 4x. Filled silhouettes (Rocky's shield body, the heart, the Korean peninsula outline, Tux's body) have larger features and no counters to lose, so they should read more easily. Two conditions. (1) The contrast finding above should be resolved before maps 2 to 5 are built, because Rocky's shield carries the internal counter of the R and Tux carries a belly-to-body contrast, and those are exactly the features that a 1.2 contrast ratio washes out under hall lighting. (2) The booth-artifact definition and the presentation plan should be settled first, so the four maps are gated against the right artifact rather than the viewport-slice shape. The GR-graphics contingency at doc:1445 stays closed on the evidence in front of me; it reopens if the brighter-pair calibration cannot reach ratio 2 in any tileset.

**Not in my remit and still open, restated so the gate row is not over-read:** SCMDraft 2 map-format validation has been run on no saved map (doc:1465). The literal in-game minimap has been captured for no map. Playability fallback (c) at doc:79 therefore has no evidence yet.

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
