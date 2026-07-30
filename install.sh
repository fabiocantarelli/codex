#!/bin/sh
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

command_exists() { command -v "$1" >/dev/null 2>&1; }

setup_colors() {
  if [ -t 1 ]; then
    FMT_RED=$(printf '\033[31m')
    FMT_GREEN=$(printf '\033[32m')
    FMT_YELLOW=$(printf '\033[33m')
    FMT_BLUE=$(printf '\033[34m')
    FMT_BOLD=$(printf '\033[1m')
    FMT_RESET=$(printf '\033[0m')
  else
    FMT_RED=''; FMT_GREEN=''; FMT_YELLOW=''; FMT_BLUE=''; FMT_BOLD=''; FMT_RESET=''
  fi
}

info() { printf '%s%sℹ%s %s\n' "$FMT_BOLD" "$FMT_BLUE" "$FMT_RESET" "$*"; }
success() { printf '%s%s✔%s %s\n' "$FMT_BOLD" "$FMT_GREEN" "$FMT_RESET" "$*"; }
warning() { printf '%s%s⚠%s %s\n' "$FMT_BOLD" "$FMT_YELLOW" "$FMT_RESET" "$*"; }
error() { printf '%s%s✘ Erro:%s %s\n' "$FMT_BOLD" "$FMT_RED" "$FMT_RESET" "$*" >&2; }
die() { error "$*"; exit 1; }

usage() {
  cat <<'EOF'

🧩 Codex Skills Installer

Instalar ou atualizar uma skill:

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" <skill>

  sh -c "$(wget -qO- https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" <skill>

Instalar várias skills:

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" <skill-1> <skill-2>

Instalar todas:

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" --all

Uso local:

  sh install.sh <skill> [skill ...] [opções]

Opções:

  --all              Instala todas as skills disponíveis
  --branch <ref>     Usa outra branch ou tag
  --help             Exibe esta ajuda

Ao executar novamente, skills e agentes existentes são atualizados diretamente.
EOF
}

cleanup() {
  [ -n "${TMP_DIR:-}" ] && [ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"
}

clone_repository() {
  destination=$1
  command_exists git || die "git não está instalado."
  info "Baixando catálogo de skills..."
  umask g-w,o-w
  GIT_TERMINAL_PROMPT=0 git init --quiet "$destination"
  (
    cd "$destination"
    git config core.eol lf
    git config core.autocrlf false
    git remote add origin "$REMOTE"
    GIT_TERMINAL_PROMPT=0 git fetch --quiet --depth=1 origin "$BRANCH"
    git checkout --quiet -b "$BRANCH" "origin/$BRANCH"
  ) || {
    rm -rf "$destination"
    die "Não foi possível baixar $REMOTE na referência $BRANCH."
  }
}

all_skill_names() {
  root=$1
  for path in "$root"/*; do
    [ -d "$path" ] || continue
    [ -f "$path/SKILL.md" ] || continue
    printf '%s ' "$(basename "$path")"
  done
}

install_skill() {
  source=$1
  target=$2
  mkdir -p "$(dirname "$target")"
  if [ -d "$target" ]; then
    info "Atualizando $(basename "$target")..."
    rm -rf "$target"
  else
    info "Instalando $(basename "$target")..."
  fi
  cp -R "$source" "$target"
}

install_agents() {
  source=$1
  target=$2
  [ -d "$source" ] || return 0
  mkdir -p "$target"
  for file in "$source"/*.toml; do
    [ -f "$file" ] || continue
    cp "$file" "$target/$(basename "$file")"
  done
}

make_scripts_executable() {
  dir=$1
  [ -d "$dir" ] || return 0
  for file in "$dir"/*.sh; do
    [ -f "$file" ] && chmod +x "$file"
  done
}

run_validation() {
  dir=$1
  validator="$dir/scripts/validate-skill.sh"
  [ "$RUN_VALIDATION" = yes ] || return 0
  [ -x "$validator" ] || return 0
  info "Validando $(basename "$dir")..."
  "$validator"
}

print_banner() {
  printf '\n%s%s' "$FMT_GREEN" "$FMT_BOLD"
  cat <<'EOF'
  /$$$$$$                  /$$                            /$$$$$$  /$$       /$$ /$$ /$$
 /$$__  $$                | $$                           /$$__  $$| $$      |__/| $$| $$
| $$  \__/  /$$$$$$   /$$$$$$$  /$$$$$$  /$$   /$$      | $$  \__/| $$   /$$ /$$| $$| $$  /$$$$$$$
| $$       /$$__  $$ /$$__  $$ /$$__  $$|  $$ /$$/      |  $$$$$$ | $$  /$$/| $$| $$| $$ /$$_____/
| $$      | $$  \ $$| $$  | $$| $$$$$$$$ \  $$$$/        \____  $$| $$$$$$/ | $$| $$| $$|  $$$$$$
| $$    $$| $$  | $$| $$  | $$| $$_____/  >$$  $$        /$$  \ $$| $$_  $$ | $$| $$| $$ \____  $$
|  $$$$$$/|  $$$$$$/|  $$$$$$$|  $$$$$$$ /$$/\  $$      |  $$$$$$/| $$ \  $$| $$| $$| $$ /$$$$$$$/
 \______/  \______/  \_______/ \_______/|__/  \__/       \______/ |__/  \__/|__/|__/|__/|_______/
EOF
  printf '%s\n' "$FMT_RESET"
}

print_success() {
  installed=$1
  print_banner
  success "Instalação concluída."
  printf '\n  Skills:  %s\n  Destino: %s/skills\n  Branch:  %s\n\n' "$installed" "$AGENTS_HOME" "$BRANCH"
  info "Reinicie o Codex CLI para recarregar as skills."
  printf '\n'
  for name in $installed; do printf '  $%s help\n' "$name"; done
  printf '\n'
}

main() {
  setup_colors
  requested=''
  install_all=no

  while [ $# -gt 0 ]; do
    case "$1" in
      --all) install_all=yes ;;
      --branch)
        shift
        [ $# -gt 0 ] || die "Informe uma referência após --branch."
        BRANCH=$1
        ;;
      --help|-h) usage; exit 0 ;;
      --*) usage; die "Opção desconhecida: $1" ;;
      *)
        case "$1" in *[!a-zA-Z0-9._-]*) die "Nome de skill inválido: $1" ;; esac
        requested="$requested $1"
        ;;
    esac
    shift
  done

  requested=$(printf '%s' "$requested" | sed 's/^ *//;s/ *$//')
  if [ "$install_all" != yes ] && [ -z "$requested" ]; then
    usage
    exit 1
  fi

  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t codex-skills)
  trap cleanup EXIT INT TERM

  repository="$TMP_DIR/repository"
  clone_repository "$repository"
  skills_root="$repository/skills"

  if [ "$install_all" = yes ]; then
    requested=$(all_skill_names "$skills_root")
    requested=$(printf '%s' "$requested" | sed 's/^ *//;s/ *$//')
  fi

  installed=''
  for name in $requested; do
    source="$skills_root/$name"
    [ -d "$source" ] || { warning "Skill não encontrada e ignorada: $name"; continue; }
    [ -f "$source/SKILL.md" ] || { warning "Skill inválida e ignorada: $name"; continue; }

    target="$AGENTS_HOME/skills/$name"
    install_skill "$source" "$target"
    install_agents "$source/agents" "$CODEX_HOME/agents"
    make_scripts_executable "$target/scripts"
    run_validation "$target"
    installed="$installed $name"
  done

  installed=$(printf '%s' "$installed" | sed 's/^ *//;s/ *$//')
  [ -n "$installed" ] || die "Nenhuma skill foi instalada."
  print_success "$installed"
}

main "$@"
