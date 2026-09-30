BEGIN;

CREATE SCHEMA IF NOT EXISTS auditoria;

CREATE TABLE IF NOT EXISTS auditoria.registro (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tabela_afetada VARCHAR(100) NOT NULL,
    operacao CHAR(1) NOT NULL,
    campo_editado VARCHAR(100),
    valor_antigo VARCHAR(100),
    valor_novo VARCHAR(100),
    data_entrada_auditoria TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    bd_user VARCHAR(30) NOT NULL DEFAULT CURRENT_USER,
    os_user VARCHAR(255) NOT NULL,

    CONSTRAINT ck_registro_operacao
        CHECK (operacao IN ('D', 'U')),
    CONSTRAINT ck_registro_campo_editado
        CHECK (
            (operacao = 'D' AND campo_editado IS NULL AND valor_novo IS NULL)
            OR operacao = 'U'
        )
);

ALTER SCHEMA auditoria OWNER TO auditoria_user;
ALTER TABLE auditoria.registro OWNER TO auditoria_user;

-- Adequa bancos que ja possuem a tabela criada pela versao anterior.
ALTER TABLE auditoria.registro
    ALTER COLUMN valor_antigo TYPE VARCHAR(100)
        USING LEFT(valor_antigo, 100),
    ALTER COLUMN valor_novo TYPE VARCHAR(100)
        USING LEFT(valor_novo, 100);

ALTER TABLE auditoria.registro
    DROP CONSTRAINT IF EXISTS ck_registro_campo_editado;

ALTER TABLE auditoria.registro
    ADD CONSTRAINT ck_registro_campo_editado
        CHECK (
            (operacao = 'D' AND valor_novo IS NULL)
            OR operacao = 'U'
        );

REVOKE ALL ON SCHEMA auditoria FROM PUBLIC, tsusho_comum_user;
REVOKE ALL ON TABLE auditoria.registro FROM PUBLIC, tsusho_comum_user;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA auditoria FROM PUBLIC, tsusho_comum_user;

GRANT USAGE ON SCHEMA concessionaria TO tsusho_comum_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA concessionaria TO tsusho_comum_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA concessionaria TO tsusho_comum_user;
ALTER DEFAULT PRIVILEGES FOR ROLE tsusho_user IN SCHEMA concessionaria
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO tsusho_comum_user;
ALTER DEFAULT PRIVILEGES FOR ROLE tsusho_user IN SCHEMA concessionaria
    GRANT USAGE, SELECT ON SEQUENCES TO tsusho_comum_user;

COMMIT;
