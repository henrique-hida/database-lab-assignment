# Toyota Tsusho — Banco de Dados

Projeto acadêmico em PostgreSQL com carga e normalização de dados de vendas, carros e acessórios, histórico temporal, auditoria automatizada e camada analítica (`dw`) com Views Materializadas.

## Entregáveis

```text
entregaveis/      Docs do projeto
sql/              Scripts DDL, cargas, histórico, auditoria e DW
sql/consultas/    Consultas analíticas e Views Materializadas por integrante
```

## Views Materializadas — Entrega 4 (`schema dw`)

As Views Materializadas abaixo pertencem ao usuário `tsusho_dw` (no schema `dw`) e consolidam os dados ativos e históricos (`UNION ALL` entre as tabelas correntes e `h*`) sem limite fixo de linhas, para consumo e filtragem no **Power BI**:

| View Materializada | Integrante | O que a View mostra | Principais Métricas / Colunas |
| :--- | :--- | :--- | :--- |
| **`dw.mv_prazo_operacional_cidade`**<br>(`diogo-jonsson/entrega-4/view-materializada.sql`) | Diogo Jonsson | Eficiência logística e *lead time* operacional das vendas entregues em cada cidade atendida. | `cidade`, `uf`, `vendas_entregues`, `ticket_medio`, `media_dias_pedido_faturamento`, `media_dias_faturamento_entrega`, `media_dias_pedido_entrega`, `percentual_entregas_ate_7_dias` |
| **`dw.mv_cross_selling_acessorios`**<br>(`enzo-kuwamoto/entrega-4/view-materializada.sql`) | Enzo Kuwamoto | Matriz de vendas cruzadas (*cross-selling*) entre modelos de veículos e categorias de acessórios instalados. | `modelo_carro`, `categoria_acessorio`, `qtd_vendas_deste_combo`, `total_itens_vendidos`, `faturamento_deste_combo` |
| **`dw.mv_evolucao_mensal_modelos`**<br>(`henrique-hida/entrega-4/view-materializada.sql`) | Henrique Hida | Série temporal mensal (Jan–Ago/2026) do desempenho de cada modelo, ranking mensal e variação percentual mês a mês (*MoM*). | `mes`, `modelo`, `unidades_vendidas`, `faturamento`, `desconto_medio`, `posicao_mes`, `variacao_percentual_faturamento` |
| **`dw.mv_desempenho_regional_hibridos`**<br>(`matheus-schalch/entrega-4/view-materializada.sql`) | Matheus Schalch | Desempenho comercial regional por cidade e modelo, participação na receita global e taxa de adoção de veículos híbridos. | `posicao`, `cidade`, `uf`, `modelo`, `unidades_vendidas`, `vendas_hibridos`, `taxa_penetracao_hibridos_pct`, `faturamento_total`, `ticket_medio`, `participacao_faturamento_pct` |

> Para o detalhamento completo de cada coluna e a matriz comparativa das Entregas 1, 2 e 4, consulte [`sql/consultas/README.md`](sql/consultas/README.md).

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
    --saida sql/06_load_jan_mar.sql
```
