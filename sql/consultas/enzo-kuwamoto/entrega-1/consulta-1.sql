-- ----------------------------------------------------------------------------
-- Enzo Kuwamoto - Entrega 1 - Consulta 1
-- Cross-Selling de Acessórios por Modelo de Veículo
-- Identifica quais categorias de acessórios são mais vendidas em conjunto
-- com determinados modelos de carros, auxiliando em campanhas de marketing
-- e combos promocionais
-- Usa apenas dados correntes
-- ----------------------------------------------------------------------------

WITH vendas_com_acessorios AS (
    SELECT
        mdv.mdv_nome AS modelo_carro,
        cta.cta_nome AS categoria_acessorio,
        vac.vac_quantidade AS quantidade,
        vac.vac_total AS valor_total_acessorio,
        vnd.vnd_id AS id_venda
    FROM concessionaria.venda_acessorio AS vac
    JOIN concessionaria.venda AS vnd
        ON vnd.vnd_id = vac.vac_venda_id
    JOIN concessionaria.veiculo AS vcl
        ON vcl.vcl_id = vnd.vnd_veiculo_id
    JOIN concessionaria.versao_veiculo AS vsv
        ON vsv.vsv_id = vcl.vcl_versao_veiculo_id
    JOIN concessionaria.modelo_veiculo AS mdv
        ON mdv.mdv_id = vsv.vsv_modelo_veiculo_id
    JOIN concessionaria.acessorio AS acs
        ON acs.acs_id = vac.vac_acessorio_id
    JOIN concessionaria.categoria_acessorio AS cta
        ON cta.cta_id = acs.acs_categoria_acessorio_id
    JOIN concessionaria.status_venda AS svd
        ON svd.svd_id = vnd.vnd_status_venda_id
    WHERE svd.svd_nome = 'Entregue'
)
SELECT
    modelo_carro,
    categoria_acessorio,
    COUNT(DISTINCT id_venda) AS qtd_vendas_deste_combo,
    SUM(quantidade) AS total_itens_vendidos,
    ROUND(SUM(valor_total_acessorio), 2) AS faturamento_deste_combo
FROM vendas_com_acessorios
GROUP BY
    modelo_carro,
    categoria_acessorio
ORDER BY
    modelo_carro,
    faturamento_deste_combo DESC;
