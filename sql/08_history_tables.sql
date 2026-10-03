BEGIN;

-- =========================================================
-- 1. TABELAS DE HISTORICO - INDEPENDENTES
-- =========================================================

CREATE TABLE concessionaria.hcidade (
    hcidade_dt_entrada TIMESTAMP CONSTRAINT nn_hcidade_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cdd_id BIGINT CONSTRAINT nn_hcidade_id NOT NULL,
    cdd_nome VARCHAR(80) CONSTRAINT nn_hcidade_nome NOT NULL,
    cdd_uf CHAR(2) CONSTRAINT nn_hcidade_uf NOT NULL,

    CONSTRAINT pk_hcidade
        PRIMARY KEY (cdd_id, hcidade_dt_entrada)
);

CREATE TABLE concessionaria.hcor (
    hcor_dt_entrada TIMESTAMP CONSTRAINT nn_hcor_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    crr_id BIGINT CONSTRAINT nn_hcor_id NOT NULL,
    crr_nome VARCHAR(50) CONSTRAINT nn_hcor_nome NOT NULL,

    CONSTRAINT pk_hcor
        PRIMARY KEY (crr_id, hcor_dt_entrada)
);

CREATE TABLE concessionaria.hmodelo_veiculo (
    hmodelo_veiculo_dt_entrada TIMESTAMP CONSTRAINT nn_hmodelo_veiculo_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    mdv_id BIGINT CONSTRAINT nn_hmodelo_veiculo_id NOT NULL,
    mdv_nome VARCHAR(80) CONSTRAINT nn_hmodelo_veiculo_nome NOT NULL,

    CONSTRAINT pk_hmodelo_veiculo
        PRIMARY KEY (mdv_id, hmodelo_veiculo_dt_entrada)
);

CREATE TABLE concessionaria.hforma_pagamento (
    hforma_pagamento_dt_entrada TIMESTAMP CONSTRAINT nn_hforma_pagamento_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fpg_id BIGINT CONSTRAINT nn_hforma_pagamento_id NOT NULL,
    fpg_descricao VARCHAR(80) CONSTRAINT nn_hforma_pagamento_descricao NOT NULL,

    CONSTRAINT pk_hforma_pagamento
        PRIMARY KEY (fpg_id, hforma_pagamento_dt_entrada)
);

CREATE TABLE concessionaria.hcategoria_acessorio (
    hcategoria_acessorio_dt_entrada TIMESTAMP CONSTRAINT nn_hcategoria_acessorio_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cta_id BIGINT CONSTRAINT nn_hcategoria_acessorio_id NOT NULL,
    cta_nome VARCHAR(60) CONSTRAINT nn_hcategoria_acessorio_nome NOT NULL,

    CONSTRAINT pk_hcategoria_acessorio
        PRIMARY KEY (cta_id, hcategoria_acessorio_dt_entrada)
);

CREATE TABLE concessionaria.hmarca_acessorio (
    hmarca_acessorio_dt_entrada TIMESTAMP CONSTRAINT nn_hmarca_acessorio_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    mca_id BIGINT CONSTRAINT nn_hmarca_acessorio_id NOT NULL,
    mca_nome VARCHAR(80) CONSTRAINT nn_hmarca_acessorio_nome NOT NULL,

    CONSTRAINT pk_hmarca_acessorio
        PRIMARY KEY (mca_id, hmarca_acessorio_dt_entrada)
);

CREATE TABLE concessionaria.hstatus_veiculo (
    hstatus_veiculo_dt_entrada TIMESTAMP CONSTRAINT nn_hstatus_veiculo_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sve_id BIGINT CONSTRAINT nn_hstatus_veiculo_id NOT NULL,
    sve_nome VARCHAR(20) CONSTRAINT nn_hstatus_veiculo_nome NOT NULL,

    CONSTRAINT pk_hstatus_veiculo
        PRIMARY KEY (sve_id, hstatus_veiculo_dt_entrada)
);

CREATE TABLE concessionaria.hstatus_venda (
    hstatus_venda_dt_entrada TIMESTAMP CONSTRAINT nn_hstatus_venda_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    svd_id BIGINT CONSTRAINT nn_hstatus_venda_id NOT NULL,
    svd_nome VARCHAR(20) CONSTRAINT nn_hstatus_venda_nome NOT NULL,

    CONSTRAINT pk_hstatus_venda
        PRIMARY KEY (svd_id, hstatus_venda_dt_entrada)
);

CREATE TABLE concessionaria.hstatus_venda_acessorio (
    hstatus_venda_acessorio_dt_entrada TIMESTAMP CONSTRAINT nn_hstatus_venda_acessorio_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sva_id BIGINT CONSTRAINT nn_hstatus_venda_acessorio_id NOT NULL,
    sva_nome VARCHAR(30) CONSTRAINT nn_hstatus_venda_acessorio_nome NOT NULL,

    CONSTRAINT pk_hstatus_venda_acessorio
        PRIMARY KEY (sva_id, hstatus_venda_acessorio_dt_entrada)
);

-- =========================================================
-- 2. TABELAS DE HISTORICO - CLIENTES
-- =========================================================

CREATE TABLE concessionaria.hcliente (
    hcliente_dt_entrada TIMESTAMP CONSTRAINT nn_hcliente_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cln_id BIGINT CONSTRAINT nn_hcliente_id NOT NULL,
    cln_cidade_id BIGINT CONSTRAINT nn_hcliente_cidade_id NOT NULL,
    cln_nome VARCHAR(120) CONSTRAINT nn_hcliente_nome NOT NULL,
    cln_tipo_pessoa CHAR(2) CONSTRAINT nn_hcliente_tipo_pessoa NOT NULL,
    cln_documento VARCHAR(18) CONSTRAINT nn_hcliente_documento NOT NULL,
    cln_telefone VARCHAR(20) CONSTRAINT nn_hcliente_telefone NOT NULL,

    CONSTRAINT pk_hcliente
        PRIMARY KEY (cln_id, hcliente_dt_entrada)
);

-- =========================================================
-- 3. TABELAS DE HISTORICO - VEICULOS
-- =========================================================

CREATE TABLE concessionaria.hversao_veiculo (
    hversao_veiculo_dt_entrada TIMESTAMP CONSTRAINT nn_hversao_veiculo_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vsv_id BIGINT CONSTRAINT nn_hversao_veiculo_id NOT NULL,
    vsv_modelo_veiculo_id BIGINT CONSTRAINT nn_hversao_modelo_id NOT NULL,
    vsv_nome VARCHAR(100) CONSTRAINT nn_hversao_veiculo_nome NOT NULL,
    vsv_combustivel VARCHAR(30) CONSTRAINT nn_hversao_combustivel NOT NULL,
    vsv_cambio VARCHAR(50) CONSTRAINT nn_hversao_cambio NOT NULL,

    CONSTRAINT pk_hversao_veiculo
        PRIMARY KEY (vsv_id, hversao_veiculo_dt_entrada)
);

CREATE TABLE concessionaria.hveiculo (
    hveiculo_dt_entrada TIMESTAMP CONSTRAINT nn_hveiculo_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vcl_id BIGINT CONSTRAINT nn_hveiculo_id NOT NULL,
    vcl_versao_veiculo_id BIGINT CONSTRAINT nn_hveiculo_versao_id NOT NULL,
    vcl_cor_id BIGINT CONSTRAINT nn_hveiculo_cor_id NOT NULL,
    vcl_placa VARCHAR(7) CONSTRAINT nn_hveiculo_placa NOT NULL,
    vcl_ano SMALLINT CONSTRAINT nn_hveiculo_ano NOT NULL,
    vcl_valor_tabela NUMERIC(12, 2) CONSTRAINT nn_hveiculo_valor_tabela NOT NULL,
    vcl_valor_minimo NUMERIC(12, 2) CONSTRAINT nn_hveiculo_valor_minimo NOT NULL,
    vcl_data_entrada_estoque DATE CONSTRAINT nn_hveiculo_data_entrada NOT NULL,
    vcl_data_reserva DATE,
    vcl_data_saida DATE,
    vcl_status_veiculo_id BIGINT CONSTRAINT nn_hveiculo_status_id NOT NULL,
    vcl_local_estoque VARCHAR(80) CONSTRAINT nn_hveiculo_local_estoque NOT NULL,
    vcl_observacao TEXT,

    CONSTRAINT pk_hveiculo
        PRIMARY KEY (vcl_id, hveiculo_dt_entrada)
);

-- =========================================================
-- 4. TABELAS DE HISTORICO - ACESSORIOS
-- =========================================================

CREATE TABLE concessionaria.hacessorio (
    hacessorio_dt_entrada TIMESTAMP CONSTRAINT nn_hacessorio_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    acs_id BIGINT CONSTRAINT nn_hacessorio_id NOT NULL,
    acs_categoria_acessorio_id BIGINT CONSTRAINT nn_hacessorio_categoria_id NOT NULL,
    acs_marca_acessorio_id BIGINT CONSTRAINT nn_hacessorio_marca_id NOT NULL,
    acs_nome VARCHAR(100) CONSTRAINT nn_hacessorio_nome NOT NULL,

    CONSTRAINT pk_hacessorio
        PRIMARY KEY (acs_id, hacessorio_dt_entrada)
);

-- =========================================================
-- 5. TABELAS DE HISTORICO - VENDAS
-- =========================================================

CREATE TABLE concessionaria.hvenda (
    hvenda_dt_entrada TIMESTAMP CONSTRAINT nn_hvenda_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vnd_id BIGINT CONSTRAINT nn_hvenda_id NOT NULL,
    vnd_cliente_id BIGINT CONSTRAINT nn_hvenda_cliente_id NOT NULL,
    vnd_veiculo_id BIGINT CONSTRAINT nn_hvenda_veiculo_id NOT NULL,
    vnd_forma_pagamento_id BIGINT CONSTRAINT nn_hvenda_forma_pagamento_id NOT NULL,
    vnd_valor_carro NUMERIC(12, 2) CONSTRAINT nn_hvenda_valor_carro NOT NULL,
    vnd_desconto NUMERIC(12, 2) CONSTRAINT nn_hvenda_desconto NOT NULL,
    vnd_valor_final NUMERIC(12, 2),
    vnd_entrada NUMERIC(12, 2),
    vnd_parcelas SMALLINT,
    vnd_valor_parcela NUMERIC(12, 2),
    vnd_data_pedido DATE CONSTRAINT nn_hvenda_data_pedido NOT NULL,
    vnd_data_faturamento DATE,
    vnd_data_entrega DATE,
    vnd_status_venda_id BIGINT CONSTRAINT nn_hvenda_status_id NOT NULL,
    vnd_observacao TEXT,

    CONSTRAINT pk_hvenda
        PRIMARY KEY (vnd_id, hvenda_dt_entrada)
);

CREATE TABLE concessionaria.hveiculo_troca (
    hveiculo_troca_dt_entrada TIMESTAMP CONSTRAINT nn_hveiculo_troca_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vtr_id BIGINT CONSTRAINT nn_hveiculo_troca_id NOT NULL,
    vtr_venda_id BIGINT CONSTRAINT nn_hveiculo_troca_venda_id NOT NULL,
    vtr_descricao VARCHAR(120) CONSTRAINT nn_hveiculo_troca_descricao NOT NULL,
    vtr_valor_avaliado NUMERIC(12, 2) CONSTRAINT nn_hveiculo_troca_valor NOT NULL,

    CONSTRAINT pk_hveiculo_troca
        PRIMARY KEY (vtr_id, hveiculo_troca_dt_entrada)
);

CREATE TABLE concessionaria.hvenda_acessorio (
    hvenda_acessorio_dt_entrada TIMESTAMP CONSTRAINT nn_hvenda_acessorio_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vac_id BIGINT CONSTRAINT nn_hvenda_acessorio_id NOT NULL,
    vac_venda_id BIGINT CONSTRAINT nn_hvenda_acessorio_venda_id NOT NULL,
    vac_acessorio_id BIGINT CONSTRAINT nn_hvenda_acessorio_acessorio_id NOT NULL,
    vac_forma_pagamento_id BIGINT CONSTRAINT nn_hvenda_acessorio_pagamento_id NOT NULL,
    vac_quantidade SMALLINT CONSTRAINT nn_hvenda_acessorio_quantidade NOT NULL,
    vac_valor_unitario NUMERIC(12, 2) CONSTRAINT nn_hvenda_acessorio_valor_unitario NOT NULL,
    vac_desconto NUMERIC(12, 2) CONSTRAINT nn_hvenda_acessorio_desconto NOT NULL,
    vac_total NUMERIC(12, 2),
    vac_data_pedido DATE CONSTRAINT nn_hvenda_acessorio_data_pedido NOT NULL,
    vac_data_instalacao DATE,
    vac_status_venda_acessorio_id BIGINT CONSTRAINT nn_hvenda_acessorio_status_id NOT NULL,
    vac_observacao TEXT,

    CONSTRAINT pk_hvenda_acessorio
        PRIMARY KEY (vac_id, hvenda_acessorio_dt_entrada)
);

DO $$
DECLARE
    tabela RECORD;
BEGIN
    FOR tabela IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'concessionaria'
          AND tablename LIKE 'h%'
    LOOP
        EXECUTE format(
            'REVOKE INSERT, UPDATE, DELETE ON TABLE concessionaria.%I FROM tsusho_user',
            tabela.tablename
        );
        EXECUTE format(
            'GRANT SELECT ON TABLE concessionaria.%I TO tsusho_user',
            tabela.tablename
        );
    END LOOP;
END;
$$;

COMMIT;
