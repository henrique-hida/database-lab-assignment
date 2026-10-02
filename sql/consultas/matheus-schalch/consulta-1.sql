-- ----------------------------------------------------------------------------
-- Inteligência Geográfica de Vendas e Adoção de Veículos Híbridos
-- Consolida os dados históricos (Jan-Mar) e atuais (Abr-Mai) da concessionária
-- para ranquear o desempenho comercial por praça/cidade, identificar o modelo
-- mais vendido em cada região e avaliar a taxa de penetração da motorização híbrida.
-- ----------------------------------------------------------------------------

-- CTE 1: Unifica os registros de vendas ativas e históricas
WITH vendas_consolidadas AS (
    SELECT
        vnd_id,
        vnd_cliente_id,
        vnd_veiculo_id,
        vnd_forma_pagamento_id,
        vnd_valor_carro,
        vnd_desconto,
        vnd_valor_final,
        vnd_data_pedido,
        vnd_status_venda_id
    FROM concessionaria.venda -- Tabela de vendas do período corrente
    UNION ALL                 -- Junta sem checar duplicatas (mais rápido e preserva todo o histórico)
    SELECT
        vnd_id,
        vnd_cliente_id,
        vnd_veiculo_id,
        vnd_forma_pagamento_id,
        vnd_valor_carro,
        vnd_desconto,
        vnd_valor_final,
        vnd_data_pedido,
        vnd_status_venda_id
    FROM concessionaria.his_venda -- Tabela de vendas do período histórico
),

-- CTE 2: Unifica os veículos físicos ativos com os históricos
veiculos_consolidados AS (
    SELECT
        vcl_id,
        vcl_versao_veiculo_id,
        vcl_cor_id,
        vcl_status_veiculo_id
    FROM concessionaria.veiculo -- Tabela de veículos do estoque atual
    UNION ALL                   -- Empilha com os veículos do histórico
    SELECT
        vcl_id,
        vcl_versao_veiculo_id,
        vcl_cor_id,
        vcl_status_veiculo_id
    FROM concessionaria.his_veiculo -- Tabela de veículos do estoque histórico
),

-- CTE 3: Apura o volume de vendas por cidade e modelo, ranqueando o mais vendido por praça
vendas_cidade_modelo AS (
    SELECT
        cdd.cdd_id,
        cdd.cdd_nome AS cidade,
        cdd.cdd_uf AS uf,
        mdv.mdv_nome AS modelo,
        COUNT(vnd.vnd_id) AS qtd_modelo, -- Total de unidades do modelo vendidas na cidade
        -- Numera os modelos dentro de cada cidade do mais vendido para o menos vendido
        ROW_NUMBER() OVER (
            PARTITION BY cdd.cdd_id                                       -- Reinicia a contagem a cada nova cidade
            ORDER BY COUNT(vnd.vnd_id) DESC, SUM(vnd.vnd_valor_final) DESC -- Critério: mais unidades; desempate: maior receita
        ) AS rank_modelo_cidade
    FROM vendas_consolidadas AS vnd
    -- Joins dimensionais para mapear cliente, cidade, veículo e modelo
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = vnd.vnd_status_venda_id
    JOIN concessionaria.cliente AS cln
        ON cln.cln_id = vnd.vnd_cliente_id
    JOIN concessionaria.cidade AS cdd
        ON cdd.cdd_id = cln.cln_cidade_id
    JOIN veiculos_consolidados AS vcl
        ON vcl.vcl_id = vnd.vnd_veiculo_id
    JOIN concessionaria.versao_veiculo AS vsv
        ON vsv.vsv_id = vcl.vcl_versao_veiculo_id
    JOIN concessionaria.modelo_veiculo AS mdv
        ON mdv.mdv_id = vsv.vsv_modelo_veiculo_id
    WHERE svd.svd_nome = 'Entregue' -- Regra de negócio: considera somente negócios concretizados
    GROUP BY
        cdd.cdd_id,
        cdd.cdd_nome,
        cdd.cdd_uf,
        mdv.mdv_nome
),

-- CTE 4: Calcula as métricas agregadas da cidade (faturamento, ticket médio e penetração de híbridos)
totais_por_cidade AS (
    SELECT
        cdd.cdd_id,
        cdd.cdd_nome AS cidade,
        cdd.cdd_uf AS uf,
        COUNT(vnd.vnd_id) AS total_veiculos_vendidos,          -- Volume total de carros entregues na cidade
        SUM(vnd.vnd_valor_final) AS faturamento_cidade,        -- Receita total gerada pela praça
        ROUND(AVG(vnd.vnd_valor_final), 2) AS ticket_medio_cidade, -- Preço médio pago por carro na praça

        -- Conta apenas os veículos cujo tipo de combustível contém a palavra 'Híbrido' (case-insensitive)
        COUNT(*) FILTER (
            WHERE vsv.vsv_combustivel ILIKE '%Híbrido%'
        ) AS vendas_hibridos,

        -- Calcula a taxa percentual de penetração de híbridos sobre o total de carros vendidos na praça
        ROUND(
            (COUNT(*) FILTER (WHERE vsv.vsv_combustivel ILIKE '%Híbrido%')::NUMERIC 
            / NULLIF(COUNT(vnd.vnd_id), 0)) * 100, -- NULLIF evita divisão por zero caso contagem seja 0
            1
        ) AS taxa_penetracao_hibridos_pct

    FROM vendas_consolidadas AS vnd
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = vnd.vnd_status_venda_id
    JOIN concessionaria.cliente AS cln
        ON cln.cln_id = vnd.vnd_cliente_id
    JOIN concessionaria.cidade AS cdd
        ON cdd.cdd_id = cln.cln_cidade_id
    JOIN veiculos_consolidados AS vcl
        ON vcl.vcl_id = vnd.vnd_veiculo_id
    JOIN concessionaria.versao_veiculo AS vsv
        ON vsv.vsv_id = vcl.vcl_versao_veiculo_id
    WHERE svd.svd_nome = 'Entregue'
    GROUP BY
        cdd.cdd_id,
        cdd.cdd_nome,
        cdd.cdd_uf
)

-- Consulta principal: Consolida indicadores da cidade, o modelo líder e gera o ranking final
SELECT
    -- Classifica as cidades em ordem decrescente de receita (sem pular posições em empates)
    DENSE_RANK() OVER (
        ORDER BY tpc.faturamento_cidade DESC
    ) AS posicao_ranking,
    tpc.cidade,
    tpc.uf,
    tpc.total_veiculos_vendidos,
    tpc.faturamento_cidade,
    tpc.ticket_medio_cidade,

    -- Calcula a fatia de mercado (% share) de cada cidade sobre o faturamento total da rede
    ROUND(
        (tpc.faturamento_cidade / NULLIF(SUM(tpc.faturamento_cidade) OVER (), 0)) * 100,
        2
    ) AS market_share_faturamento_pct,

    vcm.modelo AS modelo_mais_vendido,              -- Nome do modelo top 1 da cidade
    vcm.qtd_modelo AS unidades_modelo_mais_vendido, -- Volume vendido do modelo top 1

    tpc.vendas_hibridos,
    tpc.taxa_penetracao_hibridos_pct

FROM totais_por_cidade AS tpc
-- Junta com a CTE de modelos buscando estritamente o 1º colocado de cada município
JOIN vendas_cidade_modelo AS vcm
    ON vcm.cdd_id = tpc.cdd_id
   AND vcm.rank_modelo_cidade = 1
ORDER BY
    posicao_ranking,
    tpc.cidade;