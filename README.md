# customkc

a customized keycloak container image running into a pod

This project is an exmple of how to create a customized (i.e. an image with an embedded setup to access a production DB or with a company brand theme or with specific SPI providers) image of Keycloak.

In this example we will configure a persistent external DB (PostgresQL) and a custom authentication provider.

The example suppose you are using podman to manage the required containers and pods, in case you are using docker commands should be the same, in case you want to deploy on kubernetes or OpenShift some additional work is required but the base concepts of creating a custom image will remain the same.

## Preparing a Pod with Postgres database

In this example we are going to use a pod with containers for Keycloak, DB (PostgresQL) and DB admin console (PGAdmin). They will run in a pod so they will see each other as localhost.

Let's start creating the pod:

    > podman pod create --name customkc -p 4080:80 -p 8443:8443

The ports that will expose refer to: 4048 => PGAdmin, 8443 => keycloak server.

now let's execute the postgresql container (using the latest version that when writing this example is version 18). To make the DB persistent we need to assign a persistent volume to the container.

    > podman run -d --rm --name db --pod customkc -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=password -v <your_local_directory>:/var/lib/postgresql/data --privileged docker.io/library/postgres:latest

in the previous command note that '--privileged' parameter is used to avoid issues of privileges when running in rootless mode.
The -v parameter is used to give persistency to the pod through restarts.

In the pod now we deploy also the PGADMIN tool, a web interface to administer postgresql databases:

    > podman run -d --rm --name pgadmin --pod customkc -e 'PGADMIN_DEFAULT_EMAIL=admin@redhat.com' -e 'PGADMIN_DEFAULT_PASSWORD=password' docker.io/dpage/pgadmin4:latest

This tool will be useful for the next quick steps we need to execute before launching the keycloak server. Open a browser and connect to http://localhost:4080 (or any other port you have specified in the previous comand *podman pod create ...*). Insert the email and password specified when launched the pgadmin container and access the web console.

Using the console create a server: click on "Add New Server", give a name to the server and set the hostname as localhost in the connection TAB.

Now, in the tree on the left side, click on the newly created server and in the component named Databases right-click the "create->databse" command. Name the database **keycloak**

Done! The database is now ready to be used as the external configuration repository for Keycloak server.

## Build and Run the custom keycloak image

access the docker directory and execute the build with the command 

    > podman build -t custom-keycloak .

looking at the *Dockerfile* used in this example I just want to address a couple of points: we are using the multi stage build (very useful to be sure that the build will be indipendent from the environment) and at line 13 we execute the final setup/conf/custumization, remember that this phase could be performed also at deploy time but of course the deploy will be slower.

Finally we can run the customi keycloak image:

    > podman run -d --rm --name keycloak -p 8443:8443 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=password custom-keycloak start --db-url=jdbc:postgresql://<your-workstation-hostname>:5432/keycloak --db-username=admin --db-password=password --hostname=<your-workstation-hostname>:8443

access the console with **https://yourhost:8443** and start to protect applications!
