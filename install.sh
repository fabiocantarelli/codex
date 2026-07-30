#!/bin/sh
set -eu

REPO_OWNER="${CODEX_SKILLS_REPO_OWNER:-fabiocantarelli}"
REPO_NAME="${CODEX_SKILLS_REPO_NAME:-codex}"
REPO_REF="${CODEX_SKILLS_REPO_REF:-main}"
ARCHIVE_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/archive/refs/heads/${REPO_REF}.tar.gz"

info() {
  printf '\033[1;34mℹ\033[0m %s\n' "$*"
}

success() {
  printf '\033[1;32m✔\033[0m %s\n' "$*"
}

warning() {
  printf '\033[1;33m⚠\033[0m %s\n' "$*"
}

die() {
  printf '\033[1;31m✘ Erro:\033[0m %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<'EOF'

🧩 Codex Skills Installer

Uso remoto recomendado:

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" -- <skill>

  sh -c "$(wget -qO- https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" -- <skill>

Uso:

  install.sh <skill> [windows|linux|mac]

Exemplos:

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" -- react-product-builder

  sh -c "$(wget -qO- https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" -- react-product-builder

  ./install.sh react-product-builder linux

O sistema operacional é detectado automaticamente. O segundo argumento é opcional e serve apenas para sobrescrever a detecção.

Variáveis opcionais:

  CODEX_SKILLS_REPO_OWNER
  CODEX_SKILLS_REPO_NAME
  CODEX_SKILLS_REPO_REF
  CODEX_HOME
  AGENTS_HOME

EOF
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

normalize_os() {
  value=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')

  case "$value" in
    linux|wsl) printf '%s\n' linux ;;
    mac|macos|darwin|osx) printf '%s\n' mac ;;
    windows|win|win32|mingw|msys|cygwin) printf '%s\n' windows ;;
    *) return 1 ;;
  esac
}

detect_os() {
  uname_value=$(uname -s 2>/dev/null || printf 'unknown')

  case "$uname_value" in
    Linux*)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        printf '%s\n' linux
      else
        printf '%s\n' linux
      fi
      ;;
    Darwin*) printf '%s\n' mac ;;
    MINGW*|MSYS*|CYGWIN*) printf '%s\n' windows ;;
    *) die "Não foi possível detectar o sistema operacional: $uname_value" ;;
  esac
}

resolve_home() {
  target_os="$1"

  if [ "$target_os" = "windows" ]; then
    if [ -n "${USERPROFILE:-}" ]; then
      printf '%s\n' "$USERPROFILE"
      return
    fi

    if command_exists cmd.exe; then
      windows_home=$(cmd.exe /C "echo %USERPROFILE%" 2>/dev/null | tr -d '\r')
      [ -n "$windows_home" ] || die "Não foi possível determinar USERPROFILE."

      if command_exists cygpath; then
        cygpath -u "$windows_home"
      elif command_exists wslpath; then
        wslpath "$windows_home"
      else
        printf '%s\n' "$windows_home"
      fi
      return
    fi
  fi

  [ -n "${HOME:-}" ] || die "A variável HOME não está definida."
  printf '%s\n' "$HOME"
}

download_archive() {
  output="$1"

  if command_exists curl; then
    curl -fsSL "$ARCHIVE_URL" -o "$output"
  elif command_exists wget; then
    wget -qO "$output" "$ARCHIVE_URL"
  else
    die "Instale curl ou wget para continuar."
  fi
}

list_skills() {
  skills_dir="$1"

  [ -d "$skills_dir" ] || return 0

  for directory in "$skills_dir"/*; do
    [ -d "$directory" ] || continue
    printf '  • %s\n' "$(basename "$directory")" >&2
  done
}

SKILL_NAME="${1:-}"
REQUESTED_OS="${2:-}"

case "$SKILL_NAME" in
  ""|help|-h|--help)
    usage
    exit 0
    ;;
  *[!a-zA-Z0-9._-]*)
    die "Nome da skill inválido: $SKILL_NAME"
    ;;
esac

if [ -n "$REQUESTED_OS" ]; then
  TARGET_OS=$(normalize_os "$REQUESTED_OS") || die "Sistema inválido: $REQUESTED_OS"
else
  TARGET_OS=$(detect_os)
fi

USER_HOME=$(resolve_home "$TARGET_OS")
CODEX_HOME="${CODEX_HOME:-${USER_HOME}/.codex}"
AGENTS_HOME="${AGENTS_HOME:-${USER_HOME}/.agents}"
SKILL_TARGET="${AGENTS_HOME}/skills/${SKILL_NAME}"
CODEX_AGENTS_TARGET="${CODEX_HOME}/agents"

TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t codex-skills)
trap 'rm -rf "$TMP_DIR"' EXIT HUP INT TERM

ARCHIVE_PATH="${TMP_DIR}/repository.tar.gz"
REPOSITORY_DIR="${TMP_DIR}/repository"

printf '\n🧩 \033[1mCodex Skills\033[0m\n\n'
info "Skill: ${SKILL_NAME}"
info "Sistema detectado: ${TARGET_OS}"
info "Baixando ${REPO_OWNER}/${REPO_NAME}@${REPO_REF}..."

download_archive "$ARCHIVE_PATH"
mkdir -p "$REPOSITORY_DIR"
tar -xzf "$ARCHIVE_PATH" -C "$REPOSITORY_DIR" --strip-components=1

SKILL_SOURCE="${REPOSITORY_DIR}/skills/${SKILL_NAME}"

if [ ! -d "$SKILL_SOURCE" ]; then
  printf '\nSkills disponíveis:\n' >&2
  list_skills "${REPOSITORY_DIR}/skills"
  printf '\n' >&2
  die "Skill não encontrada: $SKILL_NAME"
fi

[ -f "${SKILL_SOURCE}/SKILL.md" ] || die "A skill não contém SKILL.md."

mkdir -p "${AGENTS_HOME}/skills" "$CODEX_AGENTS_TARGET"

if [ -d "$SKILL_TARGET" ]; then
  BACKUP="${SKILL_TARGET}.backup.$(date +%Y%m%d%H%M%S)"
  warning "Instalação existente encontrada."
  info "Criando backup em: $BACKUP"
  mv "$SKILL_TARGET" "$BACKUP"
fi

cp -R "$SKILL_SOURCE" "$SKILL_TARGET"

if [ -d "${SKILL_SOURCE}/agents" ]; then
  for agent_file in "${SKILL_SOURCE}/agents"/*.toml; do
    [ -f "$agent_file" ] || continue
    cp "$agent_file" "$CODEX_AGENTS_TARGET/"
  done
fi

if [ -d "${SKILL_TARGET}/scripts" ]; then
  for script_file in "${SKILL_TARGET}/scripts"/*.sh; do
    [ -f "$script_file" ] || continue
    chmod +x "$script_file"
  done
fi

if [ -x "${SKILL_TARGET}/scripts/validate-skill.sh" ]; then
  info "Validando a skill..."
  "${SKILL_TARGET}/scripts/validate-skill.sh"
fi

printf '\n'
success "Skill instalada com sucesso."
printf '\n'
printf '  📦 Skill:    %s\n' "$SKILL_NAME"
printf '  💻 Sistema: %s\n' "$TARGET_OS"
printf '  📁 Destino: %s\n' "$SKILL_TARGET"

if [ -d "${SKILL_SOURCE}/agents" ]; then
  printf '  🤖 Agentes: %s\n' "$CODEX_AGENTS_TARGET"
fi

printf '\n'
warning "Reinicie o Codex CLI para carregar a nova skill."
printf '\nUse:\n\n'
printf '  $%s help\n\n' "$SKILL_NAME"
