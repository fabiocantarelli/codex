# 🧩 Codex Skills

Uma coleção de **skills reutilizáveis para o Codex CLI**, organizada para instalação global, evolução independente e compartilhamento entre diferentes projetos.

Cada skill pode incluir:

- 🧠 instruções especializadas;
- 🤖 agentes auxiliares;
- 📚 referências técnicas;
- 🧱 templates;
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

O argumento vazio `""` ocupa o `$0` do `sh -c`. O nome da skill é entregue ao instalador como primeiro argumento real.

> Por segurança, em ambientes corporativos ou ao usar o projeto pela primeira vez, baixe e revise o script antes de executá-lo.

```bash
curl -fsSLO https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh
less install.sh
sh install.sh react-product-builder
```

---

## 📦 Skills disponíveis

| Skill | Plataformas | Descrição |
|---|---|---|
| [`react-product-builder`](skills/react-product-builder/README.md) | Web, Mobile e Universal | Cria produtos completos com React, React Native, Expo, Tailwind CSS e Docker |

---

## 🚀 Primeiros passos

Depois da instalação, reinicie o Codex CLI:

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

### Instalação não interativa

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" \
  react-product-builder --unattended
```

### Substituir instalação existente

A versão anterior é preservada automaticamente em um diretório de backup.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" \
  react-product-builder --force
```

### Preservar instalação existente

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" \
  react-product-builder --keep-existing
```

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

Assim como o instalador do Oh My Zsh, o comportamento pode ser customizado com variáveis de ambiente.

| Variável | Padrão | Finalidade |
|---|---|---|
| `REPO` | `fabiocantarelli/codex` | Repositório no formato `owner/repository` |
| `REMOTE` | URL HTTPS do repositório | Origem Git personalizada |
| `BRANCH` | `main` | Branch ou tag usada na instalação |
| `CODEX_HOME` | `~/.codex` | Diretório de configuração do Codex |
| `AGENTS_HOME` | `~/.agents` | Diretório global de agents e skills |
| `SKILL` | vazio | Nome da skill sem usar argumento posicional |
| `UNATTENDED` | `no` | Desabilita perguntas interativas |
| `KEEP_EXISTING` | `no` | Mantém a instalação atual |
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

O processo foi inspirado no instalador do Oh My Zsh, mas adaptado ao modelo de skills do Codex:

1. valida os argumentos;
2. verifica se o Git está disponível;
3. cria um diretório temporário;
4. inicializa um repositório Git vazio;
5. busca somente a branch ou tag solicitada com profundidade `1`;
6. verifica se a skill existe;
7. cria backup da instalação anterior;
8. instala a skill em `~/.agents/skills/<nome>`;
9. instala agentes em `~/.codex/agents`;
10. torna scripts executáveis;
11. executa a validação da skill;
12. remove os arquivos temporários;
13. apresenta as instruções finais.

O instalador não remove outras skills já instaladas.

---

## 💾 Backups

Ao atualizar uma skill, a versão existente é movida para um diretório como:

```text
~/.agents/skills/react-product-builder.pre-codex-skills-2026-07-30_12-00-00
```

Arquivos de agentes que já existirem também recebem backup antes da substituição.

---

## 🖥️ Compatibilidade

| Ambiente | Status | Observação |
|---|---:|---|
| 🐧 Linux | ✅ | Suporte nativo |
| 🐧 WSL | ✅ | Recomendado para Codex CLI no Windows |
| 🍎 macOS | ✅ | Suporte nativo |
| 🪟 Git Bash | ✅ | Usa o `$HOME` do ambiente Git Bash |
| 🪟 MSYS2 | ✅ | Requer Git instalado |
| 🪟 Cygwin | ✅ | Requer Git instalado |
| PowerShell puro | ⚠️ | Execute pelo WSL, Git Bash ou shell POSIX |

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

Use a seguinte convenção:

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

### Arquivos mínimos

Uma skill simples precisa de:

```text
SKILL.md
README.md
```

O instalador reconhece automaticamente novas pastas dentro de `skills/`, portanto não precisa ser alterado para cada skill adicionada.

---

## 🔒 Segurança

Executar scripts remotos exige confiança na origem. Uma alternativa mais segura é baixar, revisar e executar localmente:

```bash
curl -fsSLO https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh
sha256sum install.sh
less install.sh
sh install.sh react-product-builder
```

O instalador:

- não utiliza `sudo`;
- não altera o shell padrão;
- não instala pacotes do sistema;
- não apaga instalações anteriores;
- mantém backups antes de substituir arquivos;
- opera somente nos diretórios configurados para Codex e agents.

---

## 🤝 Contribuição

Consulte o [`CONTRIBUTING.md`](CONTRIBUTING.md) para adicionar novas skills, referências, templates ou melhorias no instalador.
