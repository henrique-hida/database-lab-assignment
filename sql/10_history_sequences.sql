BEGIN;

CREATE SEQUENCE concessionaria.seq_hcidade
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hcidade.hcdd_id;

CREATE SEQUENCE concessionaria.seq_hcliente
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hcliente.hcln_id;

CREATE SEQUENCE concessionaria.seq_hmodelo_veiculo
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hmodelo_veiculo.hmdv_id;

CREATE SEQUENCE concessionaria.seq_hversao_veiculo
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hversao_veiculo.hvsv_id;

CREATE SEQUENCE concessionaria.seq_hcor
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hcor.hcrr_id;

CREATE SEQUENCE concessionaria.seq_hveiculo
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hveiculo.hvcl_id;

CREATE SEQUENCE concessionaria.seq_hforma_pagamento
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hforma_pagamento.hfpg_id;

CREATE SEQUENCE concessionaria.seq_hvenda
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hvenda.hvnd_id;

CREATE SEQUENCE concessionaria.seq_hveiculo_troca
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hveiculo_troca.hvtr_id;

CREATE SEQUENCE concessionaria.seq_hcategoria_acessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hcategoria_acessorio.hcta_id;

CREATE SEQUENCE concessionaria.seq_hmarca_acessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hmarca_acessorio.hmca_id;

CREATE SEQUENCE concessionaria.seq_hstatus_veiculo
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hstatus_veiculo.hsve_id;

CREATE SEQUENCE concessionaria.seq_hstatus_venda
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hstatus_venda.hsvd_id;

CREATE SEQUENCE concessionaria.seq_hstatus_venda_acessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hstatus_venda_acessorio.hsva_id;

CREATE SEQUENCE concessionaria.seq_hacessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hacessorio.hacs_id;

CREATE SEQUENCE concessionaria.seq_hvenda_acessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.hvenda_acessorio.hvac_id;

COMMIT;
