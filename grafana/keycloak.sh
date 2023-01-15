#!/bin/bash -x
# Setup the grafana client connection

client-create grafana "$GRAFANA_HOSTNAME.$DOMAIN_NAME" "$GRAFANA_CLIENT_SECRET" </dev/null
