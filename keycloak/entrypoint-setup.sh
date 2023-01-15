#!/bin/bash

export PATH=/opt/keycloak/bin:$PATH

# perform an authentication as admin so that all other scripts can
# use the cached credentials

kcadm.sh \
	config credentials \
	--server http://keycloak:8080/ \
	--user admin \
	--password "$KEYCLOAK_ADMIN_PASSWORD" \
	--realm master \
|| exit 1

for file in /keycloak-setup/* ; do
	echo >&2 "$file: running setup"
	$file || exit 1
done
