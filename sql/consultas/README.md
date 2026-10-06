# Mapeamento e Resumo das Consultas SQL — Concessionária Toyota Tsusho

Este documento resume as consultas analíticas desenvolvidas pelo grupo no projeto da concessionária Toyota Tsusho, detalhando os objetivos de negócio, as tabelas utilizadas e os diferenciais de cada análise (estruturadas para virarem Views e integrarem o Power BI).

---

## 📊 Matriz Comparativa das Consultas

| Integrante / Pasta | Entrega | Consulta | Título da Análise | Tabelas Utilizadas | Foco e Métricas Principais |
| :--- | :---: | :---: | :--- | :--- | :--- |
| **Diogo Jonsson**<br>`diogo-jonsson/` | - | **1** | **Comparativo Comercial por Períodos** | `hvenda`, `hveiculo`, `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `status_venda` | Média mensal de vendas, faturamento e desconto médio por modelo de veículo entre períodos. |
| | - | **2** | **Lead Time Operacional de Vendas por Cidade** | `venda`, `status_venda`, `cliente`, `cidade` | Prazos médios em dias (pedido → faturamento, faturamento → entrega e pedido → entrega) e % de entregas rápidas (≤ 7 dias). |
| **Enzo Kuwamoto**<br>`enzo-kuwamoto/` | - | **1** | **Matriz de Vendas Cruzadas (*Cross-selling*)** | `venda_acessorio`, `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo`, `acessorio`, `categoria_acessorio`, `status_venda` | Volume de combos de veículos + categorias de acessórios instalados, total de itens e faturamento gerado por acessório. |
| | - | **2** | **Formas de Pagamento vs Desconto e Acessórios** | `venda`, `forma_pagamento`, `status_venda`, `venda_acessorio` | Correlação da modalidade de pagamento com a taxa de desconto médio concedida e o ticket médio gasto em acessórios. |
| **Henrique Hida**<br>`henrique-hida/` | **1** | **1** | **Evolução Mensal de Vendas por Modelo** | `venda`, `veiculo`, `versao_veiculo`, `modelo_veiculo` | Vendas e faturamento mensal por modelo com ranking (`DENSE_RANK()`) e variação percentual mês a mês via `LAG()`. |
| | **1** | **2** | **Valor de Clientes e Adesão a Acessórios** | `cliente`, `venda`, `venda_acessorio` | Segmentação de clientes via `NTILE(4)` (Estratégico, Alto valor, Intermediário, Baixo valor) somando receita de veículos e acessórios. |
| | **2** | **1** | **Evolução Mensal (Consolidada com Histórico)** | `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `modelo_veiculo` | Mesma métrica da Entrega 1 consolidando todas as cargas históricas. |
| | **2** | **2** | **Valor de Clientes (Consolidado com Histórico)** | `cliente`, `venda`, `hvenda`, `venda_acessorio`, `hvenda_acessorio` | Segmentação de clientes consolidando dados ativos e históricos. |
| **Matheus Schalch**<br>`matheus-schalch/` | **1** | **1** | **Inteligência Geográfica e Híbridos (Corrente)** | `venda`, `veiculo`, `versao_veiculo`, `cliente`, `cidade` | Faturamento por município, *market share* regional, ticket médio e taxa de penetração de veículos híbridos. |
| | **1** | **2** | **Estrutura de Pagamento e *Trade-in* (Corrente)** | `venda`, `veiculo_troca`, `forma_pagamento` | Distribuição de modalidades financeiras, entrada média, prazos, taxa de adesão ao usado na troca, volume financeiro de *trade-in* e taxa de cobertura. |
| | **2** | **1** | **Inteligência Geográfica e Híbridos (Consolidada)** | `venda`, `hvenda`, `veiculo`, `hveiculo`, `versao_veiculo`, `cliente`, `cidade` | Desempenho regional consolidado cobrindo todas as cargas históricas e atuais. |
| | **2** | **2** | **Estrutura de Pagamento e *Trade-in* (Consolidada)** | `venda`, `hvenda`, `veiculo_troca`, `hveiculo_troca`, `forma_pagamento` | Estrutura de financiamento e impacto de seminovos consolidando dados ativos e históricos. |

---

## 🎯 Detalhamento das Consultas do Matheus Schalch

As consultas foram simplificadas sem filtros hardcoded restritivos para permitir que o **Power BI** faça dinamicamente os filtros por data, cidade, status, etc.

### Entrega 1 (Apenas dados correntes / sem histórico)
- **Consulta 1:** [`matheus-schalch/entrega-1/consulta-1.sql`](file:///c:/Users/MATHEUS/Desktop/Fatec/5%20Sem/Lab%20de%20Banco/Repositorio/database-lab-assignment/sql/consultas/matheus-schalch/entrega-1/consulta-1.sql)
- **Consulta 2:** [`matheus-schalch/entrega-1/consulta-2.sql`](file:///c:/Users/MATHEUS/Desktop/Fatec/5%20Sem/Lab%20de%20Banco/Repositorio/database-lab-assignment/sql/consultas/matheus-schalch/entrega-1/consulta-2.sql)

### Entrega 2 (Consolidação com dados históricos via `UNION ALL`)
- **Consulta 1:** [`matheus-schalch/entrega-2/consulta-1.sql`](file:///c:/Users/MATHEUS/Desktop/Fatec/5%20Sem/Lab%20de%20Banco/Repositorio/database-lab-assignment/sql/consultas/matheus-schalch/entrega-2/consulta-1.sql)
- **Consulta 2:** [`matheus-schalch/entrega-2/consulta-2.sql`](file:///c:/Users/MATHEUS/Desktop/Fatec/5%20Sem/Lab%20de%20Banco/Repositorio/database-lab-assignment/sql/consultas/matheus-schalch/entrega-2/consulta-2.sql)

---

## 🚀 Como Executar as Consultas no Docker

```bash
# Entrega 1 (Sem histórico)
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/matheus-schalch/entrega-1/consulta-1.sql
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/matheus-schalch/entrega-1/consulta-2.sql

# Entrega 2 (Com histórico)
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/matheus-schalch/entrega-2/consulta-1.sql
docker compose exec -T postgres psql -U tsusho_admin -d tsusho < sql/consultas/matheus-schalch/entrega-2/consulta-2.sql
```
