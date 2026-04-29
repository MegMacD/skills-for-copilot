#!/usr/bin/env bash
set -e

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$SKILLS_DIR"

count=0
for skill in "$SCRIPT_DIR"/*/; do
  name=$(basename "$skill")
  [[ "$name" == .* ]] && continue
  ln -sf "$skill" "$SKILLS_DIR/$name"
  echo "  linked $name"
  ((count++))
done

echo ""
echo "Installed $count skills to $SKILLS_DIR"
echo "Use them in any project: /spec, /domain, /slice, /tdd, /holistic, /architect, /qa"
