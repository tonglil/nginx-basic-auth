server {
    listen ${LISTEN_PORT} default_server;

    include ${AUTH_CONF};
}
