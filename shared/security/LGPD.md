# LGPD para Skills e Agentes de IA

## Escopo

Esta política aplica os princípios da Lei nº 13.709/2018 ao uso de skills e agentes de IA em projetos de software.

## Princípios obrigatórios

- **Finalidade:** processar dados somente para concluir a tarefa solicitada.
- **Adequação:** não ampliar o uso para finalidades incompatíveis.
- **Necessidade:** acessar o mínimo possível.
- **Qualidade:** evitar propagar dados incorretos ou desatualizados.
- **Transparência:** explicar riscos relevantes sem expor conteúdo sensível.
- **Segurança:** prevenir acesso, exposição, alteração ou retenção indevida.
- **Prevenção:** evitar coleta desnecessária e saídas não sanitizadas.
- **Não discriminação:** não usar dados pessoais para práticas discriminatórias.
- **Responsabilização:** registrar decisões de segurança apenas de forma abstrata e sem dados protegidos.

## Regras operacionais

1. Não coletar dados pessoais por conveniência.
2. Não criar inventários de titulares sem solicitação legítima.
3. Não copiar dados reais para fixtures, testes, exemplos ou documentação.
4. Não persistir dados pessoais em memória, vetores, cache, logs ou telemetria.
5. Mascarar identificadores pessoais em qualquer saída.
6. Evitar leitura de dumps, uploads, logs e bancos quando a tarefa puder ser resolvida de outra forma.
7. Não inferir novos perfis pessoais além do necessário.
8. Não compartilhar dados entre agentes além do mínimo técnico indispensável.

## Dados pessoais sensíveis

Dados sobre origem racial ou étnica, convicção religiosa, opinião política, filiação sindical, saúde, vida sexual, dados genéticos ou biométricos recebem proteção máxima e não devem ser reproduzidos nem persistidos.

## Incidentes

Ao detectar exposição acidental, a skill deve:

- interromper a reprodução do dado;
- mascarar a informação;
- limitar a análise ao necessário;
- alertar o usuário sobre o risco sem repetir o valor;
- não criar cópias adicionais.

## Limitação

Esta política é uma baseline técnica e não substitui avaliação jurídica, DPO, controlador, operador, RIPD ou controles organizacionais exigidos no caso concreto.
