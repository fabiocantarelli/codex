# 🧩 Codex Skills

Uma coleção de **skills reutilizáveis para o Codex CLI**, organizadas para instalação global, evolução independente e compartilhamento entre diferentes projetos.

Cada skill pode incluir instruções, agentes especializados, referências técnicas, templates, scripts de automação e documentação própria.

---

## ⚡ Instalação rápida

Instale uma skill diretamente pelo terminal, sem clonar o repositório.

### Com `curl`

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" -- react-product-builder
```

### Com `wget`

```bash
sh -c "$(wget -qO- https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" -- react-product-builder
```

O instalador detecta automaticamente o sistema operacional.

Sistemas suportados:

- 🐧 Linux;
- 🪟 Windows via Git Bash, MSYS2 ou Cygwin;
- 🍎 macOS;
- 🐧 WSL, tratado como Linux.

> No WSL, a instalação é feita no `$HOME` da distribuição Linux, onde o Codex CLI normalmente está configurado.

### Sobrescrever a detecção do sistema

O sistema pode ser informado como segundo argumento:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" -- react-product-builder linux
```

Valores aceitos:

```text
linux
windows
mac
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

### Criar um projeto Web

```text
$react-product-builder web Crie um sistema de gestão financeira.
```

### Criar um aplicativo Mobile

```text
$react-product-builder mobile Crie um aplicativo de tarefas.
```

### Criar um produto Universal

```text
$react-product-builder universal Crie um sistema de delivery para Web, Android e iOS.
```

No modo Mobile, a validação visual ocorre em **dispositivo físico**, usando:

- Expo Go;
- Expo Development Build, quando houver módulos nativos não suportados pelo Expo Go.

---

## 🛠️ Como o instalador funciona

O `install.sh` executa o seguinte fluxo:

1. 🔎 detecta o sistema operacional;
2. ⬇️ baixa a versão atual do repositório;
3. ✅ valida se a skill solicitada existe;
4. 💾 cria backup de uma instalação anterior;
5. 📁 instala a skill em `~/.agents/skills/<nome>`;
6. 🤖 instala os agentes em `~/.codex/agents`;
7. 🔐 ajusta as permissões dos scripts;
8. 🧪 executa o validador da skill;
9. ♻️ preserva todas as outras skills já instaladas.

### Diretórios padrão

```text
~/.agents/skills/<nome-da-skill>
~/.codex/agents
```

Os diretórios podem ser personalizados com:

```bash
CODEX_HOME=/caminho/.codex
AGENTS_HOME=/caminho/.agents
```

---

## 📖 Ajuda do instalador

Com `curl`:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" -- help
```

Com `wget`:

```bash
sh -c "$(wget -qO- https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" -- help
```

---

## 💻 Instalação local

Também é possível clonar o repositório e executar o instalador localmente:

```bash
git clone https://github.com/fabiocantarelli/codex.git
cd codex
./install.sh react-product-builder
```

Para indicar o sistema manualmente:

```bash
./install.sh react-product-builder linux
```

---

## 🗂️ Estrutura do repositório

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

## 🧱 Padrão para novas skills

Cada skill deve ficar isolada em:

```text
skills/<nome-da-skill>/
```

Estrutura recomendada:

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

### Arquivos obrigatórios

| Arquivo | Finalidade |
|---|---|
| `SKILL.md` | Define nome, descrição, regras e comportamento da skill |
| `README.md` | Documenta instalação, uso, exemplos e limitações |

As demais pastas são opcionais e devem ser adicionadas somente quando agregarem valor real.

---

## 🤝 Contribuindo

Consulte o arquivo [`CONTRIBUTING.md`](CONTRIBUTING.md) para conhecer:

- convenções de nomes;
- estrutura recomendada;
- requisitos de documentação;
- regras para agentes e templates;
- processo de validação.

---

## 🔄 Atualizando uma skill

Execute novamente o mesmo comando de instalação:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh)" -- react-product-builder
```

O instalador cria um backup automático da versão anterior antes de atualizar.

---

## 🧹 Remoção manual

Para remover somente a skill:

```bash
rm -rf ~/.agents/skills/react-product-builder
```

Os agentes instalados ficam em:

```text
~/.codex/agents
```

Eles podem ser removidos manualmente quando não forem mais utilizados.

---

## 📄 Licença

Adicione uma licença ao repositório antes de distribuir ou aceitar contribuições externas em maior escala.
