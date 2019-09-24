# NGINX Basic Auth Proxy Container

NGINX container pre-configured to act as a basic auth proxy.
Simple way to protect HTTP services that don't have any authentication when OAuth or anything similar is too much.

## Quickstart

1. Generate your own `HTPASSWD_FILE`:

    ```
    htpasswd auth.htpasswd username
    ```

1. Run the container with the file:

    ```
    docker run -it -v $(pwd)/auth.htpasswd:/etc/nginx/conf.d/auth.htpasswd tonglil/nginx-basic-auth
    ```

## Configuration

Supports the following environment variables for configuration (with defaults):

| Variable | Default | Description |
| --- | --- | --- |
| LISTEN_PORT | 80 | The port to bind to |
| AUTH_REALM | "Restricted" | The identification that will be provided via basic auth |
| HTPASSWD_FILE | "/etc/nginx/conf.d/auth.htpasswd" | Can be mounted into the container via Kubernetes Secret or plain mount --bind |
| AUTH_CONF | "/etc/nginx/auth.conf" | Can be mounted into the container via Kubernetes ConfigMap or plain mount --bind |
| FORWARD_PROTOCOL | "http" |  |
| FORWARD_PORT | 8080 |  |
| FORWARD_HOST | "localhost" |  |

The default `AUTH_CONF` file enables basic auth against all paths.
This option is an escape hatch more complex configurations.

Mount your own configuration to enable basic auth for specify paths using the `include` directive.
For example:

```
location /healthz {
    auth_basic off;
    include /etc/nginx/proxy.conf;
}

location / {
    include /etc/nginx/basic.conf;
    include /etc/nginx/proxy.conf;
}
```

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

Then NGINX will configured with the following.

`/etc/nginx/conf.d/config.conf`:

```
server {
    listen 8888 default_server;

    include /etc/nginx/auth.conf;
}
```

`/etc/nginx/auth.conf` (default `$AUTH_CONF`):

```
location / {
    include /etc/nginx/basic.conf;
    include /etc/nginx/proxy.conf;
}
```

`/etc/nginx/proxy.conf`:

```
# proxy pass
proxy_pass         http://localhost:88;
proxy_read_timeout 900;

# forward headers
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
```

`/etc/nginx/basic.conf`:

```
# basic auth
auth_basic           "Restricted";
auth_basic_user_file /etc/nginx/conf.d/auth.htpasswd;
```
