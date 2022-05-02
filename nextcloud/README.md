Enable SSO:

```
( cd ../keycloak ; sudo docker-compose exec -T keycloak \
  /opt/keycloak/bin/kcadm.sh \
  create clients \
  --realm master --user admin --password admin \
  -r spacestation \
  -f - ) <<EOF
{
	"clientId": "nextcloud",
	"rootUrl": "http://spacestation:9000/",
	"adminUrl": "http://spacestation:9000/",
	"redirectUris": [ "http://spacestation:9000/*" ],
	"webOrigins": [ "http://spacestation:9000" ],
	"clientAuthenticatorType": "client-secret",
	"secret": "nextcloud-secret"
}
EOF
```

and configure the social login app:

```
sudo docker-compose exec -u www-data -T nextcloud \
  ./occ app:install sociallogin \
&& sudo docker-compose exec -u www-data -T nextcloud \
  ./occ config:app:set sociallogin prevent_create_email_exists --value=1 \
&& sudo docker-compose exec -u www-data -T nextcloud \
  ./occ config:app:set sociallogin update_profile_on_login --value=1 \
&& sudo docker-compose exec -u www-data -T nextcloud \
  ./occ config:app:set \
  sociallogin custom_providers \
  --value='{"custom_oidc":[{"name":"keycloak","title":"Keycloak","authorizeUrl":"http://spacestation:8080/realms/spacestation/protocol/openid-connect/auth","tokenUrl":"http://spacestation:8080/realms/spacestation/protocol/openid-connect/token","displayNameClaim":"","userInfoUrl":"http://spacestation:8080/realms/spacestation/protocol/openid-connect/userinfo","logoutUrl":"","clientId":"nextcloud","clientSecret":"nextcloud-secret","scope":"openid","groupsClaim":"roles","style":"keycloak","defaultGroup":""}]}'
```
