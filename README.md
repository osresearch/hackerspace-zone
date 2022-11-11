# hackerspace.zone

Infrastructure for the self-hosted, single-sign-on, community-run services.

* Set the domain name in `env.production`
* Create the DNS entries in the domain for `login`, `cloud`, `matrix`, `dashboard`, `docs` and maybe more.
* Install dependencies:

```
apt install jq docker-compose
apt install prometheus
```

* Setup each of the services. `keycloak` and `nginx` are required to start the others:

```
./keycloak/setup
./nginx/setup
./start-all
```
