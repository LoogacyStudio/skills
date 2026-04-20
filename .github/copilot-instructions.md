# Copilot Instructions

## docs map

README.md
.github/
├── copilot-instructions.md
plugins/
├── godot-dotnet/
|   └── README.md   
evals/
├── README.md
tests/
└── README.md

## User clarification preference

When clarification is genuinely needed in VS Code, **prefer `vscode/askQuestions` first**.

- batch related questions
- ask only the highest-signal questions
- prefer concrete choices over open-ended brainstorming
- stop asking once the core decision is clear enough to proceed safely

If `vscode/askQuestions` is unavailable, use brief normal chat questions instead.

## Skill checks and execution process (The Rule)

- Always perform the skill check first, then respond or execute.
- If there is even a 1% chance of applicability, load the corresponding `SKILL.md` first.
- When multiple skills run in parallel, process first, then implementation/domain.
- If a skill has a checklist, convert it to a todo and complete each item.
- If a patch context mismatch happens while editing customization files, reload the current files and switch to smaller single-file patches.
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
