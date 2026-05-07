---
applyTo: "plugins/godot-dotnet/**"
description: "Use when working on Godot/.NET architecture guidance, skills, evals, reviews, or governance artifacts that must preserve Domain, Application, Presentation, infrastructure, and AI-governance boundaries."
---
# Architecture Boundaries

Apply these rules when authoring or reviewing Godot/.NET guidance in this repository.

## Domain / Application / Presentation

- Domain must not depend on Godot `Node`, `Control`, `SceneTree`, `Resource`, `Signal`, or engine lifecycle APIs.
- Application owns use-case orchestration and returns application results, DTOs, or decisions.
- Presentation adapts user input and application outputs to engine or UI surfaces.
- Presenter / Mediator / Controller must not become the owner of gameplay or battle rules.
- Infrastructure concerns must not be smuggled into Domain as a convenience shortcut.

## Repo-layer governance

- Always classify the problem into the correct layer before proposing a fix.
- Do not use a skill to compensate for a deterministic policy gap.
- Do not use hooks to replace reasoning that belongs in skills, prompts, or review workflows.
- When editing governance artifacts, preserve human approval gates and closeout traceability.

## Eval and documentation expectations

- Architecture-boundary evals should check for wrong-layer leakage, not just wording quality.
- Skill-routing evals should distinguish the right specialist path from adjacent but weaker routes.
- Hook-policy evals should verify allow / ask / deny behavior explicitly.

## Review cues

- Is domain logic leaking into engine-facing code?
- Is application orchestration being bypassed?
- Is presentation state being mistaken for domain state?
- Is a governance rule being weakened without explicit review?
- Is the proposed fix in the wrong layer?
