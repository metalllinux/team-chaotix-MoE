# Third-party repos and packages on the demo target

**Context.** TASK-0041 needs `freerdp` (controller-side RDP client) and `tesseract` plus
`python3-pillow` (controller-side OCR). TASK-0042 will need `wine` or a Proton runtime on the target,
and `wine` is not in the target's enabled repos (`baseos`, `appstream`, `extras`). Enabling a
third-party repo on the target is a system change on the machine the audience watches, and the task
record says it must be recorded before it happens. Today neither task needs it. Evidence, 2026-11-13,
`dnf repoquery -q --available` run on both machines: `freerdp` (3.10.3-12.el10_2, 3.32.2-1.el10_2) and
`tesseract` (5.3.4-11.el10_2) resolve from already-enabled repos on the target and on the controller.
`ydotool`, `wtype`, `dotool`, `grim`, `xdotool` and `python3-evdev` resolve nowhere, not in Rocky 10
baseos, appstream, CRB or EPEL10. The controller already has `crb` and `epel` enabled plus a local
`cinnamon-rocky10` repo. The target has only the three Red Hat repos.

**Options.**

1. **No new repos anywhere.** Install only what already resolves (`freerdp`, `tesseract`,
   `tesseract-langpack-eng`, `python3-pillow`). Trade-off: TASK-0042's `wine` question stays open, and
   any uinput input tool must be built from source.
2. **Enable EPEL10 on the target.** Signed by Fedora, standard on RHEL-family, and it does *not* carry
   `wine`, `ydotool`, `wtype` or `xdotool` on `el10_2` (tested). Trade-off: a new repo for no package
   this task needs. Pure cost.
3. **Enable CRB on the target.** Official Rocky repo, no third-party trust. It does not carry the input
   tools either (tested via the controller, which has CRB enabled). Trade-off: cheap to enable, still
   does not solve the input-tool or `wine` need.
4. **Enable RPM Fusion or negativo16 on the target.** Those are where `wine` usually lives on
   RHEL-family. Trade-off: third-party, not signed by Rocky, higher trust and update-interaction cost,
   and it is TASK-0042's decision rather than this one.

**Recommendation.** Option 1 for TASK-0041, and the policy it records for TASK-0042: enable a repo only
when a named package that resolves nowhere else is required, the package NEVRA and repo id are written
into the planning doc before the `dnf install`, the enablement command and its inverse are recorded in
`DEMO-LOG.md`, and no repo is enabled "for convenience" or pre-emptively. TASK-0041 installs nothing
third-party and enables nothing on the target. If `wine` cannot be satisfied without a third-party repo
(and the evidence so far says it cannot), TASK-0042 records that decision separately, including which
repo, whose signing key, and what the enablement costs the machine.

**Consequences.** TASK-0041's target-side footprint is limited to `gnome-remote-desktop` configuration
and a firewalld rule, both already installed or built-in, so a target-side package rollback is never
needed for this task. The uinput fallback for input (option 1's cost) means a source build on the target
if the RDP path fails, which is a bigger system change than an RPM and is gated behind the input-path
decision doc. Licences: installing RPMs from a distro repo adds runtime dependencies, not vendored code,
so the house licence gate (`scripts/licence-check`) sees no new imported code in this repo, and any
script we adopt from upstream into `scripts/remote/` must be recorded with its upstream repo and ref by
Charmy and Flicky (AGENTS section 9). The distinction is recorded here so it is not re-argued later.

**Reversibility.** Cheap and independent. Disabling a repo is `dnf config-manager --set-disabled
<repo>`; removing an installed package is `dnf remove <nevra>`. Nothing in this decision is one-way.
The one-way side effect lives in the other decision doc, which is about credentials and an open port.
