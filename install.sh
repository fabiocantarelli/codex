#!/bin/sh
#
# Codex Skills Installer
#
# Execute com curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" react-product-builder
#
# Execute com wget:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" react-product-builder
#
# Também é possível baixar e inspecionar antes de executar:
#   curl -fsSLO https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh
#   sh install.sh react-product-builder
#
# Variáveis suportadas:
#   REPO         - repositório GitHub no formato owner/repository
#                  (padrão: fabiocantarelli/codex)
#   REMOTE       - URL completa do repositório Git
#   BRANCH       - branch ou tag a instalar (padrão: main)
#   CODEX_HOME   - diretório de configuração do Codex (padrão: $HOME/.codex)
#   AGENTS_HOME  - diretório global de agents/skills (padrão: $HOME/.agents)
#   SKILL        - nome da skill, como alternativa ao argumento posicional
#   UNATTENDED   - yes para desabilitar perguntas interativas
#   KEEP_EXISTING - yes para preservar instalação existente e encerrar
#   RUN_VALIDATION - no para não executar o validador da skill
#
# Opções:
#   --unattended    não solicita confirmação
#   --keep-existing preserva a instalação atual
#   --force          substitui a skill sem confirmação, mantendo backup
#   --branch <ref>   instala outra branch ou tag
#   --help           exibe a ajuda
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
UNATTENDED=${UNATTENDED:-no}
KEEP_EXISTING=${KEEP_EXISTING:-no}
RUN_VALIDATION=${RUN_VALIDATION:-yes}
FORCE_INSTALL=no

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
  printf '%s%s✘ Error:%s %s\n' "$FMT_BOLD" "$FMT_RED" "$FMT_RESET" "$*" >&2
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

Exemplo:

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" react-product-builder

Opções:

  --unattended       Instala sem perguntas interativas
  --keep-existing    Mantém a instalação atual
  --force            Substitui a instalação atual e cria backup
  --branch <ref>     Usa outra branch ou tag
  --help              Exibe esta ajuda

Variáveis:

  REPO
  REMOTE
  BRANCH
  CODEX_HOME
  AGENTS_HOME
  SKILL
  UNATTENDED
  KEEP_EXISTING
  RUN_VALIDATION

EOF
}

cleanup() {
  if [ -n "${TMP_DIR:-}" ] && [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
  fi
}

clone_repository() {
  destination=$1

  command_exists git || die "git não está instalado."

  info "Baixando catálogo de skills..."

  umask g-w,o-w

  git init --quiet "$destination"
  (
    cd "$destination"
    git config core.eol lf
    git config core.autocrlf false
    git remote add origin "$REMOTE"
    git fetch --quiet --depth=1 origin "$BRANCH"
    git checkout --quiet -b "$BRANCH" "origin/$BRANCH"
  ) || {
    rm -rf "$destination"
    die "Não foi possível baixar $REMOTE na referência $BRANCH."
  }
}

list_skills() {
  skills_root=$1

  printf '\nSkills disponíveis:\n\n'
  for skill_path in "$skills_root"/*; do
    [ -d "$skill_path" ] || continue
    printf '  • %s\n' "$(basename "$skill_path")"
  done
  printf '\n'
}

backup_existing_skill() {
  target=$1

  timestamp=$(date +%Y-%m-%d_%H-%M-%S)
  backup="${target}.pre-codex-skills-${timestamp}"

  warning "Instalação existente encontrada."
  info "Criando backup em $backup"
  mv "$target" "$backup"
}

backup_existing_agent() {
  target=$1

  [ -e "$target" ] || return 0

  timestamp=$(date +%Y-%m-%d_%H-%M-%S)
  backup="${target}.pre-codex-skills-${timestamp}"
  mv "$target" "$backup"
  warning "Agente existente movido para $backup"
}

install_skill() {
  source=$1
  target=$2

  if [ -d "$target" ]; then
    if [ "$KEEP_EXISTING" = yes ]; then
      warning "A skill já está instalada em $target."
      info "Nenhum arquivo foi alterado."
      exit 0
    fi

    if [ "$FORCE_INSTALL" != yes ] && [ "$UNATTENDED" != yes ] && [ -t 0 ]; then
      printf '%sA skill já existe. Substituir e criar backup? [Y/n]%s ' "$FMT_YELLOW" "$FMT_RESET"
      read -r answer
      case "$answer" in
        [Nn]*) info "Instalação cancelada."; exit 0 ;;
        [Yy]*|'') ;;
        *) info "Resposta inválida. Instalação cancelada."; exit 0 ;;
      esac
    fi

    backup_existing_skill "$target"
  fi

  mkdir -p "$(dirname "$target")"
  cp -R "$source" "$target"
}

install_agents() {
  source=$1
  target=$2

  [ -d "$source" ] || return 0

  mkdir -p "$target"

  for agent in "$source"/*.toml; do
    [ -f "$agent" ] || continue
    destination="$target/$(basename "$agent")"
    backup_existing_agent "$destination"
    cp "$agent" "$destination"
  done
}

make_scripts_executable() {
  scripts_dir=$1

  [ -d "$scripts_dir" ] || return 0

  for script in "$scripts_dir"/*.sh; do
    [ -f "$script" ] || continue
    chmod +x "$script"
  done
}

run_validation() {
  skill_dir=$1
  validator="$skill_dir/scripts/validate-skill.sh"

  [ "$RUN_VALIDATION" = yes ] || return 0
  [ -x "$validator" ] || return 0

  info "Validando a skill instalada..."
  "$validator"
}

print_success() {
  skill_name=$1
  skill_target=$2

  printf '\n'
  printf '%s%s' "$FMT_GREEN" "$FMT_BOLD"
  printf '   ____          __          _____ __   _ ____    \n'
  printf '  / ___|___   __| | _____  _/ ___// /__(_) / /____\n'
  printf ' | |   / _ \\ / _` |/ _ \\ \\__ \\/ //_/ / / / ___/\n'
  printf ' | |__| (_) | (_| |  __/ /__/ / ,< / / / (__  ) \n'
  printf '  \\____\\___/ \\__,_|\\___| /____/_/|_/_/_/_/____/  \n'
  printf '%s\n' "$FMT_RESET"

  success "Skill instalada com sucesso."
  printf '\n'
  printf '  Skill:   %s\n' "$skill_name"
  printf '  Destino: %s\n' "$skill_target"
  printf '  Branch:  %s\n' "$BRANCH"
  printf '\n'
  info "Reinicie o Codex CLI para recarregar as skills."
  printf '\n'
  printf '  $%s help\n' "$skill_name"
  printf '\n'
}

main() {
  setup_colors

  if [ ! -t 0 ]; then
    UNATTENDED=yes
  fi

  skill_name=${SKILL:-}

  while [ $# -gt 0 ]; do
    case "$1" in
      --unattended)
        UNATTENDED=yes
        ;;
      --keep-existing)
        KEEP_EXISTING=yes
        ;;
      --force)
        FORCE_INSTALL=yes
        ;;
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
        if [ -z "$skill_name" ]; then
          skill_name=$1
        else
          die "Argumento inesperado: $1"
        fi
        ;;
    esac
    shift
  done

  if [ -z "$skill_name" ]; then
    usage
    exit 1
  fi

  case "$skill_name" in
    *[!a-zA-Z0-9._-]*) die "Nome de skill inválido: $skill_name" ;;
  esac

  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t codex-skills)
  trap cleanup EXIT INT TERM

  repository="$TMP_DIR/repository"
  clone_repository "$repository"

  skills_root="$repository/skills"
  skill_source="$skills_root/$skill_name"

  if [ ! -d "$skill_source" ]; then
    list_skills "$skills_root"
    die "Skill não encontrada: $skill_name"
  fi

  [ -f "$skill_source/SKILL.md" ] || die "A skill não contém SKILL.md."

  skill_target="$AGENTS_HOME/skills/$skill_name"
  agents_target="$CODEX_HOME/agents"

  install_skill "$skill_source" "$skill_target"
  install_agents "$skill_source/agents" "$agents_target"
  make_scripts_executable "$skill_target/scripts"
  run_validation "$skill_target"
  print_success "$skill_name" "$skill_target"
}

main "$@"
