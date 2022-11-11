MODULES += nginx
MODULES += keycloak
MODULES += hedgedoc
MODULES += grafana
MODULES += prometheus
MODULES += mastodon
MODULES += matrix
#MODULES += pixelfed

include env.production
domain_name := $(DOMAIN_NAME)


help:
	@echo "usage: make run"
UC = $(shell echo '$1' | tr '[:lower:]' '[:upper:]')

DOCKER = \
	$(foreach m,$(MODULES),. data/$m/secrets && ) \
	docker-compose \
		--env-file env.production \
		$(foreach m,$(MODULES),--file ./$m.yaml) \

run:
	$(DOCKER) up
down:
	$(DOCKER) down
nginx-shell:
	$(DOCKER) exec nginx sh
grafana-shell:
	$(DOCKER) exec grafana bash
hedgedoc-shell:
	$(DOCKER) exec hedgedoc sh
keycloak-shell:
	$(DOCKER) exec keycloak sh
mastodon-shell:
	$(DOCKER) exec mastodon bash
mastodon-streaming-shell:
	$(DOCKER) exec mastodon-streaming bash
matrix-shell:
	$(DOCKER) exec matrix-synapse bash
matrix-logs:
	$(DOCKER) logs -f matrix-synapse
nginx-build: data/nginx/secrets
	$(DOCKER) build nginx

certdir		= ./data/certbot/conf/live/${DOMAIN_NAME}

run: secrets-setup

secrets-setup: $(foreach m,$(MODULES),data/$m/secrets)

# Create the per-subdomain secrets if they don't exist
# not every service requires all of these features, but create them anyway
GET_MODULE = $(call UC,$(word 2,$(subst /, ,$@)))
RAND = $$(openssl rand -hex $1)

data/%/secrets:
	mkdir -p $(dir $@)
	echo >$@ "# DO NOT CHECK IN"
	echo >>$@ "export $(GET_MODULE)_ADMIN_PASSWORD=$(call RAND,8)"
	echo >>$@ "export $(GET_MODULE)_CLIENT_SECRET=$(call RAND,20)"
	echo >>$@ "export $(GET_MODULE)_SESSION_SECRET=$(call RAND,20)"

keycloak-setup: secrets-setup
	$(DOCKER) run keycloak-setup

certbot:
	$(DOCKER) \
		run --entrypoint '/bin/sh -c "\
		rm -rf /etc/letsencrypt ; \
		certbot certonly \
			--webroot \
			--webroot-path /var/www/certbot \
			--email "admin@$(DOMAIN_NAME)" \
			--rsa-key-size "2048" \
			--agree-tos \
			--no-eff-email \
			--force-renewal \
			-d $(DOMAIN_NAME) \
			$(foreach m,$(MODULES),\
				-d $($(call UC,$m)_HOSTNAME).$(DOMAIN_NAME)) \
		"' certbot

nginx-reload:
	$(DOCKER) restart nginx


config:
	$(DOCKER) config

FORCE:
