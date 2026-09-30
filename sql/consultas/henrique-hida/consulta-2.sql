-- ----------------------------------------------------------------------------
-- Henrique Hida - Consulta 2
-- Valor de clientes e adesao a acessorios (Jan-Mai/2026)
-- Consolida as vendas e os acessorios atuais com seus registros historicos.
-- ----------------------------------------------------------------------------

WITH vendas_consolidadas AS (
    SELECT vnd_id, vnd_cliente_id, vnd_valor_final, vnd_status_venda_id
    FROM concessionaria.venda
    UNION ALL
    SELECT vnd_id, vnd_cliente_id, vnd_valor_final, vnd_status_venda_id
    FROM concessionaria.hvenda
),
acessorios_consolidados AS (
    SELECT vac_venda_id, vac_total, vac_status_venda_acessorio_id
    FROM concessionaria.venda_acessorio
    UNION ALL
    SELECT vac_venda_id, vac_total, vac_status_venda_acessorio_id
    FROM concessionaria.hvenda_acessorio
),
acessorios_por_venda AS (
    SELECT
        vac.vac_venda_id,
        SUM(vac.vac_total) AS receita_acessorios
    FROM acessorios_consolidados AS vac
    JOIN concessionaria.status_venda_acessorio AS sva
        ON sva.sva_id = vac.vac_status_venda_acessorio_id
    WHERE sva.sva_nome = 'Instalado'
    GROUP BY vac.vac_venda_id
),
resumo_cliente AS (
    SELECT
        cln.cln_id,
        cln.cln_nome,
        cln.cln_tipo_pessoa,
        COUNT(vnd.vnd_id) AS quantidade_compras,
        COUNT(*) FILTER (WHERE apv.receita_acessorios IS NOT NULL)
            AS compras_com_acessorios,
        SUM(vnd.vnd_valor_final) AS receita_veiculos,
        SUM(COALESCE(apv.receita_acessorios, 0)) AS receita_acessorios,
        SUM(vnd.vnd_valor_final + COALESCE(apv.receita_acessorios, 0))
            AS receita_total
    FROM concessionaria.cliente AS cln
    JOIN vendas_consolidadas AS vnd ON vnd.vnd_cliente_id = cln.cln_id
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = vnd.vnd_status_venda_id
    LEFT JOIN acessorios_por_venda AS apv ON apv.vac_venda_id = vnd.vnd_id
    WHERE svd.svd_nome = 'Entregue'
    GROUP BY cln.cln_id, cln.cln_nome, cln.cln_tipo_pessoa
),
classificacao AS (
    SELECT
        resumo_cliente.*,
        RANK() OVER (ORDER BY receita_total DESC) AS posicao,
        NTILE(4) OVER (ORDER BY receita_total DESC) AS quartil,
        ROUND(
            receita_total / NULLIF(SUM(receita_total) OVER (), 0) * 100,
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
    ROUND(
        compras_com_acessorios::NUMERIC / NULLIF(quantidade_compras, 0) * 100,
        2
    ) AS adesao_acessorios_pct,
    ROUND(receita_veiculos, 2) AS receita_veiculos,
    ROUND(receita_acessorios, 2) AS receita_acessorios,
    ROUND(receita_total, 2) AS receita_total,
    participacao_percentual,
    CASE quartil
        WHEN 1 THEN 'Cliente estrategico'
        WHEN 2 THEN 'Alto valor'
        WHEN 3 THEN 'Valor intermediario'
        ELSE 'Baixo valor'
    END AS segmento
FROM classificacao
ORDER BY posicao, cliente;
