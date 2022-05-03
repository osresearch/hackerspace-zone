For initial setup;

* Setup auth credentials
```
sudo docker-compose exec keycloak \
  /opt/keycloak/bin/kcadm.sh \
  config credentials \
  --server http://localhost:8080/ \
  --user admin \
  --password admin \
  --realm master \

```

* Create a new realm for the `spacestation`:
```
sudo docker-compose exec keycloak \
  /opt/keycloak/bin/kcadm.sh \
  create realms \
  -s realm=spacestation \
  -s enabled=true \

```

# Fix up a id bug

* https://github.com/hedgedoc/hedgedoc/issues/56

```
sudo docker-compose exec -T keycloak \
  /opt/keycloak/bin/kcadm.sh \
  create client-scopes \
  -r spacestation \
  -f - <<EOF
 {
      "name": "id",
      "protocol": "openid-connect",
      "attributes": {
        "include.in.token.scope": "true",
        "display.on.consent.screen": "true"
      },
      "protocolMappers": [
        {
          "name": "id",
          "protocol": "openid-connect",
          "protocolMapper": "oidc-usermodel-property-mapper",
          "consentRequired": false,
          "config": {
            "user.attribute": "id",
            "id.token.claim": "true",
            "access.token.claim": "true",
            "jsonType.label": "String",
            "userinfo.token.claim": "true"
          }
        }
      ]
}
EOF

# Create a client in the realm with a provided shared secret and client scope

```
sudo docker-compose exec -T keycloak \
  /opt/keycloak/bin/kcadm.sh \
  create clients \
  -r spacestation \
  -f - <<EOF
{
	"clientId": "hedgedoc",
	"rootUrl": "http://spacestation:3000/",
	"adminUrl": "http://spacestation:3000/",
	"redirectUris": [ "http://spacestation:3000/*" ],
	"webOrigins": [ "http://spacestation:3000" ],
	"clientAuthenticatorType": "client-secret",
	"secret": "abcdef1234",
	"defaultClientScopes": [
		"web-origins",
		"acr",
		"profile",
		"roles",
		"id",
		"email"
	],
	"optionalClientScopes": [
		"address",
		"phone",
		"offline_access",
		"microprofile-jwt"
	]
}
EOF
```


* Create an admin user
```
kcadm.sh create users \
  -o \
  --fields id,username \
  -r spacestation \
  -s username=admin \
  -s enabled=true \
  -s 'credentials=[{"type":"password","value":"admin","temporary":false}]' \



sudo docker-compose exec keycloak \
  /opt/keycloak/bin/kcadm.sh \
  config credentials \
  --server http://localhost:8080/ \
  --user admin \
  --password admin \
  --realm master
```


```
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
