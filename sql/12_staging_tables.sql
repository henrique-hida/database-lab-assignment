BEGIN;

CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE staging.vendas (
    stv_cliente VARCHAR(120),
    stv_cpf_cnpj VARCHAR(18),
    stv_telefone VARCHAR(20),
    stv_cidade VARCHAR(80),
    stv_modelo VARCHAR(80),
    stv_versao VARCHAR(100),
    stv_cor VARCHAR(50),
    stv_ano SMALLINT,
    stv_placa VARCHAR(7),
    stv_valor_carro NUMERIC(12, 2),
    stv_desconto NUMERIC(12, 2),
    stv_valor_final NUMERIC(12, 2),
    stv_forma_pagamento VARCHAR(80),
    stv_entrada NUMERIC(12, 2),
    stv_parcelas SMALLINT,
    stv_valor_parcela NUMERIC(12, 2),
    stv_carro_troca VARCHAR(120),
    stv_valor_troca NUMERIC(12, 2),
    stv_data_pedido DATE,
    stv_data_faturamento DATE,
    stv_data_entrega DATE,
    stv_status VARCHAR(30),
    stv_observacoes TEXT
);


CREATE TABLE staging.carros (
    stc_modelo VARCHAR(80),
    stc_versao VARCHAR(100),
    stc_ano SMALLINT,
    stc_cor VARCHAR(50),
    stc_placa VARCHAR(7),
    stc_combustivel VARCHAR(30),
    stc_cambio VARCHAR(50),
    stc_valor_tabela NUMERIC(12, 2),
    stc_valor_minimo NUMERIC(12, 2),
    stc_entrada_estoque DATE,
    stc_data_reserva DATE,
    stc_data_saida DATE,
    stc_status VARCHAR(30),
    stc_local VARCHAR(80),
    stc_observacao TEXT
);


CREATE TABLE staging.acessorios (
    sta_cliente VARCHAR(120),
    sta_modelo_carro VARCHAR(80),
    sta_placa VARCHAR(7),
    sta_acessorio VARCHAR(100),
    sta_categoria VARCHAR(60),
    sta_marca VARCHAR(80),
    sta_quantidade SMALLINT,
    sta_valor_unitario NUMERIC(12, 2),
    sta_desconto NUMERIC(12, 2),
    sta_total NUMERIC(12, 2),
    sta_forma_pagamento VARCHAR(80),
    sta_data_pedido DATE,
    sta_data_instalacao DATE,
    sta_status VARCHAR(30),
    sta_observacao TEXT
);

COMMIT;