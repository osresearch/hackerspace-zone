#!/bin/bash
# This is the custom startup script for the synpase server

# fix up the Element client config to have the correct hostname
# based on the environment variables
#export DOMAIN_NAME MATRIX_HOSTNAME
#envsubst < "element-config.json.template" > "$DATA/element-config.json"

HOMESERVER_YAML="/data/homeserver.yaml"

if [ ! -r "$HOMESERVER_YAML" ]; then
	echo >&2 "***** Configuring the home server for $DOMAIN_NAME *****"

	export SYNAPSE_SERVER_NAME="$DOMAIN_NAME"
	export SYNAPSE_REPORT_STATS="no"

	/start.py generate \
	|| exit 1

	echo >&2 "***** Adding OIDC provider *****"
	cat <<EOF >> "$HOMESERVER_YAML"
#
# added by hackerspace-zone setup scripts
#
suppress_key_server_warning: true
web_client_location: https://${MATRIX_HOSTNAME}.${DOMAIN_NAME}
public_baseurl: https://${MATRIX_HOSTNAME}.${DOMAIN_NAME}
oidc_providers:
  - idp_id: keycloak
    idp_name: "Keycloak"
    issuer: "https://${KEYCLOAK_HOSTNAME}.${DOMAIN_NAME}/realms/${REALM}"
    client_id: "matrix"
    client_secret: "${MATRIX_CLIENT_SECRET}"
    scopes: ["openid", "profile"]
    user_mapping_provider:
      config:
        localpart_template: "{{ user.preferred_username }}"
        display_name_template: "{{ user.name }}"
EOF

fi

if ! grep -q '^  smtp_host:' && [ -n "$SMTP_SERVER" ]; then
	echo >&2 "***** Adding SMTP setup to yaml"
	cat <<EOF >> "$HOMESERVER_YAML"
#
# added by hackerspace-zone setup scripts
#
email:
  smtp_host: ${SMTP_SERVER}
  smtp_port: ${SMTP_PORT}
  smtp_user: "${SMTP_USER}"
  smtp_pass: "${SMTP_PASSWORD}"
  require_transport_security: true
  notif_from: "%(app)s matrix homeserver <noreply@${DOMAIN_NAME}>"
  app_name: ${DOMAIN_NAME}
EOF
fi

# hack to let keycloak startup
sleep 5
exec /start.py
