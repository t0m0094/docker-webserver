# Webserver
A simple docker container for hosting websites using apache and php, when used in a production environment a proxy is advised.

## Supported tags and respective `Dockerfile` links:
-	[`alpine3.16-php8-v1.2`, `php8-latest`](url)
-	[`alpine3.15-php7-v1.2`, `php7-latest`](url)

## Volumes:

### `/var/www/html`

This is the document root of apache

## Environment Variables:

### `APACHE_UID`

Default: `82`

This is the default www-data UID

## Expose:

### 80/tcp - HTTP

## TODO

This list is empty for now, please [add your suggestions](https://github.com/t0m0094/docker-webserver/issues).