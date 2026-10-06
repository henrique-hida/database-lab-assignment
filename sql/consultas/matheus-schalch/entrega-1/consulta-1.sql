-- ----------------------------------------------------------------------------
-- Matheus Schalch - Entrega 1 - Consulta 1 (Base Analítica para Power BI)
-- Desempenho Regional de Vendas e Adoção de Veículos Híbridos (Apenas dados correntes)
-- ----------------------------------------------------------------------------

SELECT
    vnd.vnd_id AS id_venda,
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
FROM concessionaria.venda AS vnd
JOIN concessionaria.cliente AS cln
    ON cln.cln_id = vnd.vnd_cliente_id
JOIN concessionaria.cidade AS cdd
    ON cdd.cdd_id = cln.cln_cidade_id
JOIN concessionaria.veiculo AS vcl
    ON vcl.vcl_id = vnd.vnd_veiculo_id
JOIN concessionaria.versao_veiculo AS vsv
    ON vsv.vsv_id = vcl.vcl_versao_veiculo_id
JOIN concessionaria.modelo_veiculo AS mdv
    ON mdv.mdv_id = vsv.vsv_modelo_veiculo_id
ORDER BY
    vnd.vnd_data_pedido DESC,
    vnd.vnd_id DESC;
