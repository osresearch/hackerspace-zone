#!/bin/bash -x
# Setup the OAuth client connection

client-create mobilizon "$MOBILIZON_HOSTNAME.$DOMAIN_NAME" "$MOBILIZON_CLIENT_SECRET" </dev/null
