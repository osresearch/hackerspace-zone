#!/bin/bash

if [ -z "$SMTP_SERVER" ]; then
	exit 0
fi

echo >&2 "*** configuring email to use $SMTP_SERVER"
/opt/keycloak/bin/kcadm.sh update \
	"realms/$REALM" \
	-f - <<EOF || exit 1
{
  "resetPasswordAllowed": "true",
  "smtpServer" : {
    "auth" : "true",
    "starttls" : "true",
    "user" : "$SMTP_USER",
    "password" : "$SMTP_PASSWORD",
    "port" : "$SMTP_PORT",
    "host" : "$SMTP_SERVER",
    "from" : "keycloak@$DOMAIN_NAME",
    "fromDisplayName" : "Keycloak @ $DOMAIN_NAME",
    "ssl" : "false"
  }
}
EOF

exit 0
