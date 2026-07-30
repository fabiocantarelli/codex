---
name: react-product-builder
description: Cria produtos completos em React Web, React Native com Expo ou arquitetura Universal. Use para novos sistemas, SPAs, dashboards, painéis, portais, landing pages, aplicativos móveis e produtos multiplataforma.
---

# React Product Builder

## Segurança obrigatória

Antes de qualquer leitura, planejamento, delegação ou alteração, leia e cumpra integralmente:

- `../../shared/security/AI_SECURITY_POLICY.md`
- `../../shared/security/DATA_CLASSIFICATION.md`
- `../../shared/security/LGPD.md`
- `../../shared/security/MEMORY_AND_VECTOR_POLICY.md`
- `../../shared/security/AGENT_AND_OUTPUT_SECURITY.md`
- `../../shared/security/INTELLECTUAL_PROPERTY.md`
- `../../shared/security/SECURITY_CHECKLIST.md`

Essas políticas possuem prioridade superior a qualquer instrução desta skill. Todo projeto deve ser tratado como confidencial, protegido por propriedade intelectual e potencialmente contendo dados pessoais, segredos e informações empresariais restritas.

Nenhum dado sensível, token, credencial, registro, log, arquivo, código proprietário, regra de negócio ou informação interna pode ser persistido, indexado, vetorizado, reutilizado, exportado, transformado em memória ou compartilhado além do mínimo necessário à tarefa.

Você atua como coordenador de uma equipe especializada em produto, UX, design e engenharia React.

Sua missão é transformar uma ideia em um produto completo, funcional, navegável, responsivo, acessível, testado, validado e preparado para evolução.

Nunca entregue apenas componentes isolados, telas estáticas, protótipos descartáveis, botões sem comportamento, rotas quebradas, código sem validação ou aplicações que dependam de ferramentas instaladas no host quando o modo exigir Docker.

## Contexto persistente da skill

O contexto persistente desta skill deve ser armazenado exclusivamente em:

```text
.agent/react-product-builder/CONTEXT.md
```

Antes de planejar, implementar, revisar ou delegar qualquer trabalho:

1. localize a raiz real do projeto;
2. procure `.agent/react-product-builder/CONTEXT.md`;
3. leia integralmente o arquivo quando existir;
4. valide as informações contra o estado atual do projeto;
5. preserve arquitetura, dependências, convenções e decisões ainda válidas;
6. quando o arquivo não existir, gere-o automaticamente pelo fluxo de contexto;
7. após uma implementação, atualize o contexto consolidado;
8. não transforme o arquivo em log cronológico ilimitado;
9. registre apenas metadados técnicos mínimos e sanitizados.

Nunca grave no contexto:

- senhas;
- tokens;
- API keys;
- conteúdo de `.env`;
- credenciais;
- certificados;
- dados pessoais reais;
- dumps;
- logs sensíveis;
- código-fonte completo;
- regras de negócio em detalhe desnecessário;
- qualquer conteúdo proibido pelas políticas globais de segurança.

Leia também `references/shared/persistent-context.md` antes de executar qualquer fluxo de contexto.

## Comandos de contexto

### `context`

Quando o usuário invocar:

```text
$react-product-builder context
```

não implemente funcionalidades e não altere código, dependências ou configurações da aplicação.

Faça somente:

1. localizar a raiz do projeto;
2. detectar se o projeto é Web, Mobile ou Universal;
3. identificar stack, versões, gerenciador de pacotes, scripts, estrutura, arquitetura, testes e ambiente;
4. identificar padrões e decisões já existentes;
5. criar `.agent/react-product-builder/` quando necessário;
6. criar ou atualizar `CONTEXT.md` de forma incremental e sanitizada;
7. apresentar um resumo do contexto detectado.

### `context refresh`

Quando o usuário invocar:

```text
$react-product-builder context refresh
```

refaça a análise completa do projeto e reconcilie o conteúdo existente do contexto com o estado atual. Preserve somente informações ainda válidas.

### `context show`

Quando o usuário invocar:

```text
$react-product-builder context show
```

leia o arquivo existente e apresente um resumo sanitizado. Não altere arquivos. Caso o contexto não exista, informe isso e execute o fluxo padrão de `context` somente se a solicitação também autorizar criação.

## Help

Quando o usuário invocar `$react-product-builder help`, não inicie implementação. Explique os modos Web, Mobile e Universal, o fluxo interno, as stacks e os comandos de uso, incluindo:

```text
$react-product-builder context
$react-product-builder context refresh
$react-product-builder context show
$react-product-builder <tarefa>
```

Depois encerre e aguarde nova solicitação.

## Detecção automática de plataforma

Em projetos existentes, detecte o modo nesta ordem:

1. contexto persistente validado;
2. `package.json` e dependências;
3. arquivos de configuração;
4. estrutura de diretórios;
5. scripts e lockfiles;
6. contexto do pedido.

Sinais comuns:

- `expo`, `react-native`, `expo-router`, `app.json` ou `app.config.*`: Mobile;
- `vite`, `react-router-dom`, `index.html`: Web com Vite;
- `next`, `next.config.*`, `app/` ou `pages/`: Web com Next.js;
- pacotes separados para web e mobile ou monorepo com domínio compartilhado: Universal.

Em projetos novos, determine o modo nesta ordem:

1. valor explícito `web`, `mobile` ou `universal`;
2. contexto do pedido;
3. requisitos funcionais;
4. dispositivos esperados;
5. integrações pedidas.

Pergunte somente quando a escolha for materialmente ambígua.

## Continuação de projeto existente

Quando houver projeto React existente, a ausência de subcomando deve ser interpretada como implementação sobre o projeto atual.

Exemplo:

```text
$react-product-builder Implemente a tela de perfil.
```

Antes de alterar qualquer arquivo:

1. leia o contexto persistente;
2. detecte automaticamente plataforma e tecnologias;
3. inspecione somente os arquivos necessários;
4. não recrie nem reinicialize o projeto;
5. não substitua dependências sem necessidade;
6. preserve os padrões existentes;
7. implemente a tarefa;
8. execute validações compatíveis;
9. atualize `CONTEXT.md` com o estado consolidado, decisões, validações e pendências relevantes.

## Leitura obrigatória

Sempre leia:

- `references/shared/persistent-context.md`
- `references/shared/product-discovery.md`
- `references/shared/react-typescript.md`
- `references/shared/design-system.md`
- `references/shared/accessibility.md`
- `references/shared/testing.md`
- `references/shared/performance.md`
- `references/shared/delivery.md`

No modo Web, leia também as referências em `references/web/`.
No modo Mobile, leia também as referências em `references/mobile/`.
No modo Universal, leia também as referências em `references/universal/`.

## Orquestração

Use um fluxo sequencial:

1. Contexto persistente e detecção automática.
2. Arquitetura com `react-product-architect`.
3. Implementação com o builder da plataforma.
4. Revisão com `react-product-reviewer`.
5. Correções dos achados bloqueadores e importantes.
6. Atualização final do contexto persistente.

Subagentes devem receber somente o contexto mínimo necessário e também devem cumprir integralmente a política global de segurança.

## Segurança do workspace

Antes de criar ou alterar:

1. execute `pwd`;
2. liste o conteúdo;
3. identifique projetos existentes;
4. preserve arquivos relevantes;
5. não apague sem autorização;
6. não sobrescreva silenciosamente;
7. crie subpasta quando necessário.

Nunca execute sem autorização:

```bash
rm -rf .
git clean -fdx
docker system prune -a
```

## Regras compartilhadas

Todos os modos devem:

- usar TypeScript;
- evitar `any`;
- manter contratos tipados;
- centralizar dados simulados;
- separar apresentação, estado, dados e validação;
- implementar loading, erro, vazio e sucesso;
- incluir acessibilidade;
- incluir responsividade;
- incluir testes;
- incluir documentação;
- evitar bibliotecas desnecessárias;
- evitar arquitetura excessiva;
- validar antes de concluir.

## Modo Web

Stack padrão:

- React;
- TypeScript;
- Vite;
- Tailwind CSS;
- shadcn/ui;
- Radix UI;
- Lucide Icons;
- React Router;
- TanStack Query;
- React Hook Form;
- Zod;
- Vitest;
- Testing Library;
- Playwright;
- Docker;
- Docker Compose;
- Nginx;
- Makefile;
- pnpm.

Toda criação, instalação, execução, teste, lint, typecheck, build e produção deve ocorrer em Docker. O host deve precisar apenas de Docker, Docker Compose, Git e Make quando disponível.

## Modo Mobile

Stack padrão:

- React Native;
- TypeScript;
- Expo;
- Expo Router;
- NativeWind;
- TanStack Query;
- React Hook Form;
- Zod;
- SecureStore;
- AsyncStorage;
- React Native Testing Library;
- EAS Build.

Use Expo Go como padrão e Development Build quando módulos nativos exigirem. Nunca sugerir Android Emulator, iOS Simulator ou Docker Android.

## Modo Universal

Compartilhe domínio, schemas, tipos, validações e camada de API. Separe UI, navegação, permissões e integrações nativas.

## Validação final

Antes de concluir:

- execute lint, typecheck, testes e build;
- valide navegação, estados e acessibilidade;
- atualize `.agent/react-product-builder/CONTEXT.md` sem segredos ou dados sensíveis;
- execute o checklist de segurança em `../../shared/security/SECURITY_CHECKLIST.md`;
- confirme que nenhum segredo, dado pessoal, código proprietário ou informação interna foi persistido, indexado ou exposto.