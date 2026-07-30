#!/bin/sh
#
# Codex Skills Installer
#
# curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" react-product-builder
#
# wget:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" react-product-builder
#

set -e

USER=${USER:-$(id -u -n 2>/dev/null || printf 'unknown')}
HOME=${HOME:-$(getent passwd "$USER" 2>/dev/null | cut -d: -f6)}
HOME=${HOME:-$(eval echo ~"$USER")}

REPO=${REPO:-fabiocantarelli/codex}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-main}
CODEX_HOME=${CODEX_HOME:-$HOME/.codex}
AGENTS_HOME=${AGENTS_HOME:-$HOME/.agents}
RUN_VALIDATION=${RUN_VALIDATION:-yes}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if [ -t 1 ]; then
  is_tty() { true; }
else
  is_tty() { false; }
fi

setup_colors() {
  if is_tty; then
    FMT_RED=$(printf '\033[31m')
    FMT_GREEN=$(printf '\033[32m')
    FMT_YELLOW=$(printf '\033[33m')
    FMT_BLUE=$(printf '\033[34m')
    FMT_BOLD=$(printf '\033[1m')
    FMT_RESET=$(printf '\033[0m')
  else
    FMT_RED=''
    FMT_GREEN=''
    FMT_YELLOW=''
    FMT_BLUE=''
    FMT_BOLD=''
    FMT_RESET=''
  fi
}

info() {
  printf '%s%sℹ%s %s\n' "$FMT_BOLD" "$FMT_BLUE" "$FMT_RESET" "$*"
}

success() {
  printf '%s%s✔%s %s\n' "$FMT_BOLD" "$FMT_GREEN" "$FMT_RESET" "$*"
}

warning() {
  printf '%s%s⚠%s %s\n' "$FMT_BOLD" "$FMT_YELLOW" "$FMT_RESET" "$*"
}

error() {
  printf '%s%s✘ Erro:%s %s\n' "$FMT_BOLD" "$FMT_RED" "$FMT_RESET" "$*" >&2
}

die() {
  error "$*"
  exit 1
}

usage() {
  cat <<'EOF'

🧩 Codex Skills Installer

Uso remoto:

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" <skill>

  sh -c "$(wget -qO- https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" <skill>

Uso local:

  sh install.sh <skill> [opções]

Opções:

  --branch <ref>     Usa outra branch ou tag
  --help             Exibe esta ajuda

Comportamento:

  Se a skill já estiver instalada, ela será atualizada no mesmo diretório.
  Os agentes existentes com o mesmo nome também serão substituídos.

EOF
}

cleanup() {
  if [ -n "${TMP_DIR:-}" ] && [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
  fi
}

clone_repository() {
  csr_destination=$1

  command_exists git || die "git não está instalado."

  info "Baixando catálogo de skills..."
  umask g-w,o-w

  git init --quiet "$csr_destination"
  (
    cd "$csr_destination"
    git config core.eol lf
    git config core.autocrlf false
    git remote add origin "$REMOTE"
    git fetch --quiet --depth=1 origin "$BRANCH"
    git checkout --quiet -b "$BRANCH" "origin/$BRANCH"
  ) || {
    rm -rf "$csr_destination"
    die "Não foi possível baixar $REMOTE na referência $BRANCH."
  }
}

list_skills() {
  ls_skills_root=$1

  printf '\nSkills disponíveis:\n\n'
  for ls_skill_path in "$ls_skills_root"/*; do
    [ -d "$ls_skill_path" ] || continue
    printf '  • %s\n' "$(basename "$ls_skill_path")"
  done
  printf '\n'
}

install_skill() {
  ins_source=$1
  ins_target=$2

  mkdir -p "$(dirname "$ins_target")"

  if [ -d "$ins_target" ]; then
    info "Atualizando skill existente..."
    rm -rf "$ins_target"
  else
    info "Instalando nova skill..."
  fi

  cp -R "$ins_source" "$ins_target"
}

install_agents() {
  ia_source_dir=$1
  ia_target_dir=$2

  [ -d "$ia_source_dir" ] || return 0
  mkdir -p "$ia_target_dir"

  for ia_agent_file in "$ia_source_dir"/*.toml; do
    [ -f "$ia_agent_file" ] || continue
    ia_destination="$ia_target_dir/$(basename "$ia_agent_file")"
    cp "$ia_agent_file" "$ia_destination"
  done
}

make_scripts_executable() {
  mse_scripts_dir=$1

  [ -d "$mse_scripts_dir" ] || return 0

  for mse_script in "$mse_scripts_dir"/*.sh; do
    [ -f "$mse_script" ] || continue
    chmod +x "$mse_script"
  done
}

run_validation() {
  rv_skill_dir=$1
  rv_validator="$rv_skill_dir/scripts/validate-skill.sh"

  [ "$RUN_VALIDATION" = yes ] || return 0
  [ -x "$rv_validator" ] || return 0

  info "Validando a skill instalada..."
  "$rv_validator"
}

print_success() {
  ps_skill_name=$1
  ps_skill_target=$2

  printf '\n'
  printf '%s%s' "$FMT_GREEN" "$FMT_BOLD"
  printf '   ____          __          _____ __   _ ____    \n'
  printf '  / ___|___   __| | _____  _/ ___// /__(_) / /____\n'
  printf ' | |   / _ \\ / _` |/ _ \\ \\__ \\/ //_/ / / / ___/\n'
  printf ' | |__| (_) | (_| |  __/ /__/ / ,< / / / (__  ) \n'
  printf '  \\____\\___/ \\__,_|\\___| /____/_/|_/_/_/_/____/  \n'
  printf '%s\n' "$FMT_RESET"

  success "Skill instalada ou atualizada com sucesso."
  printf '\n'
  printf '  Skill:   %s\n' "$ps_skill_name"
  printf '  Destino: %s\n' "$ps_skill_target"
  printf '  Branch:  %s\n' "$BRANCH"
  printf '\n'
  info "Reinicie o Codex CLI para recarregar as skills."
  printf '\n'
  printf '  $%s help\n' "$ps_skill_name"
  printf '\n'
}

main() {
  setup_colors
  main_skill_name=${SKILL:-}

  while [ $# -gt 0 ]; do
    case "$1" in
      --branch)
        shift
        [ $# -gt 0 ] || die "Informe uma referência após --branch."
        BRANCH=$1
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      --*)
        usage
        die "Opção desconhecida: $1"
        ;;
      *)
        if [ -z "$main_skill_name" ]; then
          main_skill_name=$1
        else
          die "Argumento inesperado: $1"
        fi
        ;;
    esac
    shift
  done

  if [ -z "$main_skill_name" ]; then
    usage
    exit 1
  fi

  case "$main_skill_name" in
    *[!a-zA-Z0-9._-]*) die "Nome de skill inválido: $main_skill_name" ;;
  esac

  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t codex-skills)
  trap cleanup EXIT INT TERM

  main_repository="$TMP_DIR/repository"
  clone_repository "$main_repository"

  main_skills_root="$main_repository/skills"
  main_skill_source="$main_skills_root/$main_skill_name"

  if [ ! -d "$main_skill_source" ]; then
    list_skills "$main_skills_root"
    die "Skill não encontrada: $main_skill_name"
  fi

  [ -f "$main_skill_source/SKILL.md" ] || die "A skill não contém SKILL.md."

  main_skill_target="$AGENTS_HOME/skills/$main_skill_name"
  main_agents_target="$CODEX_HOME/agents"

  install_skill "$main_skill_source" "$main_skill_target"
  install_agents "$main_skill_source/agents" "$main_agents_target"
  make_scripts_executable "$main_skill_target/scripts"
  run_validation "$main_skill_target"
  print_success "$main_skill_name" "$main_skill_target"
}

main "$@"
