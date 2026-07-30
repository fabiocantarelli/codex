# Contexto Persistente do React Product Builder

## Objetivo

O contexto persistente permite que a skill recupere o estado técnico consolidado de um projeto em sessões futuras sem depender do histórico da conversa.

O arquivo oficial é:

```text
.agent/react-product-builder/CONTEXT.md
```

Esse arquivo pertence ao projeto e deve conter somente metadados técnicos mínimos, atuais e sanitizados.

## Regras fundamentais

- Leia o contexto antes de planejar, implementar, revisar ou delegar.
- Valide o conteúdo contra os arquivos atuais antes de confiar nele.
- Atualize o arquivo após mudanças relevantes.
- Preserve decisões ainda válidas.
- Remova informações obsoletas durante `context refresh`.
- Não transforme o documento em um log completo de tarefas.
- Não copie código-fonte completo para o contexto.
- Não registre segredos, credenciais, dados pessoais ou conteúdo de `.env`.

## Estrutura mínima

```markdown
---
schema_version: 1
skill: react-product-builder
updated_at: 2026-07-30T20:00:00-03:00
project_root: .
platform: mobile
---

# Contexto do Projeto

## Identificação

- Nome:
- Plataforma:
- Estado:

## Stack detectada

- Framework:
- Linguagem:
- Navegação:
- Estilos:
- Estado:
- Formulários:
- Validação:
- Persistência:
- Testes:

## Versões principais

- Node.js:
- React:
- React Native ou framework Web:
- TypeScript:

## Gerenciador de pacotes

- Gerenciador:
- Lockfile:

## Estrutura relevante

- `src/`:
- `app/`:
- `components/`:
- `features/`:
- `services/`:

## Arquitetura e padrões

- Organização:
- Convenções:
- Aliases:
- Estratégia de dados:
- Estratégia de estado:

## Comandos detectados

### Desenvolvimento

```bash
<comando>
```

### Testes

```bash
<comando>
```

### Lint

```bash
<comando>
```

### Typecheck

```bash
<comando>
```

### Build

```bash
<comando>
```

## Funcionalidades existentes

- ...

## Decisões vigentes

- ...

## Estado da última implementação

- Solicitação:
- Resultado:
- Arquivos principais alterados:
- Validações executadas:

## Pendências

- ...

## Riscos e observações

- ...
```

## Detecção de plataforma

Considere Mobile quando forem encontrados sinais como:

- `expo`;
- `react-native`;
- `expo-router`;
- `app.json`;
- `app.config.js`, `app.config.ts` ou equivalentes.

Considere Web quando forem encontrados sinais como:

- `vite`;
- `react-router-dom`;
- `next`;
- `index.html`;
- `next.config.*`;
- `vite.config.*`.

Considere Universal quando houver:

- pacotes separados para web e mobile;
- monorepo com domínio compartilhado;
- tipos, schemas ou camada de API compartilhados entre plataformas.

## Atualização incremental

Após uma implementação:

1. atualize `updated_at`;
2. mantenha a stack e arquitetura atuais;
3. consolide funcionalidades existentes;
4. registre somente a última implementação relevante;
5. atualize decisões vigentes;
6. remova pendências resolvidas;
7. adicione novas pendências e riscos;
8. registre os comandos de validação efetivamente executados.

Não acumule todas as tarefas anteriores. O documento deve representar o estado atual.

## Context refresh

Em `context refresh`:

1. reanalise o projeto desde a raiz;
2. reconcilie dependências, scripts, estrutura e versões;
3. mantenha decisões confirmadas pelos arquivos atuais;
4. remova tecnologias e comandos que não existam mais;
5. preserve informações manuais somente quando não contradisserem o projeto;
6. atualize o documento de forma sanitizada.

## Context show

Em `context show`:

- não altere arquivos;
- apresente um resumo do conteúdo existente;
- masque qualquer informação sensível encontrada;
- informe claramente quando o contexto estiver ausente ou aparentemente desatualizado.

## Conteúdo proibido

Nunca grave:

```text
.env
.env.*
*.pem
*.key
*.pfx
*.p12
*.crt
id_rsa
id_ed25519
tokens
senhas
API keys
client secrets
cookies
sessões
dados pessoais reais
dumps
logs brutos
código-fonte completo
```

Quando for necessário registrar uma integração, use descrição abstrata:

```text
Autenticação: OAuth 2.0 configurado por variáveis de ambiente.
```

Nunca:

```text
CLIENT_SECRET=valor-real
```

## Git

O arquivo pode ser versionado quando a equipe desejar compartilhar o contexto técnico entre sessões e desenvolvedores.

Arquivos temporários nunca devem ser criados dentro dessa pasta. Caso sejam necessários durante a execução, use diretório temporário externo e remova-o ao concluir.