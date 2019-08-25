#!/bin/bash
set -e

/usr/local/bin/promtail -config.file=/etc/promtail/promtail.yml&
exec "$@"