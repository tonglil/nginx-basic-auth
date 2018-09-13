# basic auth
auth_basic           "${AUTH_REALM}";
auth_basic_user_file ${HTPASSWD_FILE};
