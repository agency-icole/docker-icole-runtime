#!/bin/bash
set -e

if test -z "$DOCKER_NODE"; then export DOCKER_NODE="UNKNOWN"; fi
if test -z "$DOCKER_APP"; then export DOCKER_APP="UNKNOWN"; fi
if test -z "$LOKI"; then export LOKI="http://172.18.111.33:3100"; fi

envsubst </etc/promtail/promtail.yml >/etc/promtail/promtail-env.yml

/usr/local/bin/promtail -config.file=/etc/promtail/promtail-env.yml&
exec "$@"