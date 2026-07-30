# Classificação e Tratamento de Dados

## Classes

### Público
Informação legitimamente pública e autorizada para reutilização.

### Interno
Código, arquitetura, documentação e decisões do projeto. Uso limitado à tarefa atual.

### Confidencial
Propriedade intelectual, regras de negócio, infraestrutura, contratos, dados de clientes, registros internos e informações não públicas.

### Altamente restrito
Credenciais, tokens, chaves, certificados, dados pessoais sensíveis, dados médicos, financeiros, biométricos, jurídicos protegidos e segredos empresariais.

## Regra padrão

Na dúvida, classificar no nível mais restritivo aplicável.

## Tratamento mínimo

| Classe | Leitura | Reprodução | Persistência | Compartilhamento |
|---|---|---|---|---|
| Público | Permitida | Permitida conforme licença | Permitida | Permitido |
| Interno | Mínima necessária | Somente na tarefa | Proibida fora do artefato pedido | Mínimo necessário |
| Confidencial | Estritamente necessária | Sanitizada | Proibida | Estritamente necessário |
| Altamente restrito | Evitar | Proibida; usar redação | Proibida | Proibido, salvo necessidade operacional incontornável e segura |

## Dados derivados

Inferências, resumos, mapas arquiteturais, listas de endpoints e descrições de regras de negócio herdam a classificação da fonte.
