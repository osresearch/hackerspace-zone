#!/bin/sh -x
touch /started

#cat >> /etc/collectd/collectd.conf <<EOF
cat /etc/collectd/collectd.conf - > /tmp/conf <<EOF
LoadPlugin nginx
<Plugin "nginx">
    URL "http://localhost:80/nginx_status"
</Plugin>
EOF

#collectd
