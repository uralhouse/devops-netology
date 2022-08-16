FROM centos:centos7

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

RUN yum makecache && \
    yum -y install wget \
    yum -y install perl-Digest-SHA

RUN \
  cd / && \
  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz && \
  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz.sha512 && \
  shasum -a 512 -c elasticsearch-7.17.0-linux-x86_64.tar.gz.sha512 && \
  tar -xzf elasticsearch-7.17.0-linux-x86_64.tar.gz && \
  rm -f *.tar.gz && \
  mv /elasticsearch-7.17.0 /elasticsearch

RUN mkdir /var/lib/logs /var/lib/data

COPY elasticsearch.yml /elasticsearch/config

RUN chmod -R 777 /elasticsearch && \
    chmod -R 777 /var/lib/logs && \
    chmod -R 777 /var/lib/data

USER elasticsearch

VOLUME /var/lib/data

EXPOSE 9200
EXPOSE 9300

WORKDIR /elasticsearch/bin/

ENTRYPOINT ./elasticsearch
