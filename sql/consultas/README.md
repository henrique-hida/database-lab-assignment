# Mapeamento e Resumo das Consultas SQL — Concessionária Toyota Tsusho

Este documento resume as consultas estratégicas e as Views Materializadas (`dw`) desenvolvidas pelo grupo no projeto da concessionária Toyota Tsusho, detalhando os objetivos de negócio, as tabelas utilizadas e o que cada View Materializada apresenta.

---

## 🏛️ Detalhamento das Views Materializadas — Entrega 4 (`schema dw`)

Todas as Views Materializadas abaixo pertencem ao role `tsusho_dw`, estão no schema `dw` e consolidam os dados **correntes e históricos** (`UNION ALL` entre as tabelas ativas e `h*`), sem cláusula `LIMIT`, permitindo que filtros e recortes (*Top N*) sejam aplicados diretamente no **Power BI**.

### 1. `dw.mv_prazo_operacional_cidade` — Diogo Jonsson
- **Arquivo:** `sql/consultas/diogo-jonsson/entrega-4/view-materializada.sql`
- **O que mostra:** Analisa a eficiência logística e o prazo operacional (*lead time*) das vendas entregues em cada cidade atendida pela concessionária, identificando gargalos entre o pedido, o faturamento e a entrega final do veículo ao cliente.
- **Granularidade:** 1 linha por **Cidade (`cidade`, `uf`)**.
- **Tabelas consolidadas:** `venda` + `hvenda`, `status_venda`, `cliente`, `cidade`.
- **Colunas retornadas:**
  - `cidade` / `uf`: Município e estado de residência do cliente.
  - `vendas_entregues`: Total de veículos com status `'Entregue'` na cidade.
  - `ticket_medio`: Valor médio das vendas entregues na cidade (R$).
  - `media_dias_pedido_faturamento`: Tempo médio (em dias) entre a data do pedido e o faturamento.
  - `media_dias_faturamento_entrega`: Tempo médio (em dias) entre o faturamento e a entrega física do veículo.
  - `media_dias_pedido_entrega`: Ciclo operacional total médio (em dias) do pedido até a entrega.
  - `percentual_entregas_ate_7_dias`: Percentual (%) de pedidos concluídos e entregues em até 7 dias corridos (SLA de entrega rápida).

---

### 2. `dw.mv_cross_selling_acessorios` — Enzo Kuwamoto
- **Arquivo:** `sql/consultas/enzo-kuwamoto/entrega-4/view-materializada.sql`
- **O que mostra:** Apresenta a matriz de vendas cruzadas (*cross-selling*) entre os modelos de veículos vendidos e as categorias de acessórios instalados, permitindo identificar quais categorias de acessórios geram maior receita agregada e maior volume de pacotes vendidos para cada carro.
- **Granularidade:** 1 linha por combinação de **Modelo de Veículo × Categoria de Acessório (`modelo_carro`, `categoria_acessorio`)**.
- **Tabelas consolidadas:** `venda_acessorio` + `hvenda_acessorio`, `venda` + `hvenda`, `veiculo` + `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `acessorio`, `categoria_acessorio`, `status_venda`.
- **Colunas retornadas:**
  - `modelo_carro`: Nome do modelo do veículo (ex.: Corolla, Corolla Cross, Hilux, SW4, Yaris Cross).
  - `categoria_acessorio`: Categoria do acessório vendido junto com o veículo (ex.: Segurança, Conforto, Estética, Multimídia).
  - `qtd_vendas_deste_combo`: Quantidade de vendas distintas (pedidos entregues) em que esse modelo saiu com pelo menos um item dessa categoria.
  - `total_itens_vendidos`: Soma total de unidades físicas de acessórios dessa categoria instaladas no modelo.
  - `faturamento_deste_combo`: Receita total (R$) gerada exclusivamente pelos acessórios dessa categoria naquele modelo de veículo.

---

### 3. `dw.mv_evolucao_mensal_modelos` — Henrique Hida
- **Arquivo:** `sql/consultas/henrique-hida/entrega-4/view-materializada.sql`
- **O que mostra:** Exibe a série temporal mensal (Janeiro a Agosto de 2026) do desempenho comercial de cada modelo de veículo, incluindo o ranking de faturamento dentro de cada mês e a taxa de crescimento ou retração percentual em relação ao mês imediatamente anterior (*Month-over-Month*).
- **Granularidade:** 1 linha por **Mês × Modelo de Veículo (`mes`, `modelo`)**.
- **Tabelas consolidadas:** `venda` + `hvenda`, `veiculo` + `hveiculo`, `versao_veiculo`, `modelo_veiculo`.
- **Colunas retornadas:**
  - `mes`: Mês/ano de referência do pedido no formato `YYYY-MM`.
  - `modelo`: Nome do modelo do veículo.
  - `unidades_vendidas`: Total de veículos vendidos do modelo naquele mês.
  - `faturamento`: Receita total (R$) gerada pelo modelo no mês.
  - `desconto_medio`: Valor médio de desconto (R$) concedido nas vendas do modelo no mês.
  - `posicao_mes`: Posição do modelo no ranking de faturamento daquele mês (`DENSE_RANK()`).
  - `variacao_percentual_faturamento`: Variação percentual (%) do faturamento do modelo em comparação ao mês anterior (`LAG()`).

---

### 4. `dw.mv_desempenho_regional_hibridos` — Matheus Schalch
- **Arquivo:** `sql/consultas/matheus-schalch/entrega-4/view-materializada.sql`
- **O que mostra:** Mapeia o desempenho comercial regional por cidade e modelo de veículo, destacando o ranking geral de faturamento, a representatividade de cada praça/modelo na receita total da concessionária e a taxa de penetração (adoção) de motorizações híbridas em cada mercado.
- **Granularidade:** 1 linha por combinação de **Cidade × Modelo de Veículo (`cidade`, `uf`, `modelo`)**.
- **Tabelas consolidadas:** `venda` + `hvenda`, `veiculo` + `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `cliente`, `cidade`, `status_venda`.
- **Colunas retornadas:**
  - `posicao`: Posição no ranking geral (`RANK()`) ordenada pelo maior faturamento e volume de unidades vendidas.
  - `cidade` / `uf`: Município e estado do cliente comprador.
  - `modelo`: Nome do modelo do veículo entregue.
  - `unidades_vendidas`: Quantidade total de veículos entregues para a combinação cidade × modelo.
  - `vendas_hibridos`: Quantidade de veículos entregues cuja versão possui motorização híbrida (`vsv_combustivel ILIKE '%Híbrido%'`).
  - `taxa_penetracao_hibridos_pct`: Percentual (%) de participação de veículos híbridos sobre o total vendido daquele modelo na cidade.
  - `faturamento_total`: Receita acumulada (R$) das vendas entregues na combinação cidade × modelo.
  - `ticket_medio`: Valor médio por veículo vendido (R$) naquela cidade e modelo.
  - `participacao_faturamento_pct`: Participação percentual (%) daquela combinação cidade × modelo sobre o faturamento global da concessionária.

---

## 📊 Matriz Comparativa de Todas as Entregas (1, 2 e 4)

| Integrante / Pasta | Entrega | Item | Título da Análise | Nível / Granularidade | Tabelas / Objetos Utilizados | Foco e Métricas Principais |
| :--- | :---: | :---: | :--- | :--- | :--- | :--- |
| **Diogo Jonsson**<br>`diogo-jonsson/` | **1** | **1** | **Desempenho e Ranking de Modelos** | Agregado (Modelo) | `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `status_venda` | Volume de vendas, faturamento total, ticket médio, desconto médio e ranking (`DENSE_RANK()`) por modelo. |
| | **1** | **2** | **Lead Time Operacional de Vendas por Cidade** | Agregado (Cidade) | `venda`, `status_venda`, `cliente`, `cidade` | Prazos médios em dias (pedido → faturamento, faturamento → entrega e pedido → entrega) e % de entregas rápidas (≤ 7 dias). |
| | **2** | **1** | **Desempenho e Ranking de Modelos (Consolidado)** | Agregado (Modelo) | `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `status_venda` | Mesma análise da Entrega 1 consolidando dados correntes e históricos. |
| | **2** | **2** | **Lead Time Operacional por Cidade (Consolidado)** | Agregado (Cidade) | `venda`, `hvenda`, `status_venda`, `cliente`, `cidade` | Mesma análise da Entrega 1 consolidando dados correntes e históricos. |
| | **4** | **MView** | **`dw.mv_prazo_operacional_cidade`** | View Materializada (Cidade) | `venda`, `hvenda`, `status_venda`, `cliente`, `cidade` | Materializa no schema `dw` os prazos médios operacionais (pedido, faturamento e entrega) e SLA de 7 dias por cidade. |
| **Enzo Kuwamoto**<br>`enzo-kuwamoto/` | **1** | **1** | **Matriz de Vendas Cruzadas (*Cross-selling*)** | Agregado (Modelo x Acessório) | `venda_acessorio`, `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `acessorio`, `categoria_acessorio`, `status_venda` | Volume de combos de veículos + categorias de acessórios instalados, total de itens e faturamento gerado por acessório. |
| | **1** | **2** | **Formas de Pagamento vs Desconto e Acessórios** | Agregado (Pagamento) | `venda`, `forma_pagamento`, `status_venda`, `venda_acessorio` | Correlação da modalidade de pagamento com a taxa de desconto médio concedida e o ticket médio gasto em acessórios. |
| | **2** | **1** | **Matriz de Vendas Cruzadas (Consolidada)** | Agregado (Modelo x Acessório) | `venda_acessorio`, `hvenda_acessorio`, `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `acessorio`, `categoria_acessorio`, `status_venda` | Mesma análise da Entrega 1 consolidando dados correntes e históricos. |
| | **2** | **2** | **Formas de Pagamento vs Desconto (Consolidada)** | Agregado (Pagamento) | `venda`, `hvenda`, `forma_pagamento`, `status_venda`, `venda_acessorio`, `hvenda_acessorio` | Mesma análise da Entrega 1 consolidando dados correntes e históricos. |
| | **4** | **MView** | **`dw.mv_cross_selling_acessorios`** | View Materializada (Modelo x Acessório) | `venda_acessorio`, `hvenda_acessorio`, `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `acessorio`, `categoria_acessorio`, `status_venda` | Materializa no schema `dw` a matriz consolidada de *cross-selling* de acessórios por modelo. |
| **Henrique Hida**<br>`henrique-hida/` | **1** | **1** | **Evolução Mensal de Vendas por Modelo** | Agregado (Mês x Modelo) | `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo` | Vendas e faturamento mensal por modelo com ranking (`DENSE_RANK()`) e variação percentual mês a mês via `LAG()`. |
| | **1** | **2** | **Valor de Clientes e Adesão a Acessórios** | Agregado (Cliente) | `cliente`, `venda`, `venda_acessorio` | Segmentação de clientes via `NTILE(4)` (Estratégico, Alto valor, Intermediário, Baixo valor) somando receita de veículos e acessórios. |
| | **2** | **1** | **Evolução Mensal (Consolidada com Histórico)** | Agregado (Mês x Modelo) | `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo` | Mesma métrica da Entrega 1 consolidando todas as cargas históricas. |
| | **2** | **2** | **Valor de Clientes (Consolidado com Histórico)** | Agregado (Cliente) | `cliente`, `venda`, `hvenda`, `venda_acessorio`, `hvenda_acessorio` | Segmentação de clientes consolidando dados ativos e históricos. |
| | **4** | **MView** | **`dw.mv_evolucao_mensal_modelos`** | View Materializada (Mês x Modelo) | `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo` | Materializa no schema `dw` a evolução mensal consolidada de vendas e variação percentual por modelo. |
| **Matheus Schalch**<br>`matheus-schalch/` | **1** | **1** | **Top 10 Desempenho Regional & Adoção de Híbridos** | Agregado (Cidade x Modelo — Top 10) | `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `cliente`, `cidade`, `status_venda` | Ranking Top 10 (`RANK()`) por faturamento municipal e modelo, unidades vendidas, ticket médio, participação na receita e taxa de penetração de híbridos. |
| | **1** | **2** | **Top 10 Estrutura de Financiamento & *Trade-in*** | Agregado (Pagamento x Modelo — Top 10) | `venda`, `forma_pagamento`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `status_venda`, `veiculo_troca` | Ranking Top 10 (`RANK()`) de pagamento por modelo com representatividade no faturamento, % médio de entrada, prazo/parcela média, taxa de adesão à troca e cobertura média pelo seminovo. |
| | **2** | **1** | **Top 10 Desempenho Regional & Híbridos (Consolidado)** | Agregado (Cidade x Modelo — Top 10) | `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `cliente`, `cidade`, `status_venda` | Mesma análise estratégica Top 10 da Entrega 1 consolidando dados correntes e históricos. |
| | **2** | **2** | **Top 10 Financiamento & *Trade-in* (Consolidado)** | Agregado (Pagamento x Modelo — Top 10) | `venda`, `hvenda`, `forma_pagamento`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `status_venda`, `veiculo_troca`, `hveiculo_troca` | Mesma análise estratégica Top 10 da Entrega 1 consolidando dados correntes e históricos. |
| | **4** | **MView** | **`dw.mv_desempenho_regional_hibridos`** | View Materializada (Cidade x Modelo — Sem limite) | `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `cliente`, `cidade`, `status_venda` | Materializa no schema `dw` todas as combinações consolidadas de desempenho regional e penetração de híbridos para filtro no Power BI. |

---

## 🚀 Como Executar no Docker

```bash
# Aplicar todas as migrations (incluindo 16_dw.sql)
make db-migrate

# Executar as Views Materializadas da Entrega 4
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/diogo-jonsson/entrega-4/view-materializada.sql
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/enzo-kuwamoto/entrega-4/view-materializada.sql
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/henrique-hida/entrega-4/view-materializada.sql
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/matheus-schalch/entrega-4/view-materializada.sql
```
