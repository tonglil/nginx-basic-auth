FROM nginx:alpine

ENV LISTEN_PORT=80 \
    AUTH_REALM="Restricted" \
    HTPASSWD_FILE="/etc/nginx/conf.d/auth.htpasswd" \
    AUTH_CONF="/etc/nginx/auth.conf" \
    FORWARD_PROTOCOL="http" \
    FORWARD_PORT=8080 \
    FORWARD_HOST="localhost"

ADD start.sh /

RUN apk add --no-cache gettext \
    && rm /etc/nginx/conf.d/default.conf \
    && chmod +x /start.sh

RUN mkdir -p /etc/nginx/tpl

ADD config.conf.tpl proxy.conf.tpl basic.conf.tpl /etc/nginx/tpl/
ADD auth.conf /etc/nginx/
ADD auth.htpasswd.dist /etc/nginx/conf.d/auth.htpasswd

CMD ["/start.sh"]
