# Copilot Instructions

## docs map

README.md
.github/
├── copilot-instructions.md
plugins/
├── game-development/
|   └── README.md
├── godot-dotnet/
|   └── README.md
evals/
├── README.md
tests/
└── README.md

## Skill checks and execution process (The Rule)

- Confirm a repo-specific skill has been created
  - it is up to date, and it has a checklist if applicable.
  - **Self improvement** is the point of the skill review process, so if there is no skill for the task, create one before proceeding.
- Always perform the skill check first, then respond or execute.
- If there is even a 1% chance of applicability, load the corresponding `SKILL.md` first.
- If a skill has a checklist, convert it to a todo and complete each item.
- After completing the task, reply with:
  - Which skills were exercised
  - Ideas for skill self-improvement (if any)
  - Evaluation of the skill check process and how it could be improved (if any)
  - Suggestions for next steps or next phase (if any)

## Benchmark portability rule

For reusable benchmark agents and benchmark skills, treat [`benchmark-core`](./skills/benchmark-core/) as the shared framework owner.

- prefer capability names over concrete skill names or asset paths
- prefer active corpus discovery and corpus adapters over hardcoded corpus paths
- prefer document roles over fixed file paths
- keep templates, examples, and working skeletons in the skill layer

If the current repo has one concrete corpus implementation, document it in repo-local corpus adapters rather than baking repo-specific paths into reusable benchmark components.

## Layered skills repo contract

Source of truth:

- [`../layered-skills-vscode-model.md`](../layered-skills-vscode-model.md)

Repository default mapping:

- **Layer 0** → repo-level instructions and hooks
- **Layer 1** → foundation skills
- **Layer 2** → shared-runtime skills
- **Layer 3** → custom agents and real orchestration
- **Layer 4** → plugin-scoped overlay skills and agents

Working rules:

- treat plugins as packaging and discovery surfaces, not execution graphs
- treat `depends_on` as documentation unless backed by an explicit orchestration path
- promote true delegation, context isolation, and multi-role synthesis to custom agents
- do not let Layer 2 redefine Layer 1 semantics
- do not let Layer 4 overlays silently rewrite lower-layer meanings
