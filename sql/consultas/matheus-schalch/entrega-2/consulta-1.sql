-- ----------------------------------------------------------------------------
-- Matheus Schalch - Entrega 2 - Consulta 1 (Base Analítica Consolidada para Power BI)
-- Desempenho Regional de Vendas e Adoção de Híbridos (Corrente + Histórico)
-- ----------------------------------------------------------------------------

WITH vendas_consolidadas AS (
    SELECT
        vnd_id,
        vnd_cliente_id,
        vnd_veiculo_id,
        vnd_data_pedido,
        vnd_valor_carro,
        vnd_desconto,
        vnd_valor_final,
        'Corrente' AS tipo_registro
    FROM concessionaria.venda
    UNION ALL
    SELECT
        vnd_id,
        vnd_cliente_id,
        vnd_veiculo_id,
        vnd_data_pedido,
        vnd_valor_carro,
        vnd_desconto,
        vnd_valor_final,
        'Histórico' AS tipo_registro
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
    vnd.vnd_id AS id_venda,
    vnd.tipo_registro,
    vnd.vnd_data_pedido AS data_pedido,
    DATE_TRUNC('month', vnd.vnd_data_pedido)::DATE AS mes_pedido,
    cln.cln_id AS id_cliente,
    cln.cln_nome AS cliente,
    cln.cln_tipo_pessoa AS tipo_cliente,
    cdd.cdd_id AS id_cidade,
    cdd.cdd_nome AS cidade,
    cdd.cdd_uf AS uf,
    mdv.mdv_nome AS modelo,
    vsv.vsv_nome AS versao,
    vsv.vsv_combustivel AS combustivel,
    vsv.vsv_cambio AS cambio,
    CASE
        WHEN vsv.vsv_combustivel ILIKE '%Híbrido%' THEN 'Híbrido'
        ELSE 'Combustão Convencional'
    END AS categoria_motorizacao,
    CASE
        WHEN vsv.vsv_combustivel ILIKE '%Híbrido%' THEN 1
        ELSE 0
    END AS flag_hibrido,
    vnd.vnd_valor_carro AS valor_tabela,
    vnd.vnd_desconto AS valor_desconto,
    vnd.vnd_valor_final AS valor_venda_final
FROM vendas_consolidadas AS vnd
JOIN concessionaria.cliente AS cln
    ON cln.cln_id = vnd.vnd_cliente_id
JOIN concessionaria.cidade AS cdd
    ON cdd.cdd_id = cln.cln_cidade_id
JOIN veiculos_consolidados AS vcl
    ON vcl.vcl_id = vnd.vnd_veiculo_id
JOIN concessionaria.versao_veiculo AS vsv
    ON vsv.vsv_id = vcl.vcl_versao_veiculo_id
JOIN concessionaria.modelo_veiculo AS mdv
    ON mdv.mdv_id = vsv.vsv_modelo_veiculo_id
ORDER BY
    vnd.vnd_data_pedido DESC,
    vnd.vnd_id DESC;
