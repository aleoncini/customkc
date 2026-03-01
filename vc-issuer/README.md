# Custom Keycloak - enable Verifiable Credentials Issuing

***Issueing Verifiable Credentials with Keycloak***

This is an optional module built on top of the basic exercise of this project. It enables the OID4VCI experimental feature that can be used to create a development environment for the [European Digital Id (EUDI) and Digital Wallets](https://ec.europa.eu/digital-building-blocks/sites/spaces/EUDIGITALIDENTITYWALLET/pages/694487738/EU+Digital+Identity+Wallet+Home).

## Start the Keycloak instance

    In case you have a previously started container from this lab stop it with the command ''podman stop keycloak''
    
Using the images previously built make the Keycloak server run with the following command:

```bash
podman run -d --rm --name keycloak --pod customkc -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=password custom-keycloak start --hostname=https://localhost:8443 --features=oid4vc-vci
```
### using the Keycloak Command Line Interface (kcadm.sh)

most of the tasks in this lab must be executed using the Keycloak command line administration tool called kcadm.sh. We can use the one provided inside the keycloak container, doing this way we need to share a directory between our local environment and the internal container. Create the directory that we will use later with the admin command.

in order to avoid to repeat always the entire command line put it in a shell variable so that you can use as a shortcut
 

```bash
export KCADM="podman run --rm --entrypoint /opt/keycloak/bin/kcadm.sh -v /your/local/directory:/opt/keycloak/.keycloak quay.io/keycloak/keycloak:latest"
```

try the shortcut

```bash
$KCADM help create
```

You should see the output of the script

```
Usage: kcadm.sh create ENDPOINT_URI [ARGUMENTS]

Command to create new resources on the server.

Use 'kcadm.sh config credentials' to establish an authenticated sessions, or use --no-config with 
CREDENTIALS OPTIONS to perform one time authentication.

Arguments:

  Global options:
    -x                    Print full stack trace when exiting with error
    --config              Path to the config file (/opt/keycloak/.keycloak/kcadm.config by default)
    --no-config           Don't use config file - no authentication info is loaded or saved
    --token               Token to use to invoke on Keycloak.  Other credential may be ignored if this flag is set.
    --truststore PATH     Path to a truststore containing trusted certificates
    --trustpass PASSWORD  Truststore password (prompted for if not specified, --truststore is used, and the KC_CLI_TRUSTSTORE_PASSWORD env property is not defined)
    CREDENTIALS OPTIONS   Same set of options as accepted by 'kcadm.sh config credentials' in order to establish
                          an authenticated sessions. In combination with --no-config option this allows transient
                          (on-the-fly) authentication to be performed which leaves no tokens in config file.

    ENDPOINT_URI              URI used to compose a target resource url. Commonly used values are:
                              realms, users, roles, groups, clients, keys, serverinfo, components ...
                              If it starts with 'http://' then it will be used as target resource url
    -r, --target-realm REALM  Target realm to issue requests against if not the one authenticated against
    -s, --set NAME=VALUE      Set a specific attribute NAME to a specified value VALUE
    -d, --delete NAME         Remove a specific attribute NAME from JSON request body
    -f, --file FILENAME       Read object from file or standard input if FILENAME is set to '-'
    -b, --body CONTENT        Content to be sent as-is or used as a JSON object template
    -q, --query NAME=VALUE    Add to request URI a NAME query parameter with value VALUE, for example --query q=username:admin
    -h, --header NAME=VALUE   Set request header NAME to VALUE

    -H, --print-headers       Print response headers
    -o, --output              After creation output the new resource to standard output
    -i, --id                  After creation only print id of the new resource to standard output
    -F, --fields FILTER       A filter pattern to specify which fields of a JSON response to output
                              Use 'kcadm.sh get --help' for more info on FILTER syntax.
    -c, --compressed          Don't pretty print the output
    -a, --admin-root URL      URL of Admin REST endpoint root if not default - e.g. http://localhost:8080/admin


Nested attributes are supported by using '.' to separate components of a KEY. Optionally, the KEY components 
can be quoted with double quotes - e.g. my_client.attributes."external.user.id". If VALUE starts with [ and 
ends with ] the attribute will be set as a JSON array. If VALUE starts with { and ends with } the attribute 
will be set as a JSON object. If KEY ends with an array index - e.g. clients[3]=VALUE - then the specified item
of the array is updated. If KEY+=VALUE syntax is used, then KEY is assumed to be an array, and another item is
added to it.

Attributes can also be deleted. If KEY ends with an array index, then the targeted item of an array is removed
and the following items are shifted.


Examples:

Create a new realm:
  $ kcadm.sh create realms -s realm=demorealm -s enabled=true

Create a new realm role in realm 'demorealm' returning newly created role:
  $ kcadm.sh create roles -r demorealm -s name=manage-all -o

Create a new user in realm 'demorealm' returning only 'id', and 'username' attributes:
  $ kcadm.sh create users -r demorealm -s username=testuser -s enabled=true -o --fields id,username

Create a new client using configuration read from standard input:
  $ kcadm.sh create clients -r demorealm  -f - << EOF
  {
    "clientId": "my_client"
  }
  EOF

Create a new group using configuration JSON passed as 'body' argument:
  $ kcadm.sh create groups -r demorealm -b '{ "name": "Admins" }'

Create a client using file as a template, and override some attributes - return an 'id' of new client:
  $ kcadm.sh create clients -r demorealm -f my_client.json -s clientId=my_client2 -s 'redirectUris=["http://localhost:8980/myapp/*"]' -i

Create a new client role for client my_client in realm 'demorealm' (replace ID with output of previous example command):
  $ kcadm.sh create clients/ID/roles -r demorealm -s name=client_role


Use 'kcadm.sh help' for general information and a list of commands
```

for MAC users: In case you are using 

