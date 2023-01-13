#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "admin" --dbname "keycloak" <<-EOSQL
	CREATE USER keycloak WITH PASSWORD 'password';
	CREATE DATABASE keycloak;
	GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak;
EOSQL