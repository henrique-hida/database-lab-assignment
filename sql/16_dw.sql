BEGIN;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_roles
        WHERE rolname = 'tsusho_dw'
    ) THEN
        CREATE ROLE tsusho_dw
            LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION;
    END IF;
END;
$$;

CREATE SCHEMA IF NOT EXISTS dw AUTHORIZATION tsusho_dw;

REVOKE ALL ON SCHEMA dw FROM PUBLIC, tsusho_user, tsusho_audit;

GRANT USAGE, CREATE ON SCHEMA dw TO tsusho_dw;
GRANT USAGE ON SCHEMA concessionaria TO tsusho_dw;
GRANT SELECT ON ALL TABLES IN SCHEMA concessionaria TO tsusho_dw;

ALTER DEFAULT PRIVILEGES FOR ROLE tsusho_admin IN SCHEMA concessionaria
    GRANT SELECT ON TABLES TO tsusho_dw;

COMMIT;
