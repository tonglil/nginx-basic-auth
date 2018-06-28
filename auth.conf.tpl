server {
    listen ${LISTEN_PORT} default_server;

    location / {
        # basic auth
        auth_basic           "${AUTH_REALM}";
        auth_basic_user_file ${HTPASSWD_FILE};

        # proxy pass
        proxy_pass         ${FORWARD_PROTOCOL}://${FORWARD_HOST}:${FORWARD_PORT};
        proxy_read_timeout 900;
        
        # forward headers
        proxy_set_header Host ${ESCAPE_DOLLAR}host;
        proxy_set_header X-Real-IP ${ESCAPE_DOLLAR}remote_addr;
        proxy_set_header X-Forwarded-For ${ESCAPE_DOLLAR}proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto ${ESCAPE_DOLLAR}scheme;
    }
}
