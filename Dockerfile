FROM dockette/jdk8:latest

RUN apk add --no-cache wget bash; \
 wget -O /tmp/promtail.gz https://github.com/grafana/loki/releases/download/v0.3.0/promtail_linux_amd64.gz; \
 gzip -d /tmp/promtail.gz; cp /tmp/promtail /usr/local/bin/promtail; chmod 755 /usr/local/bin/promtail; rm /tmp/*;\
  mkdir /etc/promtail; mkdir /app; mkdir /app/log

COPY promtail.yml /etc/promtail/promtail.yml

COPY docker-entry.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/docker-entry.sh

ENTRYPOINT ["docker-entry.sh"]