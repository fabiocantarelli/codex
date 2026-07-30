#!/bin/sh
#
# Codex Skills Installer
#
# Menu interativo:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)"
#
# Instalação direta:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" react-product-builder
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
    FMT_CYAN=$(printf '\033[36m')
    FMT_BOLD=$(printf '\033[1m')
    FMT_RESET=$(printf '\033[0m')
  else
    FMT_RED=''
    FMT_GREEN=''
    FMT_YELLOW=''
    FMT_BLUE=''
    FMT_CYAN=''
    FMT_BOLD=''
    FMT_RESET=''
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

  sh -c "$(wget -qO- https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)"

Instalação direta:

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" <skill>

Instalar todas sem menu:

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" --all

Uso local:

  sh install.sh [skill ...] [opções]

Opções:

  --all              Instala todas as skills disponíveis
  --branch <ref>     Usa outra branch ou tag
  --help             Exibe esta ajuda

No menu interativo, informe:

  1                 Uma skill
  1,3               Várias skills
  1 3               Várias skills
  all               Todas as skills
  q                 Cancelar

Se uma skill já estiver instalada, ela será atualizada no mesmo diretório.

EOF
}

cleanup() {
  if [ -n "${TMP_DIR:-}" ] && [ -d "$TMP_DIR" ]; then rm -rf "$TMP_DIR"; fi
}

clone_repository() {
  csr_destination=$1
  command_exists git || die "git não está instalado."
  info "Baixando catálogo de skills..."
  umask g-w,o-w
  GIT_TERMINAL_PROMPT=0 git init --quiet "$csr_destination"
  (
    cd "$csr_destination"
    git config core.eol lf
    git config core.autocrlf false
    git remote add origin "$REMOTE"
    GIT_TERMINAL_PROMPT=0 git fetch --quiet --depth=1 origin "$BRANCH"
    git checkout --quiet -b "$BRANCH" "origin/$BRANCH"
  ) || {
    rm -rf "$csr_destination"
    die "Não foi possível baixar $REMOTE na referência $BRANCH."
  }
}

skill_description() {
  sd_skill_file="$1/SKILL.md"
  if [ -f "$sd_skill_file" ]; then
    sed -n 's/^description:[[:space:]]*//p' "$sd_skill_file" | head -n 1
  fi
}

build_skill_index() {
  bsi_skills_root=$1
  bsi_index_file=$2
  bsi_number=0
  : > "$bsi_index_file"
  for bsi_skill_path in "$bsi_skills_root"/*; do
    [ -d "$bsi_skill_path" ] || continue
    [ -f "$bsi_skill_path/SKILL.md" ] || continue
    bsi_number=$((bsi_number + 1))
    printf '%s|%s\n' "$bsi_number" "$(basename "$bsi_skill_path")" >> "$bsi_index_file"
  done
  [ "$bsi_number" -gt 0 ] || die "Nenhuma skill foi encontrada no repositório."
}

print_skill_menu() {
  psm_skills_root=$1
  psm_index_file=$2
  {
    printf '\n%s%sSkills disponíveis%s\n\n' "$FMT_BOLD" "$FMT_CYAN" "$FMT_RESET"
    while IFS='|' read -r psm_number psm_name; do
      psm_description=$(skill_description "$psm_skills_root/$psm_name")
      printf '  %s%s)%s %s%s%s\n' "$FMT_BOLD" "$psm_number" "$FMT_RESET" "$FMT_BOLD" "$psm_name" "$FMT_RESET"
      [ -n "$psm_description" ] && printf '     %s\n' "$psm_description"
      printf '\n'
    done < "$psm_index_file"
    printf '  %sa)%s Instalar todas\n' "$FMT_BOLD" "$FMT_RESET"
    printf '  %sq)%s Cancelar\n\n' "$FMT_BOLD" "$FMT_RESET"
    printf 'Selecione uma ou mais skills [ex.: 1,3 ou all]: '
  } > /dev/tty
}

all_skill_names() { cut -d'|' -f2 "$1" | tr '\n' ' '; }

resolve_menu_selection() {
  rms_selection=$1
  rms_index_file=$2
  rms_result=''
  rms_normalized=$(printf '%s' "$rms_selection" | tr ',;' '  ')
  case "$rms_normalized" in
    q|Q|quit|exit) return 2 ;;
    a|A|all|ALL|'*') all_skill_names "$rms_index_file"; return 0 ;;
  esac
  for rms_token in $rms_normalized; do
    case "$rms_token" in *[!0-9]*|'') return 1 ;; esac
    rms_name=$(awk -F'|' -v number="$rms_token" '$1 == number { print $2; exit }' "$rms_index_file")
    [ -n "$rms_name" ] || return 1
    case " $rms_result " in *" $rms_name "*) ;; *) rms_result="$rms_result $rms_name" ;; esac
  done
  rms_result=$(printf '%s' "$rms_result" | sed 's/^ *//;s/ *$//')
  [ -n "$rms_result" ] || return 1
  printf '%s\n' "$rms_result"
}

select_skills_interactively() {
  ssi_skills_root=$1
  ssi_index_file=$2
  [ -r /dev/tty ] && [ -w /dev/tty ] || die "Nenhuma skill foi informada e não há terminal interativo disponível."
  while :; do
    print_skill_menu "$ssi_skills_root" "$ssi_index_file"
    IFS= read -r ssi_answer < /dev/tty || exit 1
    if ssi_result=$(resolve_menu_selection "$ssi_answer" "$ssi_index_file"); then
      printf '%s\n' "$ssi_result"
      return 0
    else
      ssi_status=$?
      if [ "$ssi_status" -eq 2 ]; then
        printf '%sInstalação cancelada.%s\n' "$FMT_BLUE" "$FMT_RESET" > /dev/tty
        exit 0
      fi
      printf '%sSeleção inválida. Informe números separados por vírgula ou use all.%s\n' "$FMT_YELLOW" "$FMT_RESET" > /dev/tty
    fi
  done
}

install_skill() {
  ins_source=$1
  ins_target=$2
  mkdir -p "$(dirname "$ins_target")"
  if [ -d "$ins_target" ]; then info "Atualizando $(basename "$ins_target")..."; rm -rf "$ins_target"; else info "Instalando $(basename "$ins_target")..."; fi
  cp -R "$ins_source" "$ins_target"
}

install_agents() {
  ia_source_dir=$1
  ia_target_dir=$2
  [ -d "$ia_source_dir" ] || return 0
  mkdir -p "$ia_target_dir"
  for ia_agent_file in "$ia_source_dir"/*.toml; do
    [ -f "$ia_agent_file" ] || continue
    cp "$ia_agent_file" "$ia_target_dir/$(basename "$ia_agent_file")"
  done
}

make_scripts_executable() {
  mse_scripts_dir=$1
  [ -d "$mse_scripts_dir" ] || return 0
  for mse_script in "$mse_scripts_dir"/*.sh; do [ -f "$mse_script" ] && chmod +x "$mse_script"; done
}

run_validation() {
  rv_skill_dir=$1
  rv_validator="$rv_skill_dir/scripts/validate-skill.sh"
  [ "$RUN_VALIDATION" = yes ] || return 0
  [ -x "$rv_validator" ] || return 0
  info "Validando $(basename "$rv_skill_dir")..."
  "$rv_validator"
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
  ps_installed=$1
  print_banner
  success "Instalação concluída."
  printf '\n  Skills:  %s\n  Destino: %s/skills\n  Branch:  %s\n\n' "$ps_installed" "$AGENTS_HOME" "$BRANCH"
  info "Reinicie o Codex CLI para recarregar as skills."
  printf '\n'
  for ps_name in $ps_installed; do printf '  $%s help\n' "$ps_name"; done
  printf '\n'
}

main() {
  setup_colors
  main_requested_skills=''
  main_install_all=no
  while [ $# -gt 0 ]; do
    case "$1" in
      --all) main_install_all=yes ;;
      --branch) shift; [ $# -gt 0 ] || die "Informe uma referência após --branch."; BRANCH=$1 ;;
      --help|-h) usage; exit 0 ;;
      --*) usage; die "Opção desconhecida: $1" ;;
      *) case "$1" in *[!a-zA-Z0-9._-]*) die "Nome de skill inválido: $1" ;; esac; main_requested_skills="$main_requested_skills $1" ;;
    esac
    shift
  done

  TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t codex-skills)
  trap cleanup EXIT INT TERM
  main_repository="$TMP_DIR/repository"
  clone_repository "$main_repository"
  main_skills_root="$main_repository/skills"
  main_index_file="$TMP_DIR/skills.index"
  build_skill_index "$main_skills_root" "$main_index_file"

  if [ "$main_install_all" = yes ]; then
    main_requested_skills=$(all_skill_names "$main_index_file")
  else
    main_requested_skills=$(printf '%s' "$main_requested_skills" | sed 's/^ *//;s/ *$//')
  fi
  if [ -z "$main_requested_skills" ]; then
    main_requested_skills=$(select_skills_interactively "$main_skills_root" "$main_index_file")
  fi

  main_installed=''
  for main_skill_name in $main_requested_skills; do
    main_skill_source="$main_skills_root/$main_skill_name"
    if [ ! -d "$main_skill_source" ]; then warning "Skill não encontrada e ignorada: $main_skill_name"; continue; fi
    [ -f "$main_skill_source/SKILL.md" ] || { warning "Skill inválida e ignorada: $main_skill_name"; continue; }
    main_skill_target="$AGENTS_HOME/skills/$main_skill_name"
    install_skill "$main_skill_source" "$main_skill_target"
    install_agents "$main_skill_source/agents" "$CODEX_HOME/agents"
    make_scripts_executable "$main_skill_target/scripts"
    run_validation "$main_skill_target"
    main_installed="$main_installed $main_skill_name"
  done
  main_installed=$(printf '%s' "$main_installed" | sed 's/^ *//;s/ *$//')
  [ -n "$main_installed" ] || die "Nenhuma skill foi instalada."
  print_success "$main_installed"
}

main "$@"