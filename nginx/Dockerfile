FROM alpine
RUN apk update
RUN echo "building" \
    && apk add \
	nginx \
	collectd \
	collectd-nginx \
	nginx-mod-http-vts \
	gettext \
	curl \
	openssl \
    && mkdir -p \
	/etc/nginx/modules-enabled \
	/etc/nginx/conf.d \
	/docker-entrypoint.d \
    && ln -sf /etc/nginx/modules/10_http_vts.conf /etc/nginx/modules-enabled \
# forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && echo "Done"

COPY ["docker-entrypoint.d/*", "/docker-entrypoint.d/" ]
COPY ["docker-entrypoint.sh", "/" ]

ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 80
STOPSIGNAL SIGQUIT
CMD ["nginx", "-g", "daemon off;"]


