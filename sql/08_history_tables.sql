BEGIN;

-- =========================================================
-- 1. TABELAS DE HISTORICO - INDEPENDENTES
-- =========================================================

CREATE TABLE concessionaria.his_cidade (
    his_cidade_id BIGINT CONSTRAINT nn_his_cidade_hid NOT NULL,
    his_cidade_dt_entrada TIMESTAMP CONSTRAINT nn_his_cidade_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cdd_id BIGINT CONSTRAINT nn_his_cidade_id NOT NULL,
    cdd_nome VARCHAR(80) CONSTRAINT nn_his_cidade_nome NOT NULL,
    cdd_uf CHAR(2) CONSTRAINT nn_his_cidade_uf NOT NULL,

    CONSTRAINT pk_his_cidade
        PRIMARY KEY (his_cidade_id, his_cidade_dt_entrada)
);

CREATE TABLE concessionaria.his_cor (
    his_cor_id BIGINT CONSTRAINT nn_his_cor_hid NOT NULL,
    his_cor_dt_entrada TIMESTAMP CONSTRAINT nn_his_cor_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    crr_id BIGINT CONSTRAINT nn_his_cor_id NOT NULL,
    crr_nome VARCHAR(50) CONSTRAINT nn_his_cor_nome NOT NULL,

    CONSTRAINT pk_his_cor
        PRIMARY KEY (his_cor_id, his_cor_dt_entrada)
);

CREATE TABLE concessionaria.his_modelo_veiculo (
    his_modelo_veiculo_id BIGINT CONSTRAINT nn_his_modelo_veiculo_hid NOT NULL,
    his_modelo_veiculo_dt_entrada TIMESTAMP CONSTRAINT nn_his_modelo_veiculo_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    mdv_id BIGINT CONSTRAINT nn_his_modelo_veiculo_id NOT NULL,
    mdv_nome VARCHAR(80) CONSTRAINT nn_his_modelo_veiculo_nome NOT NULL,

    CONSTRAINT pk_his_modelo_veiculo
        PRIMARY KEY (his_modelo_veiculo_id, his_modelo_veiculo_dt_entrada)
);

CREATE TABLE concessionaria.his_forma_pagamento (
    his_forma_pagamento_id BIGINT CONSTRAINT nn_his_forma_pagamento_hid NOT NULL,
    his_forma_pagamento_dt_entrada TIMESTAMP CONSTRAINT nn_his_forma_pagamento_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fpg_id BIGINT CONSTRAINT nn_his_forma_pagamento_id NOT NULL,
    fpg_descricao VARCHAR(80) CONSTRAINT nn_his_forma_pagamento_descricao NOT NULL,

    CONSTRAINT pk_his_forma_pagamento
        PRIMARY KEY (his_forma_pagamento_id, his_forma_pagamento_dt_entrada)
);

CREATE TABLE concessionaria.his_categoria_acessorio (
    his_categoria_acessorio_id BIGINT CONSTRAINT nn_his_categoria_acessorio_hid NOT NULL,
    his_categoria_acessorio_dt_entrada TIMESTAMP CONSTRAINT nn_his_categoria_acessorio_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cta_id BIGINT CONSTRAINT nn_his_categoria_acessorio_id NOT NULL,
    cta_nome VARCHAR(60) CONSTRAINT nn_his_categoria_acessorio_nome NOT NULL,

    CONSTRAINT pk_his_categoria_acessorio
        PRIMARY KEY (his_categoria_acessorio_id, his_categoria_acessorio_dt_entrada)
);

CREATE TABLE concessionaria.his_marca_acessorio (
    his_marca_acessorio_id BIGINT CONSTRAINT nn_his_marca_acessorio_hid NOT NULL,
    his_marca_acessorio_dt_entrada TIMESTAMP CONSTRAINT nn_his_marca_acessorio_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    mca_id BIGINT CONSTRAINT nn_his_marca_acessorio_id NOT NULL,
    mca_nome VARCHAR(80) CONSTRAINT nn_his_marca_acessorio_nome NOT NULL,

    CONSTRAINT pk_his_marca_acessorio
        PRIMARY KEY (his_marca_acessorio_id, his_marca_acessorio_dt_entrada)
);

CREATE TABLE concessionaria.his_status_veiculo (
    his_status_veiculo_id BIGINT CONSTRAINT nn_his_status_veiculo_hid NOT NULL,
    his_status_veiculo_dt_entrada TIMESTAMP CONSTRAINT nn_his_status_veiculo_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sve_id BIGINT CONSTRAINT nn_his_status_veiculo_id NOT NULL,
    sve_nome VARCHAR(20) CONSTRAINT nn_his_status_veiculo_nome NOT NULL,

    CONSTRAINT pk_his_status_veiculo
        PRIMARY KEY (his_status_veiculo_id, his_status_veiculo_dt_entrada)
);

CREATE TABLE concessionaria.his_status_venda (
    his_status_venda_id BIGINT CONSTRAINT nn_his_status_venda_hid NOT NULL,
    his_status_venda_dt_entrada TIMESTAMP CONSTRAINT nn_his_status_venda_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    svd_id BIGINT CONSTRAINT nn_his_status_venda_id NOT NULL,
    svd_nome VARCHAR(20) CONSTRAINT nn_his_status_venda_nome NOT NULL,

    CONSTRAINT pk_his_status_venda
        PRIMARY KEY (his_status_venda_id, his_status_venda_dt_entrada)
);

CREATE TABLE concessionaria.his_status_venda_acessorio (
    his_status_venda_acessorio_id BIGINT CONSTRAINT nn_his_status_venda_acessorio_hid NOT NULL,
    his_status_venda_acessorio_dt_entrada TIMESTAMP CONSTRAINT nn_his_status_venda_acessorio_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sva_id BIGINT CONSTRAINT nn_his_status_venda_acessorio_id NOT NULL,
    sva_nome VARCHAR(30) CONSTRAINT nn_his_status_venda_acessorio_nome NOT NULL,

    CONSTRAINT pk_his_status_venda_acessorio
        PRIMARY KEY (his_status_venda_acessorio_id, his_status_venda_acessorio_dt_entrada)
);

-- =========================================================
-- 2. TABELAS DE HISTORICO - CLIENTES
-- =========================================================

CREATE TABLE concessionaria.his_cliente (
    his_cliente_id BIGINT CONSTRAINT nn_his_cliente_hid NOT NULL,
    his_cliente_dt_entrada TIMESTAMP CONSTRAINT nn_his_cliente_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cln_id BIGINT CONSTRAINT nn_his_cliente_id NOT NULL,
    cln_cidade_id BIGINT CONSTRAINT nn_his_cliente_cidade_id NOT NULL,
    cln_nome VARCHAR(120) CONSTRAINT nn_his_cliente_nome NOT NULL,
    cln_tipo_pessoa CHAR(2) CONSTRAINT nn_his_cliente_tipo_pessoa NOT NULL,
    cln_documento VARCHAR(18) CONSTRAINT nn_his_cliente_documento NOT NULL,
    cln_telefone VARCHAR(20) CONSTRAINT nn_his_cliente_telefone NOT NULL,

    CONSTRAINT pk_his_cliente
        PRIMARY KEY (his_cliente_id, his_cliente_dt_entrada)
);

-- =========================================================
-- 3. TABELAS DE HISTORICO - VEICULOS
-- =========================================================

CREATE TABLE concessionaria.his_versao_veiculo (
    his_versao_veiculo_id BIGINT CONSTRAINT nn_his_versao_veiculo_hid NOT NULL,
    his_versao_veiculo_dt_entrada TIMESTAMP CONSTRAINT nn_his_versao_veiculo_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vsv_id BIGINT CONSTRAINT nn_his_versao_veiculo_id NOT NULL,
    vsv_modelo_veiculo_id BIGINT CONSTRAINT nn_hversao_modelo_id NOT NULL,
    vsv_nome VARCHAR(100) CONSTRAINT nn_his_versao_veiculo_nome NOT NULL,
    vsv_combustivel VARCHAR(30) CONSTRAINT nn_hversao_combustivel NOT NULL,
    vsv_cambio VARCHAR(50) CONSTRAINT nn_hversao_cambio NOT NULL,

    CONSTRAINT pk_his_versao_veiculo
        PRIMARY KEY (his_versao_veiculo_id, his_versao_veiculo_dt_entrada)
);

CREATE TABLE concessionaria.his_veiculo (
    his_veiculo_id BIGINT CONSTRAINT nn_his_veiculo_hid NOT NULL,
    his_veiculo_dt_entrada TIMESTAMP CONSTRAINT nn_his_veiculo_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vcl_id BIGINT CONSTRAINT nn_his_veiculo_id NOT NULL,
    vcl_versao_veiculo_id BIGINT CONSTRAINT nn_his_veiculo_versao_id NOT NULL,
    vcl_cor_id BIGINT CONSTRAINT nn_his_veiculo_cor_id NOT NULL,
    vcl_placa VARCHAR(7) CONSTRAINT nn_his_veiculo_placa NOT NULL,
    vcl_ano SMALLINT CONSTRAINT nn_his_veiculo_ano NOT NULL,
    vcl_valor_tabela NUMERIC(12, 2) CONSTRAINT nn_his_veiculo_valor_tabela NOT NULL,
    vcl_valor_minimo NUMERIC(12, 2) CONSTRAINT nn_his_veiculo_valor_minimo NOT NULL,
    vcl_data_entrada_estoque DATE CONSTRAINT nn_his_veiculo_data_entrada NOT NULL,
    vcl_data_reserva DATE,
    vcl_data_saida DATE,
    vcl_status_veiculo_id BIGINT CONSTRAINT nn_his_veiculo_status_id NOT NULL,
    vcl_local_estoque VARCHAR(80) CONSTRAINT nn_his_veiculo_local_estoque NOT NULL,
    vcl_observacao TEXT,

    CONSTRAINT pk_his_veiculo
        PRIMARY KEY (his_veiculo_id, his_veiculo_dt_entrada)
);

-- =========================================================
-- 4. TABELAS DE HISTORICO - ACESSORIOS
-- =========================================================

CREATE TABLE concessionaria.his_acessorio (
    his_acessorio_id BIGINT CONSTRAINT nn_his_acessorio_hid NOT NULL,
    his_acessorio_dt_entrada TIMESTAMP CONSTRAINT nn_his_acessorio_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    acs_id BIGINT CONSTRAINT nn_his_acessorio_id NOT NULL,
    acs_categoria_acessorio_id BIGINT CONSTRAINT nn_his_acessorio_categoria_id NOT NULL,
    acs_marca_acessorio_id BIGINT CONSTRAINT nn_his_acessorio_marca_id NOT NULL,
    acs_nome VARCHAR(100) CONSTRAINT nn_his_acessorio_nome NOT NULL,

    CONSTRAINT pk_his_acessorio
        PRIMARY KEY (his_acessorio_id, his_acessorio_dt_entrada)
);

-- =========================================================
-- 5. TABELAS DE HISTORICO - VENDAS
-- =========================================================

CREATE TABLE concessionaria.his_venda (
    his_venda_id BIGINT CONSTRAINT nn_his_venda_hid NOT NULL,
    his_venda_dt_entrada TIMESTAMP CONSTRAINT nn_his_venda_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vnd_id BIGINT CONSTRAINT nn_his_venda_id NOT NULL,
    vnd_cliente_id BIGINT CONSTRAINT nn_his_venda_cliente_id NOT NULL,
    vnd_veiculo_id BIGINT CONSTRAINT nn_his_venda_veiculo_id NOT NULL,
    vnd_forma_pagamento_id BIGINT CONSTRAINT nn_his_venda_forma_pagamento_id NOT NULL,
    vnd_valor_carro NUMERIC(12, 2) CONSTRAINT nn_his_venda_valor_carro NOT NULL,
    vnd_desconto NUMERIC(12, 2) CONSTRAINT nn_his_venda_desconto NOT NULL,
    vnd_valor_final NUMERIC(12, 2),
    vnd_entrada NUMERIC(12, 2),
    vnd_parcelas SMALLINT,
    vnd_valor_parcela NUMERIC(12, 2),
    vnd_data_pedido DATE CONSTRAINT nn_his_venda_data_pedido NOT NULL,
    vnd_data_faturamento DATE,
    vnd_data_entrega DATE,
    vnd_status_venda_id BIGINT CONSTRAINT nn_his_venda_status_id NOT NULL,
    vnd_observacao TEXT,

    CONSTRAINT pk_his_venda
        PRIMARY KEY (his_venda_id, his_venda_dt_entrada)
);

CREATE TABLE concessionaria.his_veiculo_troca (
    his_veiculo_troca_id BIGINT CONSTRAINT nn_his_veiculo_troca_hid NOT NULL,
    his_veiculo_troca_dt_entrada TIMESTAMP CONSTRAINT nn_his_veiculo_troca_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vtr_id BIGINT CONSTRAINT nn_his_veiculo_troca_id NOT NULL,
    vtr_venda_id BIGINT CONSTRAINT nn_his_veiculo_troca_venda_id NOT NULL,
    vtr_descricao VARCHAR(120) CONSTRAINT nn_his_veiculo_troca_descricao NOT NULL,
    vtr_valor_avaliado NUMERIC(12, 2) CONSTRAINT nn_his_veiculo_troca_valor NOT NULL,

    CONSTRAINT pk_his_veiculo_troca
        PRIMARY KEY (his_veiculo_troca_id, his_veiculo_troca_dt_entrada)
);

CREATE TABLE concessionaria.his_venda_acessorio (
    his_venda_acessorio_id BIGINT CONSTRAINT nn_his_venda_acessorio_hid NOT NULL,
    his_venda_acessorio_dt_entrada TIMESTAMP CONSTRAINT nn_his_venda_acessorio_dt_entrada NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vac_id BIGINT CONSTRAINT nn_his_venda_acessorio_id NOT NULL,
    vac_venda_id BIGINT CONSTRAINT nn_his_venda_acessorio_venda_id NOT NULL,
    vac_acessorio_id BIGINT CONSTRAINT nn_his_venda_acessorio_acessorio_id NOT NULL,
    vac_forma_pagamento_id BIGINT CONSTRAINT nn_his_venda_acessorio_pagamento_id NOT NULL,
    vac_quantidade SMALLINT CONSTRAINT nn_his_venda_acessorio_quantidade NOT NULL,
    vac_valor_unitario NUMERIC(12, 2) CONSTRAINT nn_his_venda_acessorio_valor_unitario NOT NULL,
    vac_desconto NUMERIC(12, 2) CONSTRAINT nn_his_venda_acessorio_desconto NOT NULL,
    vac_total NUMERIC(12, 2),
    vac_data_pedido DATE CONSTRAINT nn_his_venda_acessorio_data_pedido NOT NULL,
    vac_data_instalacao DATE,
    vac_status_venda_acessorio_id BIGINT CONSTRAINT nn_his_venda_acessorio_status_id NOT NULL,
    vac_observacao TEXT,

    CONSTRAINT pk_his_venda_acessorio
        PRIMARY KEY (his_venda_acessorio_id, his_venda_acessorio_dt_entrada)
);

DO $$
DECLARE
    tabela RECORD;
BEGIN
    FOR tabela IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'concessionaria'
          AND tablename LIKE 'his\_%' ESCAPE E'\\'
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
