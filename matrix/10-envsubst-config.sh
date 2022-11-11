#!/bin/sh

echo >&2 "**** Configuring for $DOMAIN_NAME"
envsubst < /app/config.sample.json > /app/config.json
head /app/config.json
