#!/bin/bash -x
# Setup the OAuth client connection

client-create matrix "$MATRIX_HOSTNAME.$DOMAIN_NAME" "$MATRIX_CLIENT_SECRET" </dev/null
