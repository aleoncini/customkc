FROM postgres:13
ENV POSTGRES_PASSWORD password
ENV POSTGRES_DB world
COPY docker-entrypoint-initdb.d/init-keycloak-db.sh /docker-entrypoint-initdb.d/