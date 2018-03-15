FROM debian:stretch

ENV VERSION 2.3.0

ENV PIGEONHOLE_VERSION 0.4.21

RUN apt update && apt install -y git procps net-tools rsyslog

RUN cd /opt && git clone --depth=1 https://github.com/dovecot/core && cd /opt/core && git checkout -b release-${VERSION} && \
    apt install -y wget autoconf automake libtool \
    pkg-config gettext pandoc make libicu-dev libssl-dev libgc-dev \
    libpam0g-dev libldap2-dev libcdb-dev libbz2-dev liblzma-dev liblz4-dev \
    libexpat-dev libz-dev libsolr-java locales mercurial python-setuptools ssmtp && \
    cd /opt/core && ./autogen.sh && \
    ./configure --enable-dependency-tracking --with-docs=no --with-nss --with-pam --with-ldap=yes --with-cdb --with-zlib --with-bzlib --with-lzma --with-lz4 --with-ssl=openssl --with-gc --with-storages=maildir --with-solr --with-icu && \
    make all && cd .. && git clone --depth=1 https://github.com/dovecot/pigeonhole && cd pigeonhole && ./autogen.sh && ./configure --with-dovecot=../core --with-ldap=no && make all && \
    cd .. && cd core && make install && cd ../pigeonhole && make install && mkdir -p /var/run/dovecot && useradd dovenull && useradd dovecot && \
    apt remove -y --purge libicu-dev libssl-dev libgc-dev libpam0g-dev libldap2-dev libcdb-dev libbz2-dev liblzma-dev liblz4-dev libexpat-dev libz-dev libsolr-java && \
    rm -rf /opt && apt clean && apt -y autoremove

ENV MAILBOX_PATH  /data/mailbox
RUN mkdir -p ${MAILBOX_PATH} && chown -R dovecot:dovecot ${MAILBOX_PATH}
VOLUME ${MAILBOX_PATH}

ENV CONFIG_PATH  /config/dovecot
RUN mkdir -p ${CONFIG_PATH} && chown -R dovecot:dovecot ${CONFIG_PATH}
VOLUME ${CONFIG_PATH}

COPY dovecot.conf /usr/local/etc/dovecot/dovecot.conf
COPY dict-default.conf /usr/local/etc/dovecot/dict-default.conf

EXPOSE 110 143 995 993
CMD ["/usr/local/sbin/dovecot","-F"]
