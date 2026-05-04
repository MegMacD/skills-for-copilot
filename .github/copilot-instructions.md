# Agentive Skills for Copilot

This repository uses Agentive workflow skills adapted for VS Code Copilot instructions.

## How to use

When planning or implementing work, explicitly request one of these workflows in chat:

- "Use the spec skill"
- "Use the domain skill"
- "Use the slice skill"
- "Use the tdd skill"
- "Use the holistic skill"
- "Use the architect skill"
- "Use the qa skill"

The full instructions are in `.github/instructions/*.instructions.md`.

## Working agreement

- Prefer domain language from `docs/UBIQUITOUS_LANGUAGE.md` when present.
- Respect bounded contexts and contracts from `docs/CONTEXT_MAP.md` and `docs/contexts/*/CONTEXT.md`.
- Prefer vertical slices and tracer-bullet delivery.
- Use pragmatic TDD: test core logic and boundaries, keep UI/glue testing proportional.