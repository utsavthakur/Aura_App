#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE auth_db;
    CREATE DATABASE user_db;
    CREATE DATABASE post_db;
    CREATE DATABASE media_db;
    CREATE DATABASE chat_db;
    CREATE DATABASE notification_db;
EOSQL

# Run schema scripts for each service
for db in auth_db user_db post_db media_db chat_db notification_db; do
    schema="/docker-entrypoint-initdb.d/${db}.sql"
    if [ -f "$schema" ]; then
        psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$db" -f "$schema"
    fi
done
