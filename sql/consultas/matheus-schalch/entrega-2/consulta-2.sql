-- ----------------------------------------------------------------------------
-- Matheus Schalch - Entrega 2 - Consulta 2
-- Top 10 estrutura de financiamento e absorção de veículos de troca (com histórico)
-- Analisa a representatividade financeira das modalidades de pagamento por
-- modelo, as condições médias de entrada/parcelas e o impacto dos seminovos
-- Consolida dados correntes e históricos
-- ----------------------------------------------------------------------------

WITH vendas_consolidadas AS (
    SELECT
        vnd_id,
        vnd_veiculo_id,
        vnd_forma_pagamento_id,
        vnd_valor_carro,
        vnd_valor_final,
        vnd_entrada,
        vnd_parcelas,
        vnd_valor_parcela,
        vnd_status_venda_id
    FROM concessionaria.venda
    UNION ALL
    SELECT
        vnd_id,
        vnd_veiculo_id,
        vnd_forma_pagamento_id,
        vnd_valor_carro,
        vnd_valor_final,
        vnd_entrada,
        vnd_parcelas,
        vnd_valor_parcela,
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
trocas_consolidadas AS (
    SELECT
        vtr_venda_id,
        vtr_valor_avaliado
    FROM concessionaria.veiculo_troca
    UNION ALL
    SELECT
        vtr_venda_id,
        vtr_valor_avaliado
    FROM concessionaria.hveiculo_troca
),
trocas_por_venda AS (
    SELECT
        vtr_venda_id,
        SUM(vtr_valor_avaliado) AS valor_troca
    FROM trocas_consolidadas
    GROUP BY vtr_venda_id
),
consolidado_pagamento AS (
    SELECT
        fpg.fpg_descricao AS forma_pagamento,
        mdv.mdv_nome AS modelo,
        COUNT(*) AS total_vendas,
        SUM(vnd.vnd_valor_final) AS faturamento_total,
        ROUND(AVG(vnd.vnd_valor_final), 2) AS ticket_medio_venda,
        ROUND(
            AVG(COALESCE(vnd.vnd_entrada, 0) / NULLIF(vnd.vnd_valor_final, 0) * 100),
            2
        ) AS percentual_medio_entrada,
        COALESCE(ROUND(AVG(vnd.vnd_parcelas), 0), 0) AS prazo_medio_parcelas,
        COALESCE(ROUND(AVG(vnd.vnd_valor_parcela), 2), 0) AS valor_medio_parcela,
        COUNT(tpv.vtr_venda_id) AS vendas_com_troca,
        ROUND(
            COUNT(tpv.vtr_venda_id)::NUMERIC / NULLIF(COUNT(*), 0) * 100,
            2
        ) AS taxa_adesao_troca_pct,
        COALESCE(SUM(tpv.valor_troca), 0) AS volume_financeiro_trocas,
        ROUND(COALESCE(AVG(tpv.valor_troca), 0), 2) AS ticket_medio_usado_troca,
        COALESCE(
            ROUND(
                AVG(tpv.valor_troca / NULLIF(vnd.vnd_valor_carro, 0) * 100),
                2
            ),
            0
        ) AS cobertura_media_pelo_usado_pct
    FROM vendas_consolidadas AS vnd
    JOIN concessionaria.forma_pagamento AS fpg
        ON fpg.fpg_id = vnd.vnd_forma_pagamento_id
    JOIN veiculos_consolidados AS vcl
        ON vcl.vcl_id = vnd.vnd_veiculo_id
    JOIN concessionaria.versao_veiculo AS vsv
        ON vsv.vsv_id = vcl.vcl_versao_veiculo_id
    JOIN concessionaria.modelo_veiculo AS mdv
        ON mdv.mdv_id = vsv.vsv_modelo_veiculo_id
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = vnd.vnd_status_venda_id
    LEFT JOIN trocas_por_venda AS tpv
        ON tpv.vtr_venda_id = vnd.vnd_id
    WHERE svd.svd_nome = 'Entregue'
    GROUP BY
        fpg.fpg_descricao,
        mdv.mdv_nome
),
ranking_pagamento AS (
    SELECT
        RANK() OVER (
            ORDER BY faturamento_total DESC, total_vendas DESC
        ) AS posicao,
        forma_pagamento,
        modelo,
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
)
SELECT
    posicao,
    forma_pagamento,
    modelo,
    total_vendas,
    faturamento_total,
    representatividade_faturamento_pct,
    ticket_medio_venda,
    percentual_medio_entrada,
    prazo_medio_parcelas,
    valor_medio_parcela,
    vendas_com_troca,
    taxa_adesao_troca_pct,
    volume_financeiro_trocas,
    ticket_medio_usado_troca,
    cobertura_media_pelo_usado_pct
FROM ranking_pagamento
ORDER BY
    posicao,
    forma_pagamento,
    modelo
LIMIT 10;
