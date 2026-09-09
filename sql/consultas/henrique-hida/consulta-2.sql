WITH acessorios_por_venda AS (
    SELECT
        vac.vac_venda_id,
        SUM(vac.vac_total) AS valor_acessorios
    FROM concessionaria.venda_acessorio AS vac
    GROUP BY vac.vac_venda_id
),
resumo_cliente AS (
    SELECT
        cln.cln_id,
        cln.cln_nome,
        cln.cln_tipo_pessoa,
        COUNT(vnd.vnd_id) AS quantidade_compras,

        COUNT(*) FILTER (
            WHERE COALESCE(apv.valor_acessorios, 0) > 0
        ) AS compras_com_acessorios,

        SUM(vnd.vnd_valor_final) AS receita_veiculos,
        SUM(COALESCE(apv.valor_acessorios, 0)) AS receita_acessorios,

        SUM(
            vnd.vnd_valor_final
            + COALESCE(apv.valor_acessorios, 0)
        ) AS receita_total

    FROM concessionaria.cliente AS cln
    JOIN concessionaria.venda AS vnd
        ON vnd.vnd_cliente_id = cln.cln_id
    LEFT JOIN acessorios_por_venda AS apv
        ON apv.vac_venda_id = vnd.vnd_id
    WHERE vnd.vnd_status = 'Entregue'
    GROUP BY
        cln.cln_id,
        cln.cln_nome,
        cln.cln_tipo_pessoa
),
classificacao AS (
    SELECT
        resumo_cliente.*,

        RANK() OVER (
            ORDER BY receita_total DESC
        ) AS posicao,

        NTILE(4) OVER (
            ORDER BY receita_total DESC
        ) AS quartil,

        ROUND(
            receita_total
            / NULLIF(SUM(receita_total) OVER (), 0)
            * 100,
            2
        ) AS participacao_percentual

    FROM resumo_cliente
)
SELECT
    posicao,
    cln_nome AS cliente,
    cln_tipo_pessoa AS tipo_pessoa,
    quantidade_compras,
    compras_com_acessorios,
    receita_veiculos,
    receita_acessorios,
    receita_total,
    participacao_percentual,

    CASE quartil
        WHEN 1 THEN 'Cliente estratégico'
        WHEN 2 THEN 'Alto valor'
        WHEN 3 THEN 'Valor intermediário'
        ELSE 'Baixo valor'
    END AS segmento

FROM classificacao
ORDER BY
    posicao,
    cliente;