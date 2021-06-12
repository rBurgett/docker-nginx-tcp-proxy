# docker-nginx-tcp-proxy
docker-nginx-tcp-proxy

## Build Image
```bash
docker build -t [image name] --build-arg version=[nginx version] .
```

## Run Image
```bash
docker run -d \
-p 80:80 \
-p 443:443 \
-v [host sites-enabled path]:/etc/nginx/sites-enabled \
-v [host streams-enabled path]:/etc/nginx/streams-enabled \
--name [instance name] \
[image name]
```

## Test NGINX configuration
```bash
docker exec [container name] nginx -t
```

## Reload NGINX configuration
```bash
docker exec [container name] nginx -s reload
```
