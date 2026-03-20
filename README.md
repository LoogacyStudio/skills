# Loogacy Agent Skills

This repository contains Loogacy's curated set of reusable **Agent Skills** for coding agents working on **Godot 4.6**, **.NET 10**, and **C#** projects.

For information about the Agent Skills standard, see [agentskills.io](https://agentskills.io/).

> [!NOTE]
> This is **not** a runtime gameplay library or a NuGet package.
> It is a version-controlled repository of reusable agent instructions, references, and templates.

## What's Included

| Skill                                           | Description                                                                                                                                                                                 |
| :---------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [`create-reusable-skill`](.agents/skills/create-reusable-skill/) | Creates or upgrades reusable agent skills by selecting the right skill pattern, generating the minimum useful file structure, drafting `SKILL.md`, and validating the result before returning it. |

## Target Stack

These skills are intended for agent-assisted workflows around:

- **Godot 4.6**
- **.NET 10**
- **C#**

Typical scenarios include:

- Godot gameplay and systems programming
- Godot editor tooling and pipeline support
- C# architecture and code review workflows
- reusable project conventions for agent-driven development

## Repository Layout

```text
.agents/
└── skills/
    └── create-reusable-skill/
        ├── SKILL.md
        ├── assets/
        │   ├── intake-questionnaire.md
        │   ├── review-template.md
        │   └── skill-template.md
        └── references/
            ├── pattern-decision-guide.md
            └── skill-review-checklist.md
```

Each skill typically uses:

- `SKILL.md` for the main operating instructions
- `references/` for reusable guidance and checklists
- `assets/` for templates, examples, and intake material

## Using These Skills

This repository is currently intended to be consumed **directly from source**.

1. Make this repository available to your coding agent.
2. Ensure the agent can discover files under `.agents/skills/`.
3. Invoke or reference the relevant skill when working on a compatible task.
4. Add new skills under `.agents/skills/<skill-name>/` using the same structure.

If your agent platform supports workspace or repository-based skill discovery, this layout should fit naturally. No marketing smoke, no mystery sauce.

## Design Principles

- Keep skills narrowly scoped and reusable.
- Make descriptions trigger-oriented.
- Prefer concrete, ordered workflows.
- Keep validation criteria observable.
- Move bulky reference material out of `SKILL.md` when possible.
- Avoid unsupported runtime assumptions.

## Contributing

When adding or updating skills:

- prefer small, composable skills over oversized all-in-one instructions,
- keep `SKILL.md` focused on operation and flow,
- place reusable rules in `references/`,
- place templates and examples in `assets/`.

## License

See [LICENSE](LICENSE) for details.
