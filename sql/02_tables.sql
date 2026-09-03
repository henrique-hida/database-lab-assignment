BEGIN;

-- =========================================================
-- 1. TABELAS INDEPENDENTES
-- =========================================================

CREATE TABLE concessionaria.cidade (
    cdd_id BIGINT CONSTRAINT nn_cidade_id NOT NULL,
    cdd_nome VARCHAR(80) CONSTRAINT nn_cidade_nome NOT NULL,
    cdd_uf CHAR(2) CONSTRAINT nn_cidade_uf NOT NULL,

    CONSTRAINT pk_cidade
        PRIMARY KEY (cdd_id),

    CONSTRAINT uq_cidade_nome_uf
        UNIQUE (cdd_nome, cdd_uf)
);

CREATE TABLE concessionaria.cor (
    crr_id BIGINT CONSTRAINT nn_cor_id NOT NULL,
    crr_nome VARCHAR(50) CONSTRAINT nn_cor_nome NOT NULL,

    CONSTRAINT pk_cor
        PRIMARY KEY (crr_id),

    CONSTRAINT uq_cor_nome
        UNIQUE (crr_nome)
);

CREATE TABLE concessionaria.modelo_veiculo (
    mdv_id BIGINT CONSTRAINT nn_modelo_veiculo_id NOT NULL,
    mdv_nome VARCHAR(80) CONSTRAINT nn_modelo_veiculo_nome NOT NULL,

    CONSTRAINT pk_modelo_veiculo
        PRIMARY KEY (mdv_id),

    CONSTRAINT uq_modelo_veiculo_nome
        UNIQUE (mdv_nome)
);

CREATE TABLE concessionaria.forma_pagamento (
    fpg_id BIGINT CONSTRAINT nn_forma_pagamento_id NOT NULL,
    fpg_descricao VARCHAR(80) CONSTRAINT nn_forma_pagamento_descricao NOT NULL,

    CONSTRAINT pk_forma_pagamento
        PRIMARY KEY (fpg_id),

    CONSTRAINT uq_forma_pagamento_descricao
        UNIQUE (fpg_descricao)
);

CREATE TABLE concessionaria.categoria_acessorio (
    cta_id BIGINT CONSTRAINT nn_categoria_acessorio_id NOT NULL,
    cta_nome VARCHAR(60) CONSTRAINT nn_categoria_acessorio_nome NOT NULL,

    CONSTRAINT pk_categoria_acessorio
        PRIMARY KEY (cta_id),

    CONSTRAINT uq_categoria_acessorio_nome
        UNIQUE (cta_nome)
);

CREATE TABLE concessionaria.marca_acessorio (
    mca_id BIGINT CONSTRAINT nn_marca_acessorio_id NOT NULL,
    mca_nome VARCHAR(80) CONSTRAINT nn_marca_acessorio_nome NOT NULL,

    CONSTRAINT pk_marca_acessorio
        PRIMARY KEY (mca_id),

    CONSTRAINT uq_marca_acessorio_nome
        UNIQUE (mca_nome)
);

-- =========================================================
-- 2. CLIENTES
-- =========================================================

CREATE TABLE concessionaria.cliente (
    cln_id BIGINT CONSTRAINT nn_cliente_id NOT NULL,
    cln_cidade_id BIGINT CONSTRAINT nn_cliente_cidade_id NOT NULL,
    cln_nome VARCHAR(120) CONSTRAINT nn_cliente_nome NOT NULL,
    cln_tipo_pessoa CHAR(2) CONSTRAINT nn_cliente_tipo_pessoa NOT NULL,
    cln_documento VARCHAR(18) CONSTRAINT nn_cliente_documento NOT NULL,
    cln_telefone VARCHAR(20) CONSTRAINT nn_cliente_telefone NOT NULL,

    CONSTRAINT pk_cliente
        PRIMARY KEY (cln_id),

    CONSTRAINT uq_cliente_documento
        UNIQUE (cln_documento),

    CONSTRAINT fk_cliente_cidade
        FOREIGN KEY (cln_cidade_id)
        REFERENCES concessionaria.cidade (cdd_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT ck_cliente_tipo_pessoa
        CHECK (cln_tipo_pessoa IN ('PF', 'PJ'))
);

-- =========================================================
-- 3. VEICULOS
-- =========================================================

CREATE TABLE concessionaria.versao_veiculo (
    vsv_id BIGINT CONSTRAINT nn_versao_veiculo_id NOT NULL,
    vsv_modelo_veiculo_id BIGINT CONSTRAINT nn_versao_modelo_id NOT NULL,
    vsv_nome VARCHAR(100) CONSTRAINT nn_versao_veiculo_nome NOT NULL,
    vsv_combustivel VARCHAR(30) CONSTRAINT nn_versao_combustivel NOT NULL,
    vsv_cambio VARCHAR(50) CONSTRAINT nn_versao_cambio NOT NULL,

    CONSTRAINT pk_versao_veiculo
        PRIMARY KEY (vsv_id),

    CONSTRAINT uq_versao_veiculo_modelo_nome
        UNIQUE (vsv_modelo_veiculo_id, vsv_nome),

    CONSTRAINT fk_versao_veiculo_modelo
        FOREIGN KEY (vsv_modelo_veiculo_id)
        REFERENCES concessionaria.modelo_veiculo (mdv_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
);

CREATE TABLE concessionaria.veiculo (
    vcl_id BIGINT CONSTRAINT nn_veiculo_id NOT NULL,
    vcl_versao_veiculo_id BIGINT CONSTRAINT nn_veiculo_versao_id NOT NULL,
    vcl_cor_id BIGINT CONSTRAINT nn_veiculo_cor_id NOT NULL,
    vcl_placa VARCHAR(7) CONSTRAINT nn_veiculo_placa NOT NULL,
    vcl_ano SMALLINT CONSTRAINT nn_veiculo_ano NOT NULL,
    vcl_valor_tabela NUMERIC(12, 2) CONSTRAINT nn_veiculo_valor_tabela NOT NULL,
    vcl_valor_minimo NUMERIC(12, 2) CONSTRAINT nn_veiculo_valor_minimo NOT NULL,
    vcl_data_entrada_estoque DATE CONSTRAINT nn_veiculo_data_entrada NOT NULL,
    vcl_data_reserva DATE,
    vcl_data_saida DATE,
    vcl_status VARCHAR(20) CONSTRAINT nn_veiculo_status NOT NULL,
    vcl_local_estoque VARCHAR(80) CONSTRAINT nn_veiculo_local_estoque NOT NULL,
    vcl_observacao TEXT,

    CONSTRAINT pk_veiculo
        PRIMARY KEY (vcl_id),

    CONSTRAINT uq_veiculo_placa
        UNIQUE (vcl_placa),

    CONSTRAINT fk_veiculo_versao
        FOREIGN KEY (vcl_versao_veiculo_id)
        REFERENCES concessionaria.versao_veiculo (vsv_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_veiculo_cor
        FOREIGN KEY (vcl_cor_id)
        REFERENCES concessionaria.cor (crr_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT ck_veiculo_valor_tabela
        CHECK (vcl_valor_tabela > 0),

    CONSTRAINT ck_veiculo_valor_minimo
        CHECK (vcl_valor_minimo > 0 AND vcl_valor_minimo <= vcl_valor_tabela),

    CONSTRAINT ck_veiculo_data_reserva
        CHECK (
            vcl_data_reserva IS NULL
            OR vcl_data_reserva >= vcl_data_entrada_estoque
        ),

    CONSTRAINT ck_veiculo_data_saida
        CHECK (
            vcl_data_saida IS NULL
            OR vcl_data_saida >= vcl_data_entrada_estoque
        )
);

-- =========================================================
-- 4. ACESSORIOS
-- =========================================================

CREATE TABLE concessionaria.acessorio (
    acs_id BIGINT CONSTRAINT nn_acessorio_id NOT NULL,
    acs_categoria_acessorio_id BIGINT CONSTRAINT nn_acessorio_categoria_id NOT NULL,
    acs_marca_acessorio_id BIGINT CONSTRAINT nn_acessorio_marca_id NOT NULL,
    acs_nome VARCHAR(100) CONSTRAINT nn_acessorio_nome NOT NULL,

    CONSTRAINT pk_acessorio
        PRIMARY KEY (acs_id),

    CONSTRAINT uq_acessorio_nome_categoria_marca
        UNIQUE (acs_nome, acs_categoria_acessorio_id, acs_marca_acessorio_id),

    CONSTRAINT fk_acessorio_categoria
        FOREIGN KEY (acs_categoria_acessorio_id)
        REFERENCES concessionaria.categoria_acessorio (cta_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_acessorio_marca
        FOREIGN KEY (acs_marca_acessorio_id)
        REFERENCES concessionaria.marca_acessorio (mca_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
);

-- =========================================================
-- 5. VENDAS
-- =========================================================

CREATE TABLE concessionaria.venda (
    vnd_id BIGINT CONSTRAINT nn_venda_id NOT NULL,
    vnd_cliente_id BIGINT CONSTRAINT nn_venda_cliente_id NOT NULL,
    vnd_veiculo_id BIGINT CONSTRAINT nn_venda_veiculo_id NOT NULL,
    vnd_forma_pagamento_id BIGINT CONSTRAINT nn_venda_forma_pagamento_id NOT NULL,
    vnd_valor_carro NUMERIC(12, 2) CONSTRAINT nn_venda_valor_carro NOT NULL,
    vnd_desconto NUMERIC(12, 2) CONSTRAINT nn_venda_desconto NOT NULL,
    vnd_valor_final NUMERIC(12, 2)
        GENERATED ALWAYS AS (vnd_valor_carro - vnd_desconto) STORED,
    vnd_entrada NUMERIC(12, 2),
    vnd_parcelas SMALLINT,
    vnd_valor_parcela NUMERIC(12, 2),
    vnd_data_pedido DATE CONSTRAINT nn_venda_data_pedido NOT NULL,
    vnd_data_faturamento DATE,
    vnd_data_entrega DATE,
    vnd_status VARCHAR(20) CONSTRAINT nn_venda_status NOT NULL,
    vnd_observacao TEXT,

    CONSTRAINT pk_venda
        PRIMARY KEY (vnd_id),

    CONSTRAINT uq_venda_veiculo
        UNIQUE (vnd_veiculo_id),

    CONSTRAINT fk_venda_cliente
        FOREIGN KEY (vnd_cliente_id)
        REFERENCES concessionaria.cliente (cln_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_venda_veiculo
        FOREIGN KEY (vnd_veiculo_id)
        REFERENCES concessionaria.veiculo (vcl_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_venda_forma_pagamento
        FOREIGN KEY (vnd_forma_pagamento_id)
        REFERENCES concessionaria.forma_pagamento (fpg_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT ck_venda_valor_carro
        CHECK (vnd_valor_carro > 0),

    CONSTRAINT ck_venda_desconto
        CHECK (vnd_desconto >= 0 AND vnd_desconto <= vnd_valor_carro),

    CONSTRAINT ck_venda_entrada
        CHECK (
            vnd_entrada IS NULL
            OR (
                vnd_entrada >= 0
                AND vnd_entrada <= (vnd_valor_carro - vnd_desconto)
            )
        ),

    CONSTRAINT ck_venda_parcelamento
        CHECK (
            (vnd_parcelas IS NULL AND vnd_valor_parcela IS NULL)
            OR
            (vnd_parcelas > 0 AND vnd_valor_parcela > 0)
        ),

    CONSTRAINT ck_venda_data_faturamento
        CHECK (
            vnd_data_faturamento IS NULL
            OR vnd_data_faturamento >= vnd_data_pedido
        ),

    CONSTRAINT ck_venda_data_entrega
        CHECK (
            vnd_data_entrega IS NULL
            OR vnd_data_entrega >= COALESCE(vnd_data_faturamento, vnd_data_pedido)
        )
);

CREATE TABLE concessionaria.veiculo_troca (
    vtr_id BIGINT CONSTRAINT nn_veiculo_troca_id NOT NULL,
    vtr_venda_id BIGINT CONSTRAINT nn_veiculo_troca_venda_id NOT NULL,
    vtr_descricao VARCHAR(120) CONSTRAINT nn_veiculo_troca_descricao NOT NULL,
    vtr_valor_avaliado NUMERIC(12, 2) CONSTRAINT nn_veiculo_troca_valor NOT NULL,

    CONSTRAINT pk_veiculo_troca
        PRIMARY KEY (vtr_id),

    CONSTRAINT uq_veiculo_troca_venda
        UNIQUE (vtr_venda_id),

    CONSTRAINT fk_veiculo_troca_venda
        FOREIGN KEY (vtr_venda_id)
        REFERENCES concessionaria.venda (vnd_id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE,

    CONSTRAINT ck_veiculo_troca_valor
        CHECK (vtr_valor_avaliado > 0)
);

CREATE TABLE concessionaria.venda_acessorio (
    vac_id BIGINT CONSTRAINT nn_venda_acessorio_id NOT NULL,
    vac_venda_id BIGINT CONSTRAINT nn_venda_acessorio_venda_id NOT NULL,
    vac_acessorio_id BIGINT CONSTRAINT nn_venda_acessorio_acessorio_id NOT NULL,
    vac_forma_pagamento_id BIGINT CONSTRAINT nn_venda_acessorio_pagamento_id NOT NULL,
    vac_quantidade SMALLINT CONSTRAINT nn_venda_acessorio_quantidade NOT NULL,
    vac_valor_unitario NUMERIC(12, 2) CONSTRAINT nn_venda_acessorio_valor_unitario NOT NULL,
    vac_desconto NUMERIC(12, 2) CONSTRAINT nn_venda_acessorio_desconto NOT NULL,
    vac_total NUMERIC(12, 2)
        GENERATED ALWAYS AS ((vac_quantidade * vac_valor_unitario) - vac_desconto) STORED,
    vac_data_pedido DATE CONSTRAINT nn_venda_acessorio_data_pedido NOT NULL,
    vac_data_instalacao DATE,
    vac_status VARCHAR(30) CONSTRAINT nn_venda_acessorio_status NOT NULL,
    vac_observacao TEXT,

    CONSTRAINT pk_venda_acessorio
        PRIMARY KEY (vac_id),

    CONSTRAINT uq_venda_acessorio_item
        UNIQUE (vac_venda_id, vac_acessorio_id),

    CONSTRAINT fk_venda_acessorio_venda
        FOREIGN KEY (vac_venda_id)
        REFERENCES concessionaria.venda (vnd_id)
        ON UPDATE RESTRICT
        ON DELETE CASCADE,

    CONSTRAINT fk_venda_acessorio_acessorio
        FOREIGN KEY (vac_acessorio_id)
        REFERENCES concessionaria.acessorio (acs_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_venda_acessorio_pagamento
        FOREIGN KEY (vac_forma_pagamento_id)
        REFERENCES concessionaria.forma_pagamento (fpg_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT ck_venda_acessorio_quantidade
        CHECK (vac_quantidade > 0),

    CONSTRAINT ck_venda_acessorio_valor_unitario
        CHECK (vac_valor_unitario >= 0),

    CONSTRAINT ck_venda_acessorio_desconto
        CHECK (
            vac_desconto >= 0
            AND vac_desconto <= (vac_quantidade * vac_valor_unitario)
        ),

    CONSTRAINT ck_venda_acessorio_data_instalacao
        CHECK (
            vac_data_instalacao IS NULL
            OR vac_data_instalacao >= vac_data_pedido
        )
);

COMMIT;