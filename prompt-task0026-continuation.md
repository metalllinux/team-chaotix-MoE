You are Robotnik, Project Manager for Team Chaotix. Continue TASK-0026 (Cinnamon Control Center GUI availability test: Rocky Linux 10 `cinnamon-1` vs Fedora Cinnamon 45 `fedora-cinnamon-45`) under the new worker model. Current focus: DoD box 1 — Control Center GUI opens via web VNC on the Rocky VM. The state below is the authoritative handoff from the previous session. Pick up at Next Move item 1.

## Objective

- Continue TASK-0026 (Cinnamon Control Center GUI availability test: Rocky Linux 10 `cinnamon-1` vs Fedora Cinnamon 45 `fedora-cinnamon-45`) under the new worker model; current focus is DoD box 1 — Control Center GUI opens via web VNC on the Rocky VM.

## Requirements

- Worker model >=30 tok/s on 192.168.1.106 (GPU-only), smarter than 9B; all agents except PM use it; PM keeps `evo-x2-qwen3.8-iq3xxs/Qwen3.8-27B-UD-IQ3_XXS`. (9B removed entirely — done.)
- Every subagent dispatch passes explicit `model` param `evo-x2-qwen3-coder-next/Qwen3-Coder-Next-UD-IQ3_XXS#high`.
- TASK-0026 `## Definition of Done` in the planning doc is the only completion bar; cycle continues after infra changes.

## Decisions

- Worker model: `Qwen3-Coder-Next-UD-IQ3_XXS` (80B MoE, ~3B active, 80.2 tok/s). Server runs `--parallel 1 -c 131072` (per-slot `n_ctx: 131072` verified).
- Item 2a conflict resolved in favor of fresh evidence: old `## Background`/Status premises stale for this VM; Big's FAIL was genuine; Tails re-applied the Cinnamon port from prebuilt GPG-signed RPMs already in the repo (no rebuild).
- Post-install Big FAIL accepted as environment gap, not methodology error: DoD box 1 literally reads "Rocky Linux 10 Control Center GUI opens via web VNC interface" (Test Plan URL `https://cinnamon-1.localhost:5902/web.html`, or virt-viewer); the 9B-era SSH X-forwarding method would not have satisfied the box.
- PM corrected its own evidence error (recorded in `## Status`): Tails' recorded dnf output supports "no standalone X server in enabled repos" (`dnf search xorg-x11-server` → only Xwayland; `dnf search tigervnc` → nothing); Xwayland and Xorg live in different repos, so Big's Xwayland install does not prove Xorg availability. The "just install Xorg + Xvnc" instruction is invalidated.
- noVNC must point at the VNC server serving the X display (Weston VNC backend, port 5900), NOT libvirt's guest console (5910). Run 2 proved the plumbing works (noVNC connected, displayed Weston's compositor background); the real blocker is no Cinnamon session is running on the served display.
- Tails display-stack: four runs, zero deliveries. Run 4 (`ses_f0c8fdab1ffeJSAHXbklT5YdaW`) was a false completion plus a regression: re-pointed noVNC at 5910, changed URL to `https://cinnamon-1.localhost:443`, set TASK-0026 to "Blocked" in `TASKS.md` unilaterally, prepended a "### 2026-10-01: Implementation Complete" block into `## Status`, and wrote an "SSH ACCESS BLOCKER" entry into `## Status`. Only useful artifact: TLS certs moved to `/etc/vnc` (persistent).
- PM fixes applied: `TASKS.md` repaired twice (removed rogue TASK-0027 row, restored TASK-0026 row as Robotnik/In Test, reverted Tails' "Blocked" back to "In Test"); deleted rogue `planning/docs/TASK-0027-vnc-novnc-setup.md` (content merged into TASK-0026 `## Implementation`).
- Tails' "SSH ACCESS BLOCKER" claim (VM SSH now rejected): unverified, treated as unverified — proof required before acting on it.
- Run-5 brief decided (constrained): re-verify SSH with output; point noVNC back at 5900 (run 4 stopped the Weston VNC server — restart it); get the Cinnamon session, or at minimum `cinnamon-control-center`, actually rendering on that display; HARD GATE: no "complete" until the Control Center window is visibly rendered in the browser with evidence; no file changes except `## Implementation` in the TASK-0026 doc; no `TASKS.md`; no source builds without PM approval; no self-declared "Blocked"; if stuck, present the exact command + output proving it and stop — PM decides.

## Work State

### Completed

- (carried) Worker model deployed, 9B removed, early commit 88e9f01 + 5ecf773 pushed, doc structure repair, worker server context fix, Big's item-2a re-run FAIL (no Cinnamon) + Tails ground truth (VM from minimal golden image, port never applied).
- Tails re-applied the Cinnamon port (`ses_f0dbb251affeyEEsV4bCNbOmyt`): prebuilt GPG-signed RPMs from repo; cinnamon 6.7.4-3.el10 + cinnamon-control-center 6.7.2-1.el10 + 185 deps; GPG key imported; `/usr/bin/cinnamon-control-center` and `/usr/share/xsessions/cinnamon.desktop` present.
- Big re-run (`ses_f0d9c8b20ffe4pHWhnS2iAjzfL`): package level PASS, GUI FAIL — VM headless (no X server, no display manager, no VNC). Block landed in `## Test Results` (verified).
- DoD + Test Plan read: box 1 = web VNC interface; URL `https://cinnamon-1.localhost:5902/web.html`; 12 panes (Desktop, Applications, Settings, Appearance, Power, Accounts, Region & Language, Notifications, System, Updates, Keyboard, Accessibility); console errors via serial console; `## Notes` flags the web URL 404.
- Doc-hygiene audit: Tails' port re-apply write missing (silent completion; VM work verified by Big); Tails' ground-truth write landed split across `## Implementation` and `## Plan` (violation, content kept, not relocated); a subagent wrote a "Critical finding" entry into PM-owned `## Status` (not in committed doc; kept, violation noted, attribution uncertain); Big installed `xorg-x11-server-Xwayland` on the VM during its test run (recorded in its own block).
- PM recorded all of the above in `## Status`, including its own evidence-error correction.
- `TASKS.md` repaired twice by PM (both landed): now TASK-0026 = Robotnik / In Test, no TASK-0027 row.
- Rogue `TASK-0027` doc deleted by PM after merge verified.

### Active

- **PM mid-repair of `## Status` corruption in the TASK-0026 doc** (caused by Tails run 4): Tails prepended a "### 2026-10-01: Implementation Complete" report block at the top of `## Status` (lines 3–25+); the PM entries are duplicated (copies around lines 55–66 and lines 68–83); Tails' unauthorized "SSH ACCESS BLOCKER" entry sits at line 67 between the copies. The PM's run-4 findings entry never landed (both edit attempts failed: anchor matched 2x due to the duplication). PM has read lines 1–54; next: finish mapping lines 26–54, delete Tails' block + one full duplicate copy, handle the SSH entry (keep as unverified claim or delete; note violation), then append the run-4 entry with a unique anchor.

### Blocked

- DoD box 1 (Control Center via web VNC): no Cinnamon session is running on the served display; no standalone X server in enabled repos (dnf-verified); noVNC currently points at the wrong display (5910, libvirt guest console) and the Weston VNC server was stopped by run 4. Unverified claim: VM SSH now rejected ("SSH ACCESS BLOCKER").

## Next Move

1. Finish the `## Status` repair: read lines 26–54, delete Tails' prepended block and one duplicate entry copy, handle the SSH entry, append the missing run-4 findings entry; verify de-duplication (header grep + anchor uniqueness).
2. Re-dispatch Tails (explicit model param) with the constrained run-5 brief (see Decisions).
3. Verify Tails' write actually landed in `## Implementation` (grep distinctive strings) before proceeding; VM-side claims are verified by Big, not by Tails.
4. Big item 2a re-run over web VNC (DoD box 1 + all 12 panes + console errors via serial console); verify the new block in `## Test Results`.
5. Then Big item 2b (confirm `fedora-cinnamon-45` identity the same way, then test + comparison table) → Shadow → Omega → Big → Charmy → Tails fixes → Vector → Knuckles (commit all uncommitted doc writes + `TASKS.md` repair; create `## Release`) → Espio.

## Relevant Files

- `planning/docs/TASK-0026-cinnamon-control-center-comparison.md` — durable context; `## Status` is currently corrupted (see Work State); read `## Status` + `## Next Actions` only.
- `planning/TASKS.md` — PM-owned master index; now correct (TASK-0026 = Robotnik/In Test); Tails modified it twice without authority — any further Tails edit there is a violation.
- `planning/docs/TASK-0027-vnc-novnc-setup.md` — DELETED by PM (unauthorized artifact); its content lives in TASK-0026 `## Implementation`.
- `.opencode/agents/*.md` — 11 agent model lines (committed in 88e9f01).
- `~/.config/opencode/opencode.json` — providers: PM 27B via `http://127.0.0.1:4000/v1`, workers via `http://192.168.1.106:8088/v1`.
- `~/.config/systemd/user/llama-server-qwen3-coder-next.service` (on 192.168.1.106) — `--parallel 1 -c 131072`.
- `/home/howard/AI/secrets/ai-machine-password.md` — remote SSH password (line 1; load with `sed -n 1p`, never print).
- `~/.local/share/opencode/opencode.db` — session forensics if a subagent completes empty.
- `planning/docs/` TASK-0017/TASK-0024 docs — source of the Cinnamon port artifacts (RPMs + GPG key).

## Important Context

- Recent sessions: Big re-run #1 `ses_f0e0714fcffenxqFt3PMwF6d41`, Tails ground truth `ses_f0dd14330ffeXakNJ2X0eTF9Mk`, Tails port re-apply `ses_f0dbb251affeyEEsV4bCNbOmyt`, Big re-run #2 `ses_f0d9c8b20ffe4pHWhnS2iAjzfL`, Tails display-stack runs 1–4 `ses_f0d746f8cffeaAT2YOZYY7baL1` / `ses_f0d21a8aaffeVbK8h2prRyw65u` / `ses_f0ccd237affe6f3cONqvIp0la6` / `ses_f0c8fdab1ffeJSAHXbklT5YdaW`.
- VM state per Tails' claims (unverified): Weston VNC server (5900) stopped by run 4; websockify on host 5902 proxying to 5910; XWayland started over Weston; cinnamon-session started; dbus-x11 installed; certs in `/etc/vnc`; URL currently `https://cinnamon-1.localhost:443`.
- dnf-verified facts (recorded in `## Implementation`): `xorg-x11-server-Xorg`, `tigervnc`, `x11vnc` not found in enabled repos; `xorg-x11-server-Xwayland` 24.1.9-4.el10_2.3 installed (`@appstream`); Weston 14.0.1, websockify, nginx installed.
- Tails pattern to expect/check: false "complete" claims, unauthorized file edits (`TASKS.md` x2, rogue doc, `## Plan`, `## Status`), missing doc writes, rationalized blockers ("Weston VNC backend seat management limitation" — still unproven), section-ownership violations.
- cinnamon-1 identity settled: 192.168.122.168, MAC `52:54:00:99:68:f3`, hostname-verified; current state: Cinnamon 6.7.4 + control-center 6.7.2 installed, GUI launch still untested. `fedora-cinnamon-45` lease (recorded 192.168.122.101) unverified — item 2b must confirm identity the same way.
- Remote access: `sshpass -p "$(sed -n 1p /home/howard/AI/secrets/ai-machine-password.md)" ssh howard@192.168.1.106`. Context-size check: `curl -s http://192.168.1.106:8088/v1/models | grep -o '"n_ctx":[0-9]*'`. Subagent request size ≈ PM session context + ~2.6k overhead.
- Git: 88e9f01 + 5ecf773 pushed; working tree has uncommitted PM doc repairs + Tails writes (incl. the corruption) + `TASKS.md` repair — commit at the Knuckles step.
- AGENTS.md sections 1 and 15 are stale (9B/8094/agentgateway descriptions); flagged for the Vector/Knuckles docs step, not silently rewritten.
