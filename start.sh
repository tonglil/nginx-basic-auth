#!/bin/sh

# print env
echo "# Configuration:"
echo "LISTEN_PORT=${LISTEN_PORT}"
echo "AUTH_REALM=${AUTH_REALM}"
echo "HTPASSWD_FILE=${HTPASSWD_FILE}"
echo "HTPASSWD=${HTPASSWD}"
echo "FORWARD_PROTOCOL=${FORWARD_PROTOCOL}"
echo "FORWARD_PORT=${FORWARD_PORT}"
echo "FORWARD_HOST=${FORWARD_HOST}"
echo ""

# process config for this container
export ESCAPE_DOLLAR='$'
envsubst < /etc/nginx/conf.d/auth.conf > /etc/nginx/conf.d/auth.conf

# print config
echo "# Running with NGINX auth.conf:"
cat /etc/nginx/conf.d/auth.conf
echo ""

# append optional contents of HTPASSWD variable to auth file
echo $HTPASSWD >> $HTPASSWD_FILE

# run nginx in foreground
nginx -g "daemon off;"
