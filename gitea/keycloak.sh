#!/bin/bash -x
# Setup the gitea client connection

client-create gitea "$GITEA_HOSTNAME.$DOMAIN_NAME" "$GITEA_CLIENT_SECRET" </dev/null
