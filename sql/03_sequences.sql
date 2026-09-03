BEGIN;

CREATE SEQUENCE concessionaria.seq_cidade
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.cidade.cdd_id;

CREATE SEQUENCE concessionaria.seq_cliente
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.cliente.cln_id;

CREATE SEQUENCE concessionaria.seq_modelo_veiculo
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.modelo_veiculo.mdv_id;

CREATE SEQUENCE concessionaria.seq_versao_veiculo
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.versao_veiculo.vsv_id;

CREATE SEQUENCE concessionaria.seq_cor
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.cor.crr_id;

CREATE SEQUENCE concessionaria.seq_veiculo
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.veiculo.vcl_id;

CREATE SEQUENCE concessionaria.seq_forma_pagamento
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.forma_pagamento.fpg_id;

CREATE SEQUENCE concessionaria.seq_venda
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.venda.vnd_id;

CREATE SEQUENCE concessionaria.seq_veiculo_troca
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.veiculo_troca.vtr_id;

CREATE SEQUENCE concessionaria.seq_categoria_acessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.categoria_acessorio.cta_id;

CREATE SEQUENCE concessionaria.seq_marca_acessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.marca_acessorio.mca_id;

CREATE SEQUENCE concessionaria.seq_acessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.acessorio.acs_id;

CREATE SEQUENCE concessionaria.seq_venda_acessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.venda_acessorio.vac_id;

COMMIT;