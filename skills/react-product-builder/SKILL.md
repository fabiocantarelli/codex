---
name: react-product-builder
description: Cria produtos completos em React Web, React Native com Expo ou arquitetura Universal. Use para novos sistemas, SPAs, dashboards, painéis, portais, landing pages, aplicativos móveis e produtos multiplataforma.
---

# React Product Builder

Você atua como coordenador de uma equipe especializada em produto, UX, design e engenharia React.

Sua missão é transformar uma ideia em um produto completo, funcional, navegável, responsivo, acessível, testado, validado e preparado para evolução.

Nunca entregue apenas:

- componentes isolados;
- uma tela estática;
- um protótipo descartável;
- botões sem comportamento;
- rotas quebradas;
- código sem validação;
- uma aplicação que dependa de ferramentas instaladas no host quando o modo exigir Docker.

## Help

Quando o usuário invocar:

```text
$react-product-builder help
```

não inicie implementação.

Explique:

### Modos disponíveis

#### Web

Indicado para:

- sistemas administrativos;
- dashboards;
- portais;
- landing pages;
- SPAs;
- aplicações internas;
- produtos SaaS.

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
- pnpm.

Exemplo:

```text
$react-product-builder web Crie um CRM para pequenas empresas.
```

#### Mobile

Indicado para:

- aplicativos Android;
- aplicativos iOS;
- aplicativos móveis internos;
- produtos com uso em campo;
- aplicações com câmera, localização ou notificações.

Stack padrão:

- React Native;
- TypeScript;
- Expo;
- Expo Router;
- NativeWind;
- React Native Reusables ou componentes próprios;
- TanStack Query;
- React Hook Form;
- Zod;
- Zustand somente quando necessário;
- AsyncStorage;
- SecureStore;
- React Native Testing Library;
- Maestro ou Detox quando aplicável;
- EAS Build.

Exemplo:

```text
$react-product-builder mobile Crie um aplicativo de controle financeiro.
```

#### Universal

Indicado para produtos com:

- Web;
- Android;
- iOS;
- compartilhamento de domínio;
- compartilhamento de tipos;
- compartilhamento de schemas;
- compartilhamento de regras de negócio;
- compartilhamento de camada de API.

Exemplo:

```text
$react-product-builder universal Crie um sistema de delivery para web e mobile.
```

### Fluxo interno

1. Descoberta
2. Arquitetura
3. Design System
4. Implementação
5. Testes
6. Revisão
7. Correções
8. Entrega

### Comandos úteis

```text
$react-product-builder help
$react-product-builder web <descrição>
$react-product-builder mobile <descrição>
$react-product-builder universal <descrição>
```

Depois de explicar, encerre a resposta e aguarde uma nova solicitação.

## Detecção de plataforma

Determine o modo nesta ordem:

1. valor explícito `web`, `mobile` ou `universal`;
2. contexto do pedido;
3. requisitos funcionais;
4. dispositivos esperados;
5. integrações pedidas.

Considere Web quando houver termos como:

- dashboard;
- painel;
- portal;
- navegador;
- desktop;
- landing page;
- SPA;
- sistema administrativo.

Considere Mobile quando houver:

- Android;
- iOS;
- Expo;
- aplicativo;
- câmera;
- GPS;
- push notification;
- biometria;
- uso offline;
- dispositivo físico.

Considere Universal quando houver:

- web e mobile;
- Android, iOS e navegador;
- código compartilhado;
- produto multiplataforma.

Se a escolha for materialmente ambígua, pergunte apenas:

```text
O projeto será Web, Mobile ou Universal?
```

Não pergunte quando o contexto já permitir uma decisão segura.

## Leitura obrigatória

Sempre leia:

- `references/shared/product-discovery.md`
- `references/shared/react-typescript.md`
- `references/shared/design-system.md`
- `references/shared/accessibility.md`
- `references/shared/testing.md`
- `references/shared/performance.md`
- `references/shared/delivery.md`

No modo Web, leia também:

- `references/web/architecture.md`
- `references/web/tailwind-shadcn.md`
- `references/web/docker.md`
- `references/web/browser-validation.md`

No modo Mobile, leia também:

- `references/mobile/architecture.md`
- `references/mobile/expo.md`
- `references/mobile/nativewind.md`
- `references/mobile/mobile-ux.md`
- `references/mobile/permissions-storage.md`
- `references/mobile/testing.md`

No modo Universal, leia também:

- `references/universal/architecture.md`
- `references/universal/code-sharing.md`
- `references/universal/platform-boundaries.md`

## Orquestração

Use um fluxo sequencial.

### Fase 1 — Arquitetura

Inicie o agente:

```text
react-product-architect
```

Envie:

- solicitação integral;
- plataforma;
- diretório;
- arquivos existentes;
- restrições;
- referências obrigatórias;
- critérios de conclusão.

O Architect não altera arquivos.

Ele deve produzir:

- resumo do produto;
- usuários;
- fluxos;
- páginas ou telas;
- rotas;
- arquitetura;
- navegação;
- design system;
- estratégia de dados;
- estados;
- riscos;
- critérios de conclusão.

### Fase 2 — Implementação

Use:

```text
react-web-builder
```

para Web.

Use:

```text
react-mobile-builder
```

para Mobile.

Use:

```text
react-universal-builder
```

para Universal.

Envie:

- pedido original;
- plano consolidado;
- decisões de UX;
- design system;
- arquitetura;
- critérios de conclusão;
- regras de ambiente;
- referências da plataforma.

### Fase 3 — Revisão

Inicie:

```text
react-product-reviewer
```

Envie:

- pedido original;
- plataforma;
- plano;
- resumo da implementação;
- validações;
- critérios de conclusão.

Classifique achados:

- bloqueadores;
- importantes;
- opcionais.

### Fase 4 — Correções

Envie bloqueadores e achados importantes ao Builder responsável.

Repita revisão quando houver mudanças substanciais.

Não considere o produto concluído com bloqueadores.

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

## Descoberta

Determine:

- problema;
- público;
- objetivo;
- ação principal;
- tarefas;
- páginas ou telas;
- fluxos;
- dados;
- permissões;
- integrações;
- erros;
- vazios;
- restrições;
- uso offline;
- dispositivos;
- requisitos de acessibilidade.

Quando faltarem detalhes secundários:

1. assuma decisões razoáveis;
2. documente as suposições;
3. avance.

Pergunte apenas quando uma ausência impedir materialmente o trabalho.

## Planejamento

Antes de editar, apresente brevemente:

- plataforma;
- páginas ou telas;
- rotas;
- navegação;
- arquitetura;
- features;
- componentes;
- dados;
- identidade visual;
- estratégia de ambiente;
- critérios de conclusão.

Depois avance sem aguardar confirmação, salvo risco real de sobrescrever conteúdo importante.

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
- evitar interface genérica;
- validar antes de concluir.

## Modo Web

### Stack

Use por padrão:

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

### Docker obrigatório

Toda criação, instalação, execução, teste, lint, typecheck, build e produção deve ocorrer em Docker.

O host deve precisar apenas de:

- Docker;
- Docker Compose;
- Git;
- Make, quando disponível.

Nunca execute no host:

- Node;
- npm;
- npx;
- pnpm;
- Vite;
- Vitest;
- Playwright.

### Arquivos obrigatórios

Crie:

```text
Dockerfile
Dockerfile.prod
docker-compose.yml
docker-compose.prod.yml
.dockerignore
.env.example
Makefile
README.md
docker/nginx/default.conf
```

### Serviço

Use:

```text
frontend
```

O Vite deve escutar em:

```text
0.0.0.0
```

Use:

- volume do código;
- volume separado para `node_modules`;
- healthcheck;
- hot reload;
- restart adequado.

### Execução

```bash
docker compose up -d --build
```

Preferencialmente:

```bash
make up
```

### Alterações futuras

Mantenha o ambiente ativo.

Para alterações comuns em:

- React;
- TypeScript;
- CSS;
- Tailwind;
- componentes;
- páginas;
- rotas;

use hot reload.

Não faça rebuild sem necessidade.

Reinicie quando alterar:

- variáveis de ambiente;
- Vite;
- Tailwind;
- configuração carregada no startup.

Rebuild quando alterar:

- Dockerfile;
- imagem base;
- dependências do sistema;
- Docker Compose estrutural.

### Validação Web

Execute:

```bash
docker compose config
docker compose build
docker compose up -d
docker compose ps
docker compose logs --tail=100 frontend
docker compose exec frontend pnpm lint
docker compose exec frontend pnpm typecheck
docker compose exec frontend pnpm test -- --run
docker compose exec frontend pnpm build
```

Valide produção:

```bash
docker compose -f docker-compose.prod.yml config
docker compose -f docker-compose.prod.yml build
docker compose -f docker-compose.prod.yml up -d
docker compose -f docker-compose.prod.yml ps
```

Confirme resposta HTTP.

## Modo Mobile

### Stack

Use por padrão:

- React Native;
- TypeScript;
- Expo;
- Expo Router;
- NativeWind;
- TanStack Query;
- React Hook Form;
- Zod;
- Zustand somente quando necessário;
- AsyncStorage;
- SecureStore;
- React Native Testing Library;
- Maestro ou Detox quando aplicável;
- EAS Build.

### Ambiente

Use Docker para:

- criação;
- instalação;
- lint;
- typecheck;
- testes;
- scripts;
- validações automatizáveis.

A execução visual pode ocorrer fora do container por:

- Expo Go;
- Android Emulator;
- iOS Simulator;
- dispositivo físico;
- development build.

Não tente executar iOS Simulator em ambiente que não seja macOS.

Não tente ocultar limitações de emuladores em Docker.

### Criação

Use Expo e Expo Router.

Evite React Native CLI puro, salvo solicitação explícita.

### UX Mobile

Considere:

- safe areas;
- teclado;
- gestos;
- orientação;
- áreas de toque;
- navegação nativa;
- feedback tátil;
- conectividade;
- uso offline;
- permissões;
- deep links;
- acessibilidade;
- tema do sistema.

### Validação Mobile

Execute por Docker, quando aplicável:

```bash
pnpm lint
pnpm typecheck
pnpm test
```

Valide também:

- Expo Doctor;
- rotas;
- permissões;
- configuração Android;
- configuração iOS;
- assets;
- splash;
- ícone;
- deep links;
- variáveis de ambiente.

Quando houver dispositivo ou emulador:

1. execute o app;
2. verifique logs;
3. teste navegação;
4. teste teclado;
5. teste permissões;
6. teste diferentes tamanhos;
7. teste modo claro e escuro.

## Modo Universal

### Objetivo

Compartilhe o que for realmente multiplataforma.

Compartilhe:

- tipos;
- schemas;
- contratos;
- regras de domínio;
- camada de API;
- validações;
- hooks independentes de plataforma;
- utilitários;
- tokens conceituais.

Separe:

- componentes visuais;
- navegação;
- armazenamento;
- permissões;
- APIs nativas;
- acessibilidade específica;
- comportamento de teclado;
- estilos incompatíveis.

### Estrutura sugerida

Use monorepo quando fizer sentido:

```text
apps/
├── web/
└── mobile/

packages/
├── api/
├── domain/
├── schemas/
├── shared/
└── config/
```

Não force compartilhamento de UI quando isso prejudicar UX ou manutenção.

### Validação Universal

Valide separadamente:

- Web;
- Mobile;
- pacotes compartilhados;
- tipos;
- schemas;
- contratos;
- builds.

## Design

A aplicação deve parecer um produto real.

Evite:

- dashboards genéricos;
- cards em excesso;
- badges demais;
- gradientes gratuitos;
- sombras pesadas;
- cores demais;
- bordas em tudo;
- fontes pequenas;
- animações chamativas;
- telas sem função;
- componentes padrão sem adaptação;
- sidebars sem necessidade.

Priorize:

- hierarquia;
- ação principal;
- poucos cliques;
- feedback;
- consistência;
- acessibilidade;
- responsividade;
- linguagem visual coerente com o domínio.

## Dados

Quando não houver API:

- crie tipos;
- crie contratos;
- crie camada de serviço;
- centralize mocks;
- simule latência;
- simule erros relevantes;
- mantenha componentes desacoplados;
- prepare integração futura.

## Estados obrigatórios

Considere:

- loading;
- skeleton;
- vazio;
- erro;
- sucesso;
- retry;
- sem permissão;
- indisponível;
- sem conexão;
- resultado vazio;
- envio;
- confirmação;
- ação destrutiva;
- atualização;
- cancelamento.

## Acessibilidade

Siga WCAG AA na Web e boas práticas equivalentes no Mobile.

Valide:

- semântica;
- labels;
- contraste;
- foco;
- teclado;
- leitores de tela;
- áreas de toque;
- headings;
- landmarks;
- mensagens de erro;
- redução de movimento;
- dialogs;
- menus;
- estados selecionados.

## Testes

Priorize:

- fluxos principais;
- navegação;
- formulários;
- validação;
- loading;
- erro;
- vazio;
- ações destrutivas;
- integrações críticas.

Evite testes frágeis baseados em detalhes internos.

## Browser, dispositivo e screenshots

Quando houver browser:

1. abra;
2. verifique console;
3. verifique rede;
4. teste fluxos;
5. teste resoluções;
6. analise screenshots;
7. corrija;
8. repita.

Quando houver dispositivo ou emulador:

1. execute;
2. verifique logs;
3. teste navegação;
4. teste teclado;
5. teste gestos;
6. teste permissões;
7. teste orientação;
8. teste temas.

## Entrega

Ao finalizar, informe:

### Produto

- plataforma;
- objetivo;
- público;
- fluxos.

### Implementado

- páginas ou telas;
- rotas;
- componentes;
- interações;
- formulários;
- estados;
- mocks.

### Design

- identidade;
- tokens;
- UX;
- responsividade;
- acessibilidade.

### Arquitetura

- estrutura;
- bibliotecas;
- dados;
- compartilhamento;
- limites de plataforma.

### Ambiente

- Docker;
- Expo;
- portas;
- volumes;
- emuladores;
- dispositivos;
- comandos.

### Validações

Informe resultados reais.

### Execução

Forneça os comandos corretos para o modo escolhido.

### Pendências

Liste apenas pendências reais.

## Critério final

Só considere concluído quando:

1. arquitetura estiver definida;
2. fluxos estiverem funcionais;
3. páginas ou telas estiverem conectadas;
4. testes relevantes tiverem sido executados;
5. lint e typecheck tiverem sido executados;
6. build ou validação equivalente tiver sido executada;
7. ambiente aplicável estiver funcionando;
8. revisão final não possuir bloqueadores.
