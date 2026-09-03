BEGIN;

CREATE TRIGGER tg_cidade_controlar_id
    BEFORE INSERT OR UPDATE OF cdd_id
    ON concessionaria.cidade
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id_cidade();

CREATE TRIGGER tg_cliente_controlar_id
    BEFORE INSERT OR UPDATE OF cln_id
    ON concessionaria.cliente
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id_cliente();

CREATE TRIGGER tg_modelo_veiculo_controlar_id
    BEFORE INSERT OR UPDATE OF mdv_id
    ON concessionaria.modelo_veiculo
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id_modelo_veiculo();

CREATE TRIGGER tg_versao_veiculo_controlar_id
    BEFORE INSERT OR UPDATE OF vsv_id
    ON concessionaria.versao_veiculo
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id_versao_veiculo();

CREATE TRIGGER tg_cor_controlar_id
    BEFORE INSERT OR UPDATE OF crr_id
    ON concessionaria.cor
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id_cor();

CREATE TRIGGER tg_veiculo_controlar_id
    BEFORE INSERT OR UPDATE OF vcl_id
    ON concessionaria.veiculo
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id_veiculo();

CREATE TRIGGER tg_forma_pagamento_controlar_id
    BEFORE INSERT OR UPDATE OF fpg_id
    ON concessionaria.forma_pagamento
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id_forma_pagamento();

CREATE TRIGGER tg_venda_controlar_id
    BEFORE INSERT OR UPDATE OF vnd_id
    ON concessionaria.venda
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id_venda();

CREATE TRIGGER tg_veiculo_troca_controlar_id
    BEFORE INSERT OR UPDATE OF vtr_id
    ON concessionaria.veiculo_troca
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id_veiculo_troca();

CREATE TRIGGER tg_categoria_acessorio_controlar_id
    BEFORE INSERT OR UPDATE OF cta_id
    ON concessionaria.categoria_acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id_categoria_acessorio();

CREATE TRIGGER tg_marca_acessorio_controlar_id
    BEFORE INSERT OR UPDATE OF mca_id
    ON concessionaria.marca_acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id_marca_acessorio();

CREATE TRIGGER tg_acessorio_controlar_id
    BEFORE INSERT OR UPDATE OF acs_id
    ON concessionaria.acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id_acessorio();

CREATE TRIGGER tg_venda_acessorio_controlar_id
    BEFORE INSERT OR UPDATE OF vac_id
    ON concessionaria.venda_acessorio
    FOR EACH ROW
    EXECUTE FUNCTION concessionaria.fn_controlar_id_venda_acessorio();

COMMIT;