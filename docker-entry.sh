#!/bin/bash
set -e

if test -z "$DEV_SERVER"; then export DEV_SERVER="192.168.56.1"; fi
if test -z "$DOCKER_NODE"; then export DOCKER_NODE="UNKNOWN"; fi
if test -z "$DOCKER_APP"; then export DOCKER_APP="UNKNOWN"; fi
if test -z "$LOKI"; then export LOKI="http://$DEV_SERVER:3100"; fi
if test -z "$INFLUXDB"; then export INFLUXDB="http://$DEV_SERVER:8086"; fi

export LD_LIBRARY_PATH=./lib/META-INF/native:$LD_LIBRARY_PATH

/usr/bin/telegraf&

envsubst </etc/promtail/promtail.yml >/etc/promtail/promtail-env.yml
/usr/local/bin/promtail -config.file=/etc/promtail/promtail-env.yml&

cd /app
exec "$@"