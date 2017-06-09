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
| HTPASSWD | `null` | inline htpasswd file entry, appended to configuration file specified by HTPASSWD_FILE |
| FORWARD_PROTOCOL | "http" |  |
| FORWARD_PORT | 8080 |  |
| FORWARD_HOST | "example.localhost" |  |

## Sample Configuration
Given the following configuration:

```
LISTEN_PORT=8080
AUTH_REALM=Restricted
HTPASSWD_FILE=/etc/nginx/conf.d/auth.htpasswd
HTPASSWD=someuser:$some/hash.
FORWARD_PROTOCOL=http
FORWARD_PORT=80
FORWARD_HOST=localhost
```

Then NGINX will be configured like this:
Contents of /etc/nginx/conf.d/auth.conf:
```
server {
    listen 8080 default_server;

    location / {
        # basic auth
        auth_basic           "Restricted";
        auth_basic_user_file /etc/nginx/conf.d/auth.htpasswd;

        # proxy pass
        proxy_pass         http://localhost:80;
        proxy_read_timeout 900;

        # forward headers
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```