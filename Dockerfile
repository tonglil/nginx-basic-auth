FROM nginx:alpine
LABEL maintainer "admin@dhswt.de"

ENV LISTEN_PORT=80 \
	AUTH_REALM="Restricted" \
	HTPASSWD_FILE="/etc/nginx/conf.d/auth.htpasswd" \
	HTPASSWD="" \
	FORWARD_PROTOCOL="http" \
	FORWARD_PORT=8080 \
    FORWARD_HOST="example.localhost"

ADD start.sh /

RUN apk add --no-cache gettext \
&&	rm /etc/nginx/conf.d/default.conf \
&&  chmod +x /start.sh

ADD auth.conf auth.htpasswd /etc/nginx/conf.d/

CMD ["/start.sh"]
