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

if test -z "$SPLUNK"; then export SPLUNK="$DEV_SERVER:9997"; fi

cd /opt/splunkforwarder/bin
./splunk start --accept-license --answer-yes --no-prompt --seed-passwd admin1234
./splunk add forward-server $SPLUNK -auth admin:admin1234
#./splunk enable local-index -name $DOCKER_APP -auth :admin1234
./splunk add monitor /app/log -index $DOCKER_APP -auth admin:admin1234

cd /app
exec "$@"