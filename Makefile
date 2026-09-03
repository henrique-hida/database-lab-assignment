COMPOSE := docker compose
SERVICE := postgres
DATABASE := tsusho
USER := tsusho_user
MIGRATIONS := $(sort $(wildcard sql/[0-9][0-9]_*.sql))

.PHONY: help db-up db-migrate db-until db-clear run-migrations

help:
	@printf '%s\n' \
	  'Comandos disponíveis:' \
	  '  make db-up                      Inicia o PostgreSQL.' \
	  '  make db-migrate                 Executa todas as migrations.' \
	  '  make db-until UNTIL=05          Executa migrations até o número 05.' \
	  '  make db-clear                   Remove os schemas do projeto.'

db-up:
	@$(COMPOSE) up -d $(SERVICE)
	@echo "Aguardando o PostgreSQL..."
	@until $(COMPOSE) exec -T $(SERVICE) \
		pg_isready -U $(USER) -d $(DATABASE) >/dev/null 2>&1; do \
		sleep 1; \
	done
	@echo "PostgreSQL disponível."

db-migrate: db-up
	@$(MAKE) --no-print-directory run-migrations

db-until: db-up
	@test -n "$(UNTIL)" || { \
		echo 'Informe UNTIL, por exemplo: make db-until UNTIL=05'; \
		exit 1; \
	}
	@$(MAKE) --no-print-directory run-migrations UNTIL=$(UNTIL)

.PHONY: run-migrations
run-migrations:
	@test -n "$(MIGRATIONS)" || { \
		echo 'Nenhuma migration encontrada em sql/'; \
		exit 1; \
	}
	@set -e; \
	for migration in $(MIGRATIONS); do \
		number=$${migration##*/}; \
		number=$${number%%_*}; \
		if [ -n "$(UNTIL)" ] && [ "$$number" -gt "$(UNTIL)" ]; then \
			continue; \
		fi; \
		echo "Executando $$migration"; \
		$(COMPOSE) exec -T $(SERVICE) \
			psql \
			-v ON_ERROR_STOP=1 \
			-U $(USER) \
			-d $(DATABASE) \
			< "$$migration"; \
	done
	@echo "Migrations executadas com sucesso."

db-clear:
	@printf 'Isso removerá todos os dados do projeto. Continuar? [s/N] '; \
	read answer; \
	case "$$answer" in \
	  s|S|sim|SIM) \
		$(COMPOSE) exec -T $(SERVICE) \
			psql \
			-v ON_ERROR_STOP=1 \
			-U $(USER) \
			-d $(DATABASE) \
			-c 'DROP SCHEMA IF EXISTS staging CASCADE; DROP SCHEMA IF EXISTS concessionaria CASCADE;' \
		;; \
	  *) \
		echo 'Operação cancelada.' \
		;; \
	esac