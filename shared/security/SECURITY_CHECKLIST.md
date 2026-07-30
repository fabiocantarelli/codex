# Checklist Obrigatório de Segurança

Antes de executar:

- [ ] Confirmar o escopo mínimo da tarefa.
- [ ] Evitar arquivos e diretórios de alto risco não necessários.
- [ ] Não criar coleta, telemetria ou indexação do projeto.
- [ ] Compartilhar com subagentes apenas contexto mínimo.

Durante a execução:

- [ ] Não reproduzir segredos ou credenciais.
- [ ] Não copiar dados reais para exemplos, testes ou documentação.
- [ ] Mascarar dados pessoais e identificadores.
- [ ] Não gerar embeddings ou memória persistente com conteúdo do projeto.
- [ ] Não enviar conteúdo a integrações externas não solicitadas.

Antes de concluir:

- [ ] Sanitizar logs e saídas.
- [ ] Confirmar que nenhum segredo está no diff.
- [ ] Confirmar que nenhum dado pessoal foi persistido.
- [ ] Remover temporários criados pela skill.
- [ ] Confirmar que artefatos entregues contêm somente dados necessários.
- [ ] Confirmar que nenhuma informação do projeto foi transformada em conhecimento reutilizável.
