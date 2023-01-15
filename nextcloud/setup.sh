#!/bin/bash -x

SERVER="apache2-foreground"
CANARY="/var/www/html/.installed"
if [ -r "$CANARY" ]; then
	exec "/entrypoint.sh" "$SERVER"
fi

echo >&2 "**** installing nextcloud"
NEXTCLOUD_UPDATE=1 bash /entrypoint.sh date || exit 1

echo >&2 "***** Setting up nextcloud for ${DOMAIN_NAME}"
occ() { su -p www-data -s /bin/sh -c "php /var/www/html/occ $*" ; }
#occ maintenance:install || exit 1

PROVIDER="$(cat <<EOF
{
	"custom_oidc": [
		{
			"name":		"keycloak",
			"title":	"Keycloak",
			"clientId":	"nextcloud",
			"clientSecret":	"$NEXTCLOUD_CLIENT_SECRET",
			"authorizeUrl":	"$AUTH_URL",
			"tokenUrl":	"$TOKEN_URL",
			"userInfoUrl":	"$USERINFO_URL",
			"logoutUrl":	"$LOGOUT_URL",
			"scope":	"openid",
			"groupsClaim":	"roles",
			"style":	"keycloak",
			"displayNameClaim": "",
			"defaultGroup":	""
		}
	]
}
EOF
)"

for app in calendar sociallogin; do
	if [ ! -r "$CANARY.$app" ]; then
		echo >&2 "installing app $app"
		occ app:install $app || exit 1
		touch "$CANARY.$app"
	fi
done

occ config:app:set sociallogin prevent_create_email_exists --value=1 || exit 1
occ config:app:set sociallogin update_profile_on_login --value=1 || exit 1
occ config:app:set sociallogin custom_providers --value=\'$PROVIDER\' || exit 1

touch "$CANARY"
exec "/entrypoint.sh" "$SERVER"
