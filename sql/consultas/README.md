# Mapeamento e Resumo das Consultas SQL — Concessionária Toyota Tsusho

Este documento resume as consultas estratégicas e as Views Materializadas (`dw`) desenvolvidas pelo grupo no projeto da concessionária Toyota Tsusho, detalhando os objetivos de negócio, as tabelas utilizadas e as métricas de cada análise nas entregas.

---

## 📊 Matriz Comparativa das Consultas e Views Materializadas

| Integrante / Pasta | Entrega | Item | Título da Análise | Nível / Granularidade | Tabelas / Objetos Utilizados | Foco e Métricas Principais |
| :--- | :---: | :---: | :--- | :--- | :--- | :--- |
| **Diogo Jonsson**<br>`diogo-jonsson/` | **1** | **1** | **Desempenho e Ranking de Modelos** | Agregado (Modelo) | `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `status_venda` | Volume de vendas, faturamento total, ticket médio, desconto médio e ranking (`DENSE_RANK()`) por modelo. |
| | **1** | **2** | **Lead Time Operacional de Vendas por Cidade** | Agregado (Cidade) | `venda`, `status_venda`, `cliente`, `cidade` | Prazos médios em dias (pedido → faturamento, faturamento → entrega e pedido → entrega) e % de entregas rápidas (≤ 7 dias). |
| | **2** | **1** | **Desempenho e Ranking de Modelos (Consolidado)** | Agregado (Modelo) | `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `status_venda` | Mesma análise da Entrega 1 consolidando dados correntes e históricos. |
| | **2** | **2** | **Lead Time Operacional por Cidade (Consolidado)** | Agregado (Cidade) | `venda`, `hvenda`, `status_venda`, `cliente`, `cidade` | Mesma análise da Entrega 1 consolidando dados correntes e históricos. |
| | **4** | **MView** | **`dw.mv_prazo_operacional_cidade`** | View Materializada (Cidade) | `venda`, `hvenda`, `status_venda`, `cliente`, `cidade` | Materializa no schema `dw` os prazos médios operacionais (pedido, faturamento e entrega) por cidade. |
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
