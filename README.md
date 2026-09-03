# Toyota Tsusho — Banco de Dados

Projeto acadêmico em PostgreSQL com carga e normalização de dados de vendas, carros e acessórios.

## Entregáveis

```text
entregaveis/   Docs do projeto
sql/           Scripts DDL
```

## Executar

Execute toda a criação e carga (db-migrate já sobe o container):

```bash
make db-migrate
```

Executar somente até determinado script:

```bash
make db-until UNTIL=05
```

Limpar o banco:

```bash
make db-clear
```

Após uma execução parcial, limpe o banco antes de executar novamente:

```bash
make db-clear
make db-migrate
```

Listar os comandos disponíveis:

```bash
make help
```

## Gerar novamente a carga

Instale a dependência:

```bash
pip install openpyxl
```

Gere o arquivo de carga:

```bash
python scripts/generate_staging_load.py \
    entregaveis/tsusho-2026-preenchido.xlsx \
    --saida sql/07_staging_load_jan_mar.sql
```
