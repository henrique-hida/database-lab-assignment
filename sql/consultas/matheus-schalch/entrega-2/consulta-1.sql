-- ----------------------------------------------------------------------------
-- Matheus Schalch - Entrega 2 - Consulta 1
-- Desempenho Regional de Vendas e Adoção de Veículos Híbridos com dados consolidados
-- Responde à dúvida: qual o faturamento, volume de vendas e taxa de penetração
-- de veículos híbridos em cada município considerando todo o histórico da concessionária?
-- ----------------------------------------------------------------------------

WITH vendas_consolidadas AS (
    SELECT
        vnd_id,
        vnd_cliente_id,
        vnd_veiculo_id,
        vnd_valor_final
    FROM concessionaria.venda
    UNION ALL
    SELECT
        vnd_id,
        vnd_cliente_id,
        vnd_veiculo_id,
        vnd_valor_final
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
)
SELECT
    cdd.cdd_id,
    cdd.cdd_nome AS cidade,
    cdd.cdd_uf AS uf,
    COUNT(vnd.vnd_id) AS total_veiculos_vendidos,
    SUM(vnd.vnd_valor_final) AS faturamento_cidade,
    ROUND(AVG(vnd.vnd_valor_final), 2) AS ticket_medio_cidade,
    ROUND(
        SUM(vnd.vnd_valor_final) / NULLIF(SUM(SUM(vnd.vnd_valor_final)) OVER (), 0) * 100,
        2
    ) AS market_share_faturamento_pct,
    COUNT(*) FILTER (
        WHERE vsv.vsv_combustivel ILIKE '%Híbrido%'
    ) AS vendas_hibridos,
    ROUND(
        COUNT(*) FILTER (WHERE vsv.vsv_combustivel ILIKE '%Híbrido%')::NUMERIC 
        / NULLIF(COUNT(vnd.vnd_id), 0) * 100,
        2
    ) AS taxa_penetracao_hibridos_pct
FROM vendas_consolidadas AS vnd
JOIN concessionaria.cliente AS cln
    ON cln.cln_id = vnd.vnd_cliente_id
JOIN concessionaria.cidade AS cdd
    ON cdd.cdd_id = cln.cln_cidade_id
JOIN veiculos_consolidados AS vcl
    ON vcl.vcl_id = vnd.vnd_veiculo_id
JOIN concessionaria.versao_veiculo AS vsv
    ON vsv.vsv_id = vcl.vcl_versao_veiculo_id
GROUP BY
    cdd.cdd_id,
    cdd.cdd_nome,
    cdd.cdd_uf
ORDER BY
    faturamento_cidade DESC,
    cidade;
