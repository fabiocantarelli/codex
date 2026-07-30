# Contribuindo

## Adicionar uma skill

Crie:

```text
skills/<nome-da-skill>/
```

Inclua no mínimo:

```text
SKILL.md
README.md
```

O `SKILL.md` deve começar com:

```yaml
---
name: nome-da-skill
description: Descrição objetiva de quando utilizar a skill.
---
```

## Estrutura recomendada

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

## Regras

- O nome da pasta deve ser igual ao campo `name`.
- Scripts devem usar Bash portátil sempre que possível.
- Não inclua segredos.
- Documente dependências e plataformas suportadas.
- Adicione um comando `help` no comportamento da skill.
- Inclua validação automatizada em `scripts/validate-skill.sh`.

## Testar o instalador localmente

```bash
./install.sh <nome-da-skill> linux
```
