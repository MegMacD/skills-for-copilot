#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_REPO="${1:-$PWD}"
MODE="copy"

usage() {
  cat <<'EOF'
Install Agentive skills as VS Code Copilot instructions.

Usage:
  ./install-copilot.sh [target-repo] [--mode copy|link]

Examples:
  ./install-copilot.sh
  ./install-copilot.sh ~/source/my-repo
  ./install-copilot.sh ~/source/my-repo --mode link
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      shift
      [[ $# -gt 0 ]] || { echo "Missing value for --mode" >&2; exit 1; }
      MODE="$1"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      TARGET_REPO="$1"
      ;;
  esac
  shift
 done

if [[ "$MODE" != "copy" && "$MODE" != "link" ]]; then
  echo "Invalid mode: $MODE (expected copy or link)" >&2
  exit 1
fi

if [[ ! -d "$TARGET_REPO" ]]; then
  echo "Target repository does not exist: $TARGET_REPO" >&2
  exit 1
fi

SKILLS=(spec domain slice tdd holistic architect qa)
INSTRUCTIONS_DIR="$TARGET_REPO/.github/instructions"
mkdir -p "$INSTRUCTIONS_DIR"

strip_frontmatter() {
  local src="$1"
  awk '
    NR == 1 && $0 == "---" { in_fm = 1; next }
    in_fm && $0 == "---" { in_fm = 0; started = 1; next }
    started && !in_fm { print }
  ' "$src"
}

get_description() {
  local src="$1"
  sed -n 's/^description:[[:space:]]*//p' "$src" | head -n 1 | sed 's/^"//; s/"$//'
}

for skill in "${SKILLS[@]}"; do
  src="$SCRIPT_DIR/$skill/SKILL.md"
  dest="$INSTRUCTIONS_DIR/$skill.instructions.md"

  if [[ ! -f "$src" ]]; then
    echo "Missing source skill: $src" >&2
    exit 1
  fi

  if [[ "$MODE" == "link" ]]; then
    ln -sfn "$src" "$dest"
    echo "linked $skill.instructions.md -> $src"
  else
    desc="$(get_description "$src")"
    {
      printf -- "---\n"
      printf 'applyTo: "**"\n'
      printf 'description: "%s"\n' "${desc//\"/\\\"}"
      printf -- "---\n\n"
      printf '# %s Skill\n\n' "$skill"
      printf 'Imported from AgentiveStack/skills `%s/SKILL.md`.\n\n' "$skill"
      strip_frontmatter "$src"
      printf '\n'
    } > "$dest"
    echo "created $skill.instructions.md"
  fi
 done

cat > "$TARGET_REPO/.github/copilot-instructions.md" <<'EOF'
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
EOF

echo ""
echo "Installed Copilot instruction files to: $TARGET_REPO/.github"
echo "Mode: $MODE"
echo "Skills: ${SKILLS[*]}"
