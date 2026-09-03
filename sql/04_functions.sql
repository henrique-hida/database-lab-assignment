BEGIN;

CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id_cidade()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.cdd_id := nextval('concessionaria.seq_cidade'::regclass);
    ELSIF TG_OP = 'UPDATE'
        AND NEW.cdd_id IS DISTINCT FROM OLD.cdd_id THEN
        RAISE EXCEPTION
            'Nao e permitido alterar o identificador de cidade.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id_cliente()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.cln_id := nextval('concessionaria.seq_cliente'::regclass);
    ELSIF TG_OP = 'UPDATE'
        AND NEW.cln_id IS DISTINCT FROM OLD.cln_id THEN
        RAISE EXCEPTION
            'Nao e permitido alterar o identificador de cliente.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id_modelo_veiculo()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.mdv_id := nextval('concessionaria.seq_modelo_veiculo'::regclass);
    ELSIF TG_OP = 'UPDATE'
        AND NEW.mdv_id IS DISTINCT FROM OLD.mdv_id THEN
        RAISE EXCEPTION
            'Nao e permitido alterar o identificador de modelo de veiculo.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id_versao_veiculo()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.vsv_id := nextval('concessionaria.seq_versao_veiculo'::regclass);
    ELSIF TG_OP = 'UPDATE'
        AND NEW.vsv_id IS DISTINCT FROM OLD.vsv_id THEN
        RAISE EXCEPTION
            'Nao e permitido alterar o identificador de versao de veiculo.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id_cor()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.crr_id := nextval('concessionaria.seq_cor'::regclass);
    ELSIF TG_OP = 'UPDATE'
        AND NEW.crr_id IS DISTINCT FROM OLD.crr_id THEN
        RAISE EXCEPTION
            'Nao e permitido alterar o identificador de cor.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id_veiculo()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.vcl_id := nextval('concessionaria.seq_veiculo'::regclass);
    ELSIF TG_OP = 'UPDATE'
        AND NEW.vcl_id IS DISTINCT FROM OLD.vcl_id THEN
        RAISE EXCEPTION
            'Nao e permitido alterar o identificador de veiculo.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id_forma_pagamento()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.fpg_id := nextval('concessionaria.seq_forma_pagamento'::regclass);
    ELSIF TG_OP = 'UPDATE'
        AND NEW.fpg_id IS DISTINCT FROM OLD.fpg_id THEN
        RAISE EXCEPTION
            'Nao e permitido alterar o identificador de forma de pagamento.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id_venda()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.vnd_id := nextval('concessionaria.seq_venda'::regclass);
    ELSIF TG_OP = 'UPDATE'
        AND NEW.vnd_id IS DISTINCT FROM OLD.vnd_id THEN
        RAISE EXCEPTION
            'Nao e permitido alterar o identificador de venda.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id_veiculo_troca()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.vtr_id := nextval('concessionaria.seq_veiculo_troca'::regclass);
    ELSIF TG_OP = 'UPDATE'
        AND NEW.vtr_id IS DISTINCT FROM OLD.vtr_id THEN
        RAISE EXCEPTION
            'Nao e permitido alterar o identificador de veiculo de troca.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id_categoria_acessorio()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.cta_id := nextval('concessionaria.seq_categoria_acessorio'::regclass);
    ELSIF TG_OP = 'UPDATE'
        AND NEW.cta_id IS DISTINCT FROM OLD.cta_id THEN
        RAISE EXCEPTION
            'Nao e permitido alterar o identificador de categoria de acessorio.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id_marca_acessorio()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.mca_id := nextval('concessionaria.seq_marca_acessorio'::regclass);
    ELSIF TG_OP = 'UPDATE'
        AND NEW.mca_id IS DISTINCT FROM OLD.mca_id THEN
        RAISE EXCEPTION
            'Nao e permitido alterar o identificador de marca de acessorio.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id_acessorio()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.acs_id := nextval('concessionaria.seq_acessorio'::regclass);
    ELSIF TG_OP = 'UPDATE'
        AND NEW.acs_id IS DISTINCT FROM OLD.acs_id THEN
        RAISE EXCEPTION
            'Nao e permitido alterar o identificador de acessorio.';
    END IF;

    RETURN NEW;
END;
$$;


CREATE OR REPLACE FUNCTION concessionaria.fn_controlar_id_venda_acessorio()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.vac_id := nextval('concessionaria.seq_venda_acessorio'::regclass);
    ELSIF TG_OP = 'UPDATE'
        AND NEW.vac_id IS DISTINCT FROM OLD.vac_id THEN
        RAISE EXCEPTION
            'Nao e permitido alterar o identificador de venda de acessorio.';
    END IF;

    RETURN NEW;
END;
$$;

COMMIT;