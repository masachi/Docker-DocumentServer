FROM ubuntu:16.04
LABEL maintainer Ascensio System SIA <support@onlyoffice.com>

ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive

RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d && \
    apt-get -y update && \
    apt-get -yq install wget apt-transport-https curl locales && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0x8320ca65cb2de8e5 && \
    locale-gen en_US.UTF-8 && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get -y update && \
    apt-get -yq install \
        adduser \
        bomstrip \
        htop \
        libasound2 \
        libboost-regex-dev \
        libcairo2 \
        libcurl3 \
        libgconf2-4 \
        libgtkglext1 \
        libnspr4 \
        libnss3 \
        libnss3-nssdb \
        libstdc++6 \
        libxml2 \
        libxss1 \
        libxtst6 \
        nano \
        net-tools \
        netcat \
        nginx-extras \
        nodejs \
        pwgen \
        rabbitmq-server \
        redis-server \
        software-properties-common \
        sudo \
        supervisor \
        xvfb \
        zlib1g && \
    
    rm -rf /var/lib/apt/lists/*

COPY config /app/onlyoffice/setup/config/
COPY run-document-server.sh /app/onlyoffice/run-document-server.sh

EXPOSE 80

ARG REPO_URL="deb http://download.onlyoffice.com/repo/debian squeeze main"
ARG PRODUCT_NAME=onlyoffice-documentserver

RUN echo "$REPO_URL" | tee /etc/apt/sources.list.d/onlyoffice.list && \
    apt-get -y update && \
    apt-get -yq install $PRODUCT_NAME && \
    chmod 755 /app/onlyoffice/*.sh && \
    rm -rf /var/log/onlyoffice && \
    rm -rf /var/lib/apt/lists/*

VOLUME /var/log/onlyoffice /var/lib/onlyoffice /var/www/onlyoffice/Data /usr/share/fonts/truetype/custom

ENTRYPOINT /app/onlyoffice/run-document-server.sh
