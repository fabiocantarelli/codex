---
name: react-product-builder
version: 1.1.0
description: Cria e evolui produtos React Web, React Native com Expo ou arquitetura Universal, preservando a stack existente e validando compatibilidade antes de alterar dependências.
---

# React Product Builder

## Segurança obrigatória

Antes de qualquer alteração, cumpra integralmente:

- `../../shared/security/AI_SECURITY_POLICY.md`
- `../../shared/security/DATA_CLASSIFICATION.md`
- `../../shared/security/LGPD.md`
- `../../shared/security/MEMORY_AND_VECTOR_POLICY.md`
- `../../shared/security/AGENT_AND_OUTPUT_SECURITY.md`
- `../../shared/security/INTELLECTUAL_PROPERTY.md`
- `../../shared/security/SECURITY_CHECKLIST.md`

Trate o projeto como confidencial. Não persista segredos, credenciais, conteúdo de `.env`, dados pessoais, logs sensíveis ou código-fonte completo no contexto.

## Objetivo

Entregar alterações funcionais, tipadas, testadas e compatíveis com a stack real do projeto. Evite reanálises extensas, dependências desnecessárias e mudanças fora do escopo.

## Modo rápido obrigatório

Para tarefas em projetos existentes, use este fluxo por padrão:

1. localizar a raiz do projeto;
2. ler `.agent/react-product-builder/CONTEXT.md` somente quando existir;
3. inspecionar `package.json`, lockfile e arquivos diretamente relacionados à tarefa;
4. executar a verificação de compatibilidade antes de instalar, atualizar ou remover dependências;
5. alterar somente o conjunto mínimo de arquivos;
6. executar primeiro validações focadas;
7. executar a suíte completa somente quando a alteração justificar;
8. atualizar o contexto apenas quando houver mudança arquitetural, de stack, comandos ou decisões permanentes.

Não execute descoberta completa, arquitetura completa, revisão completa ou atualização do contexto em toda tarefa pequena.

### Classificação da tarefa

Classifique antes de agir:

- **Pequena:** correção localizada, estilo, texto, componente isolado ou configuração pontual.
- **Média:** funcionalidade com múltiplos arquivos dentro de um módulo existente.
- **Grande:** nova arquitetura, novo produto, migração de stack, mudança transversal ou requisito ambíguo.

Aplique:

- pequena: implementação direta + validações focadas;
- média: plano curto + implementação + revisão direcionada;
- grande: architect → builder → reviewer.

Subagentes são opcionais. Use-os somente quando reduzirem risco ou trabalho, e nunca por rotina.

## Contexto persistente

O arquivo oficial é:

```text
.agent/react-product-builder/CONTEXT.md
```

Use-o como cache técnico consolidado, não como log de cada tarefa.

Leia o contexto quando existir, mas valide apenas as informações relevantes contra o estado atual. Não faça varredura completa do projeto sem necessidade.

Crie ou atualize o contexto quando ocorrer uma destas mudanças:

- plataforma ou framework;
- versão principal de runtime, React, Expo ou React Native;
- arquitetura ou estrutura de módulos;
- gerenciador de pacotes ou lockfile;
- comandos de desenvolvimento, teste ou build;
- decisão permanente relevante;
- risco ou pendência que afete próximas sessões.

Não atualize o contexto para ajustes locais sem impacto duradouro.

## Comandos de contexto

### `context`

Analise a stack e crie ou atualize o contexto, sem implementar funcionalidades.

### `context refresh`

Refaça a análise completa e remova informações obsoletas.

### `context show`

Mostre um resumo sanitizado do contexto sem alterar arquivos.

### `help`

Explique os modos Web, Mobile e Universal e os comandos disponíveis. Não implemente nada.

### `version` e `--version`

Quando o usuário invocar:

```text
$react-product-builder version
$react-product-builder --version
```

não analise o projeto e não altere arquivos.

Leia a versão registrada em `VERSION` e apresente somente:

- nome da skill;
- versão instalada;
- origem `fabiocantarelli/codex`;
- resumo curto das capacidades principais.

Formato esperado:

```text
React Product Builder v1.1.0
Origem: fabiocantarelli/codex
Recursos: React Web, React Native, Expo, Universal, validação de compatibilidade e fluxo rápido adaptativo.
```

O arquivo `VERSION` é a fonte oficial da versão. O campo `version` do frontmatter deve permanecer sincronizado com ele.

## Detecção automática

Em projetos existentes, detecte a plataforma nesta ordem:

1. `package.json` e dependências instaladas;
2. lockfile;
3. arquivos de configuração;
4. contexto persistente, quando ainda válido;
5. estrutura diretamente relevante;
6. pedido do usuário.

Sinais comuns:

- `expo`, `react-native`, `expo-router`, `app.json` ou `app.config.*`: Mobile;
- `vite`, `react-router-dom`, `index.html`: Web com Vite;
- `next`, `next.config.*`, `app/` ou `pages/`: Web com Next.js;
- pacotes separados para web/mobile ou monorepo compartilhado: Universal.

Em projetos novos, use o modo explícito `web`, `mobile` ou `universal`. Pergunte apenas quando a escolha for materialmente ambígua.

## Preservação de projetos existentes

Antes de alterar:

1. não reinicialize o projeto;
2. não substitua dependências sem necessidade;
3. preserve versões, arquitetura e padrões existentes;
4. leia somente os arquivos necessários;
5. não faça upgrade de SDK, framework ou runtime sem autorização explícita;
6. não assuma que a versão mais recente é compatível ou a mais utilizada;
7. não use comandos genéricos de instalação quando a plataforma possuir resolvedor próprio de versões.

## Gate obrigatório de compatibilidade

Antes de instalar, remover ou atualizar qualquer dependência, gere uma matriz mínima com:

- framework e versão;
- React;
- React Native, quando aplicável;
- Expo SDK, quando aplicável;
- Node.js;
- gerenciador de pacotes;
- pacote solicitado e versão compatível;
- suporte no runtime utilizado, como Expo Go ou Development Build.

Use primeiro as fontes locais do projeto:

- `package.json`;
- lockfile;
- `app.json` ou `app.config.*`;
- `node_modules/<pacote>/package.json`, quando disponível;
- scripts e configurações existentes.

Quando a compatibilidade não puder ser comprovada localmente, consulte documentação oficial atual antes de modificar dependências. Não adivinhe.

Se houver incompatibilidade, pare antes da alteração e apresente a opção compatível ou a necessidade de migração.

## Regras específicas para Expo e React Native

### Compatibilidade do SDK

Em projetos Expo existentes:

1. leia a versão exata de `expo` no `package.json`;
2. identifique as versões instaladas de React e React Native;
3. execute `npx expo-doctor` antes de concluir mudanças de dependências ou configuração;
4. use `npx expo install <pacote>` em vez de `npm install <pacote>` para dependências mantidas ou versionadas pelo ecossistema Expo;
5. use `npx expo install --check` para detectar divergências;
6. use `npx expo install --fix` somente quando a correção estiver dentro do escopo e não implicar migração de SDK;
7. nunca atualize Expo SDK automaticamente;
8. nunca escolha um SDK por popularidade presumida;
9. preserve o SDK atual quando ele suportar a tarefa;
10. quando o Expo Go instalado no dispositivo não suportar o SDK do projeto, informe explicitamente a incompatibilidade e proponha uma destas rotas:
   - alinhar o projeto a um SDK suportado, mediante autorização;
   - usar Development Build compatível;
   - usar uma versão compatível do cliente apenas quando oficialmente disponível.

### Expo Go e módulos nativos

Antes de recomendar Expo Go, confirme que todos os módulos necessários são suportados pelo runtime do Expo Go para o SDK atual.

Quando houver módulo nativo não incluído no Expo Go, use Development Build. Não tente contornar incompatibilidade com ajustes aleatórios de versão.

### Docker e LAN

Para desenvolvimento Mobile, use Docker para dependências, Metro, lint, testes e typecheck. O dispositivo físico executa o app via Expo Go ou Development Build.

Ao configurar acesso LAN:

- o Metro deve ouvir em `0.0.0.0`;
- a porta deve estar publicada no Docker Compose;
- o endereço anunciado deve ser o IPv4 do host acessível pelo celular;
- valide separadamente `localhost`, IP do host e acesso por outro dispositivo;
- não confunda publicação de porta com liberação no firewall;
- não sugira Tunnel quando o requisito for LAN;
- não sugira Android Emulator, iOS Simulator ou Docker Android.

## Leitura sob demanda

Leia somente referências relacionadas à tarefa.

Referências compartilhadas:

- `references/shared/persistent-context.md`: somente para comandos de contexto ou atualização estrutural;
- `references/shared/product-discovery.md`: criação de produto ou requisito ambíguo;
- `references/shared/react-typescript.md`: alterações de implementação React/TypeScript;
- `references/shared/design-system.md`: UI, componentes ou identidade visual;
- `references/shared/accessibility.md`: UI e interação;
- `references/shared/testing.md`: criação ou alteração de testes;
- `references/shared/performance.md`: problema ou requisito de desempenho;
- `references/shared/delivery.md`: build, Docker, publicação ou entrega.

Leia referências de `references/web/`, `references/mobile/` ou `references/universal/` somente conforme a plataforma e a tarefa.

## Orquestração adaptativa

### Tarefa pequena

```text
Compatibilidade rápida → implementação direta → lint/typecheck/teste focado
```

### Tarefa média

```text
Compatibilidade → plano curto → implementação → revisão direcionada → validações
```

### Tarefa grande

```text
Contexto → compatibilidade → architect → builder → reviewer → correções → validação completa
```

## Segurança do workspace

Antes de criar ou alterar:

1. execute `pwd`;
2. confirme a raiz do projeto;
3. preserve arquivos relevantes;
4. não apague nem sobrescreva silenciosamente.

Nunca execute sem autorização:

```bash
rm -rf .
git clean -fdx
docker system prune -a
```

## Regras compartilhadas

Todos os modos devem:

- usar TypeScript;
- evitar `any` sem justificativa;
- manter contratos tipados;
- preservar apresentação, estado, dados e validação separados quando o projeto já usar essa separação;
- implementar estados de loading, erro, vazio e sucesso quando aplicáveis;
- incluir acessibilidade nas alterações de UI;
- evitar bibliotecas desnecessárias;
- evitar arquitetura excessiva;
- validar antes de concluir.

## Modo Web

Stack padrão para novos projetos:

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

Em projetos existentes, preserve a stack detectada. Não migre para a stack padrão automaticamente.

## Modo Mobile

Stack padrão para novos projetos:

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

A versão do Expo SDK deve ser escolhida com base na compatibilidade oficial atual entre Expo, React Native, React, Node.js e o runtime de execução. Não fixe nem presuma uma versão sem validação.

Use Expo Go somente quando compatível. Use Development Build quando módulos nativos ou a versão do runtime exigirem.

## Modo Universal

Compartilhe domínio, schemas, tipos, validações e camada de API. Separe UI, navegação, permissões e integrações nativas.

## Estratégia de validação

Execute na ordem mais barata e específica possível:

1. validação de sintaxe ou arquivo alterado;
2. lint dos arquivos afetados, quando suportado;
3. typecheck;
4. testes relacionados;
5. `npx expo-doctor` e `npx expo install --check` em projetos Expo afetados;
6. build ou export quando a alteração impactar configuração, dependências ou entrega;
7. suíte completa somente em mudanças amplas ou antes de entrega final.

Não repita comandos que já passaram sem que arquivos relacionados tenham mudado.

## Critério de conclusão

Antes de concluir:

- confirme que o pedido foi atendido;
- registre versões e compatibilidade verificadas quando dependências forem alteradas;
- informe validações executadas e eventuais limitações;
- atualize o contexto somente quando necessário;
- execute o checklist de segurança aplicável;
- confirme que nenhum segredo ou dado sensível foi persistido.
