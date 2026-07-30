# {{PROJECT_NAME}}

## Estrutura

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

## Regras

- Web usa Docker integralmente.
- Mobile usa Expo.
- Compartilhe domínio, tipos, schemas e API.
- Não force compartilhamento de UI.
