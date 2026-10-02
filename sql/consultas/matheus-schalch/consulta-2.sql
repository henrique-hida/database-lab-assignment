-- ----------------------------------------------------------------------------
-- Estrutura de Financiamento e Impacto dos Veículos de Troca (Trade-in)
-- Consolida os dados históricos (Jan-Mar) e atuais (Abr-Mai) da concessionária
-- para analisar a distribuição das modalidades de pagamento, condições
-- financeiras (entrada, parcelas) e a efetividade do programa de absorção de
-- veículos seminovos na troca (volume financeiro, ticket médio e taxa de cobertura).
-- ----------------------------------------------------------------------------

-- CTE 1: Consolida as condições de pagamento e valores das vendas ativas e históricas
WITH vendas_consolidadas AS (
    SELECT
        vnd_id,
        vnd_forma_pagamento_id,
        vnd_valor_carro,
        vnd_desconto,
        vnd_valor_final,
        vnd_entrada,
        vnd_parcelas,
        vnd_valor_parcela,
        vnd_status_venda_id
    FROM concessionaria.venda -- Vendas correntes
    UNION ALL                 -- Unificação rápida sem remoção de duplicatas
    SELECT
        vnd_id,
        vnd_forma_pagamento_id,
        vnd_valor_carro,
        vnd_desconto,
        vnd_valor_final,
        vnd_entrada,
        vnd_parcelas,
        vnd_valor_parcela,
        vnd_status_venda_id
    FROM concessionaria.his_venda -- Vendas históricas
),

-- CTE 2: Consolida os seminovos aceitos como parte de pagamento (trade-in)
trocas_consolidadas AS (
    SELECT
        vtr_id,
        vtr_venda_id,
        vtr_descricao,
        vtr_valor_avaliado
    FROM concessionaria.veiculo_troca -- Seminovos de negociações correntes
    UNION ALL                         -- Empilha com o histórico
    SELECT
        vtr_id,
        vtr_venda_id,
        vtr_descricao,
        vtr_valor_avaliado
    FROM concessionaria.his_veiculo_troca -- Seminovos de negociações históricas
),

-- CTE 3: Simplifica a tabela de trocas para facilitar a junção com a venda
resumo_trocas_por_venda AS (
    SELECT
        vtr_venda_id,
        vtr_valor_avaliado AS valor_troca
    FROM trocas_consolidadas
),

-- CTE 4: Agrupa por modalidade de pagamento e calcula os indicadores financeiros e de troca
consolidado_pagamento AS (
    SELECT
        fpg.fpg_descricao AS forma_pagamento,
        COUNT(vnd.vnd_id) AS total_vendas,                     -- Quantidade de veículos comercializados
        SUM(vnd.vnd_valor_final) AS faturamento_total,         -- Volume financeiro faturado no método
        ROUND(AVG(vnd.vnd_valor_final), 2) AS ticket_medio_venda, -- Valor médio por carro na modalidade

        -- Percentual médio que o cliente paga como entrada sobre o valor final do carro
        ROUND(
            AVG(COALESCE(vnd.vnd_entrada, 0) / NULLIF(vnd.vnd_valor_final, 0) * 100),
            2
        ) AS percentual_medio_entrada,
        ROUND(AVG(vnd.vnd_parcelas), 0) AS prazo_medio_parcelas, -- Média do número de parcelas contratadas
        ROUND(AVG(vnd.vnd_valor_parcela), 2) AS valor_medio_parcela, -- Custo médio mensal da parcela

        -- Indicadores operacionais do veículo usado dado como parte do pagamento
        COUNT(rtv.vtr_venda_id) AS vendas_com_troca,           -- Quantidade de negócios que aceitaram carro usado
        COALESCE(SUM(rtv.valor_troca), 0) AS volume_financeiro_trocas, -- Total em R$ absorvido em veículos seminovos
        ROUND(COALESCE(AVG(rtv.valor_troca), 0), 2) AS ticket_medio_usado_troca, -- Valor médio pago por cada seminovo

        -- Quanto o seminovo cobriu percentualmente em relação ao valor de tabela do veículo novo
        ROUND(
            AVG(
                (rtv.valor_troca / NULLIF(vnd.vnd_valor_carro, 0)) * 100
            ),
            2
        ) AS cobertura_media_pelo_usado_pct

    FROM vendas_consolidadas AS vnd
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = vnd.vnd_status_venda_id
    JOIN concessionaria.forma_pagamento AS fpg
        ON fpg.fpg_id = vnd.vnd_forma_pagamento_id
    -- LEFT JOIN garante que vendas SEM veículo de troca também permaneçam no cálculo
    LEFT JOIN resumo_trocas_por_venda AS rtv
        ON rtv.vtr_venda_id = vnd.vnd_id
    WHERE svd.svd_nome = 'Entregue' -- Considera apenas negócios finalizados
    GROUP BY fpg.fpg_descricao
)

-- Consulta final: Cria o ranking dos métodos de pagamento e métricas de adesão
SELECT
    -- Cria o ranking financeiro das formas de pagamento (da que mais fatura para a que menos fatura)
    RANK() OVER (
        ORDER BY faturamento_total DESC
    ) AS ranking_faturamento,
    forma_pagamento,
    total_vendas,
    faturamento_total,

    -- Participação percentual de cada forma de pagamento sobre a receita total da concessionária
    ROUND(
        (faturamento_total / NULLIF(SUM(faturamento_total) OVER (), 0)) * 100,
        2
    ) AS representatividade_faturamento_pct,

    ticket_medio_venda,
    percentual_medio_entrada,
    prazo_medio_parcelas,
    valor_medio_parcela,

    vendas_com_troca,
    -- Taxa de adesão: porcentagem das vendas da modalidade que envolveram seminovo como entrada
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