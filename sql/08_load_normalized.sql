BEGIN;

-- ----------------------------------------------------------------------------
-- 1. VALIDACOES DOS DADOS BRUTOS
-- ----------------------------------------------------------------------------

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM staging.vendas) THEN
        RAISE EXCEPTION 'A tabela staging.vendas esta vazia';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM staging.carros) THEN
        RAISE EXCEPTION 'A tabela staging.carros esta vazia';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM staging.acessorios) THEN
        RAISE EXCEPTION 'A tabela staging.acessorios esta vazia';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM staging.vendas
        WHERE LENGTH(REGEXP_REPLACE(stv_cpf_cnpj, '[^0-9]', '', 'g'))
            NOT IN (11, 14)
    ) THEN
        RAISE EXCEPTION 'Existe CPF ou CNPJ com quantidade invalida de digitos';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM staging.vendas
        WHERE stv_valor_final IS DISTINCT FROM (stv_valor_carro - stv_desconto)
    ) THEN
        RAISE EXCEPTION 'Existe venda com valor final divergente';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM staging.acessorios
        WHERE sta_total IS DISTINCT FROM
            ((sta_quantidade * sta_valor_unitario) - sta_desconto)
    ) THEN
        RAISE EXCEPTION 'Existe acessorio com valor total divergente';
    END IF;

    IF EXISTS (
        SELECT stc_placa
        FROM staging.carros
        GROUP BY stc_placa
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Existe placa duplicada em staging.carros';
    END IF;

    IF EXISTS (
        SELECT stv_placa
        FROM staging.vendas
        GROUP BY stv_placa
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Existe placa duplicada em staging.vendas';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM staging.vendas AS stv
        LEFT JOIN staging.carros AS stc
            ON stc.stc_placa = stv.stv_placa
        WHERE stc.stc_placa IS NULL
    ) THEN
        RAISE EXCEPTION 'Existe venda sem carro correspondente no staging';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM staging.acessorios AS sta
        LEFT JOIN staging.vendas AS stv
            ON stv.stv_placa = sta.sta_placa
        WHERE stv.stv_placa IS NULL
    ) THEN
        RAISE EXCEPTION 'Existe acessorio sem venda correspondente no staging';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM staging.acessorios AS sta
        JOIN staging.vendas AS stv
            ON stv.stv_placa = sta.sta_placa
        WHERE sta.sta_cliente IS DISTINCT FROM stv.stv_cliente
    ) THEN
        RAISE EXCEPTION 'Existe divergencia de cliente entre venda e acessorio';
    END IF;
END;
$$;

-- ----------------------------------------------------------------------------
-- 2. TABELAS DE DOMINIO
-- ----------------------------------------------------------------------------

INSERT INTO concessionaria.cidade (
    cdd_nome,
    cdd_uf
)
SELECT DISTINCT
    stv_cidade,
    'SP'
FROM staging.vendas;

INSERT INTO concessionaria.cor (
    crr_nome
)
SELECT DISTINCT
    stc_cor
FROM staging.carros;

INSERT INTO concessionaria.modelo_veiculo (
    mdv_nome
)
SELECT DISTINCT
    stc_modelo
FROM staging.carros;

INSERT INTO concessionaria.forma_pagamento (
    fpg_descricao
)
SELECT stv_forma_pagamento
FROM staging.vendas

UNION

SELECT sta_forma_pagamento
FROM staging.acessorios;

INSERT INTO concessionaria.categoria_acessorio (
    cta_nome
)
SELECT DISTINCT
    sta_categoria
FROM staging.acessorios;

INSERT INTO concessionaria.marca_acessorio (
    mca_nome
)
SELECT DISTINCT
    sta_marca
FROM staging.acessorios;

-- ----------------------------------------------------------------------------
-- 3. CLIENTES
-- ----------------------------------------------------------------------------

INSERT INTO concessionaria.cliente (
    cln_cidade_id,
    cln_nome,
    cln_tipo_pessoa,
    cln_documento,
    cln_telefone
)
SELECT DISTINCT
    cdd.cdd_id,
    stv.stv_cliente,
    CASE
        WHEN LENGTH(REGEXP_REPLACE(stv.stv_cpf_cnpj, '[^0-9]', '', 'g')) = 11
            THEN 'PF'
        WHEN LENGTH(REGEXP_REPLACE(stv.stv_cpf_cnpj, '[^0-9]', '', 'g')) = 14
            THEN 'PJ'
    END,
    stv.stv_cpf_cnpj,
    stv.stv_telefone
FROM staging.vendas AS stv
JOIN concessionaria.cidade AS cdd
    ON cdd.cdd_nome = stv.stv_cidade
   AND cdd.cdd_uf = 'SP';

-- ----------------------------------------------------------------------------
-- 4. VERSOES E VEICULOS
-- ----------------------------------------------------------------------------

INSERT INTO concessionaria.versao_veiculo (
    vsv_modelo_veiculo_id,
    vsv_nome,
    vsv_combustivel,
    vsv_cambio
)
SELECT DISTINCT
    mdv.mdv_id,
    stc.stc_versao,
    stc.stc_combustivel,
    stc.stc_cambio
FROM staging.carros AS stc
JOIN concessionaria.modelo_veiculo AS mdv
    ON mdv.mdv_nome = stc.stc_modelo;

INSERT INTO concessionaria.veiculo (
    vcl_versao_veiculo_id,
    vcl_cor_id,
    vcl_placa,
    vcl_ano,
    vcl_valor_tabela,
    vcl_valor_minimo,
    vcl_data_entrada_estoque,
    vcl_data_reserva,
    vcl_data_saida,
    vcl_status,
    vcl_local_estoque,
    vcl_observacao
)
SELECT
    vsv.vsv_id,
    crr.crr_id,
    stc.stc_placa,
    stc.stc_ano,
    stc.stc_valor_tabela,
    stc.stc_valor_minimo,
    stc.stc_entrada_estoque,
    stc.stc_data_reserva,
    stc.stc_data_saida,
    stc.stc_status,
    stc.stc_local,
    stc.stc_observacao
FROM staging.carros AS stc
JOIN concessionaria.modelo_veiculo AS mdv
    ON mdv.mdv_nome = stc.stc_modelo
JOIN concessionaria.versao_veiculo AS vsv
    ON vsv.vsv_modelo_veiculo_id = mdv.mdv_id
   AND vsv.vsv_nome = stc.stc_versao
JOIN concessionaria.cor AS crr
    ON crr.crr_nome = stc.stc_cor;

-- ----------------------------------------------------------------------------
-- 5. ACESSORIOS
-- ----------------------------------------------------------------------------

INSERT INTO concessionaria.acessorio (
    acs_categoria_acessorio_id,
    acs_marca_acessorio_id,
    acs_nome
)
SELECT DISTINCT
    cta.cta_id,
    mca.mca_id,
    sta.sta_acessorio
FROM staging.acessorios AS sta
JOIN concessionaria.categoria_acessorio AS cta
    ON cta.cta_nome = sta.sta_categoria
JOIN concessionaria.marca_acessorio AS mca
    ON mca.mca_nome = sta.sta_marca;

-- ----------------------------------------------------------------------------
-- 6. VENDAS
-- ----------------------------------------------------------------------------

-- vnd_valor_final nao e informado porque e uma coluna GENERATED ALWAYS.
INSERT INTO concessionaria.venda (
    vnd_cliente_id,
    vnd_veiculo_id,
    vnd_forma_pagamento_id,
    vnd_valor_carro,
    vnd_desconto,
    vnd_entrada,
    vnd_parcelas,
    vnd_valor_parcela,
    vnd_data_pedido,
    vnd_data_faturamento,
    vnd_data_entrega,
    vnd_status,
    vnd_observacao
)
SELECT
    cln.cln_id,
    vcl.vcl_id,
    fpg.fpg_id,
    stv.stv_valor_carro,
    stv.stv_desconto,
    stv.stv_entrada,
    stv.stv_parcelas,
    stv.stv_valor_parcela,
    stv.stv_data_pedido,
    stv.stv_data_faturamento,
    stv.stv_data_entrega,
    stv.stv_status,
    stv.stv_observacoes
FROM staging.vendas AS stv
JOIN concessionaria.cliente AS cln
    ON cln.cln_documento = stv.stv_cpf_cnpj
JOIN concessionaria.veiculo AS vcl
    ON vcl.vcl_placa = stv.stv_placa
JOIN concessionaria.forma_pagamento AS fpg
    ON fpg.fpg_descricao = stv.stv_forma_pagamento;

-- ----------------------------------------------------------------------------
-- 7. VEICULOS RECEBIDOS COMO TROCA
-- ----------------------------------------------------------------------------

INSERT INTO concessionaria.veiculo_troca (
    vtr_venda_id,
    vtr_descricao,
    vtr_valor_avaliado
)
SELECT
    vnd.vnd_id,
    stv.stv_carro_troca,
    stv.stv_valor_troca
FROM staging.vendas AS stv
JOIN concessionaria.veiculo AS vcl
    ON vcl.vcl_placa = stv.stv_placa
JOIN concessionaria.venda AS vnd
    ON vnd.vnd_veiculo_id = vcl.vcl_id
WHERE stv.stv_carro_troca IS NOT NULL;

-- ----------------------------------------------------------------------------
-- 8. ACESSORIOS VENDIDOS
-- ----------------------------------------------------------------------------

-- vac_total nao e informado porque e uma coluna GENERATED ALWAYS.
INSERT INTO concessionaria.venda_acessorio (
    vac_venda_id,
    vac_acessorio_id,
    vac_forma_pagamento_id,
    vac_quantidade,
    vac_valor_unitario,
    vac_desconto,
    vac_data_pedido,
    vac_data_instalacao,
    vac_status,
    vac_observacao
)
SELECT
    vnd.vnd_id,
    acs.acs_id,
    fpg.fpg_id,
    sta.sta_quantidade,
    sta.sta_valor_unitario,
    sta.sta_desconto,
    sta.sta_data_pedido,
    sta.sta_data_instalacao,
    sta.sta_status,
    sta.sta_observacao
FROM staging.acessorios AS sta
JOIN concessionaria.veiculo AS vcl
    ON vcl.vcl_placa = sta.sta_placa
JOIN concessionaria.venda AS vnd
    ON vnd.vnd_veiculo_id = vcl.vcl_id
JOIN concessionaria.categoria_acessorio AS cta
    ON cta.cta_nome = sta.sta_categoria
JOIN concessionaria.marca_acessorio AS mca
    ON mca.mca_nome = sta.sta_marca
JOIN concessionaria.acessorio AS acs
    ON acs.acs_nome = sta.sta_acessorio
   AND acs.acs_categoria_acessorio_id = cta.cta_id
   AND acs.acs_marca_acessorio_id = mca.mca_id
JOIN concessionaria.forma_pagamento AS fpg
    ON fpg.fpg_descricao = sta.sta_forma_pagamento;

-- ----------------------------------------------------------------------------
-- 9. VALIDACAO DAS QUANTIDADES MIGRADAS
-- ----------------------------------------------------------------------------

DO $$
DECLARE
    qtd_staging BIGINT;
    qtd_destino BIGINT;
BEGIN
    SELECT COUNT(*)
    INTO qtd_staging
    FROM staging.carros;

    SELECT COUNT(*)
    INTO qtd_destino
    FROM staging.carros AS stc
    JOIN concessionaria.veiculo AS vcl
        ON vcl.vcl_placa = stc.stc_placa;

    IF qtd_staging <> qtd_destino THEN
        RAISE EXCEPTION
            'Quantidade de carros divergente: staging=%, destino=%',
            qtd_staging,
            qtd_destino;
    END IF;

    SELECT COUNT(*)
    INTO qtd_staging
    FROM staging.vendas;

    SELECT COUNT(*)
    INTO qtd_destino
    FROM staging.vendas AS stv
    JOIN concessionaria.veiculo AS vcl
        ON vcl.vcl_placa = stv.stv_placa
    JOIN concessionaria.venda AS vnd
        ON vnd.vnd_veiculo_id = vcl.vcl_id;

    IF qtd_staging <> qtd_destino THEN
        RAISE EXCEPTION
            'Quantidade de vendas divergente: staging=%, destino=%',
            qtd_staging,
            qtd_destino;
    END IF;

    SELECT COUNT(*)
    INTO qtd_staging
    FROM staging.acessorios;

    SELECT COUNT(*)
    INTO qtd_destino
    FROM staging.acessorios AS sta
    JOIN concessionaria.veiculo AS vcl
        ON vcl.vcl_placa = sta.sta_placa
    JOIN concessionaria.venda AS vnd
        ON vnd.vnd_veiculo_id = vcl.vcl_id
    JOIN concessionaria.categoria_acessorio AS cta
        ON cta.cta_nome = sta.sta_categoria
    JOIN concessionaria.marca_acessorio AS mca
        ON mca.mca_nome = sta.sta_marca
    JOIN concessionaria.acessorio AS acs
        ON acs.acs_nome = sta.sta_acessorio
       AND acs.acs_categoria_acessorio_id = cta.cta_id
       AND acs.acs_marca_acessorio_id = mca.mca_id
    JOIN concessionaria.venda_acessorio AS vac
        ON vac.vac_venda_id = vnd.vnd_id
       AND vac.vac_acessorio_id = acs.acs_id;

    IF qtd_staging <> qtd_destino THEN
        RAISE EXCEPTION
            'Quantidade de acessorios divergente: staging=%, destino=%',
            qtd_staging,
            qtd_destino;
    END IF;
END;
$$;

-- ----------------------------------------------------------------------------
-- 10. REMOCAO DA AREA DE STAGING
-- ----------------------------------------------------------------------------

DROP TABLE staging.acessorios;
DROP TABLE staging.vendas;
DROP TABLE staging.carros;
DROP SCHEMA staging;

COMMIT;