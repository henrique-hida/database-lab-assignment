COMPOSE := docker compose
SERVICE := postgres
DATABASE := tsusho
USER := tsusho_admin
MIGRATIONS := $(sort $(wildcard sql/[0-9][0-9]_*.sql))
MIGRATIONS_TABLE := public.tsusho_migrations

.PHONY: help db-up db-migrate db-until db-clear run-migrations

help:
	@printf '%s\n' \
	  'Comandos disponíveis:' \
	  '  make db-up                      Inicia o PostgreSQL.' \
	  '  make db-migrate                 Executa as migrations ainda nao aplicadas.' \
	  '  make db-until UNTIL=05          Executa migrations até o número 05.' \
	  '  make db-clear                   Remove os schemas do projeto.'

db-up:
	@if $(COMPOSE) up -d $(SERVICE) >/dev/null 2>&1; then \
		:; \
	else \
		echo 'ERRO ao iniciar o PostgreSQL.'; \
		exit 1; \
	fi
	@until $(COMPOSE) exec -T $(SERVICE) \
		pg_isready -U $(USER) -d $(DATABASE) >/dev/null 2>&1; do \
		sleep 1; \
	done

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
	@if $(COMPOSE) exec -T $(SERVICE) \
		psql \
		-v ON_ERROR_STOP=1 \
		-U $(USER) \
		-d $(DATABASE) \
		-c 'CREATE TABLE IF NOT EXISTS $(MIGRATIONS_TABLE) (arquivo TEXT PRIMARY KEY, aplicado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP);' \
		>/dev/null 2>&1; then \
		:; \
	else \
		echo 'ERRO ao preparar o controle de migrations.'; \
		exit 1; \
	fi
	@set -e; \
	executou=0; \
	for migration in $(MIGRATIONS); do \
		number=$${migration##*/}; \
		number=$${number%%_*}; \
		if [ -n "$(UNTIL)" ] && [ "$$number" -gt "$(UNTIL)" ]; then \
			continue; \
		fi; \
		aplicada=$$($(COMPOSE) exec -T $(SERVICE) \
			psql \
			-v ON_ERROR_STOP=1 \
			-U $(USER) \
			-d $(DATABASE) \
			-tAc "SELECT EXISTS (SELECT 1 FROM $(MIGRATIONS_TABLE) WHERE arquivo = '$$migration');" \
			2>/dev/null); \
		if [ "$$aplicada" = 't' ]; then \
			continue; \
		fi; \
		if $(COMPOSE) exec -T $(SERVICE) \
			psql \
			-v ON_ERROR_STOP=1 \
			-U $(USER) \
			-d $(DATABASE) \
			< "$$migration" >/dev/null 2>&1; then \
			if $(COMPOSE) exec -T $(SERVICE) \
				psql \
				-v ON_ERROR_STOP=1 \
				-U $(USER) \
				-d $(DATABASE) \
				-c "INSERT INTO $(MIGRATIONS_TABLE) (arquivo) VALUES ('$$migration');" \
				>/dev/null 2>&1; then \
				echo "OK $$migration"; \
				executou=1; \
			else \
				echo "ERRO ao registrar $$migration"; \
				exit 1; \
			fi; \
		else \
			echo "ERRO $$migration"; \
			exit 1; \
		fi; \
	done; \
	if [ "$$executou" -eq 0 ]; then \
		echo 'Up to date.'; \
	fi

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
			-c 'DROP TABLE IF EXISTS public.tsusho_migrations; DROP SCHEMA IF EXISTS staging CASCADE; DROP SCHEMA IF EXISTS concessionaria CASCADE; DROP SCHEMA IF EXISTS auditoria CASCADE;' \
		;; \
	  *) \
		echo 'Operação cancelada.' \
		;; \
	esac
