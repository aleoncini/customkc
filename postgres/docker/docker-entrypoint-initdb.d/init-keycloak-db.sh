CREATE USER keycloak WITH PASSWORD password;
CREATE DATABASE keycloak;
GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak;