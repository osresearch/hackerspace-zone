#!/bin/bash -x
# This is *container* setup for the OIDC stuff

export APP_NAME="${DOMAIN_NAME} Gitea"
OIDC_CANARY="/data/oidc.done"

if [ -r "$OIDC_CANARY" ]; then
	# based on https://github.com/go-gitea/gitea/blob/main/Dockerfile
	exec "/usr/bin/entrypoint" "/bin/s6-svscan"  "/etc/s6";
fi


# We have to do some setup, so start things and wait for the config
# file to appear so that we can edit it.
"/usr/bin/entrypoint" "/bin/s6-svscan"  "/etc/s6" &

echo >&2 "*** Sleeping for setup"
sleep 30

echo >&2 "*** Adding OIDC login for $DOMAIN_NAME"
su -s /bin/sh git <<EOF || exit 1
gitea admin auth add-oauth \
	--name "keycloak" \
	--provider "openidConnect" \
	--key "gitea" \
	--secret "${GITEA_CLIENT_SECRET}" \
	--auto-discover-url "https://${KEYCLOAK_HOSTNAME}.${DOMAIN_NAME}/realms/${REALM}/.well-known/openid-configuration" \
	--group-claim-name "groups" \
	--admin-group "admin" \

EOF

touch "${OIDC_CANARY}"

echo >&2 "*** Done, maybe it works?"
exit 0
