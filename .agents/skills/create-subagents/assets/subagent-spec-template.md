# Subagent Spec Template

Use this template when documenting each subagent or specialist role.

Keep it concrete.
If a field cannot be filled crisply, the role boundary probably needs revision.

---

## `<subagent-name>`

- **Role:**
- **Purpose:**

- **Responsibilities:**
  -

  -
  -

- **Non-goals:**
  -

  -
- **Trigger:**

- **Inputs:**
  -

  -

- **Outputs:**
  -

  -

- **Completion criteria:**
  -

  -

- **Allowed tools:**
  -

  -

- **Forbidden tools:**
  -

  -
- **Context in:**
  - Full pass-through:
  - Summary only:
  - Do not pass:
- **Context out:**
  - Canonical outputs:
  - Summary back to coordinator:
  - Local-only scratch work:
- **Memory policy:**
  - Can read history:
  - Can write shared state:
  - Durable memory:
  - Ephemeral task state:
  - Isolation required:
- **Permissions:**
  - Risk level:
  - Approval gate needed:
- **Model tier:**
  - Recommended tier:
  - Can use cheaper model:
- **Runtime packaging notes:**
  - File format / location:
  - Invocation controls:
  - Runtime-enforced tool or permission settings:
- **Preloaded skills:**
- **Optional skills:**
- **Orchestration contract:**
  - agent-as-tool / handoff target / workflow node / critic / coordinator / remote specialist candidate
- **Risks:**

---

## Design notes

Use this template to surface boundary mistakes early.
Common warning signs:

- responsibilities and non-goals overlap with another role
- trigger is vague
- inputs or outputs are informal instead of explicit
- the role gets more tools than it needs
- context policy says "everything"
- no completion criteria are defined
