#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_FILE="$SKILL_DIR/SKILL.md"

[[ -f "$SKILL_FILE" ]] || { echo "SKILL.md não encontrado"; exit 1; }

[[ "$(head -n 1 "$SKILL_FILE")" == "---" ]] || {
  echo "Frontmatter inválido"
  exit 1
}

grep -q '^name: react-product-builder$' "$SKILL_FILE" || {
  echo "Nome da skill inválido"
  exit 1
}

grep -q '^description:' "$SKILL_FILE" || {
  echo "Description ausente"
  exit 1
}

for dir in \
  "$SKILL_DIR/references/shared" \
  "$SKILL_DIR/references/web" \
  "$SKILL_DIR/references/mobile" \
  "$SKILL_DIR/references/universal" \
  "$SKILL_DIR/prompts" \
  "$SKILL_DIR/templates"; do
  [[ -d "$dir" ]] || {
    echo "Diretório ausente: $dir"
    exit 1
  }
done

echo "Skill válida: $SKILL_FILE"
