# 🧩 Codex Skills

Uma coleção de **skills reutilizáveis para o Codex CLI**, organizada para instalação global, evolução independente e compartilhamento entre projetos.

Cada skill pode incluir:

- 🧠 instruções especializadas;
- 🤖 agentes auxiliares;
- 📚 referências técnicas;
- 🧱 templates reutilizáveis;
- ⚙️ scripts de automação;
- ✅ validações próprias;
- 📖 documentação dedicada.

---

## ⚡ Instalação rápida

O instalador segue o mesmo conceito popularizado pelo Oh My Zsh: um script POSIX pode ser baixado e executado diretamente com `curl` ou `wget`.

### Com `curl`

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" react-product-builder
```

### Com `wget`

```bash
sh -c "$(wget -qO- https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" react-product-builder
```

O argumento vazio `""` ocupa o `$0` do `sh -c`. O nome da skill é recebido pelo instalador como primeiro argumento real.

> Em ambientes corporativos, baixe e revise o script antes de executá-lo.

```bash
curl -fsSLO https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh
less install.sh
sh install.sh react-product-builder
```

---

## 🔄 Instalação e atualização

O mesmo comando serve para instalar e atualizar.

Quando a skill ainda não existe:

```text
~/.agents/skills/react-product-builder
```

ela é criada.

Quando já existe, o instalador:

1. baixa a versão mais recente;
2. substitui a pasta da skill no mesmo local;
3. atualiza os agentes `.toml` com o mesmo nome;
4. preserva as demais skills e agentes;
5. executa o validador da skill;
6. remove os arquivos temporários.

Não são criados backups automáticos.

Para atualizar, execute novamente:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" react-product-builder
```

---

## 📦 Skills disponíveis

| Skill | Plataformas | Descrição |
|---|---|---|
| [`react-product-builder`](skills/react-product-builder/README.md) | Web, Mobile e Universal | Cria produtos completos com React, React Native, Expo, Tailwind CSS e Docker |

---

## 🚀 Primeiros passos

Depois da instalação ou atualização, reinicie o Codex CLI:

```bash
codex
```

Consulte a ajuda da skill:

```text
$react-product-builder help
```

### 🌐 Criar um projeto Web

```text
$react-product-builder web Crie um sistema de gestão financeira.
```

### 📱 Criar um aplicativo Mobile

```text
$react-product-builder mobile Crie um aplicativo de tarefas.
```

Os aplicativos mobile são executados e testados em dispositivo físico usando Expo Go ou Expo Development Build.

### 🔄 Criar um produto Universal

```text
$react-product-builder universal Crie um sistema de delivery para web, Android e iOS.
```

---

## 🛠️ Opções do instalador

### Instalar outra branch ou tag

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" \
  react-product-builder --branch develop
```

### Exibir ajuda

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" --help
```

---

## 🔧 Configuração avançada

O comportamento pode ser customizado com variáveis de ambiente.

| Variável | Padrão | Finalidade |
|---|---|---|
| `REPO` | `fabiocantarelli/codex` | Repositório no formato `owner/repository` |
| `REMOTE` | URL HTTPS do repositório | Origem Git personalizada |
| `BRANCH` | `main` | Branch ou tag usada na instalação |
| `CODEX_HOME` | `~/.codex` | Diretório de configuração do Codex |
| `AGENTS_HOME` | `~/.agents` | Diretório global de agents e skills |
| `SKILL` | vazio | Nome da skill sem argumento posicional |
| `RUN_VALIDATION` | `yes` | Executa o validador da skill |

### Instalar de um fork

```bash
REPO=usuario/codex BRANCH=main \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/usuario/codex/main/install.sh)" "" \
  react-product-builder
```

### Definir diretório personalizado

```bash
AGENTS_HOME="$HOME/.config/codex-agents" \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" \
  react-product-builder
```

---

## 🧭 Como o instalador funciona

O fluxo foi inspirado no instalador do Oh My Zsh e adaptado ao modelo de skills do Codex:

1. valida os argumentos;
2. verifica se o Git está disponível;
3. cria um diretório temporário;
4. inicializa um repositório Git vazio;
5. busca somente a branch ou tag solicitada com profundidade `1`;
6. verifica se a skill existe;
7. instala ou atualiza a skill em `~/.agents/skills/<nome>`;
8. instala ou atualiza os agentes em `~/.codex/agents`;
9. torna os scripts executáveis;
10. executa a validação da skill;
11. remove os arquivos temporários;
12. apresenta as instruções finais.

O instalador não remove outras skills ou agentes que não façam parte da skill selecionada.

---

## 🖥️ Compatibilidade

| Ambiente | Status | Observação |
|---|---:|---|
| 🐧 Linux | ✅ | Suporte nativo |
| 🐧 WSL | ✅ | Recomendado para Codex CLI no Windows |
| 🍎 macOS | ✅ | Suporte nativo |
| 🪟 Git Bash | ✅ | Usa o `$HOME` do Git Bash |
| 🪟 MSYS2 | ✅ | Requer Git instalado |
| 🪟 Cygwin | ✅ | Requer Git instalado |
| PowerShell puro | ⚠️ | Use WSL, Git Bash ou outro shell POSIX |

---

## 📁 Estrutura do repositório

```text
.
├── install.sh
├── README.md
├── CONTRIBUTING.md
├── skills.json
└── skills/
    └── react-product-builder/
        ├── SKILL.md
        ├── README.md
        ├── agents/
        ├── prompts/
        ├── references/
        │   ├── shared/
        │   ├── web/
        │   ├── mobile/
        │   └── universal/
        ├── scripts/
        └── templates/
            ├── web/
            ├── mobile/
            └── universal/
```

---

## 🧱 Criando novas skills

Use a convenção:

```text
skills/<nome-da-skill>/
├── SKILL.md
├── README.md
├── agents/
├── prompts/
├── references/
├── scripts/
└── templates/
```

Uma skill simples precisa apenas de:

```text
SKILL.md
README.md
```

O instalador encontra automaticamente qualquer diretório dentro de `skills/`.

---

## 🤝 Contribuindo

Consulte [`CONTRIBUTING.md`](CONTRIBUTING.md) para padrões de estrutura, documentação e validação.
