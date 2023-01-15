#!/bin/sh

mkdir -p /data/nginx/cache

if [ -z "$DOMAIN_NAME" ]; then
	DOMAIN_NAME="example.com"
fi

certdir="/etc/letsencrypt/live/${DOMAIN_NAME}"

if [ -r "$certdir/fullchain.pem" ]; then
	exit 0
fi

mkdir -p "$certdir"

echo >&2 "$certdir: Creating temporary keys"
openssl req \
	-x509 \
	-newkey rsa:2048 \
	-keyout "$certdir/privkey.pem" \
	-out "$certdir/fullchain.pem" \
	-sha256 \
	-nodes \
	-days 365 \
	-subj "/CN=$DOMAIN_NAME'" \
|| exit 1

echo >&2 "$certdir: Generated temporary keys -- certbot needs to request real ones"
exit 0

