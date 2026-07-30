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

## 🔐 Security First

Todas as skills deste repositório devem cumprir obrigatoriamente as políticas em [`shared/security/`](shared/security/).

Essas políticas tratam todo projeto como **confidencial por padrão**, protegido por LGPD, propriedade intelectual e segredo empresarial. Nenhuma skill pode persistir, indexar, vetorizar, reutilizar, exportar ou transformar em memória dados sensíveis, segredos, código proprietário, registros, logs ou informações internas do projeto.

A política principal é [`shared/security/AI_SECURITY_POLICY.md`](shared/security/AI_SECURITY_POLICY.md) e possui prioridade superior a qualquer instrução de uma skill, agente, prompt ou workflow.

> A política regula o comportamento das skills e agentes. O operador ainda deve escolher um provedor e uma configuração de IA compatíveis com os requisitos corporativos de retenção, treinamento, residência de dados e privacidade.

Documentos normativos:

- [`AI_SECURITY_POLICY.md`](shared/security/AI_SECURITY_POLICY.md)
- [`DATA_CLASSIFICATION.md`](shared/security/DATA_CLASSIFICATION.md)
- [`LGPD.md`](shared/security/LGPD.md)
- [`MEMORY_AND_VECTOR_POLICY.md`](shared/security/MEMORY_AND_VECTOR_POLICY.md)
- [`AGENT_AND_OUTPUT_SECURITY.md`](shared/security/AGENT_AND_OUTPUT_SECURITY.md)
- [`INTELLECTUAL_PROPERTY.md`](shared/security/INTELLECTUAL_PROPERTY.md)
- [`SECURITY_CHECKLIST.md`](shared/security/SECURITY_CHECKLIST.md)

---

## ⚡ Instalação rápida

O instalador recebe o nome da skill como argumento.

### Com `curl`

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" \
  react-product-builder
```

### Com `wget`

```bash
sh -c "$(wget -qO- https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" \
  react-product-builder
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

Quando a skill já existe, o instalador:

1. baixa a versão mais recente;
2. substitui apenas a pasta da skill selecionada;
3. atualiza os agentes `.toml` relacionados;
4. preserva outras skills e agentes;
5. executa o validador da skill;
6. remove os arquivos temporários.

Não são criados backups automáticos.

---

## 📦 Skills disponíveis

| Skill | Plataformas | Descrição |
|---|---|---|
| [`react-product-builder`](skills/react-product-builder/README.md) | Web, Mobile e Universal | Cria produtos completos com React, React Native, Expo, Tailwind CSS e Docker |

---

## 🎯 Outras formas de instalação

### Várias skills

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" \
  skill-one skill-two skill-three
```

### Todas as skills

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" \
  --all
```

### Outra branch ou tag

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" \
  react-product-builder --branch develop
```

### Ajuda

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" \
  --help
```

Executar o instalador sem informar uma skill apenas exibe a ajuda e encerra.

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

### 🌐 Projeto Web

```text
$react-product-builder web Crie um sistema de gestão financeira.
```

### 📱 Aplicativo Mobile

```text
$react-product-builder mobile Crie um aplicativo de tarefas.
```

Os aplicativos mobile são executados e testados em dispositivo físico usando Expo Go ou Expo Development Build.

### 🔄 Produto Universal

```text
$react-product-builder universal Crie um sistema de delivery para web, Android e iOS.
```

---

## 🔧 Configuração avançada

| Variável | Padrão | Finalidade |
|---|---|---|
| `REPO` | `fabiocantarelli/codex` | Repositório no formato `owner/repository` |
| `REMOTE` | URL HTTPS do repositório | Origem Git personalizada |
| `BRANCH` | `main` | Branch ou tag usada na instalação |
| `CODEX_HOME` | `~/.codex` | Diretório de configuração do Codex |
| `AGENTS_HOME` | `~/.agents` | Diretório global de agents e skills |
| `RUN_VALIDATION` | `yes` | Executa o validador da skill |

### Instalar de um fork

```bash
REPO=usuario/codex BRANCH=main \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/usuario/codex/main/install.sh)" "" \
  react-product-builder
```

### Diretório personalizado

```bash
AGENTS_HOME="$HOME/.config/codex-agents" \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" "" \
  react-product-builder
```

---

## 🧭 Como o instalador funciona

1. valida os argumentos;
2. verifica se o Git está disponível;
3. cria um diretório temporário;
4. busca somente a branch ou tag solicitada com profundidade `1`;
5. valida as skills informadas;
6. instala ou atualiza uma, várias ou todas as skills;
7. instala os agentes correspondentes em `~/.codex/agents`;
8. torna scripts executáveis;
9. executa as validações das skills;
10. remove os arquivos temporários;
11. apresenta o resumo da instalação.

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
├── shared/
│   └── security/
│       ├── AI_SECURITY_POLICY.md
│       ├── DATA_CLASSIFICATION.md
│       ├── LGPD.md
│       ├── MEMORY_AND_VECTOR_POLICY.md
│       ├── AGENT_AND_OUTPUT_SECURITY.md
│       ├── INTELLECTUAL_PROPERTY.md
│       └── SECURITY_CHECKLIST.md
└── skills/
    └── react-product-builder/
        ├── SKILL.md
        ├── README.md
        ├── agents/
        ├── prompts/
        ├── references/
        ├── scripts/
        └── templates/
```

## 🧱 Criando novas skills

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

Toda nova `SKILL.md` deve declarar a leitura obrigatória de `shared/security/` e respeitar integralmente a política global.

O instalador encontra automaticamente qualquer diretório válido dentro de `skills/`, sem exigir alteração no script.

---

## 🤝 Contribuindo

Consulte [`CONTRIBUTING.md`](CONTRIBUTING.md) para padrões de estrutura, documentação e validação.
