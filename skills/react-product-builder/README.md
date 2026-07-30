# React Product Builder Skill

## O que é

Uma skill global para Codex CLI que cria e continua produtos React completos nos modos:

- Web
- Mobile
- Universal

A skill detecta automaticamente a plataforma e as tecnologias de projetos existentes antes de implementar alterações.

## Como chamar

### Ajuda

```text
$react-product-builder help
```

### Analisar o projeto e criar contexto

```text
$react-product-builder context
```

Cria ou atualiza:

```text
.agent/react-product-builder/CONTEXT.md
```

Sem alterar código, dependências ou configurações da aplicação.

### Reanalisar completamente

```text
$react-product-builder context refresh
```

### Mostrar o contexto atual

```text
$react-product-builder context show
```

### Criar projeto Web

```text
$react-product-builder web Crie um sistema de gestão de chamados.
```

### Criar projeto Mobile

```text
$react-product-builder mobile Crie um app de exercícios.
```

### Criar produto Universal

```text
$react-product-builder universal Crie um sistema de delivery.
```

### Continuar projeto existente

```text
$react-product-builder Implemente uma tela de perfil.
```

Nesse caso, a skill:

1. lê o contexto persistente;
2. detecta automaticamente se o projeto é Web, Mobile ou Universal;
3. identifica framework, bibliotecas, versões e padrões existentes;
4. preserva a arquitetura atual;
5. implementa a tarefa;
6. executa as validações compatíveis;
7. atualiza o contexto consolidado.

## Contexto persistente

O arquivo:

```text
.agent/react-product-builder/CONTEXT.md
```

mantém o estado técnico consolidado do projeto para novas sessões.

Ele pode registrar:

- plataforma detectada;
- stack e versões;
- estrutura e arquitetura;
- gerenciador de pacotes;
- comandos de desenvolvimento e validação;
- funcionalidades existentes;
- decisões vigentes;
- estado da última implementação;
- pendências e riscos.

Ele nunca deve conter:

- senhas;
- tokens;
- API keys;
- conteúdo de `.env`;
- credenciais;
- certificados;
- dados pessoais reais;
- código-fonte completo;
- dumps ou logs sensíveis.

O contexto representa o estado atual e não um histórico ilimitado de tarefas.

## Comportamento do Help

Ao receber `help`, a skill explica:

- plataformas;
- stacks;
- diferenças;
- contexto persistente;
- Docker;
- Expo;
- exemplos;
- fluxo interno.

Ela não cria arquivos nessa execução.

## Fluxo

```text
Contexto e detecção automática
   ↓
Architect
   ↓
Builder da plataforma
   ↓
Reviewer
   ↓
Correções
   ↓
Validação
   ↓
Atualização do contexto
```

## Web

Docker obrigatório para criação, instalação, execução, testes e build.

## Mobile

Use Expo Go como padrão e Development Build quando módulos nativos exigirem.

Não use Android Emulator, iOS Simulator ou Docker Android.

## Universal

Monorepo recomendado quando houver compartilhamento real de domínio, tipos, schemas e camada de API.

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

A especificação do contexto persistente está em:

```text
references/shared/persistent-context.md
```