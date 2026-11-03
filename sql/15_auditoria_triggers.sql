BEGIN;

-- Procedure responsavel por inserir os registros na tabela de auditoria.
CREATE OR REPLACE PROCEDURE auditoria.proc_auditoria(
    p_tabela_afetada VARCHAR(100),
    p_operacao CHAR(1),
    p_campo_editado VARCHAR(100),
    p_valor_antigo VARCHAR(100),
    p_valor_novo VARCHAR(100),
    p_bd_user VARCHAR(30),
    p_os_user VARCHAR(255),
    p_data_entrada TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, auditoria
AS $$
BEGIN
    INSERT INTO auditoria.registro (
        tabela_afetada,
        operacao,
        campo_editado,
        valor_antigo,
        valor_novo,
        data_entrada_auditoria,
        bd_user,
        os_user
    ) VALUES (
        p_tabela_afetada,
        p_operacao,
        p_campo_editado,
        p_valor_antigo,
        p_valor_novo,
        p_data_entrada,
        p_bd_user,
        p_os_user
    );
END;
$$;

ALTER PROCEDURE auditoria.proc_auditoria(
    VARCHAR, CHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, TIMESTAMPTZ
) OWNER TO tsusho_audit;

REVOKE ALL ON PROCEDURE auditoria.proc_auditoria(
    VARCHAR, CHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, TIMESTAMPTZ
) FROM PUBLIC;

GRANT EXECUTE ON PROCEDURE auditoria.proc_auditoria(
    VARCHAR, CHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, TIMESTAMPTZ
) TO tsusho_audit;

-- Funcao utilizada pelos triggers de auditoria que aciona a procedure.
CREATE OR REPLACE FUNCTION auditoria.fn_registrar_alteracao()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, auditoria
AS $$
DECLARE
    dados_antigos JSONB;
    dados_novos JSONB;
    nome_campo TEXT;
    valor_antigo JSONB;
    valor_novo JSONB;
    usuario_banco TEXT := SESSION_USER;
    usuario_sistema TEXT := COALESCE(
        NULLIF(current_setting('app.os_user', true), ''),
        SESSION_USER
    );
BEGIN
    dados_antigos := to_jsonb(OLD);

    -- DELETE nao possui NEW: registra o valor anterior de todas as colunas via procedure.
    IF TG_OP = 'DELETE' THEN
        FOR nome_campo IN
            SELECT chave
            FROM jsonb_object_keys(dados_antigos) AS chave
        LOOP
            valor_antigo := dados_antigos -> nome_campo;

            CALL auditoria.proc_auditoria(
                format('%I.%I', TG_TABLE_SCHEMA, TG_TABLE_NAME),
                'D',
                nome_campo,
                LEFT(valor_antigo #>> '{}', 100),
                NULL,
                usuario_banco,
                usuario_sistema,
                CURRENT_TIMESTAMP
            );
        END LOOP;

        RETURN OLD;
    END IF;

    -- UPDATE: grava somente as colunas cujo valor foi efetivamente modificado via procedure.
    dados_novos := to_jsonb(NEW);

    FOR nome_campo IN
        SELECT chave
        FROM jsonb_object_keys(dados_novos) AS chave
    LOOP
        valor_antigo := dados_antigos -> nome_campo;
        valor_novo := dados_novos -> nome_campo;

        IF valor_antigo IS DISTINCT FROM valor_novo THEN
            CALL auditoria.proc_auditoria(
                format('%I.%I', TG_TABLE_SCHEMA, TG_TABLE_NAME),
                'U',
                nome_campo,
                LEFT(valor_antigo #>> '{}', 100),
                LEFT(valor_novo #>> '{}', 100),
                usuario_banco,
                usuario_sistema,
                CURRENT_TIMESTAMP
            );
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$;

-- Mantem a funcao sob a role proprietaria do schema de auditoria.
ALTER FUNCTION auditoria.fn_registrar_alteracao() OWNER TO tsusho_audit;

-- Impede invocacao direta por roles nao autorizadas.
REVOKE ALL ON FUNCTION auditoria.fn_registrar_alteracao() FROM PUBLIC;

-- Cria o trigger apenas para tabelas operacionais. As tabelas historicas h*
-- ja armazenam versoes anteriores e nao devem gerar registros de auditoria.
DO $$
DECLARE
    tabela RECORD;
BEGIN
    FOR tabela IN
        SELECT classe.relname
        FROM pg_class AS classe
        JOIN pg_namespace AS esquema
            ON esquema.oid = classe.relnamespace
        WHERE esquema.nspname = 'concessionaria'
          AND classe.relkind = 'r'
          AND classe.relname NOT LIKE 'h%'
    LOOP
        EXECUTE format(
            'CREATE TRIGGER tg_auditoria_registro '
            || 'AFTER UPDATE OR DELETE ON concessionaria.%I '
            || 'FOR EACH ROW EXECUTE FUNCTION auditoria.fn_registrar_alteracao()',
            tabela.relname
        );
    END LOOP;
END;
$$;

COMMIT;
