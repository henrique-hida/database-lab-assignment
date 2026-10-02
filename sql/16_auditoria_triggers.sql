BEGIN;

CREATE FUNCTION auditoria.fn_registrar_alteracao()
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
    usuario_sistema TEXT := COALESCE(
        NULLIF(current_setting('app.os_user', true), ''),
        SESSION_USER
    );
BEGIN
    dados_antigos := to_jsonb(OLD);

    IF TG_OP = 'DELETE' THEN
        FOR nome_campo IN
            SELECT chave
            FROM jsonb_object_keys(dados_antigos) AS chave
        LOOP
            valor_antigo := dados_antigos -> nome_campo;

            INSERT INTO auditoria.registro (
                tabela_afetada,
                operacao,
                campo_editado,
                valor_antigo,
                valor_novo,
                bd_user,
                os_user
            ) VALUES (
                format('%I.%I', TG_TABLE_SCHEMA, TG_TABLE_NAME),
                'D',
                nome_campo,
                LEFT(valor_antigo #>> '{}', 100),
                NULL,
                SESSION_USER,
                usuario_sistema
            );
        END LOOP;

        RETURN OLD;
    END IF;

    dados_novos := to_jsonb(NEW);

    FOR nome_campo IN
        SELECT chave
        FROM jsonb_object_keys(dados_novos) AS chave
    LOOP
        valor_antigo := dados_antigos -> nome_campo;
        valor_novo := dados_novos -> nome_campo;

        IF valor_antigo IS DISTINCT FROM valor_novo THEN
            INSERT INTO auditoria.registro (
                tabela_afetada,
                operacao,
                campo_editado,
                valor_antigo,
                valor_novo,
                bd_user,
                os_user
            ) VALUES (
                format('%I.%I', TG_TABLE_SCHEMA, TG_TABLE_NAME),
                'U',
                nome_campo,
                LEFT(valor_antigo #>> '{}', 100),
                LEFT(valor_novo #>> '{}', 100),
                SESSION_USER,
                usuario_sistema
            );
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$;

ALTER FUNCTION auditoria.fn_registrar_alteracao() OWNER TO tsusho_audit;

REVOKE ALL ON FUNCTION auditoria.fn_registrar_alteracao() FROM PUBLIC;

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
