WITH resumo_trocas_por_venda AS (
    SELECT
        vtr.vtr_venda_id,
        vtr.vtr_valor_avaliado AS valor_troca
    FROM concessionaria.veiculo_troca AS vtr
),
consolidado_pagamento AS (
    SELECT
        fpg.fpg_descricao AS forma_pagamento,
        COUNT(vnd.vnd_id) AS total_vendas,
        SUM(vnd.vnd_valor_final) AS faturamento_total,
        ROUND(AVG(vnd.vnd_valor_final), 2) AS ticket_medio_venda,

        ROUND(
            AVG(COALESCE(vnd.vnd_entrada, 0) / NULLIF(vnd.vnd_valor_final, 0) * 100),
            2
        ) AS percentual_medio_entrada,
        ROUND(AVG(vnd.vnd_parcelas), 0) AS prazo_medio_parcelas,
        ROUND(AVG(vnd.vnd_valor_parcela), 2) AS valor_medio_parcela,

        COUNT(rtv.vtr_venda_id) AS vendas_com_troca,
        COALESCE(SUM(rtv.valor_troca), 0) AS volume_financeiro_trocas,
        ROUND(COALESCE(AVG(rtv.valor_troca), 0), 2) AS ticket_medio_usado_troca,

        ROUND(
            AVG(
                (rtv.valor_troca / NULLIF(vnd.vnd_valor_carro, 0)) * 100
            ),
            2
        ) AS cobertura_media_pelo_usado_pct

    FROM concessionaria.venda AS vnd
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = vnd.vnd_status_venda_id
    JOIN concessionaria.forma_pagamento AS fpg
        ON fpg.fpg_id = vnd.vnd_forma_pagamento_id
    LEFT JOIN resumo_trocas_por_venda AS rtv
        ON rtv.vtr_venda_id = vnd.vnd_id
    WHERE svd.svd_nome = 'Entregue'
    GROUP BY fpg.fpg_descricao
)
SELECT
    RANK() OVER (
        ORDER BY faturamento_total DESC
    ) AS ranking_faturamento,
    forma_pagamento,
    total_vendas,
    faturamento_total,

    ROUND(
        (faturamento_total / NULLIF(SUM(faturamento_total) OVER (), 0)) * 100,
        2
    ) AS representatividade_faturamento_pct,

    ticket_medio_venda,
    percentual_medio_entrada,
    prazo_medio_parcelas,
    valor_medio_parcela,

    vendas_com_troca,
    ROUND(
        (vendas_com_troca::NUMERIC / total_vendas) * 100,
        1
    ) AS taxa_adesao_troca_pct,
    volume_financeiro_trocas,
    ticket_medio_usado_troca,
    cobertura_media_pelo_usado_pct
FROM consolidado_pagamento
ORDER BY
    ranking_faturamento;
