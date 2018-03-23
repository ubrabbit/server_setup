FROM debian:stretch

ENV DOVECOT_VERSION 2.3.0
RUN apt-get update --fix-missing && apt-get install -y git procps net-tools rsyslog supervisor vim

RUN cd /opt && git clone --depth=1 https://github.com/dovecot/core && cd /opt/core && git checkout -b release-${DOVECOT_VERSION} && \
    apt-get install -y wget autoconf automake libtool \
    pkg-config gettext pandoc make libicu-dev libssl-dev libgc-dev \
    libpam0g-dev libldap2-dev libcdb-dev libbz2-dev liblzma-dev liblz4-dev \
    libexpat-dev libz-dev libsolr-java locales mercurial python-setuptools ssmtp && \
    cd /opt/core && ./autogen.sh && \
    ./configure --enable-dependency-tracking --with-docs=no --with-nss --with-pam --with-ldap=yes --with-cdb --with-zlib --with-bzlib --with-lzma --with-lz4 --with-ssl=openssl --with-gc --with-storages=maildir --with-solr --with-icu && \
    make all && cd .. && git clone --depth=1 https://github.com/dovecot/pigeonhole && cd pigeonhole && ./autogen.sh && ./configure --with-dovecot=../core --with-ldap=no && make all && \
    cd .. && cd core && make install && cd ../pigeonhole && make install && mkdir -p /var/run/dovecot && useradd dovenull && useradd dovecot && \
    apt-get remove -y --purge libicu-dev libssl-dev libgc-dev libpam0g-dev libldap2-dev libcdb-dev libbz2-dev liblzma-dev liblz4-dev libexpat-dev libz-dev && \
    rm -rf /opt && apt-get clean && apt-get -y autoremove

ENV MAILBOX_PATH  /home/mailbox
RUN mkdir -p ${MAILBOX_PATH} && chown -R dovecot:dovecot ${MAILBOX_PATH}
VOLUME ${MAILBOX_PATH}

ENV CONFIG_CUSTOM_DOVECOT  /config/dovecot
RUN mkdir -p ${CONFIG_CUSTOM_DOVECOT} && chown -R dovecot:dovecot ${CONFIG_CUSTOM_DOVECOT}
VOLUME ${CONFIG_CUSTOM_DOVECOT}


ENV POST_VERSION 3.3.0
ENV DOWNLOAD_URL "ftp://ftp.cuhk.edu.hk/pub/packages/mail-server/postfix/official/postfix-${POST_VERSION}.tar.gz"

ENV POSTFIX_PROGRAM_DIR "/usr/local/postfix"
ENV POSTFIX_CMD_DIR "/usr/local/postfix"
ENV POSTFIX_SPOOL_DIR "/var/spool/postfix"
ENV POSTFIX_CONFIG_DIR "/etc/postfix"

COPY postfix/master.cf ${POSTFIX_CONFIG_DIR}/master.cf
RUN mkdir -p /opt && mkdir -p ${POSTFIX_PROGRAM_DIR} && mkdir -p ${POSTFIX_SPOOL_DIR} \
    && mkdir -p ${POSTFIX_CONFIG_DIR} \
    && addgroup --system --gid 91 postfix \
    && adduser --system --uid 90 --disabled-password \
            --no-create-home \
            --ingroup postfix --gecos postfix \
            postfix \
    && adduser postfix mail \
    && addgroup --system --gid 93 postdrop \
    && adduser --system --uid 92 --disabled-password --shell /sbin/nologin \
            --no-create-home --home /var/mail/domains \
            --ingroup postdrop --gecos vmail vmail \
    && adduser postfix dovecot \
    && adduser postfix postdrop \
    && adduser postfix postfix \
    && apt-get update --fix-missing \
    && buildDeps=" \
    libdb5.3-dev gcc make wget tar \
    libssl-dev libmariadbclient-dev libsqlite3-dev libsasl2-dev libmysql++-dev \
    " \
    && apt-get -y install ${buildDeps} && \
    cd /opt && wget ${DOWNLOAD_URL} && \
    tar xvf postfix-${POST_VERSION}.tar.gz && \
    cd /opt/postfix-${POST_VERSION} && \
    make -f Makefile.init makefiles \
    CCARGS=' \
    -DHAS_MYSQL -I/usr/include/mysql \
    -DHAS_SQLITE -I/usr/include \
    -DUSE_SASL_AUTH -DDEF_SASL_SERVER=\\\"dovecot\\\" \
    -DDEF_SERVER_SASL_TYPE=\"dovecot\" \
    -DDEF_CONFIG_DIR=\"${POSTFIX_CONFIG_DIR}\" \
    -DDEF_MAILQ_PATH=\"${POSTFIX_PROGRAM_DIR}/bin/mailq\" \
    -DDEF_DAEMON_DIR=\"${POSTFIX_PROGRAM_DIR}/libexec\" \
    -DDEF_MANPAGE_DIR=\"${POSTFIX_PROGRAM_DIR}/man\" \
    -DDEF_NEWALIAS_PATH=\"${POSTFIX_CMD_DIR}/bin/newaliases\" \
    -DDEF_COMMAND_DIR=\"${POSTFIX_CMD_DIR}/sbin\" \
    -DDEF_SENDMAIL_PATH=\"${POSTFIX_CMD_DIR}/sbin/sendmail\" \
    -DDEF_DATA_DIR=\"${POSTFIX_PROGRAM_DIR}/data\" \
    -DDEF_QUEUE_DIR=\"${POSTFIX_SPOOL_DIR}\" \
    -DHAS_SHL_LOAD -DUSE_TLS \
    -DUSE_CYRUS_SASL -I/usr/include/sasl \
    ' \
    AUXLIBS=' \
    -lssl -lcrypto -lsasl2 \
    -ldb \
    ' \
    AUXLIBS_MYSQL="$(mysql_config --libs) -lmysqlclient -lz -lm" \
    AUXLIBS_SQLITE="-lsqlite3 -lpthread" \
    && make \
    && DEBIAN_FRONTEND=noninteractive make upgrade \
    && rm -rf /opt \
    && apt-get -y install sasl2-bin opendkim opendkim-tools \
    && apt-get clean && apt-get purge -y --autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/*

ENV CONFIG_CUSTOM_POSTFIX  /config/postfix
RUN mkdir -p ${CONFIG_CUSTOM_POSTFIX} \
    && chown -R postfix:postfix ${CONFIG_CUSTOM_POSTFIX} \
    && chown -R postfix:postdrop ${POSTFIX_SPOOL_DIR} \
    && chmod g+s ${POSTFIX_CMD_DIR}/sbin/postdrop ${POSTFIX_CMD_DIR}/sbin/postqueue \
    && ${POSTFIX_CMD_DIR}/bin/newaliases

VOLUME ${CONFIG_CUSTOM_POSTFIX}
VOLUME ${POSTFIX_SPOOL_DIR}

COPY postfix/main.cf ${POSTFIX_CONFIG_DIR}/main.cf
COPY dovecot/dovecot.conf /usr/local/etc/dovecot/dovecot.conf
COPY dovecot/dict-default.conf /usr/local/etc/dovecot/dict-default.conf

COPY postfix/mysql ${POSTFIX_CONFIG_DIR}/mysql

ADD docker-config.sh /docker-config.sh
ADD docker-init.sh /docker-init.sh
RUN chmod 777 /docker-init.sh && mkdir -p /etc/supervisor/conf.d
COPY supervisord/supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisord/conf.d/dovecot.conf /etc/supervisor/conf.d/dovecot.conf
COPY supervisord/conf.d/postfix.conf /etc/supervisor/conf.d/postfix.conf

EXPOSE 110 143 995 993 25 465 10025
CMD ["/docker-init.sh"]
