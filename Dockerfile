# Based off of https://github.com/docker-library/postgres/blob/master/9.4/Dockerfile
FROM debian:wheezy
MAINTAINER Heap Analytics https://heapanalytics.com

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r postgres && useradd -r -g postgres postgres

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get update \
    && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN mkdir /docker-entrypoint-initdb.d

# Install CitusDB 4.1
RUN curl -o /tmp/citus.deb -SL https://packages.citusdata.com/readline-6.0/citusdb-4.0.1-1.amd64.deb && \
    curl -o /tmp/citus-contrib.deb -SL https://packages.citusdata.com/contrib/citusdb-contrib-4.0.1-1.amd64.deb && \
    dpkg --install /tmp/citus.deb && \
    dpkg --install /tmp/citus-contrib.deb && \
    rm /tmp/citus*.deb

ENV PG_MAJOR 9.4
ENV CITUS_MAJOR 4.0

ENV PGUSER postgres
ENV PATH /opt/citusdb/$CITUS_MAJOR/bin:$PATH
ENV PGDATA /data
VOLUME /data
VOLUME /etc/citus

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
