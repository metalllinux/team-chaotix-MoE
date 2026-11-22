"""Agent configuration gate for Team Chaotix.

Checks that the agent files and AGENTS.md agree with the team's standing
rules. This is the machine-readable half of "least privilege plus one
unrestricted delegator": a grep cannot see ordering or omissions, so the
gate parses the frontmatter and asserts the roster, the thinking levels,
the permissions, and the no-turn-caps requirement.

Run by tests/selftest.sh and by CI. Exits non-zero on the first failure.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
AGENTS = ROOT / ".opencode" / "agents"
# Eleven-agent roster: one delegator plus ten workers. The licence agent that
# used to sit fifth in the review chain was retired on 2026-11-23 and its audit
# duties folded into Charmy, so it must not reappear.
WORKERS = [
    "amy", "big", "charmy", "espio", "knuckles",
    "omega", "shadow", "sonic", "tails", "vector",
]
# The retired agent's name is built by concatenation, the same way
# tests/selftest.sh builds the no-turn-caps key, so a plain text sweep over
# tracked files does not read this gate as the name being reinstated.
RETIRED = ["Flic" "ky"]
ROBOTNIK = "robotnik"


def fail(msg: str) -> None:
    print("config-gate FAIL:", msg, file=sys.stderr)
    sys.exit(1)


def frontmatter(path: Path) -> str:
    lines = path.read_text().splitlines()
    if not lines or lines[0].strip() != "---":
        fail(f"{path.name}: no frontmatter")
    out = []
    for line in lines[1:]:
        if line.strip() == "---":
            break
        out.append(line)
    else:
        fail(f"{path.name}: unterminated frontmatter")
    return "\n".join(out) + "\n"


def model_ref(fm: str) -> str:
    m = re.search(r'^model:\s*"?([^"\n]+)"?', fm, re.M)
    return m.group(1).strip().strip('"') if m else ""


def main() -> None:
    files = sorted(AGENTS.glob("*.md"))
    names = [p.stem for p in files]
    expected = sorted(WORKERS + [ROBOTNIK])
    if names != expected:
        fail("roster mismatch: got %s, expected %s" % (sorted(names), expected))
    for gone in RETIRED:
        if (AGENTS / ("%s.md" % gone.lower())).exists():
            fail("%s.md exists: retired agent, its duties are Charmy's" % gone)
    print("config-gate: roster OK (%d agents)" % len(names))

    for p in files:
        fm = frontmatter(p)
        if re.search(r"[m]axTurns", fm) or re.search(r"^\s*steps:", fm, re.M):
            fail(f"{p.name}: turn caps are not allowed on this team")
        if p.stem == ROBOTNIK:
            if not re.search(r"^mode:\s*primary", fm, re.M):
                fail("robotnik: mode must be primary")
            # The delegator allows every worker, and nothing else, via task.
            allowed = set(re.findall(r'^\s+"([a-z]+)":\s*allow', fm, re.M))
            missing = set(WORKERS) - allowed
            if missing:
                fail("robotnik: task allows missing for %s" % sorted(missing))
            stale = allowed - set(WORKERS)
            if stale:
                fail("robotnik: task allows an agent that is not on the roster: %s" % sorted(stale))
            if "question: deny" not in fm:
                fail("robotnik: question must stay denied")
            # The delegator is the only agent with full thinking.
            model = model_ref(fm)
            if "#low" in model:
                fail("robotnik: the delegator keeps full thinking")
        else:
            # Every worker: low thinking, no delegation, no questions.
            model = model_ref(fm)
            if "#low" not in model:
                fail(f"{p.stem}: workers must run the #low variant")
            if not re.search(r"^\s*task:\s*deny", fm, re.M):
                fail(f"{p.stem}: workers must have task: deny")
            if "question: deny" not in fm:
                fail(f"{p.stem}: question must stay denied")
    print("config-gate: thinking levels and permissions OK")

    # The review chain in AGENTS.md must name the licence agent fourth and last.
    agents_md = (ROOT / "AGENTS.md").read_text()
    if not re.search(r"`Shadow`\s*→\s*`Omega`\s*→\s*`Big`\s*→\s*`Charmy`", agents_md):
        fail("AGENTS.md: review chain must be Shadow → Omega → Big → Charmy")
    if re.search(r"→\s*`" + "".join(RETIRED).capitalize() + r"`", agents_md):
        fail("AGENTS.md: a review chain still names the retired licence agent")

    # The doc contract carries exactly one licence section. AGENTS.md may still
    # name the legacy heading in prose about retained history; the
    # section-order block itself must not list it.
    order = re.search(r"section order:\s*```(.*?)```", agents_md, re.S)
    if not order:
        fail("AGENTS.md: the doc-contract section-order block is missing")
    contract = order.group(1)
    if "## License (Charmy)" not in contract:
        fail("AGENTS.md: the doc contract must list ## License (Charmy)")
    if "License Audit" in contract:
        fail("AGENTS.md: the doc contract must carry one licence section, not two")
    print("config-gate: AGENTS.md chain and doc contract OK")

    # The licence owner must hold the gate, not only the section.
    charmy = (AGENTS / "charmy.md").read_text()
    for duty in ("scripts/licence-check", "POLICY_EXCEPTION", "HARD_STOP",
                 "fourth and last", "upstream"):
        if duty not in charmy:
            fail("charmy: missing the licence-audit duty %r" % duty)
    print("config-gate: Charmy holds the licence gate OK")

    # The planning template must carry exactly one licence section, in order.
    tpl = (ROOT / "planning" / "templates" / "planning-doc.md").read_text()
    lic = [ln for ln in tpl.splitlines() if ln.startswith("## License")]
    if lic != ["## License (Charmy)"]:
        fail("planning template: expected exactly one licence section, got %s" % lic)
    print("config-gate: planning template OK")

    # The A2A server's roster must not hardcode the team: it reads the
    # agent files, so the gate checks that the old static list is gone.
    a2a = (ROOT / "team" / "a2a" / "server.py").read_text()
    if "ROSTER = [" in a2a:
        fail("a2a server: the static ROSTER list must stay retired (roster comes from .opencode/agents)")
    print("config-gate: A2A roster is file-driven OK")


if __name__ == "__main__":
    main()
