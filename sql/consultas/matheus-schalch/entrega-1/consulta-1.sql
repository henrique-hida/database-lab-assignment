-- ----------------------------------------------------------------------------
-- Matheus Schalch - Entrega 1 - Consulta 1
-- Top 10 desempenho regional de vendas e adoção de veículos híbridos
-- Analisa quais mercados municipais e modelos lideram o faturamento da
-- concessionária e mede a taxa de penetração da motorização híbrida
-- Usa apenas dados correntes
-- ----------------------------------------------------------------------------

WITH desempenho_regional AS (
    SELECT
        cdd.cdd_nome AS cidade,
        cdd.cdd_uf AS uf,
        mdv.mdv_nome AS modelo,
        COUNT(*) AS unidades_vendidas,
        COUNT(*) FILTER (
            WHERE vsv.vsv_combustivel ILIKE '%Híbrido%'
        ) AS vendas_hibridos,
        SUM(vnd.vnd_valor_final) AS faturamento_total,
        ROUND(AVG(vnd.vnd_valor_final), 2) AS ticket_medio
    FROM concessionaria.venda AS vnd
    JOIN concessionaria.cliente AS cln
        ON cln.cln_id = vnd.vnd_cliente_id
    JOIN concessionaria.cidade AS cdd
        ON cdd.cdd_id = cln.cln_cidade_id
    JOIN concessionaria.veiculo AS vcl
        ON vcl.vcl_id = vnd.vnd_veiculo_id
    JOIN concessionaria.versao_veiculo AS vsv
        ON vsv.vsv_id = vcl.vcl_versao_veiculo_id
    JOIN concessionaria.modelo_veiculo AS mdv
        ON mdv.mdv_id = vsv.vsv_modelo_veiculo_id
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = vnd.vnd_status_venda_id
    WHERE svd.svd_nome = 'Entregue'
    GROUP BY
        cdd.cdd_nome,
        cdd.cdd_uf,
        mdv.mdv_nome
),
ranking_regional AS (
    SELECT
        RANK() OVER (
            ORDER BY faturamento_total DESC, unidades_vendidas DESC
        ) AS posicao,
        cidade,
        uf,
        modelo,
        unidades_vendidas,
        vendas_hibridos,
        ROUND(
            vendas_hibridos::NUMERIC / NULLIF(unidades_vendidas, 0) * 100,
            2
        ) AS taxa_penetracao_hibridos_pct,
        ROUND(faturamento_total, 2) AS faturamento_total,
        ticket_medio,
        ROUND(
            faturamento_total / NULLIF(SUM(faturamento_total) OVER (), 0) * 100,
            2
        ) AS participacao_faturamento_pct
    FROM desempenho_regional
)
SELECT
    posicao,
    cidade,
    uf,
    modelo,
    unidades_vendidas,
    vendas_hibridos,
    taxa_penetracao_hibridos_pct,
    faturamento_total,
    ticket_medio,
    participacao_faturamento_pct
FROM ranking_regional
ORDER BY
    posicao,
    cidade,
    modelo
LIMIT 10;
