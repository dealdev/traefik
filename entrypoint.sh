#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- traefik "$@"

fi

# if our command is a valid Traefik subcommand, let's invoke it through Traefik instead
# (this allows for "docker run traefik version", etc)
if traefik "$1" --help 2>&1 >/dev/null | grep "help requested" > /dev/null 2>&1; then
    set -- traefik "$@" 
fi

DOMAIN=$(echo "$DOMAIN" | sed 's/\//\\\//g')
ENDPOINT=$(echo "$ENDPOINT" | sed 's/\//\\\//g')
ACCESS_KEY=$(echo "$ACCESS_KEY" | sed 's/\//\\\//g')
SECRET_KEY=$(echo "$SECRET_KEY" | sed 's/\//\\\//g')

sed "s/_DOMAIN/${DOMAIN}/; s/_END_POINT/${ENDPOINT}/; s/_ACCESS_KEY/${ACCESS_KEY}/; s/_SECRET_KEY/${SECRET_KEY}/" /etc/traefik/traefik.tmpl > /etc/traefik/traefik.toml

exec "$@"