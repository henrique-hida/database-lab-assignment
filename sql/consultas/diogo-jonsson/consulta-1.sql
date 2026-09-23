-- ----------------------------------------------------------------------------
-- Comparativo de desempenho comercial: Jan-Mar x Abr-Mai
-- Usa o historico gerado pela exclusao dos dados de Jan-Mar e compara
-- a media mensal de unidades e faturamento com a carga atual de Abr-Mai.
-- ----------------------------------------------------------------------------

WITH vendas_historicas AS (
    SELECT
        'Jan-Mar' AS periodo,
        DATE_TRUNC('month', hv.vnd_data_pedido)::DATE AS mes,
        mdv.mdv_nome AS modelo,
        hv.vnd_valor_final AS valor_final,
        hv.vnd_desconto AS desconto
    FROM concessionaria.hvenda AS hv
    JOIN concessionaria.hveiculo AS hvc
        ON hvc.vcl_id = hv.vnd_veiculo_id
    JOIN concessionaria.versao_veiculo AS vsv
        ON vsv.vsv_id = hvc.vcl_versao_veiculo_id
    JOIN concessionaria.modelo_veiculo AS mdv
        ON mdv.mdv_id = vsv.vsv_modelo_veiculo_id
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = hv.vnd_status_venda_id
    WHERE hv.vnd_data_pedido >= DATE '2026-01-01'
      AND hv.vnd_data_pedido < DATE '2026-04-01'
      AND svd.svd_nome = 'Entregue'
),
vendas_atuais AS (
    SELECT
        'Abr-Mai' AS periodo,
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
    WHERE vnd.vnd_data_pedido >= DATE '2026-04-01'
      AND vnd.vnd_data_pedido < DATE '2026-06-01'
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
        MAX(unidades_vendidas) FILTER (WHERE periodo = 'Jan-Mar') AS unidades_jan_mar,
        MAX(faturamento) FILTER (WHERE periodo = 'Jan-Mar') AS faturamento_jan_mar,
        MAX(unidades_vendidas) FILTER (WHERE periodo = 'Abr-Mai') AS unidades_abr_mai,
        MAX(faturamento) FILTER (WHERE periodo = 'Abr-Mai') AS faturamento_abr_mai,
        MAX(desconto_medio) FILTER (WHERE periodo = 'Jan-Mar') AS desconto_medio_jan_mar,
        MAX(desconto_medio) FILTER (WHERE periodo = 'Abr-Mai') AS desconto_medio_abr_mai
    FROM resumo
    GROUP BY modelo
)
SELECT
    modelo,
    COALESCE(unidades_jan_mar, 0) AS unidades_jan_mar,
    COALESCE(unidades_abr_mai, 0) AS unidades_abr_mai,
    ROUND(COALESCE(unidades_jan_mar, 0)::NUMERIC / 3, 2) AS media_mensal_jan_mar,
    ROUND(COALESCE(unidades_abr_mai, 0)::NUMERIC / 2, 2) AS media_mensal_abr_mai,
    ROUND(
        (
            (
                COALESCE(unidades_abr_mai, 0)::NUMERIC / 2
            ) - (
                COALESCE(unidades_jan_mar, 0)::NUMERIC / 3
            )
        )
        / NULLIF(COALESCE(unidades_jan_mar, 0)::NUMERIC / 3, 0)
        * 100,
        2
    ) AS variacao_media_mensal_unidades_pct,
    ROUND(COALESCE(faturamento_jan_mar, 0), 2) AS faturamento_jan_mar,
    ROUND(COALESCE(faturamento_abr_mai, 0), 2) AS faturamento_abr_mai,
    ROUND(COALESCE(faturamento_jan_mar, 0) / 3, 2) AS media_mensal_faturamento_jan_mar,
    ROUND(COALESCE(faturamento_abr_mai, 0) / 2, 2) AS media_mensal_faturamento_abr_mai,
    ROUND(desconto_medio_jan_mar, 2) AS desconto_medio_jan_mar,
    ROUND(desconto_medio_abr_mai, 2) AS desconto_medio_abr_mai
FROM comparativo
ORDER BY
    media_mensal_abr_mai DESC,
    modelo;
