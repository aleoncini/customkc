# customkc

a customized keycloak container image

This project is an exmple of how to create a customized (i.e. an image with an embedded setup to access a production DB or with a company brand theme or with specific SPI providers) image of Kycloak.

In this example the external DB is a PostgresQL instance.

The example suppose you are using podman to manage the required containers, in case you are using docker commands should be the same, in case you want to deploy on kubernetes or OpenShift some additional work is required but the base concepts of creating a custom image will remain the same.

## Preparing a Pod with Postgres database

In this example we are going to use a pod with two containers, a container with the actual database server and a container with pgadmin client, a tool to administer postgresql server.

Let's start creating the pod:

    > podman pod create --name postgres -p 4080:80 -p 5432:5432

now we can run the postgresql container (version 13 for this example):

    > podman run -d --rm --name db --pod=postgres -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=password -v ~/worklab/projects/volumes/pgsql_13/data:/var/lib/postgresql/data --privileged docker.io/library/postgres:13

in the previous command note that '--privileged' parameter is used to avoid issues of privileges when running in rootless mode.

## Build and Run the custom keycloak image

podman build -t custom-keycloak .

podman run --rm --name keycloak -p 8443:8443 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=password kc start --db-url=jdbc:postgresql://ersamurai:5432/keycloak --db-username=admin --db-password=password --hostname=ersamurai:8443

