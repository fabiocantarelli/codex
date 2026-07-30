SHELL := /bin/sh

.PHONY: help build up down restart logs ps shell install lint typecheck test test-watch build-app validate prod-build prod-up prod-down prod-logs clean

help:
	@echo ""
	@echo "Comandos disponíveis:"
	@echo "  make up"
	@echo "  make down"
	@echo "  make restart"
	@echo "  make logs"
	@echo "  make shell"
	@echo "  make install"
	@echo "  make lint"
	@echo "  make typecheck"
	@echo "  make test"
	@echo "  make build-app"
	@echo "  make validate"
	@echo "  make prod-up"
	@echo ""

build:
	docker compose build

up:
	docker compose up -d --build

down:
	docker compose down

restart:
	docker compose restart frontend

logs:
	docker compose logs -f frontend

ps:
	docker compose ps

shell:
	docker compose exec frontend sh

install:
	docker compose run --rm frontend pnpm install

lint:
	docker compose run --rm frontend pnpm lint

typecheck:
	docker compose run --rm frontend pnpm typecheck

test:
	docker compose run --rm frontend pnpm test -- --run

test-watch:
	docker compose run --rm frontend pnpm test

build-app:
	docker compose run --rm frontend pnpm build

validate:
	docker compose run --rm frontend sh -lc "pnpm lint && pnpm typecheck && pnpm test -- --run && pnpm build"

prod-build:
	docker compose -f docker-compose.prod.yml build

prod-up:
	docker compose -f docker-compose.prod.yml up -d --build

prod-down:
	docker compose -f docker-compose.prod.yml down

prod-logs:
	docker compose -f docker-compose.prod.yml logs -f frontend

clean:
	docker compose down --volumes --remove-orphans
	docker compose -f docker-compose.prod.yml down --volumes --remove-orphans
