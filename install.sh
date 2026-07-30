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
SELECTED_SKILLS=''

command_exists() { command -v "$1" >/dev/null 2>&1; }

setup_colors() {
  if [ -t 1 ]; then
    FMT_RED=$(printf '\033[31m')
    FMT_GREEN=$(printf '\033[32m')
    FMT_YELLOW=$(printf '\033[33m')
    FMT_BLUE=$(printf '\033[34m')
    FMT_CYAN=$(printf '\033[36m')
    FMT_BOLD=$(printf '\033[1m')
    FMT_RESET=$(printf '\033[0m')
  else
    FMT_RED=''; FMT_GREEN=''; FMT_YELLOW=''; FMT_BLUE=''; FMT_CYAN=''; FMT_BOLD=''; FMT_RESET=''
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

Menu interativo:
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)"

Instalação direta:
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" <skill>

Instalar todas:
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" --all

Opções:
  --all
  --branch <ref>
  --help
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

skill_description() {
  file="$1/SKILL.md"
  [ -f "$file" ] && sed -n 's/^description:[[:space:]]*//p' "$file" | head -n 1
}

build_skill_index() {
  root=$1
  index=$2
  number=0
  : > "$index"
  for path in "$root"/*; do
    [ -d "$path" ] || continue
    [ -f "$path/SKILL.md" ] || continue
    number=$((number + 1))
    printf '%s|%s\n' "$number" "$(basename "$path")" >> "$index"
  done
  [ "$number" -gt 0 ] || die "Nenhuma skill foi encontrada no repositório."
}

all_skill_names() {
  cut -d'|' -f2 "$1" | tr '\n' ' '
}

print_skill_menu() {
  root=$1
  index=$2
  printf '\n%s%sSkills disponíveis%s\n\n' "$FMT_BOLD" "$FMT_CYAN" "$FMT_RESET"
  while IFS='|' read -r number name; do
    description=$(skill_description "$root/$name")
    printf '  %s%s)%s %s%s%s\n' "$FMT_BOLD" "$number" "$FMT_RESET" "$FMT_BOLD" "$name" "$FMT_RESET"
    [ -n "$description" ] && printf '     %s\n' "$description"
    printf '\n'
  done < "$index"
  printf '  %sa)%s Instalar todas\n' "$FMT_BOLD" "$FMT_RESET"
  printf '  %sq)%s Cancelar\n\n' "$FMT_BOLD" "$FMT_RESET"
  printf 'Selecione uma ou mais skills [ex.: 1,3 ou all]: '
}

resolve_selection() {
  selection=$1
  index=$2
  result=''
  normalized=$(printf '%s' "$selection" | tr ',;' '  ')

  case "$normalized" in
    q|Q|quit|exit) return 2 ;;
    a|A|all|ALL|'*') SELECTED_SKILLS=$(all_skill_names "$index"); return 0 ;;
  esac

  for token in $normalized; do
    case "$token" in *[!0-9]*|'') return 1 ;; esac
    name=$(awk -F'|' -v n="$token" '$1 == n { print $2; exit }' "$index")
    [ -n "$name" ] || return 1
    case " $result " in *" $name "*) ;; *) result="$result $name" ;; esac
  done

  result=$(printf '%s' "$result" | sed 's/^ *//;s/ *$//')
  [ -n "$result" ] || return 1
  SELECTED_SKILLS=$result
  return 0
}

select_skills_interactively() {
  root=$1
  index=$2
  [ -r /dev/tty ] && [ -w /dev/tty ] || die "Não há terminal interativo disponível."

  while :; do
    print_skill_menu "$root" "$index" > /dev/tty
    IFS= read -r answer < /dev/tty || exit 1

    if resolve_selection "$answer" "$index"; then
      return 0
    fi

    status=$?
    if [ "$status" -eq 2 ]; then
      info "Instalação cancelada."
      exit 0
    fi

    warning "Seleção inválida. Informe números separados por vírgula ou use 'all'."
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

  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t codex-skills)
  trap cleanup EXIT INT TERM

  repository="$TMP_DIR/repository"
  clone_repository "$repository"

  skills_root="$repository/skills"
  index_file="$TMP_DIR/skills.index"
  build_skill_index "$skills_root" "$index_file"

  if [ "$install_all" = yes ]; then
    requested=$(all_skill_names "$index_file")
  else
    requested=$(printf '%s' "$requested" | sed 's/^ *//;s/ *$//')
  fi

  if [ -z "$requested" ]; then
    select_skills_interactively "$skills_root" "$index_file"
    requested=$SELECTED_SKILLS
  fi

  installed=''
  for name in $requested; do
    source="$skills_root/$name"
    if [ ! -d "$source" ]; then warning "Skill não encontrada e ignorada: $name"; continue; fi
    if [ ! -f "$source/SKILL.md" ]; then warning "Skill inválida e ignorada: $name"; continue; fi

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
