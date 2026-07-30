# Política de Memória, Retenção e Bancos Vetoriais

## Regra geral

Conteúdo específico de projetos deve permanecer apenas no contexto transitório necessário à execução.

## É proibido persistir

- código proprietário;
- arquitetura interna;
- regras de negócio;
- nomes de clientes e empresas;
- dados pessoais;
- credenciais;
- logs;
- SQL e dumps;
- endpoints privados;
- topologia de rede;
- configurações de infraestrutura;
- documentação interna;
- incidentes e vulnerabilidades específicas.

## Memória permitida

Somente conhecimento técnico genérico, abstrato, não identificável e não derivado de segredos do projeto.

## Vetores e embeddings

Por padrão, nenhuma skill pode criar embeddings ou índices persistentes do projeto.

Uma exceção exige solicitação explícita do usuário e todos os seguintes controles:

1. armazenamento local ou ambiente aprovado;
2. escopo de arquivos definido;
3. exclusão automática de segredos e dados pessoais;
4. política de expiração e descarte;
5. ausência de telemetria de conteúdo;
6. revisão dos diretórios e padrões excluídos;
7. possibilidade de remoção integral.

Mesmo sob exceção, credenciais, chaves, tokens, dados pessoais sensíveis e documentos de identidade nunca podem ser indexados.

## Temporários

Arquivos temporários criados pela skill devem ser apagados ao final, salvo quando forem parte explícita da entrega solicitada.
