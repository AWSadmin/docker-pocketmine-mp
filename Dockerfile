FROM ubuntu:14.04

MAINTAINER AWSadmin https://github.com/AWSadmin

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y \
        wget \
        perl gcc g++ make automake libtool autoconf m4 \
        gcc-multilib php7.0

RUN adduser --gecos 'PocketMine-MP' --disabled-password --home /pocketmine pocketmine

WORKDIR /pocketmine
RUN mkdir /pocketmine/PocketMine-MP
RUN chown -R pocketmine:pocketmine /pocketmine

COPY assets/server.properties /pocketmine/server.properties.original
COPY assets/entrypoint.sh /pocketmine/entrypoint.sh

RUN chmod 755 /pocketmine/entrypoint.sh

USER pocketmine

ENV GNUPGHOME /pocketmine

RUN gpg --keyserver pgp.mit.edu --recv-key 2280B75B

ENV PHP_BINARY /pocketmine/PocketMine-MP/bin/php5/bin/php

RUN cd PocketMine-MP && wget -q -O - http://cdn.pocketmine.net/installer.sh | bash -s - -v beta

EXPOSE 19132
EXPOSE 19132/udp

ENTRYPOINT ["./entrypoint.sh"]
