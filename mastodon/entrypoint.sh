#!/bin/bash -x

id
export
pwd
rm -f /mastodon/tmp/pids/server.pid

export MASTODON_DIR=/mastodon/public/system
export VAPID_KEY="$MASTODON_DIR/vapid_key"
export DB_SETUP="$MASTODON_DIR/db_done"


which rails
chown -R mastodon:mastodon "$MASTODON_DIR"

#exec su mastodon /bin/bash - <<EOF
exec su mastodon <<EOF

export PATH="$PATH:/opt/ruby/bin:/opt/node/bin:/opt/mastodon/bin"

if [ ! -r "$VAPID_KEY" ]; then
	rails mastodon:webpush:generate_vapid_key > "$VAPID_KEY" \
	|| exit 1
fi

. "$VAPID_KEY"

if [ ! -r "$DB_SETUP" ]; then
	rails db:setup \
	|| exit 1

	touch "$DB_SETUP"
fi

exec bundle exec rails s -p 6001
EOF


