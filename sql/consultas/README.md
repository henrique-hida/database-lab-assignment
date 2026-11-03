# Mapeamento e Resumo das Consultas SQL — Concessionária Toyota Tsusho

Este documento resume as consultas estratégicas desenvolvidas pelo grupo no projeto da concessionária Toyota Tsusho, detalhando os objetivos de negócio, as tabelas utilizadas e as métricas de cada análise nas duas entregas.

---

## 📊 Matriz Comparativa das Consultas

| Integrante / Pasta | Entrega | Consulta | Título da Análise | Nível / Granularidade | Tabelas Utilizadas | Foco e Métricas Principais |
| :--- | :---: | :---: | :--- | :--- | :--- | :--- |
| **Diogo Jonsson**<br>`diogo-jonsson/` | **1** | **1** | **Desempenho e Ranking de Modelos** | Agregado (Modelo) | `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `status_venda` | Volume de vendas, faturamento total, ticket médio, desconto médio e ranking (`DENSE_RANK()`) por modelo. |
| | **1** | **2** | **Lead Time Operacional de Vendas por Cidade** | Agregado (Cidade) | `venda`, `status_venda`, `cliente`, `cidade` | Prazos médios em dias (pedido → faturamento, faturamento → entrega e pedido → entrega) e % de entregas rápidas (≤ 7 dias). |
| | **2** | **1** | **Desempenho e Ranking de Modelos (Consolidado)** | Agregado (Modelo) | `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `status_venda` | Mesma análise da Entrega 1 consolidando dados correntes e históricos. |
| | **2** | **2** | **Lead Time Operacional por Cidade (Consolidado)** | Agregado (Cidade) | `venda`, `hvenda`, `status_venda`, `cliente`, `cidade` | Mesma análise da Entrega 1 consolidando dados correntes e históricos. |
| **Enzo Kuwamoto**<br>`enzo-kuwamoto/` | **1** | **1** | **Matriz de Vendas Cruzadas (*Cross-selling*)** | Agregado (Modelo x Acessório) | `venda_acessorio`, `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `acessorio`, `categoria_acessorio`, `status_venda` | Volume de combos de veículos + categorias de acessórios instalados, total de itens e faturamento gerado por acessório. |
| | **1** | **2** | **Formas de Pagamento vs Desconto e Acessórios** | Agregado (Pagamento) | `venda`, `forma_pagamento`, `status_venda`, `venda_acessorio` | Correlação da modalidade de pagamento com a taxa de desconto médio concedida e o ticket médio gasto em acessórios. |
| | **2** | **1** | **Matriz de Vendas Cruzadas (Consolidada)** | Agregado (Modelo x Acessório) | `venda_acessorio`, `hvenda_acessorio`, `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `acessorio`, `categoria_acessorio`, `status_venda` | Mesma análise da Entrega 1 consolidando dados correntes e históricos. |
| | **2** | **2** | **Formas de Pagamento vs Desconto (Consolidada)** | Agregado (Pagamento) | `venda`, `hvenda`, `forma_pagamento`, `status_venda`, `venda_acessorio`, `hvenda_acessorio` | Mesma análise da Entrega 1 consolidando dados correntes e históricos. |
| **Henrique Hida**<br>`henrique-hida/` | **1** | **1** | **Evolução Mensal de Vendas por Modelo** | Agregado (Mês x Modelo) | `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo` | Vendas e faturamento mensal por modelo com ranking (`DENSE_RANK()`) e variação percentual mês a mês via `LAG()`. |
| | **1** | **2** | **Valor de Clientes e Adesão a Acessórios** | Agregado (Cliente) | `cliente`, `venda`, `venda_acessorio` | Segmentação de clientes via `NTILE(4)` (Estratégico, Alto valor, Intermediário, Baixo valor) somando receita de veículos e acessórios. |
| | **2** | **1** | **Evolução Mensal (Consolidada com Histórico)** | Agregado (Mês x Modelo) | `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo` | Mesma métrica da Entrega 1 consolidando todas as cargas históricas. |
| | **2** | **2** | **Valor de Clientes (Consolidado com Histórico)** | Agregado (Cliente) | `cliente`, `venda`, `hvenda`, `venda_acessorio`, `hvenda_acessorio` | Segmentação de clientes consolidando dados ativos e históricos. |
| **Matheus Schalch**<br>`matheus-schalch/` | **1** | **1** | **Top 10 Desempenho Regional & Adoção de Híbridos** | Agregado (Cidade x Modelo — Top 10) | `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `cliente`, `cidade`, `status_venda` | Ranking Top 10 (`RANK()`) por faturamento municipal e modelo, unidades vendidas, ticket médio, participação na receita e taxa de penetração de híbridos. |
| | **1** | **2** | **Top 10 Estrutura de Financiamento & *Trade-in*** | Agregado (Pagamento x Modelo — Top 10) | `venda`, `forma_pagamento`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `status_venda`, `veiculo_troca` | Ranking Top 10 (`RANK()`) de pagamento por modelo com representatividade no faturamento, % médio de entrada, prazo/parcela média, taxa de adesão à troca e cobertura média pelo seminovo. |
| | **2** | **1** | **Top 10 Desempenho Regional & Híbridos (Consolidado)** | Agregado (Cidade x Modelo — Top 10) | `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `cliente`, `cidade`, `status_venda` | Mesma análise estratégica Top 10 da Entrega 1 consolidando dados correntes e históricos. |
| | **2** | **2** | **Top 10 Financiamento & *Trade-in* (Consolidado)** | Agregado (Pagamento x Modelo — Top 10) | `venda`, `hvenda`, `forma_pagamento`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `status_venda`, `veiculo_troca`, `hveiculo_troca` | Mesma análise estratégica Top 10 da Entrega 1 consolidando dados correntes e históricos. |

---

## 🚀 Como Executar as Consultas no Docker

```bash
# Entrega 1 (Dados correntes)
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/matheus-schalch/entrega-1/consulta-1.sql
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/matheus-schalch/entrega-1/consulta-2.sql

# Entrega 2 (Consolidação: corrente + histórico)
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/matheus-schalch/entrega-2/consulta-1.sql
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/matheus-schalch/entrega-2/consulta-2.sql
```
