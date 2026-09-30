BEGIN;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_roles
        WHERE rolname = 'auditoria_user'
    ) THEN
        CREATE ROLE auditoria_user LOGIN SUPERUSER;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_roles
        WHERE rolname = 'tsusho_comum_user'
    ) THEN
        CREATE ROLE tsusho_comum_user LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION;
    END IF;
END;
$$;

ALTER ROLE auditoria_user WITH LOGIN SUPERUSER;
ALTER ROLE tsusho_user WITH LOGIN SUPERUSER;
ALTER ROLE tsusho_comum_user WITH LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION;

COMMIT;
