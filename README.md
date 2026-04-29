# Agentive Skills

General-purpose workflow skills for AI-assisted software development. Built for [Claude Code](https://claude.ai/code), but the ideas apply anywhere.

These skills encode a **Domain-Driven Design workflow for building with AI** — shared language, clear boundaries, documented contracts. They help you and your AI maintain a coherent mental model of your system as it grows.

## The Workflow

```
/spec  →  /domain  →  /slice  →  /tdd  →  update docs
 define    stress-test   break into   implement    keep the model
 what      against the   vertical     each slice   current
 to build  domain model  slices       test-first
```

Each skill works standalone, but they're designed to flow together. Use what you need.

## Skills

| Skill | Command | What it does |
|-------|---------|-------------|
| **[Spec](spec/)** | `/spec` | Interview → feature spec grounded in your domain model and ubiquitous language |
| **[Domain](domain/)** | `/domain` | Stress-test a plan against your domain model. Surfaces contradictions, updates docs inline |
| **[Slice](slice/)** | `/slice` | Break a spec into vertical tracer-bullet slices. Each cuts through all layers end-to-end |
| **[TDD](tdd/)** | `/tdd` | Implement a slice using pragmatic test-driven development. Test-first for core logic, implementation-first for UI |
| **[Holistic](holistic/)** | `/holistic` | Zoom out. Map how code fits the bigger picture — bounded contexts, data flow, hidden dependencies |
| **[Architect](architect/)** | `/architect` | Surface architectural friction and design deep module interfaces using parallel exploration |
| **[QA](qa/)** | `/qa` | Describe bugs conversationally → durable GitHub issues written in domain language |

## Installation

### Quick install (recommended)

```bash
npx skills add AgentiveStack/skills
```

This uses the [Skills CLI](https://github.com/vercel-labs/skills) to automatically install all skills into your Claude Code setup.

### Manual install

```bash
git clone https://github.com/AgentiveStack/skills.git
cd skills
./install.sh
```

Or symlink individual ones:

```bash
ln -sf "$(pwd)/spec" "$HOME/.claude/skills/spec"
ln -sf "$(pwd)/domain" "$HOME/.claude/skills/domain"
```

Then use them in any project: `/spec`, `/domain`, `/slice`, etc.

### Project-level domain docs

The skills discover your project's domain model automatically by looking for:

1. `docs/CONTEXT_MAP.md` — bounded contexts and their relationships
2. `docs/UBIQUITOUS_LANGUAGE.md` — shared glossary of domain terms
3. `docs/contexts/*/CONTEXT.md` — per-context documentation (ownership, invariants, contracts)
4. `CLAUDE.md` — project-level context

If these don't exist yet, the skills create them lazily as you work. Start with `/spec` or `/domain` on your first feature — the documents will emerge from the conversation.

## How the skills work

Each skill is a single `SKILL.md` file — a structured prompt that teaches the AI a specific workflow. No code, no dependencies, no build step.

The skills are **project-agnostic**. They don't know your tech stack, your folder structure, or your domain. They discover context by reading your project's domain documentation (see above). This means they work the same way whether you're building a web app, a CLI tool, or a mobile app.

### Key principles baked into these skills

- **Substance over structure** — no folder reorganization, no architectural plumbing. Just shared understanding, written down.
- **Vertical slices** — every slice cuts through all layers (schema → API → UI → tests). No horizontal "set up the database first" slices.
- **Pragmatic TDD** — test-first for core logic and boundary contracts, implementation-first for UI and glue code. Mock only at system boundaries.
- **Deep modules** — small interfaces hiding significant complexity. Inspired by John Ousterhout's *A Philosophy of Software Design*.
- **Domain language everywhere** — code, tests, issues, and conversations use the same vocabulary defined in your glossary.

## Background

These skills grew out of a practical need: after a year of building a product almost entirely with AI, the codebase grew faster than the understanding of it. Working code with no map.

The fix came from Domain-Driven Design (Eric Evans, 2003) — a 20-year-old methodology designed for exactly this problem: maintaining a coherent mental model of a complex system when the people working on it keep changing.

Back then, the "people" changing were new hires joining a team.
Today, it's a new AI session. Every time.

Three artifacts made the difference:
1. **A shared language** — so you and the AI mean the same thing
2. **Clear boundaries** — so the AI knows what it's working on and what it shouldn't touch
3. **Documented contracts** — so changes in one area don't silently break another

These skills formalize that workflow.

## Contributing

Each skill lives in its own directory with a single `SKILL.md` file. To add a new skill:

1. Create a new directory with a descriptive name
2. Add a `SKILL.md` following the frontmatter format (see existing skills for examples)
3. Keep it project-agnostic — discover context, don't assume it
4. Open a PR

## License

MIT
