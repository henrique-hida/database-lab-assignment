BEGIN;

-- =========================================================
-- 1. TRIGGERS DE HISTORICO - INDEPENDENTES
-- =========================================================

CREATE OR REPLACE FUNCTION concessionaria.fn_historico_cidade()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_cidade (
        his_cidade_id,
        his_cidade_dt_entrada,
        cdd_id,
        cdd_nome,
        cdd_uf
    ) VALUES (
        nextval('concessionaria.seq_his_cidade'::regclass),
        CURRENT_TIMESTAMP,
        OLD.cdd_id,
        OLD.cdd_nome,
        OLD.cdd_uf
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_cidade ON concessionaria.cidade;
CREATE TRIGGER tg_his_cidade
    BEFORE UPDATE OR DELETE ON concessionaria.cidade
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_cidade();


CREATE OR REPLACE FUNCTION concessionaria.fn_historico_cor()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_cor (
        his_cor_id,
        his_cor_dt_entrada,
        crr_id,
        crr_nome
    ) VALUES (
        nextval('concessionaria.seq_his_cor'::regclass),
        CURRENT_TIMESTAMP,
        OLD.crr_id,
        OLD.crr_nome
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_cor ON concessionaria.cor;
CREATE TRIGGER tg_his_cor
    BEFORE UPDATE OR DELETE ON concessionaria.cor
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_cor();


CREATE OR REPLACE FUNCTION concessionaria.fn_historico_modelo_veiculo()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_modelo_veiculo (
        his_modelo_veiculo_id,
        his_modelo_veiculo_dt_entrada,
        mdv_id,
        mdv_nome
    ) VALUES (
        nextval('concessionaria.seq_his_modelo_veiculo'::regclass),
        CURRENT_TIMESTAMP,
        OLD.mdv_id,
        OLD.mdv_nome
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_modelo_veiculo ON concessionaria.modelo_veiculo;
CREATE TRIGGER tg_his_modelo_veiculo
    BEFORE UPDATE OR DELETE ON concessionaria.modelo_veiculo
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_modelo_veiculo();


CREATE OR REPLACE FUNCTION concessionaria.fn_historico_forma_pagamento()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_forma_pagamento (
        his_forma_pagamento_id,
        his_forma_pagamento_dt_entrada,
        fpg_id,
        fpg_descricao
    ) VALUES (
        nextval('concessionaria.seq_his_forma_pagamento'::regclass),
        CURRENT_TIMESTAMP,
        OLD.fpg_id,
        OLD.fpg_descricao
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_forma_pagamento ON concessionaria.forma_pagamento;
CREATE TRIGGER tg_his_forma_pagamento
    BEFORE UPDATE OR DELETE ON concessionaria.forma_pagamento
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_forma_pagamento();


CREATE OR REPLACE FUNCTION concessionaria.fn_historico_categoria_acessorio()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_categoria_acessorio (
        his_categoria_acessorio_id,
        his_categoria_acessorio_dt_entrada,
        cta_id,
        cta_nome
    ) VALUES (
        nextval('concessionaria.seq_his_categoria_acessorio'::regclass),
        CURRENT_TIMESTAMP,
        OLD.cta_id,
        OLD.cta_nome
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_categoria_acessorio ON concessionaria.categoria_acessorio;
CREATE TRIGGER tg_his_categoria_acessorio
    BEFORE UPDATE OR DELETE ON concessionaria.categoria_acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_categoria_acessorio();


CREATE OR REPLACE FUNCTION concessionaria.fn_historico_marca_acessorio()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_marca_acessorio (
        his_marca_acessorio_id,
        his_marca_acessorio_dt_entrada,
        mca_id,
        mca_nome
    ) VALUES (
        nextval('concessionaria.seq_his_marca_acessorio'::regclass),
        CURRENT_TIMESTAMP,
        OLD.mca_id,
        OLD.mca_nome
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_marca_acessorio ON concessionaria.marca_acessorio;
CREATE TRIGGER tg_his_marca_acessorio
    BEFORE UPDATE OR DELETE ON concessionaria.marca_acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_marca_acessorio();


CREATE OR REPLACE FUNCTION concessionaria.fn_historico_status_veiculo()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_status_veiculo (
        his_status_veiculo_id,
        his_status_veiculo_dt_entrada,
        sve_id,
        sve_nome
    ) VALUES (
        nextval('concessionaria.seq_his_status_veiculo'::regclass),
        CURRENT_TIMESTAMP,
        OLD.sve_id,
        OLD.sve_nome
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_status_veiculo ON concessionaria.status_veiculo;
CREATE TRIGGER tg_his_status_veiculo
    BEFORE UPDATE OR DELETE ON concessionaria.status_veiculo
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_status_veiculo();


CREATE OR REPLACE FUNCTION concessionaria.fn_historico_status_venda()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_status_venda (
        his_status_venda_id,
        his_status_venda_dt_entrada,
        svd_id,
        svd_nome
    ) VALUES (
        nextval('concessionaria.seq_his_status_venda'::regclass),
        CURRENT_TIMESTAMP,
        OLD.svd_id,
        OLD.svd_nome
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_status_venda ON concessionaria.status_venda;
CREATE TRIGGER tg_his_status_venda
    BEFORE UPDATE OR DELETE ON concessionaria.status_venda
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_status_venda();


CREATE OR REPLACE FUNCTION concessionaria.fn_historico_status_venda_acessorio()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_status_venda_acessorio (
        his_status_venda_acessorio_id,
        his_status_venda_acessorio_dt_entrada,
        sva_id,
        sva_nome
    ) VALUES (
        nextval('concessionaria.seq_his_status_venda_acessorio'::regclass),
        CURRENT_TIMESTAMP,
        OLD.sva_id,
        OLD.sva_nome
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_status_venda_acessorio ON concessionaria.status_venda_acessorio;
CREATE TRIGGER tg_his_status_venda_acessorio
    BEFORE UPDATE OR DELETE ON concessionaria.status_venda_acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_status_venda_acessorio();


-- =========================================================
-- 2. TRIGGERS DE HISTORICO - CLIENTES
-- =========================================================

CREATE OR REPLACE FUNCTION concessionaria.fn_historico_cliente()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_cliente (
        his_cliente_id,
        his_cliente_dt_entrada,
        cln_id,
        cln_cidade_id,
        cln_nome,
        cln_tipo_pessoa,
        cln_documento,
        cln_telefone
    ) VALUES (
        nextval('concessionaria.seq_his_cliente'::regclass),
        CURRENT_TIMESTAMP,
        OLD.cln_id,
        OLD.cln_cidade_id,
        OLD.cln_nome,
        OLD.cln_tipo_pessoa,
        OLD.cln_documento,
        OLD.cln_telefone
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_cliente ON concessionaria.cliente;
CREATE TRIGGER tg_his_cliente
    BEFORE UPDATE OR DELETE ON concessionaria.cliente
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_cliente();


-- =========================================================
-- 3. TRIGGERS DE HISTORICO - VEICULOS
-- =========================================================

CREATE OR REPLACE FUNCTION concessionaria.fn_historico_versao_veiculo()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_versao_veiculo (
        his_versao_veiculo_id,
        his_versao_veiculo_dt_entrada,
        vsv_id,
        vsv_modelo_veiculo_id,
        vsv_nome,
        vsv_combustivel,
        vsv_cambio
    ) VALUES (
        nextval('concessionaria.seq_his_versao_veiculo'::regclass),
        CURRENT_TIMESTAMP,
        OLD.vsv_id,
        OLD.vsv_modelo_veiculo_id,
        OLD.vsv_nome,
        OLD.vsv_combustivel,
        OLD.vsv_cambio
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_versao_veiculo ON concessionaria.versao_veiculo;
CREATE TRIGGER tg_his_versao_veiculo
    BEFORE UPDATE OR DELETE ON concessionaria.versao_veiculo
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_versao_veiculo();


CREATE OR REPLACE FUNCTION concessionaria.fn_historico_veiculo()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_veiculo (
        his_veiculo_id,
        his_veiculo_dt_entrada,
        vcl_id,
        vcl_versao_veiculo_id,
        vcl_cor_id,
        vcl_placa,
        vcl_ano,
        vcl_valor_tabela,
        vcl_valor_minimo,
        vcl_data_entrada_estoque,
        vcl_data_reserva,
        vcl_data_saida,
        vcl_status_veiculo_id,
        vcl_local_estoque,
        vcl_observacao
    ) VALUES (
        nextval('concessionaria.seq_his_veiculo'::regclass),
        CURRENT_TIMESTAMP,
        OLD.vcl_id,
        OLD.vcl_versao_veiculo_id,
        OLD.vcl_cor_id,
        OLD.vcl_placa,
        OLD.vcl_ano,
        OLD.vcl_valor_tabela,
        OLD.vcl_valor_minimo,
        OLD.vcl_data_entrada_estoque,
        OLD.vcl_data_reserva,
        OLD.vcl_data_saida,
        OLD.vcl_status_veiculo_id,
        OLD.vcl_local_estoque,
        OLD.vcl_observacao
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_veiculo ON concessionaria.veiculo;
CREATE TRIGGER tg_his_veiculo
    BEFORE UPDATE OR DELETE ON concessionaria.veiculo
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_veiculo();


-- =========================================================
-- 4. TRIGGERS DE HISTORICO - ACESSORIOS
-- =========================================================

CREATE OR REPLACE FUNCTION concessionaria.fn_historico_acessorio()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_acessorio (
        his_acessorio_id,
        his_acessorio_dt_entrada,
        acs_id,
        acs_categoria_acessorio_id,
        acs_marca_acessorio_id,
        acs_nome
    ) VALUES (
        nextval('concessionaria.seq_his_acessorio'::regclass),
        CURRENT_TIMESTAMP,
        OLD.acs_id,
        OLD.acs_categoria_acessorio_id,
        OLD.acs_marca_acessorio_id,
        OLD.acs_nome
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_acessorio ON concessionaria.acessorio;
CREATE TRIGGER tg_his_acessorio
    BEFORE UPDATE OR DELETE ON concessionaria.acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_acessorio();


-- =========================================================
-- 5. TRIGGERS DE HISTORICO - VENDAS
-- =========================================================

CREATE OR REPLACE FUNCTION concessionaria.fn_historico_venda()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_venda (
        his_venda_id,
        his_venda_dt_entrada,
        vnd_id,
        vnd_cliente_id,
        vnd_veiculo_id,
        vnd_forma_pagamento_id,
        vnd_valor_carro,
        vnd_desconto,
        vnd_valor_final,
        vnd_entrada,
        vnd_parcelas,
        vnd_valor_parcela,
        vnd_data_pedido,
        vnd_data_faturamento,
        vnd_data_entrega,
        vnd_status_venda_id,
        vnd_observacao
    ) VALUES (
        nextval('concessionaria.seq_his_venda'::regclass),
        CURRENT_TIMESTAMP,
        OLD.vnd_id,
        OLD.vnd_cliente_id,
        OLD.vnd_veiculo_id,
        OLD.vnd_forma_pagamento_id,
        OLD.vnd_valor_carro,
        OLD.vnd_desconto,
        OLD.vnd_valor_final,
        OLD.vnd_entrada,
        OLD.vnd_parcelas,
        OLD.vnd_valor_parcela,
        OLD.vnd_data_pedido,
        OLD.vnd_data_faturamento,
        OLD.vnd_data_entrega,
        OLD.vnd_status_venda_id,
        OLD.vnd_observacao
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_venda ON concessionaria.venda;
CREATE TRIGGER tg_his_venda
    BEFORE UPDATE OR DELETE ON concessionaria.venda
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_venda();


CREATE OR REPLACE FUNCTION concessionaria.fn_historico_veiculo_troca()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_veiculo_troca (
        his_veiculo_troca_id,
        his_veiculo_troca_dt_entrada,
        vtr_id,
        vtr_venda_id,
        vtr_descricao,
        vtr_valor_avaliado
    ) VALUES (
        nextval('concessionaria.seq_his_veiculo_troca'::regclass),
        CURRENT_TIMESTAMP,
        OLD.vtr_id,
        OLD.vtr_venda_id,
        OLD.vtr_descricao,
        OLD.vtr_valor_avaliado
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_veiculo_troca ON concessionaria.veiculo_troca;
CREATE TRIGGER tg_his_veiculo_troca
    BEFORE UPDATE OR DELETE ON concessionaria.veiculo_troca
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_veiculo_troca();


CREATE OR REPLACE FUNCTION concessionaria.fn_historico_venda_acessorio()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, concessionaria
AS $$
BEGIN
    INSERT INTO concessionaria.his_venda_acessorio (
        his_venda_acessorio_id,
        his_venda_acessorio_dt_entrada,
        vac_id,
        vac_venda_id,
        vac_acessorio_id,
        vac_forma_pagamento_id,
        vac_quantidade,
        vac_valor_unitario,
        vac_desconto,
        vac_total,
        vac_data_pedido,
        vac_data_instalacao,
        vac_status_venda_acessorio_id,
        vac_observacao
    ) VALUES (
        nextval('concessionaria.seq_his_venda_acessorio'::regclass),
        CURRENT_TIMESTAMP,
        OLD.vac_id,
        OLD.vac_venda_id,
        OLD.vac_acessorio_id,
        OLD.vac_forma_pagamento_id,
        OLD.vac_quantidade,
        OLD.vac_valor_unitario,
        OLD.vac_desconto,
        OLD.vac_total,
        OLD.vac_data_pedido,
        OLD.vac_data_instalacao,
        OLD.vac_status_venda_acessorio_id,
        OLD.vac_observacao
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tg_his_venda_acessorio ON concessionaria.venda_acessorio;
CREATE TRIGGER tg_his_venda_acessorio
    BEFORE UPDATE OR DELETE ON concessionaria.venda_acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_historico_venda_acessorio();

COMMIT;
