-- ----------------------------------------------------------------------------
-- Henrique Hida - Consulta 1
-- Evolucao mensal de vendas por modelo (Jan-Mai/2026)
-- Consolida a carga atual com as vendas e veiculos arquivados no historico.
-- ----------------------------------------------------------------------------

WITH vendas_consolidadas AS (
    SELECT vnd_id, vnd_veiculo_id, vnd_valor_final, vnd_desconto,
           vnd_data_pedido, vnd_status_venda_id
    FROM concessionaria.venda
    UNION ALL
    SELECT vnd_id, vnd_veiculo_id, vnd_valor_final, vnd_desconto,
           vnd_data_pedido, vnd_status_venda_id
    FROM concessionaria.hvenda
),
veiculos_consolidados AS (
    SELECT vcl_id, vcl_versao_veiculo_id
    FROM concessionaria.veiculo
    UNION ALL
    SELECT vcl_id, vcl_versao_veiculo_id
    FROM concessionaria.hveiculo
),
vendas_mensais AS (
    SELECT
        DATE_TRUNC('month', vnd.vnd_data_pedido)::DATE AS mes,
        mdv.mdv_nome AS modelo,
        COUNT(*) AS unidades_vendidas,
        SUM(vnd.vnd_valor_final) AS faturamento,
        AVG(vnd.vnd_desconto) AS desconto_medio
    FROM vendas_consolidadas AS vnd
    JOIN veiculos_consolidados AS vcl ON vcl.vcl_id = vnd.vnd_veiculo_id
    JOIN concessionaria.versao_veiculo AS vsv
        ON vsv.vsv_id = vcl.vcl_versao_veiculo_id
    JOIN concessionaria.modelo_veiculo AS mdv
        ON mdv.mdv_id = vsv.vsv_modelo_veiculo_id
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = vnd.vnd_status_venda_id
    WHERE svd.svd_nome = 'Entregue'
    GROUP BY DATE_TRUNC('month', vnd.vnd_data_pedido), mdv.mdv_nome
),
comparativo AS (
    SELECT
        mes,
        modelo,
        unidades_vendidas,
        faturamento,
        desconto_medio,
        DENSE_RANK() OVER (
            PARTITION BY mes
            ORDER BY faturamento DESC
        ) AS posicao_mes,
        LAG(faturamento) OVER (
            PARTITION BY modelo
            ORDER BY mes
        ) AS faturamento_mes_anterior
    FROM vendas_mensais
)
SELECT
    TO_CHAR(mes, 'YYYY-MM') AS mes,
    modelo,
    unidades_vendidas,
    ROUND(faturamento, 2) AS faturamento,
    ROUND(desconto_medio, 2) AS desconto_medio,
    posicao_mes,
    ROUND(
        (faturamento - faturamento_mes_anterior)
        / NULLIF(faturamento_mes_anterior, 0) * 100,
        2
    ) AS variacao_percentual_faturamento
FROM comparativo
ORDER BY mes, posicao_mes, modelo;
