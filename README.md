# NGINX Basic Auth Proxy Container

NGINX container pre-configured to act as a basic auth proxy.
Simple way to protect HTTP services that don't have any authentication when OAuth or anything similar is to much.

## Configuration

Supports the following environment variables for configuration (with defaults):

| Variable | Default | Description |
| --- | --- | --- |
| LISTEN_PORT | 80 | The port to bind to |
| AUTH_REALM | "Restricted" | The identification that will be provided via basic auth |
| HTPASSWD_FILE | "/etc/nginx/conf.d/auth.htpasswd" | Can be mounted into the container via Swarm Secret, Kubernetes Secret oder plain mount --bind |
| FORWARD_PROTOCOL | "http" |  |
| FORWARD_PORT | 8080 |  |
| FORWARD_HOST | "localhost" |  |

## Sample Configuration

Given the following configuration:

```
LISTEN_PORT=8888
AUTH_REALM=Restricted
HTPASSWD_FILE=/etc/nginx/conf.d/auth.htpasswd
FORWARD_PROTOCOL=http
FORWARD_PORT=88
FORWARD_HOST=localhost
```

Then NGINX will configured with `/etc/nginx/conf.d/auth.conf`:

```
server {
    listen 8888 default_server;

    location / {
        # basic auth
        auth_basic           "Restricted";
        auth_basic_user_file /etc/nginx/conf.d/auth.htpasswd;

        # proxy pass
        proxy_pass         http://localhost:88;
        proxy_read_timeout 900;

        # forward headers
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
