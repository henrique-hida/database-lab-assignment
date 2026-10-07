-- ----------------------------------------------------------------------------
-- Diogo Jonsson - Entrega 2 - Consulta 1
-- Desempenho e ranking de modelos por faturamento e volume (com histórico)
-- Analisa o desempenho dos modelos de veículos através do faturamento
-- e volume de vendas para identificar os mais rentáveis
-- Consolida dados correntes e históricos
-- ----------------------------------------------------------------------------

WITH vendas_consolidadas AS (
    SELECT
        vnd_id,
        vnd_veiculo_id,
        vnd_valor_final,
        vnd_valor_carro,
        vnd_desconto,
        vnd_status_venda_id
    FROM concessionaria.venda
    UNION ALL
    SELECT
        vnd_id,
        vnd_veiculo_id,
        vnd_valor_final,
        vnd_valor_carro,
        vnd_desconto,
        vnd_status_venda_id
    FROM concessionaria.hvenda
),
veiculos_consolidados AS (
    SELECT
        vcl_id,
        vcl_versao_veiculo_id
    FROM concessionaria.veiculo
    UNION ALL
    SELECT
        vcl_id,
        vcl_versao_veiculo_id
    FROM concessionaria.hveiculo
),
vendas_por_modelo AS (
    SELECT
        mdv.mdv_nome AS modelo,
        COUNT(*) AS unidades_vendidas,
        SUM(vnd.vnd_valor_final) AS faturamento_total,
        ROUND(AVG(vnd.vnd_valor_final), 2) AS ticket_medio,
        ROUND(AVG(vnd.vnd_desconto), 2) AS desconto_medio,
        ROUND(SUM(vnd.vnd_desconto) / NULLIF(SUM(vnd.vnd_valor_carro), 0) * 100, 2) AS percentual_desconto_total
    FROM vendas_consolidadas AS vnd
    JOIN veiculos_consolidados AS vcl
        ON vcl.vcl_id = vnd.vnd_veiculo_id
    JOIN concessionaria.versao_veiculo AS vsv
        ON vsv.vsv_id = vcl.vcl_versao_veiculo_id
    JOIN concessionaria.modelo_veiculo AS mdv
        ON mdv.mdv_id = vsv.vsv_modelo_veiculo_id
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = vnd.vnd_status_venda_id
    WHERE svd.svd_nome = 'Entregue'
    GROUP BY mdv.mdv_nome
),
ranking AS (
    SELECT
        modelo,
        unidades_vendidas,
        faturamento_total,
        ticket_medio,
        desconto_medio,
        percentual_desconto_total,
        DENSE_RANK() OVER (ORDER BY faturamento_total DESC) AS ranking_faturamento,
        DENSE_RANK() OVER (ORDER BY unidades_vendidas DESC) AS ranking_volume
    FROM vendas_por_modelo
)
SELECT
    ranking_faturamento,
    ranking_volume,
    modelo,
    unidades_vendidas,
    ROUND(faturamento_total, 2) AS faturamento_total,
    ticket_medio,
    desconto_medio,
    percentual_desconto_total
FROM ranking
ORDER BY ranking_faturamento, ranking_volume, modelo;
