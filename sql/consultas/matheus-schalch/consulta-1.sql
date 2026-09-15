WITH vendas_cidade_modelo AS (
    SELECT
        cdd.cdd_id,
        cdd.cdd_nome AS cidade,
        cdd.cdd_uf AS uf,
        mdv.mdv_nome AS modelo,
        COUNT(vnd.vnd_id) AS qtd_modelo,
        ROW_NUMBER() OVER (
            PARTITION BY cdd.cdd_id
            ORDER BY COUNT(vnd.vnd_id) DESC, SUM(vnd.vnd_valor_final) DESC
        ) AS rank_modelo_cidade
    FROM concessionaria.venda AS vnd
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = vnd.vnd_status_venda_id
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
    WHERE svd.svd_nome = 'Entregue'
    GROUP BY
        cdd.cdd_id,
        cdd.cdd_nome,
        cdd.cdd_uf,
        mdv.mdv_nome
),
totais_por_cidade AS (
    SELECT
        cdd.cdd_id,
        cdd.cdd_nome AS cidade,
        cdd.cdd_uf AS uf,
        COUNT(vnd.vnd_id) AS total_veiculos_vendidos,
        SUM(vnd.vnd_valor_final) AS faturamento_cidade,
        ROUND(AVG(vnd.vnd_valor_final), 2) AS ticket_medio_cidade,

        COUNT(*) FILTER (
            WHERE vsv.vsv_combustivel ILIKE '%Híbrido%'
        ) AS vendas_hibridos,

        ROUND(
            (COUNT(*) FILTER (WHERE vsv.vsv_combustivel ILIKE '%Híbrido%')::NUMERIC 
            / NULLIF(COUNT(vnd.vnd_id), 0)) * 100,
            1
        ) AS taxa_penetracao_hibridos_pct

    FROM concessionaria.venda AS vnd
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = vnd.vnd_status_venda_id
    JOIN concessionaria.cliente AS cln
        ON cln.cln_id = vnd.vnd_cliente_id
    JOIN concessionaria.cidade AS cdd
        ON cdd.cdd_id = cln.cln_cidade_id
    JOIN concessionaria.veiculo AS vcl
        ON vcl.vcl_id = vnd.vnd_veiculo_id
    JOIN concessionaria.versao_veiculo AS vsv
        ON vsv.vsv_id = vcl.vcl_versao_veiculo_id
    WHERE svd.svd_nome = 'Entregue'
    GROUP BY
        cdd.cdd_id,
        cdd.cdd_nome,
        cdd.cdd_uf
)
SELECT
    DENSE_RANK() OVER (
        ORDER BY tpc.faturamento_cidade DESC
    ) AS posicao_ranking,
    tpc.cidade,
    tpc.uf,
    tpc.total_veiculos_vendidos,
    tpc.faturamento_cidade,
    tpc.ticket_medio_cidade,

    ROUND(
        (tpc.faturamento_cidade / NULLIF(SUM(tpc.faturamento_cidade) OVER (), 0)) * 100,
        2
    ) AS market_share_faturamento_pct,

    vcm.modelo AS modelo_mais_vendido,
    vcm.qtd_modelo AS unidades_modelo_mais_vendido,

    tpc.vendas_hibridos,
    tpc.taxa_penetracao_hibridos_pct

FROM totais_por_cidade AS tpc
JOIN vendas_cidade_modelo AS vcm
    ON vcm.cdd_id = tpc.cdd_id
   AND vcm.rank_modelo_cidade = 1
ORDER BY
    posicao_ranking,
    tpc.cidade;
