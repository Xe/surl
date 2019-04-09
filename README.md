# surl

My custom URL shortener. I have it mounted at https://g.o/.

## Configuration

To use this:

| Environment Variable | Value           |
| :------------------- | :-------------- |
| `DATABASE_PATH`      | `/data/surl.db` |
| `DOMAIN`             | `g.o`           |
| `PORT`               | `5000`          |

```
docker volue create surl
docker run --name surl -dit -p 127.0.0.1:45273:5000 \
  -e DOMAIN=g.o -v surl:/data xena/surl:v0.1.5
```

## Serving

```
# /etc/caddy/Caddyfile

## Custom DNS domain
g.o:80 {
  tls off
  
  redir / https://g.o
}
g.o:443 {
  tls /srv/within/certs/g.o/cert.pem /srv/within/certs/g.o/key.pem
  
  proxy / http://127.0.0.1:45273
}

## Clearnet domain
some.clearnet.domain {
  tls some@email.address
  
  proxy / http://127.0.0.1:45273
}
```

## Releasing

```
nimble release
nimble docker
```
