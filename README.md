# hackerspace.zone

Infrastructure for the self-hosted, single-sign-on, community-run services.

* Set the domain name in `env.production`
* Create the DNS entries in the domain for `login`, `cloud`, `matrix`, `dashboard`, `docs` and maybe more.
* Install dependencies (note that `docker-compose 1.25` breaks environment variables as we use them):

```
apt install python3-pip prometheus
pip3 install docker-compose
```

* `make run` to startup all of the containers
* `make keycloak-setup` to setup all of the OIDC links
* `make down` to stop everything
