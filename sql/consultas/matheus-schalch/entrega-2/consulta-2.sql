-- ----------------------------------------------------------------------------
-- Matheus Schalch - Entrega 2 - Consulta 2 (Base Analítica Consolidada para Power BI)
-- Estrutura de Pagamento e Absorção de Veículos de Troca (Corrente + Histórico)
-- ----------------------------------------------------------------------------

WITH vendas_consolidadas AS (
    SELECT
        vnd_id,
        vnd_data_pedido,
        vnd_forma_pagamento_id,
        vnd_valor_carro,
        vnd_desconto,
        vnd_valor_final,
        vnd_entrada,
        vnd_parcelas,
        vnd_valor_parcela,
        'Corrente' AS tipo_registro
    FROM concessionaria.venda
    UNION ALL
    SELECT
        vnd_id,
        vnd_data_pedido,
        vnd_forma_pagamento_id,
        vnd_valor_carro,
        vnd_desconto,
        vnd_valor_final,
        vnd_entrada,
        vnd_parcelas,
        vnd_valor_parcela,
        'Histórico' AS tipo_registro
    FROM concessionaria.hvenda
),
trocas_consolidadas AS (
    SELECT
        vtr_id,
        vtr_venda_id,
        vtr_descricao,
        vtr_valor_avaliado
    FROM concessionaria.veiculo_troca
    UNION ALL
    SELECT
        vtr_id,
        vtr_venda_id,
        vtr_descricao,
        vtr_valor_avaliado
    FROM concessionaria.hveiculo_troca
)
SELECT
    vnd.vnd_id AS id_venda,
    vnd.tipo_registro,
    vnd.vnd_data_pedido AS data_pedido,
    DATE_TRUNC('month', vnd.vnd_data_pedido)::DATE AS mes_pedido,
    fpg.fpg_id AS id_forma_pagamento,
    fpg.fpg_descricao AS forma_pagamento,
    vnd.vnd_valor_carro AS valor_carro,
    vnd.vnd_desconto AS valor_desconto,
    vnd.vnd_valor_final AS valor_venda_final,
    COALESCE(vnd.vnd_entrada, 0) AS valor_entrada,
    ROUND(
        COALESCE(vnd.vnd_entrada, 0) / NULLIF(vnd.vnd_valor_final, 0) * 100,
        2
    ) AS percentual_entrada_pct,
    COALESCE(vnd.vnd_parcelas, 0) AS qtd_parcelas,
    COALESCE(vnd.vnd_valor_parcela, 0) AS valor_parcela,
    CASE
        WHEN vtr.vtr_id IS NOT NULL THEN 'Sim'
        ELSE 'Não'
    END AS tem_veiculo_troca,
    CASE
        WHEN vtr.vtr_id IS NOT NULL THEN 1
        ELSE 0
    END AS flag_troca,
    vtr.vtr_descricao AS modelo_veiculo_usado,
    COALESCE(vtr.vtr_valor_avaliado, 0) AS valor_avaliacao_usado,
    ROUND(
        COALESCE(vtr.vtr_valor_avaliado, 0) / NULLIF(vnd.vnd_valor_carro, 0) * 100,
        2
    ) AS cobertura_usado_pct
FROM vendas_consolidadas AS vnd
JOIN concessionaria.forma_pagamento AS fpg
    ON fpg.fpg_id = vnd.vnd_forma_pagamento_id
LEFT JOIN trocas_consolidadas AS vtr
    ON vtr.vtr_venda_id = vnd.vnd_id
ORDER BY
    vnd.vnd_data_pedido DESC,
    vnd.vnd_id DESC;
