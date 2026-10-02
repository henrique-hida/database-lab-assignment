BEGIN;

CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    coluna_id TEXT := TG_ARGV[0];
    sequencia_id REGCLASS := TG_ARGV[1]::REGCLASS;
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW := jsonb_populate_record(
            NEW,
            jsonb_build_object(coluna_id, nextval(sequencia_id))
        );
    ELSIF TG_OP = 'UPDATE'
        AND (to_jsonb(NEW) -> coluna_id)
            IS DISTINCT FROM (to_jsonb(OLD) -> coluna_id) THEN
        RAISE EXCEPTION 'Nao e permitido alterar o identificador.';
    END IF;

    RETURN NEW;
END;
$$;

COMMIT;

BEGIN;

CREATE TRIGGER tg_cidade_controlar_id
    BEFORE INSERT OR UPDATE OF cdd_id
    ON concessionaria.cidade
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('cdd_id', 'concessionaria.seq_cidade');

CREATE TRIGGER tg_cliente_controlar_id
    BEFORE INSERT OR UPDATE OF cln_id
    ON concessionaria.cliente
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('cln_id', 'concessionaria.seq_cliente');

CREATE TRIGGER tg_modelo_veiculo_controlar_id
    BEFORE INSERT OR UPDATE OF mdv_id
    ON concessionaria.modelo_veiculo
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('mdv_id', 'concessionaria.seq_modelo_veiculo');

CREATE TRIGGER tg_versao_veiculo_controlar_id
    BEFORE INSERT OR UPDATE OF vsv_id
    ON concessionaria.versao_veiculo
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('vsv_id', 'concessionaria.seq_versao_veiculo');

CREATE TRIGGER tg_cor_controlar_id
    BEFORE INSERT OR UPDATE OF crr_id
    ON concessionaria.cor
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('crr_id', 'concessionaria.seq_cor');

CREATE TRIGGER tg_veiculo_controlar_id
    BEFORE INSERT OR UPDATE OF vcl_id
    ON concessionaria.veiculo
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('vcl_id', 'concessionaria.seq_veiculo');

CREATE TRIGGER tg_forma_pagamento_controlar_id
    BEFORE INSERT OR UPDATE OF fpg_id
    ON concessionaria.forma_pagamento
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('fpg_id', 'concessionaria.seq_forma_pagamento');

CREATE TRIGGER tg_venda_controlar_id
    BEFORE INSERT OR UPDATE OF vnd_id
    ON concessionaria.venda
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('vnd_id', 'concessionaria.seq_venda');

CREATE TRIGGER tg_veiculo_troca_controlar_id
    BEFORE INSERT OR UPDATE OF vtr_id
    ON concessionaria.veiculo_troca
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('vtr_id', 'concessionaria.seq_veiculo_troca');

CREATE TRIGGER tg_categoria_acessorio_controlar_id
    BEFORE INSERT OR UPDATE OF cta_id
    ON concessionaria.categoria_acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('cta_id', 'concessionaria.seq_categoria_acessorio');

CREATE TRIGGER tg_marca_acessorio_controlar_id
    BEFORE INSERT OR UPDATE OF mca_id
    ON concessionaria.marca_acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('mca_id', 'concessionaria.seq_marca_acessorio');

CREATE TRIGGER tg_status_veiculo_controlar_id
    BEFORE INSERT OR UPDATE OF sve_id
    ON concessionaria.status_veiculo
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('sve_id', 'concessionaria.seq_status_veiculo');

CREATE TRIGGER tg_status_venda_controlar_id
    BEFORE INSERT OR UPDATE OF svd_id
    ON concessionaria.status_venda
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('svd_id', 'concessionaria.seq_status_venda');

CREATE TRIGGER tg_status_venda_acessorio_controlar_id
    BEFORE INSERT OR UPDATE OF sva_id
    ON concessionaria.status_venda_acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('sva_id', 'concessionaria.seq_status_venda_acessorio');

CREATE TRIGGER tg_acessorio_controlar_id
    BEFORE INSERT OR UPDATE OF acs_id
    ON concessionaria.acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('acs_id', 'concessionaria.seq_acessorio');

CREATE TRIGGER tg_venda_acessorio_controlar_id
    BEFORE INSERT OR UPDATE OF vac_id
    ON concessionaria.venda_acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id('vac_id', 'concessionaria.seq_venda_acessorio');

COMMIT;
