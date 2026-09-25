-- ----------------------------------------------------------------------------
-- Prazo operacional de vendas por cidade
-- Mede o tempo entre pedido, faturamento e entrega para identificar
-- diferencas operacionais entre os mercados atendidos pela concessionaria.
-- ----------------------------------------------------------------------------

SELECT
    cdd.cdd_nome AS cidade,
    cdd.cdd_uf AS uf,
    COUNT(vnd.vnd_id) AS vendas_entregues,
    ROUND(AVG(vnd.vnd_valor_final), 2) AS ticket_medio,
    ROUND(AVG(vnd.vnd_data_faturamento - vnd.vnd_data_pedido), 2) AS media_dias_pedido_faturamento,
    ROUND(
        AVG(vnd.vnd_data_entrega - vnd.vnd_data_faturamento)
        FILTER (WHERE vnd.vnd_data_faturamento IS NOT NULL),
        2
    ) AS media_dias_faturamento_entrega,
    ROUND(AVG(vnd.vnd_data_entrega - vnd.vnd_data_pedido), 2) AS media_dias_pedido_entrega,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE vnd.vnd_data_entrega - vnd.vnd_data_pedido <= 7
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS percentual_entregas_ate_7_dias
FROM concessionaria.venda AS vnd
JOIN concessionaria.status_venda AS svd
    ON svd.svd_id = vnd.vnd_status_venda_id
JOIN concessionaria.cliente AS cln
    ON cln.cln_id = vnd.vnd_cliente_id
JOIN concessionaria.cidade AS cdd
    ON cdd.cdd_id = cln.cln_cidade_id
WHERE svd.svd_nome = 'Entregue'
  AND vnd.vnd_data_pedido >= DATE '2026-04-01'
  AND vnd.vnd_data_pedido < DATE '2026-06-01'
GROUP BY
    cdd.cdd_id,
    cdd.cdd_nome,
    cdd.cdd_uf
ORDER BY
    media_dias_pedido_entrega DESC,
    cidade;
