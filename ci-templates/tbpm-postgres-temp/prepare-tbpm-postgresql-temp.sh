#!/bin/bash
# 1. create application server databases
sleep 3
set -e
psql -v ON_ERROR_STOP=1 --username "postgres" --dbname "postgres" <<-EOSQL
    DROP DATABASE IF EXISTS "sso-db" WITH (FORCE);
    DROP DATABASE IF EXISTS "dotnet-temp" WITH (FORCE);
    CREATE DATABASE "dotnet-temp";
    CREATE DATABASE "sso-db";
EOSQL

# 2. restore application server databases
sleep 3
pg_restore --host "localhost" --port "5432" --username "postgres" --no-password --dbname "dotnet-temp" --verbose "dotnet-temp.bak"
sleep 3
pg_restore --host "localhost" --port "5432" --username "postgres" --no-password --dbname "sso-db" --verbose "sso-db.bak"

# 3. add kz dictionaries
sleep 3
set -e
psql -v ON_ERROR_STOP=1 --username "postgres" --dbname "dotnet-temp" <<-EOSQL
    CREATE TEXT SEARCH CONFIGURATION public.kazakh ( COPY = pg_catalog.russian );
    CREATE TEXT SEARCH DICTIONARY kazakh_ispell (
         TEMPLATE = ispell,
         DictFile = kk_KZ,
         AffFile = kk_KZ
    );
    ALTER TEXT SEARCH CONFIGURATION kazakh
        ALTER MAPPING FOR asciiword, asciihword, hword_asciipart,
                          word, hword, hword_part
        WITH kazakh_ispell, russian_stem;
EOSQL