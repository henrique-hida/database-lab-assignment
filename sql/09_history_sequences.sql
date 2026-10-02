BEGIN;

CREATE SEQUENCE concessionaria.seq_his_cidade
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_cidade.his_cidade_id;

CREATE SEQUENCE concessionaria.seq_his_cliente
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_cliente.his_cliente_id;

CREATE SEQUENCE concessionaria.seq_his_modelo_veiculo
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_modelo_veiculo.his_modelo_veiculo_id;

CREATE SEQUENCE concessionaria.seq_his_versao_veiculo
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_versao_veiculo.his_versao_veiculo_id;

CREATE SEQUENCE concessionaria.seq_his_cor
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_cor.his_cor_id;

CREATE SEQUENCE concessionaria.seq_his_veiculo
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_veiculo.his_veiculo_id;

CREATE SEQUENCE concessionaria.seq_his_forma_pagamento
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_forma_pagamento.his_forma_pagamento_id;

CREATE SEQUENCE concessionaria.seq_his_venda
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_venda.his_venda_id;

CREATE SEQUENCE concessionaria.seq_his_veiculo_troca
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_veiculo_troca.his_veiculo_troca_id;

CREATE SEQUENCE concessionaria.seq_his_categoria_acessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_categoria_acessorio.his_categoria_acessorio_id;

CREATE SEQUENCE concessionaria.seq_his_marca_acessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_marca_acessorio.his_marca_acessorio_id;

CREATE SEQUENCE concessionaria.seq_his_status_veiculo
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_status_veiculo.his_status_veiculo_id;

CREATE SEQUENCE concessionaria.seq_his_status_venda
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_status_venda.his_status_venda_id;

CREATE SEQUENCE concessionaria.seq_his_status_venda_acessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_status_venda_acessorio.his_status_venda_acessorio_id;

CREATE SEQUENCE concessionaria.seq_his_acessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_acessorio.his_acessorio_id;

CREATE SEQUENCE concessionaria.seq_his_venda_acessorio
    AS BIGINT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NO MAXVALUE
    NO CYCLE
    CACHE 1
    OWNED BY concessionaria.his_venda_acessorio.his_venda_acessorio_id;

COMMIT;
