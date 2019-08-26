FROM dockette/jdk8:latest

RUN apk update; apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing telegraf; apk add wget; \
wget -O /root/jolokia.jar http://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-jvm/1.6.2/jolokia-jvm-1.6.2-agent.jar
COPY telegraf.conf /etc/telegraf/

RUN apk add tzdata; cp /usr/share/zoneinfo/Europe/Warsaw /etc/localtime; echo "Europe/Warsaw" >  /etc/timezone; date; apk del tzdata

RUN wget -O /tmp/netty.jar http://repo1.maven.org/maven2/io/netty/netty-all/4.1.18.Final/netty-all-4.1.18.Final.jar; unzip /tmp/netty.jar -d /tmp; \
        mkdir /app; mkdir /app/META-INF; mkdir /app/META-INF/native; cp /tmp/META-INF/native/* /app/META-INF/native; rm -rf /tmp/*

RUN apk add --no-cache wget bash gettext; \
 wget -O /tmp/promtail.gz https://github.com/grafana/loki/releases/download/v0.3.0/promtail_linux_amd64.gz; \
 gzip -d /tmp/promtail.gz; cp /tmp/promtail /usr/local/bin/promtail; chmod 755 /usr/local/bin/promtail; rm /tmp/*;\
  mkdir /etc/promtail; mkdir /app/log

COPY promtail.yml /etc/promtail/promtail.yml

COPY docker-entry.sh /usr/local/bin/
RUN chmod 775 /usr/local/bin/docker-entry.sh

ENTRYPOINT ["docker-entry.sh"]