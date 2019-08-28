FROM harisekhon/ubuntu-java

RUN apt-get update; apt-get -y install wget; wget https://repos.influxdata.com/ubuntu/pool/stable/t/telegraf/telegraf_1.11.5-1_amd64.deb; \
    dpkg -i telegraf_1.11.5-1_amd64.deb; rm telegraf_1.11.5-1_amd64.deb
RUN wget -O /root/jolokia.jar http://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-jvm/1.6.2/jolokia-jvm-1.6.2-agent.jar
COPY telegraf.conf /etc/telegraf/

RUN apt-get -y install tzdata; ln -fs /usr/share/zoneinfo/Europe/Warsaw /etc/localtime;  dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get -y install gettext; \
 wget -O /tmp/promtail.gz https://github.com/grafana/loki/releases/download/v0.3.0/promtail_linux_amd64.gz; \
 gzip -d /tmp/promtail.gz; cp /tmp/promtail /usr/local/bin/promtail; chmod 755 /usr/local/bin/promtail; rm /tmp/*;\
  mkdir /etc/promtail; mkdir /app /app/log

COPY promtail.yml /etc/promtail/promtail.yml

COPY docker-entry.sh /usr/local/bin/
RUN chmod 775 /usr/local/bin/docker-entry.sh

ENTRYPOINT ["docker-entry.sh"]