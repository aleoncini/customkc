#!/bin/bash

# Loading common env variables. Don't forget to check they match your local environment
. .env

TARGET_DIR=$1

# the script requires an installation directory.
# Here we check that the specified directory exists.
ensure_directory_exists() {
    if [ ! -d $TARGET_DIR ]; then
        echo "Directory $TARGET_DIR does not exist, creating..."
        mkdir -p $TARGET_DIR || { echo "Failed to create $TARGET_DIR"; exit 1; }
        echo "Directory $dir created."
    else
        echo "Directory $dir already exists."
    fi
}

KEYCLOAK_SERVER="$TARGET_DIR/keycloak-$KEYCLOAK_VERSION.tar.gz"

# This function checks if the Keycloak server is already available in the target directory
# if it doesn't already exist downloads it
download_keycloak_server() {
    if [ ! -f "$KEYCLOAK_SERVER" ]; then
        echo "Downloading Keycloak server..."
        curl -L --output "$KEYCLOAK_SERVER" https://github.com/keycloak/keycloak/releases/download/"${KEYCLOAK_VERSION}"/keycloak-"${KEYCLOAK_VERSION}".tar.gz
        echo "Keycloak server downloaded to $KEYCLOAK_SERVER."
    else
        echo "Keycloak server already exists at $KEYCLOAK_SERVER."
    fi
}

# running the script
ensure_directory_exists
download_keycloak_server

echo "Installation completed. Check logs for a successful outcome."