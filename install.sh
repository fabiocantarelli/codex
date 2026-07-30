#!/usr/bin/env bash
set -euo pipefail

REPO_OWNER="${CODEX_SKILLS_REPO_OWNER:-fabiocantarelli}"
REPO_NAME="${CODEX_SKILLS_REPO_NAME:-codex}"
REPO_REF="${CODEX_SKILLS_REPO_REF:-main}"
RAW_BASE="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${REPO_REF}"
ARCHIVE_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/archive/refs/heads/${REPO_REF}.tar.gz"

usage() {
  cat <<'EOF'
Codex Skills Installer

Uso:
  install.sh <skill> <windows|linux|mac>

Instalação remota:
  curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh \
    | bash -s -- react-product-builder linux

  wget -qO- https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh \
    | bash -s -- react-product-builder linux

Exemplos:
  install.sh react-product-builder linux
  install.sh react-product-builder mac
  install.sh react-product-builder windows

Variáveis opcionais:
  CODEX_SKILLS_REPO_OWNER
  CODEX_SKILLS_REPO_NAME
  CODEX_SKILLS_REPO_REF
  CODEX_HOME
  AGENTS_HOME
EOF
}

die() {
  echo "Erro: $*" >&2
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

normalize_os() {
  case "${1,,}" in
    linux|wsl) echo "linux" ;;
    mac|macos|darwin|osx) echo "mac" ;;
    windows|win|win32|mingw|msys|cygwin) echo "windows" ;;
    *) return 1 ;;
  esac
}

resolve_home() {
  local os_name="$1"

  if [[ "$os_name" == "windows" ]]; then
    if [[ -n "${USERPROFILE:-}" ]]; then
      printf '%s\n' "$USERPROFILE"
      return
    fi

    if command_exists cmd.exe; then
      local win_home
      win_home="$(cmd.exe /C "echo %USERPROFILE%" 2>/dev/null | tr -d '\r')"
      [[ -n "$win_home" ]] || die "Não foi possível determinar USERPROFILE."
      if command_exists wslpath; then
        wslpath "$win_home"
      else
        printf '%s\n' "$win_home"
      fi
      return
    fi
  fi

  [[ -n "${HOME:-}" ]] || die "Variável HOME não definida."
  printf '%s\n' "$HOME"
}

download_archive() {
  local output="$1"

  if command_exists curl; then
    curl -fsSL "$ARCHIVE_URL" -o "$output"
  elif command_exists wget; then
    wget -q "$ARCHIVE_URL" -O "$output"
  else
    die "Instale curl ou wget."
  fi
}

SKILL_NAME="${1:-}"
REQUESTED_OS="${2:-}"

if [[ -z "$SKILL_NAME" || -z "$REQUESTED_OS" ]]; then
  usage
  exit 1
fi

TARGET_OS="$(normalize_os "$REQUESTED_OS")" || {
  usage
  die "Sistema inválido: $REQUESTED_OS"
}

case "$SKILL_NAME" in
  help|-h|--help)
    usage
    exit 0
    ;;
  *[!a-zA-Z0-9._-]*)
    die "Nome da skill inválido: $SKILL_NAME"
    ;;
esac

USER_HOME="$(resolve_home "$TARGET_OS")"
CODEX_HOME="${CODEX_HOME:-${USER_HOME}/.codex}"
AGENTS_HOME="${AGENTS_HOME:-${USER_HOME}/.agents}"
SKILL_TARGET="${AGENTS_HOME}/skills/${SKILL_NAME}"
CODEX_AGENTS_TARGET="${CODEX_HOME}/agents"

TMP_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t codex-skills)"
trap 'rm -rf "$TMP_DIR"' EXIT

ARCHIVE_PATH="${TMP_DIR}/repository.tar.gz"
download_archive "$ARCHIVE_PATH"

mkdir -p "${TMP_DIR}/repository"
tar -xzf "$ARCHIVE_PATH" -C "${TMP_DIR}/repository" --strip-components=1

SKILL_SOURCE="${TMP_DIR}/repository/skills/${SKILL_NAME}"
[[ -d "$SKILL_SOURCE" ]] || {
  echo "Skills disponíveis:" >&2
  find "${TMP_DIR}/repository/skills" -mindepth 1 -maxdepth 1 -type d \
    -printf '  - %f\n' 2>/dev/null || true
  die "Skill não encontrada: $SKILL_NAME"
}

[[ -f "${SKILL_SOURCE}/SKILL.md" ]] || die "A skill não contém SKILL.md."

mkdir -p "${AGENTS_HOME}/skills" "$CODEX_AGENTS_TARGET"

if [[ -d "$SKILL_TARGET" ]]; then
  BACKUP="${SKILL_TARGET}.backup.$(date +%Y%m%d%H%M%S)"
  echo "Criando backup: $BACKUP"
  mv "$SKILL_TARGET" "$BACKUP"
fi

cp -R "$SKILL_SOURCE" "$SKILL_TARGET"

if [[ -d "${SKILL_SOURCE}/agents" ]]; then
  find "${SKILL_SOURCE}/agents" -maxdepth 1 -type f -name '*.toml' -exec cp {} "$CODEX_AGENTS_TARGET/" \;
fi

if [[ -d "${SKILL_TARGET}/scripts" ]]; then
  find "${SKILL_TARGET}/scripts" -maxdepth 1 -type f -name '*.sh' -exec chmod +x {} \;
fi

if [[ -x "${SKILL_TARGET}/scripts/validate-skill.sh" ]]; then
  "${SKILL_TARGET}/scripts/validate-skill.sh"
fi

echo
echo "Skill instalada com sucesso."
echo "Nome:     $SKILL_NAME"
echo "Sistema:  $TARGET_OS"
echo "Destino:  $SKILL_TARGET"

if [[ -d "${SKILL_SOURCE}/agents" ]]; then
  echo "Agentes:  $CODEX_AGENTS_TARGET"
fi

echo
echo "Reinicie o Codex CLI."
echo "Use:"
echo "  \$${SKILL_NAME} help"
