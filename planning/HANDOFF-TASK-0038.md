# TASK-0038 session-resume prompt (2026-10-29)

How to use: start a fresh `robotnik` session in `/home/howard/AI/projects/team-chaotix`
(opencode must be launched from this directory) and paste everything from the "Resume brief"
below as the first message. This file is disposable once the session is resumed; the planning
doc is the durable record.

## Resume brief

You are Robotnik, project manager for Team Chaotix. Continue TASK-0038 (Cinnamon for Rocky 10:
System Settings launch + icon, icon parity vs Fedora 45 baseline). Read ONLY `## Status` and
`## Next Actions` of `planning/docs/TASK-0038-cinnamon-gpg-settings-icons.md` (never the whole
doc) and continue per `## Next Actions`. One subagent at a time, strictly sequential. The
operator is actively engaged: report state in replies, never ask questions, never wait on an
answer; durable state goes into `## Status`.

### Active thread: reference-VM SSH access

- VM `Fedora-45-Cinnamon-AI`, system-level (`sudo virsh`), running, IP 192.168.1.181 (bridged on
  `virbr0`, host LAN 192.168.1.0/24), MAC `52:54:00:cd:cd:79`, disk
  `/var/lib/libvirt/images/Fedora-45-Cinnamon-AI.qcow2`, user `howard`, password in
  `~/AI/secrets/pass.txt` (mode 644, never echo it).
- Host keypair `~/.ssh/id_ed25519` / `.pub` exists; the public key is NOT installed on the VM.
  `sshpass` is installed on the host.
- Latest evidence (2026-10-29, this session): host sshd is active on 0.0.0.0:22 (that is the
  host machine itself, not the VM); `192.168.1.181:22` is still `Connection refused` (probe:
  `timeout 5 ssh -o ConnectTimeout=4 -o BatchMode=yes howard@192.168.1.181 'echo VM-SSH-OK'`).
  The VM's own sshd is not listening. The block stands.
- Next moves, in order:
  1. Probe guest agent:
     `sudo virsh qemu-agent-command Fedora-45-Cinnamon-AI '{"execute":"guest-exec","arguments":{"path":["systemctl"],"arg":["status","sshd"],"capture-output":true}}'`
  2. If `guest-exec` is enabled: run `systemctl start sshd` in-guest, check firewalld, re-probe
     port 22.
  3. If `guest-exec` is disabled or sshd cannot be started: record an operator hand-off in
     `## Status` (operator must start sshd on the VM from its console; the operator previously
     had console access and already disabled lock/screensaver).
  4. Once port 22 opens: install the public key idempotently (`grep -qxF` guard, via sshpass if
     password auth is the only path), then verify passwordless
     `ssh howard@192.168.1.181`.
  5. Record VM access in `## Status` (IP 192.168.1.181, system-level, virbr0/LAN bridged,
     key-based access; note `pass.txt` mode 644).
- Then dispatch Tails per `## Next Actions`: plan item 6 (enumerate icon differences from the
  two screenshot sets), then item 7 (root-cause the System Settings launch; check the host VM
  state first per the recorded caveat).

### VM inventory (verified; do not re-derive)

- User-level (user `howard` via virtqemud):
  - `Rocky_Linux_10_Cinnamon` — restored from the
    `/home/howard/AI/setup-backup/2026-10-20-host-reinstall/` backup, boots to the Cinnamon GDM
    login, guest agent live, VNC 127.0.0.1:5901.
  - `Fedora_45_Cinnamon_Howards` — locked Cinnamon session, accepted as the baseline as-is,
    guest agent live, VNC 127.0.0.1:5900.
- System-level (`sudo virsh`): `Fedora-45-Cinnamon-AI` (above). Note: `sudo systemctl
  is-active libvirtd` reports inactive even though the system VM is listed; use `sudo virsh`
  directly for system-level inspection.
- Recorded limitation, already in `## Status`: user-level libvirt cannot do host-to-guest SSH
  (no CAP_NET_ADMIN). Do not re-derive it.

### Key paths

- Planning doc: `planning/docs/TASK-0038-cinnamon-gpg-settings-icons.md`
- Project: `~/Linux/projects/cinnamon-for-rocky10/` (expected git state 62 M / 3 D / 15 ??,
  verified by Tails)
- Restore screenshots: `/tmp/opencode/task38/vm-restore/` (`rocky-boot-1.png`,
  `fedora-state-1.png`)
- Icon-parity shots: `~/Linux/projects/cinnamon-for-rocky10/screenshots/rl10/2026-10-24/` and
  `~/Linux/projects/cinnamon-for-rocky10/screenshots/f45-beta/2026-10-24/`
- Rollback snapshot: `/home/howard/snapshots/TASK-0038/` (+ `rpms.sha256`)
- Backup source: `/home/howard/AI/setup-backup/2026-10-20-host-reinstall/` (SHA256SUMS verified)
- Secret: `~/AI/secrets/pass.txt` (mode 644; never echo or commit)

### Standing requirements

- Big's verification must use the "Cinnamon / desktop RPM projects" layer in
  `.opencode/agents/big.md` (line 87+): GPG fresh-consumer install (`gpgcheck=1` full published
  set), per-RPM `rpm -K`, icon parity against the reference desktop, feature parity against the
  reference desktop.
- Task sequence after VM access works: Tails items 6, 7, 8, 9 → Knuckles item 10 (republish, tag
  `v1.0.1`) → Big items 11 + 12 → review chain Shadow → Omega → Big → Charmy → Flicky → Vector
  item 14 → Knuckles item 15.
- Never echo secret values. Record the command and its output as evidence for every claim.
  Never re-derive anything already recorded in the planning doc.
