#!/bin/bash -x
# Setup the hedgedoc client connection

# this might fail; we'll ignore it if we have already created it
# https://github.com/hedgedoc/hedgedoc/issues/56
kcadm.sh \
	create client-scopes \
	-r "$REALM" \
	-f - <<EOF || echo "whatever"
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

client-create hedgedoc "$HEDGEDOC_HOSTNAME.$DOMAIN_NAME" "$HEDGEDOC_CLIENT_SECRET" <<EOF
	,"defaultClientScopes": [
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
EOF
