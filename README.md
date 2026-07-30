# Codex Skills

Repositório de skills reutilizáveis para o Codex CLI.

A estrutura foi preparada para receber várias skills independentes, cada uma com documentação, referências, templates, scripts e agentes próprios.

## Instalação rápida

### Linux ou WSL

```bash
curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh \
  | bash -s -- react-product-builder linux
```

Com `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh \
  | bash -s -- react-product-builder linux
```

### macOS

```bash
curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh \
  | bash -s -- react-product-builder mac
```

### Windows

Execute pelo Git Bash, MSYS2, Cygwin ou WSL:

```bash
curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh \
  | bash -s -- react-product-builder windows
```

> No WSL, prefira instalar como `linux`, porque o Codex CLI e o diretório `$HOME` pertencem ao ambiente Linux.

## Skills disponíveis

| Skill | Finalidade |
|---|---|
| [`react-product-builder`](skills/react-product-builder/README.md) | Cria produtos React Web, React Native com Expo ou aplicações universais |

## Ajuda do instalador

```bash
curl -fsSL https://raw.githubusercontent.com/fabiocantarelli/codex/main/install.sh \
  | bash -s -- help linux
```

Também é possível clonar o repositório:

```bash
git clone https://github.com/fabiocantarelli/codex.git
cd codex
./install.sh react-product-builder linux
```

## Como o instalador funciona

O instalador:

1. baixa o repositório;
2. valida se a skill existe;
3. cria backup da instalação anterior;
4. copia a skill para `~/.agents/skills/<skill>`;
5. copia agentes `.toml` para `~/.codex/agents`;
6. torna scripts executáveis;
7. executa o validador da skill;
8. preserva outras skills instaladas.

## Estrutura do repositório

```text
.
├── install.sh
├── README.md
├── CONTRIBUTING.md
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

## Convenção para novas skills

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

Apenas `SKILL.md` e `README.md` são obrigatórios para uma skill simples.

## Uso após a instalação

```text
$react-product-builder help
```

```text
$react-product-builder web Crie um sistema de gestão financeira.
```

```text
$react-product-builder mobile Crie um aplicativo de tarefas.
```

Os aplicativos mobile são testados em dispositivo físico via Expo Go ou Expo Development Build.
