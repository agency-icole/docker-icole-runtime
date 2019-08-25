FROM dockette/jdk8:latest

RUN apk add --no-cache wget; \
 wget -O /tmp/promtail.gz https://github.com/grafana/loki/releases/download/v0.3.0/promtail_linux_amd64.gz; \
 gzip -d /tmp/promtail.gz; cp /tmp/promtail /usr/local/bin/promtail; chmod 755 /usr/local/bin/promtail; rm /tmp/*; mkdir /etc/promtail

COPY promtail.yml /etc/promtail/promtail.yml

