# Mapeamento e Resumo das Consultas SQL — Concessionária Toyota Tsusho

Este documento resume as consultas analíticas desenvolvidas pelo grupo no projeto da concessionária Toyota Tsusho, detalhando os objetivos de negócio, as tabelas utilizadas e os diferenciais de cada análise (estruturadas para virarem Views e integrarem o Power BI).

---

## 📊 Matriz Comparativa das Consultas

| Integrante / Pasta | Entrega | Consulta | Título da Análise | Nível / Granularidade | Tabelas Utilizadas | Foco e Métricas Principais |
| :--- | :---: | :---: | :--- | :---: | :--- | :--- |
| **Diogo Jonsson**<br>`diogo-jonsson/` | - | **1** | **Comparativo Comercial por Períodos** | Agregado (Modelo) | `hvenda`, `hveiculo`, `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `status_venda` | Média mensal de vendas, faturamento e desconto médio por modelo de veículo entre períodos. |
| | - | **2** | **Lead Time Operacional de Vendas por Cidade** | Agregado (Cidade) | `venda`, `status_venda`, `cliente`, `cidade` | Prazos médios em dias (pedido → faturamento, faturamento → entrega e pedido → entrega) e % de entregas rápidas (≤ 7 dias). |
| **Enzo Kuwamoto**<br>`enzo-kuwamoto/` | - | **1** | **Matriz de Vendas Cruzadas (*Cross-selling*)** | Agregado (Modelo x Acessório) | `venda_acessorio`, `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `acessorio`, `categoria_acessorio`, `status_venda` | Volume de combos de veículos + categorias de acessórios instalados, total de itens e faturamento gerado por acessório. |
| | - | **2** | **Formas de Pagamento vs Desconto e Acessórios** | Agregado (Pagamento) | `venda`, `forma_pagamento`, `status_venda`, `venda_acessorio` | Correlação da modalidade de pagamento com a taxa de desconto médio concedida e o ticket médio gasto em acessórios. |
| **Henrique Hida**<br>`henrique-hida/` | **1** | **1** | **Evolução Mensal de Vendas por Modelo** | Agregado (Mês x Modelo) | `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo` | Vendas e faturamento mensal por modelo com ranking (`DENSE_RANK()`) e variação percentual mês a mês via `LAG()`. |
| | **1** | **2** | **Valor de Clientes e Adesão a Acessórios** | Agregado (Cliente) | `cliente`, `venda`, `venda_acessorio` | Segmentação de clientes via `NTILE(4)` (Estratégico, Alto valor, Intermediário, Baixo valor) somando receita de veículos e acessórios. |
| | **2** | **1** | **Evolução Mensal (Consolidada com Histórico)** | Agregado (Mês x Modelo) | `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo` | Mesma métrica da Entrega 1 consolidando todas as cargas históricas. |
| | **2** | **2** | **Valor de Clientes (Consolidado com Histórico)** | Agregado (Cliente) | `cliente`, `venda`, `hvenda`, `venda_acessorio`, `hvenda_acessorio` | Segmentação de clientes consolidando dados ativos e históricos. |
| **Matheus Schalch**<br>`matheus-schalch/` | **1** | **1** | **Base Analítica Regional & Híbridos (Corrente)** | **Transacional (1 linha por venda / 43 linhas)** | `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `cliente`, `cidade` | Base rica para Power BI com data, cliente, cidade, UF, modelo, motorização (híbrido/combustão), valores e descontos. |
| | **1** | **2** | **Base Analítica Pagamento & *Trade-in* (Corrente)** | **Transacional (1 linha por venda / 43 linhas)** | `venda`, `forma_pagamento`, `veiculo_troca` | Base rica para Power BI com data, forma de pagamento, entrada, parcelas, adesão a seminovos na troca, valor de avaliação e cobertura do usado. |
| | **2** | **1** | **Base Analítica Regional & Híbridos (Consolidada)** | **Transacional (1 linha por venda / 109 linhas)** | `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo`, `cliente`, `cidade` | Base analítica consolidando todo o histórico (Jan–Ago), permitindo slicers de período, mapas municipais e cálculos de eletrificação no Power BI. |
| | **2** | **2** | **Base Analítica Pagamento & *Trade-in* (Consolidada)** | **Transacional (1 linha por venda / 109 linhas)** | `venda`, `hvenda`, `forma_pagamento`, `veiculo_troca`, `hveiculo_troca` | Base consolidada completa para Power BI analisar conversão de financiamento, absorção de usados e taxas de cobertura ao longo do tempo. |

---

## 🎯 Detalhamento das Consultas do Matheus Schalch (Prontas para Views no Power BI)

As consultas do Matheus foram modeladas no nível da venda (grão transacional). Isso significa que no Power BI você pode:
1. Usar filtros dinâmicos de linha do tempo (*Slicers* por Ano, Trimestre ou Mês).
2. Filtrar por Cidade, Estado (UF), Modelo de Carro ou Forma de Pagamento.
3. Criar mapas de calor geográficos e cartões de KPI dinâmicos com DAX (`SUM`, `AVERAGE`, `COUNT`, `DIVIDE`).

### Entrega 1 (Apenas dados correntes — 43 registros)
- **Consulta 1:** [`matheus-schalch/entrega-1/consulta-1.sql`](file:///c:/Users/MATHEUS/Desktop/Fatec/5%20Sem/Lab%20de%20Banco/Repositorio/database-lab-assignment/sql/consultas/matheus-schalch/entrega-1/consulta-1.sql)
- **Consulta 2:** [`matheus-schalch/entrega-1/consulta-2.sql`](file:///c:/Users/MATHEUS/Desktop/Fatec/5%20Sem/Lab%20de%20Banco/Repositorio/database-lab-assignment/sql/consultas/matheus-schalch/entrega-1/consulta-2.sql)

### Entrega 2 (Consolidação completa: corrente + histórico — 109 registros)
- **Consulta 1:** [`matheus-schalch/entrega-2/consulta-1.sql`](file:///c:/Users/MATHEUS/Desktop/Fatec/5%20Sem/Lab%20de%20Banco/Repositorio/database-lab-assignment/sql/consultas/matheus-schalch/entrega-2/consulta-1.sql)
- **Consulta 2:** [`matheus-schalch/entrega-2/consulta-2.sql`](file:///c:/Users/MATHEUS/Desktop/Fatec/5%20Sem/Lab%20de%20Banco/Repositorio/database-lab-assignment/sql/consultas/matheus-schalch/entrega-2/consulta-2.sql)

---

## 🚀 Como Executar as Consultas no Docker

```bash
# Entrega 1 (43 linhas cada)
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/matheus-schalch/entrega-1/consulta-1.sql
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/matheus-schalch/entrega-1/consulta-2.sql

# Entrega 2 (109 linhas cada)
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/matheus-schalch/entrega-2/consulta-1.sql
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/matheus-schalch/entrega-2/consulta-2.sql
```
