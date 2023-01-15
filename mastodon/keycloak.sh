#!/bin/bash -x

client-create mastodon "$MASTODON_HOSTNAME.$DOMAIN_NAME" "$MASTODON_CLIENT_SECRET" </dev/null
