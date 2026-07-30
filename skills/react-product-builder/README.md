# React Product Builder Skill

## O que é

Uma skill global para Codex CLI que cria produtos React completos nos modos:

- Web
- Mobile
- Universal

## Como chamar

```text
$react-product-builder help
```

```text
$react-product-builder web Crie um sistema de gestão de chamados.
```

```text
$react-product-builder mobile Crie um app de exercícios.
```

```text
$react-product-builder universal Crie um sistema de delivery.
```

## Comportamento do Help

Ao receber `help`, a skill explica:

- plataformas;
- stacks;
- diferenças;
- Docker;
- Expo;
- exemplos;
- fluxo interno.

Ela não cria arquivos nessa execução.

## Fluxo

```text
Architect
   ↓
Builder da plataforma
   ↓
Reviewer
   ↓
Correções
   ↓
Validação
```

## Web

Docker obrigatório para tudo.

## Mobile

Docker para dependências e validações.

Execução visual via Expo Go, emulador, simulador ou dispositivo.

## Universal

Monorepo recomendado quando houver compartilhamento real.

## Diretórios

```text
references/shared/
references/web/
references/mobile/
references/universal/
prompts/
templates/
scripts/
```
