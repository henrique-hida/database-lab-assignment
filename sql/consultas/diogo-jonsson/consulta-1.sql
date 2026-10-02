-- ----------------------------------------------------------------------------
-- Comparativo de desempenho comercial: Jan-Mai x Jun-Ago
-- Usa o historico gerado pela exclusao dos dados de Jan-Mai e compara
-- a media mensal de unidades e faturamento com a carga atual de Jun-Ago.
-- ----------------------------------------------------------------------------

WITH vendas_historicas AS (
    SELECT
        'Jan-Mai' AS periodo,
        DATE_TRUNC('month', his_venda.vnd_data_pedido)::DATE AS mes,
        mdv.mdv_nome AS modelo,
        his_venda.vnd_valor_final AS valor_final,
        his_venda.vnd_desconto AS desconto
    FROM concessionaria.his_venda
    JOIN concessionaria.his_veiculo
        ON his_veiculo.vcl_id = his_venda.vnd_veiculo_id
    JOIN concessionaria.versao_veiculo AS vsv
        ON vsv.vsv_id = his_veiculo.vcl_versao_veiculo_id
    JOIN concessionaria.modelo_veiculo AS mdv
        ON mdv.mdv_id = vsv.vsv_modelo_veiculo_id
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = his_venda.vnd_status_venda_id
    WHERE his_venda.vnd_data_pedido >= DATE '2026-01-01'
      AND his_venda.vnd_data_pedido < DATE '2026-06-01'
      AND svd.svd_nome = 'Entregue'
),
vendas_atuais AS (
    SELECT
        'Jun-Ago' AS periodo,
        DATE_TRUNC('month', vnd.vnd_data_pedido)::DATE AS mes,
        mdv.mdv_nome AS modelo,
        vnd.vnd_valor_final AS valor_final,
        vnd.vnd_desconto AS desconto
    FROM concessionaria.venda AS vnd
    JOIN concessionaria.veiculo AS vcl
        ON vcl.vcl_id = vnd.vnd_veiculo_id
    JOIN concessionaria.versao_veiculo AS vsv
        ON vsv.vsv_id = vcl.vcl_versao_veiculo_id
    JOIN concessionaria.modelo_veiculo AS mdv
        ON mdv.mdv_id = vsv.vsv_modelo_veiculo_id
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = vnd.vnd_status_venda_id
    WHERE vnd.vnd_data_pedido >= DATE '2026-06-01'
      AND vnd.vnd_data_pedido < DATE '2026-09-01'
      AND svd.svd_nome = 'Entregue'
),
periodos AS (
    SELECT * FROM vendas_historicas
    UNION ALL
    SELECT * FROM vendas_atuais
),
resumo AS (
    SELECT
        periodo,
        modelo,
        COUNT(*) AS unidades_vendidas,
        SUM(valor_final) AS faturamento,
        ROUND(AVG(desconto), 2) AS desconto_medio
    FROM periodos
    GROUP BY periodo, modelo
),
comparativo AS (
    SELECT
        modelo,
        MAX(unidades_vendidas) FILTER (WHERE periodo = 'Jan-Mai') AS unidades_jan_mai,
        MAX(faturamento) FILTER (WHERE periodo = 'Jan-Mai') AS faturamento_jan_mai,
        MAX(unidades_vendidas) FILTER (WHERE periodo = 'Jun-Ago') AS unidades_jun_ago,
        MAX(faturamento) FILTER (WHERE periodo = 'Jun-Ago') AS faturamento_jun_ago,
        MAX(desconto_medio) FILTER (WHERE periodo = 'Jan-Mai') AS desconto_medio_jan_mai,
        MAX(desconto_medio) FILTER (WHERE periodo = 'Jun-Ago') AS desconto_medio_jun_ago
    FROM resumo
    GROUP BY modelo
)
SELECT
    modelo,
    COALESCE(unidades_jan_mai, 0) AS unidades_jan_mai,
    COALESCE(unidades_jun_ago, 0) AS unidades_jun_ago,
    ROUND(COALESCE(unidades_jan_mai, 0)::NUMERIC / 5, 2) AS media_mensal_jan_mai,
    ROUND(COALESCE(unidades_jun_ago, 0)::NUMERIC / 3, 2) AS media_mensal_jun_ago,
    ROUND(
        (
            (
                COALESCE(unidades_jun_ago, 0)::NUMERIC / 3
            ) - (
                COALESCE(unidades_jan_mai, 0)::NUMERIC / 5
            )
        )
        / NULLIF(COALESCE(unidades_jan_mai, 0)::NUMERIC / 5, 0)
        * 100,
        2
    ) AS variacao_media_mensal_unidades_pct,
    ROUND(COALESCE(faturamento_jan_mai, 0), 2) AS faturamento_jan_mai,
    ROUND(COALESCE(faturamento_jun_ago, 0), 2) AS faturamento_jun_ago,
    ROUND(COALESCE(faturamento_jan_mai, 0) / 5, 2) AS media_mensal_faturamento_jan_mai,
    ROUND(COALESCE(faturamento_jun_ago, 0) / 3, 2) AS media_mensal_faturamento_jun_ago,
    ROUND(desconto_medio_jan_mai, 2) AS desconto_medio_jan_mai,
    ROUND(desconto_medio_jun_ago, 2) AS desconto_medio_jun_ago
FROM comparativo
ORDER BY
    media_mensal_jun_ago DESC,
    modelo;
