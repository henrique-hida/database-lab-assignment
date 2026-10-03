-- ----------------------------------------------------------------------------
-- Henrique Hida - Consulta 1
-- Evolucao mensal de vendas por modelo
-- Responde a duvida: quais modelos lideram o faturamento em cada
-- mes e como o faturamento de cada modelo varia em relacao ao mes anterior?
-- ----------------------------------------------------------------------------

WITH vendas_mensais AS (
    SELECT
        DATE_TRUNC('month', vnd.vnd_data_pedido)::DATE AS mes,
        mdv.mdv_nome AS modelo,
        COUNT(*) AS unidades_vendidas,
        SUM(vnd.vnd_valor_final) AS faturamento,
        AVG(vnd.vnd_desconto) AS desconto_medio
    FROM concessionaria.venda AS vnd
    JOIN concessionaria.veiculo AS vcl ON vcl.vcl_id = vnd.vnd_veiculo_id
    JOIN concessionaria.versao_veiculo AS vsv
        ON vsv.vsv_id = vcl.vcl_versao_veiculo_id
    JOIN concessionaria.modelo_veiculo AS mdv
        ON mdv.mdv_id = vsv.vsv_modelo_veiculo_id
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
