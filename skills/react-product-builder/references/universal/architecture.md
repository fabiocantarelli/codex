# Arquitetura Universal

Use monorepo quando houver compartilhamento real:

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

Não force compartilhamento de UI.
