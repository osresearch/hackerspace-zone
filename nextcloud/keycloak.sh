#!/bin/bash -x
# Setup the OAuth client connection

client-create nextcloud "$NEXTCLOUD_HOSTNAME.$DOMAIN_NAME" "$NEXTCLOUD_CLIENT_SECRET" </dev/null
