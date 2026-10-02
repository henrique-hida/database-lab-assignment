BEGIN;

CREATE SCHEMA auditoria;

CREATE TABLE auditoria.registro (
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
            (operacao = 'D' AND valor_novo IS NULL)
            OR operacao = 'U'
        )
);

REVOKE ALL ON SCHEMA auditoria FROM PUBLIC, tsusho_user;
REVOKE ALL ON TABLE auditoria.registro FROM PUBLIC, tsusho_user;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA auditoria FROM PUBLIC, tsusho_user;

GRANT USAGE ON SCHEMA auditoria TO tsusho_audit;
GRANT INSERT ON auditoria.registro TO tsusho_audit;
GRANT USAGE ON SEQUENCE auditoria.registro_id_seq TO tsusho_audit;

COMMIT;
