SHELL := /bin/sh

.PHONY: help build up down restart logs shell install lint typecheck test doctor validate clean

help:
	@echo ""
	@echo "Comandos disponíveis:"
	@echo "  make up"
	@echo "  make down"
	@echo "  make logs"
	@echo "  make shell"
	@echo "  make install"
	@echo "  make lint"
	@echo "  make typecheck"
	@echo "  make test"
	@echo "  make doctor"
	@echo "  make validate"
	@echo ""

build:
	docker compose build

up:
	docker compose up -d --build

down:
	docker compose down

restart:
	docker compose restart mobile

logs:
	docker compose logs -f mobile

shell:
	docker compose exec mobile sh

install:
	docker compose run --rm mobile pnpm install

lint:
	docker compose run --rm mobile pnpm lint

typecheck:
	docker compose run --rm mobile pnpm typecheck

test:
	docker compose run --rm mobile pnpm test -- --run

doctor:
	docker compose run --rm mobile pnpm expo-doctor

validate:
	docker compose run --rm mobile sh -lc "pnpm lint && pnpm typecheck && pnpm test -- --run && pnpm expo-doctor"

clean:
	docker compose down --volumes --remove-orphans
