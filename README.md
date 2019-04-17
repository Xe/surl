# surl

My custom URL shortener. I have it mounted at https://g.o/.

## Configuration

To use this:

| Environment Variable | Value                                                                                            |
| :------------------ | :------------- |
| `DATABASE_PATH`      | `/data/surl.db`                                                                                  |
| `DOMAIN`             | `g.o`                                                                                            |
| `PORT`               | `5000`                                                                                           |
| `THEME`              | `solarized.css` (or `gruvbox.css`, put themes [here](https://github.com/Xe/surl/tree/master/public/css)) |

```
docker volue create surl
docker run --name surl -dit -p 127.0.0.1:45273:5000 \
  -e DOMAIN=g.o -v surl:/data xena/surl:v0.3.0
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

## Customization

Build your CSS on top of this example CSS:

```css
main {
  font-family: Arial, Helvetica, sans-serif;
  max-width: 38rem;
  padding: 2rem;
  margin: auto;
}

body {
  background: #fdf6e3;
  color: #657b83;
}

// unclicked links
a { color: #b58900 }

// clicked links
a:visited { color: #586e75; }

@media (prefers-color-scheme: dark) {
  body {
    background: #002b36;
    color: #839496;
  }

  // clicked links
  a:visited { color: #93a1a1; }
}
```
