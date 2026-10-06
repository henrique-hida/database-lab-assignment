-- ----------------------------------------------------------------------------
-- Matheus Schalch - Entrega 2 - Consulta 2
-- Estrutura de Financiamento e Veículos de Troca (Trade-in) com dados consolidados
-- Responde à dúvida: qual a representatividade de cada forma de pagamento,
-- as condições médias de parcelamento/entrada e o impacto da absorção de seminovos
-- considerando todo o histórico da concessionária?
-- ----------------------------------------------------------------------------

WITH vendas_consolidadas AS (
    SELECT
        vnd_id,
        vnd_forma_pagamento_id,
        vnd_valor_carro,
        vnd_valor_final,
        vnd_entrada,
        vnd_parcelas,
        vnd_valor_parcela
    FROM concessionaria.venda
    UNION ALL
    SELECT
        vnd_id,
        vnd_forma_pagamento_id,
        vnd_valor_carro,
        vnd_valor_final,
        vnd_entrada,
        vnd_parcelas,
        vnd_valor_parcela
    FROM concessionaria.hvenda
),
trocas_consolidadas AS (
    SELECT
        vtr_id,
        vtr_venda_id,
        vtr_valor_avaliado
    FROM concessionaria.veiculo_troca
    UNION ALL
    SELECT
        vtr_id,
        vtr_venda_id,
        vtr_valor_avaliado
    FROM concessionaria.hveiculo_troca
),
trocas_por_venda AS (
    SELECT
        vtr_venda_id,
        vtr_valor_avaliado AS valor_troca
    FROM trocas_consolidadas
),
consolidado_pagamento AS (
    SELECT
        fpg.fpg_id,
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
        COUNT(tpv.vtr_venda_id) AS vendas_com_troca,
        ROUND(
            COUNT(tpv.vtr_venda_id)::NUMERIC / NULLIF(COUNT(vnd.vnd_id), 0) * 100,
            2
        ) AS taxa_adesao_troca_pct,
        COALESCE(SUM(tpv.valor_troca), 0) AS volume_financeiro_trocas,
        ROUND(COALESCE(AVG(tpv.valor_troca), 0), 2) AS ticket_medio_usado_troca,
        ROUND(
            AVG(tpv.valor_troca / NULLIF(vnd.vnd_valor_carro, 0) * 100),
            2
        ) AS cobertura_media_pelo_usado_pct
    FROM vendas_consolidadas AS vnd
    JOIN concessionaria.forma_pagamento AS fpg
        ON fpg.fpg_id = vnd.vnd_forma_pagamento_id
    LEFT JOIN trocas_por_venda AS tpv
        ON tpv.vtr_venda_id = vnd.vnd_id
    GROUP BY
        fpg.fpg_id,
        fpg.fpg_descricao
)
SELECT
    RANK() OVER (ORDER BY faturamento_total DESC) AS posicao,
    forma_pagamento,
    total_vendas,
    ROUND(faturamento_total, 2) AS faturamento_total,
    ROUND(
        faturamento_total / NULLIF(SUM(faturamento_total) OVER (), 0) * 100,
        2
    ) AS representatividade_faturamento_pct,
    ticket_medio_venda,
    percentual_medio_entrada,
    prazo_medio_parcelas,
    valor_medio_parcela,
    vendas_com_troca,
    taxa_adesao_troca_pct,
    ROUND(volume_financeiro_trocas, 2) AS volume_financeiro_trocas,
    ticket_medio_usado_troca,
    cobertura_media_pelo_usado_pct
FROM consolidado_pagamento
ORDER BY posicao, forma_pagamento;
