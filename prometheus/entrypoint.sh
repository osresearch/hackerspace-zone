#!/bin/sh -x

chmod 777 /prometheus
exec su -s /bin/sh nobody <<EOF
exec /bin/prometheus \
	--config.file=/etc/prometheus/prometheus.yml \
	--web.console.libraries=/etc/prometheus/console_libraries \
	--web.console.templates=/etc/prometheus/consoles
EOF

# --storage.local.path=/prometheus \
