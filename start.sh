#!/bin/sh

# print env
echo "# Configuration:"
echo "LISTEN_PORT=${LISTEN_PORT}"
echo "AUTH_REALM=${AUTH_REALM}"
echo "HTPASSWD_FILE=${HTPASSWD_FILE}"
echo "AUTH_CONF=${AUTH_CONF}"
echo "FORWARD_PROTOCOL=${FORWARD_PROTOCOL}"
echo "FORWARD_PORT=${FORWARD_PORT}"
echo "FORWARD_HOST=${FORWARD_HOST}"
echo ""

# process config for this container
export ESCAPE_DOLLAR='$'
envsubst < /etc/nginx/tpl/config.conf.tpl > /etc/nginx/conf.d/config.conf
envsubst < /etc/nginx/tpl/proxy.conf.tpl > /etc/nginx/proxy.conf
envsubst < /etc/nginx/tpl/basic.conf.tpl > /etc/nginx/basic.conf

# print config
echo "=== config.conf ==="
cat /etc/nginx/conf.d/config.conf
echo ""
echo "=== proxy.conf ==="
cat /etc/nginx/proxy.conf
echo ""
echo "=== basic.conf ==="
cat /etc/nginx/basic.conf
echo ""
echo "=== auth.conf ==="
cat "${AUTH_CONF}"
echo ""

# run nginx in foreground
nginx -g "daemon off;"
