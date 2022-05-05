# gitea

OpenID setup doesn't work out of the box.  The open id provider must be configured:

* Authentication name: `keycloak`
* OAuth2 Provider: `OpenID Connect`
* Client key: `gitea`
* Client secret: (copy from `../data/gitea/env.secrets`)
* Discovery URL: https://login.hackerspace.zone/realms/hackerspace/.well-known/openid-configuration
