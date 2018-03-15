FROM debian:stretch

ENV DOVECOT_VERSION 2.3.0
RUN apt-get update --fix-missing && apt-get install -y git procps net-tools rsyslog supervisor

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

ENV MAILBOX_PATH  /data/mailbox
RUN mkdir -p ${MAILBOX_PATH} && chown -R dovecot:dovecot ${MAILBOX_PATH}
VOLUME ${MAILBOX_PATH}

ENV CONFIG_PATH_DOVECOT  /config/dovecot
RUN mkdir -p ${CONFIG_PATH_DOVECOT} && chown -R dovecot:dovecot ${CONFIG_PATH_DOVECOT}
VOLUME ${CONFIG_PATH_DOVECOT}


ENV POST_VERSION 3.3.0
ENV DOWNLOAD_URL "ftp://ftp.cuhk.edu.hk/pub/packages/mail-server/postfix/official/postfix-${POST_VERSION}.tar.gz"

# auto install
ENV DEBIAN_FRONTEND noninteractive
ENV postfix_program_dir "/usr/local/postfix"
RUN mkdir -p /opt && mkdir -p /etc/postfix && mkdir -p ${postfix_program_dir}
COPY postfix/master.cf ${postfix_program_dir}/etc/master.cf
RUN apt-get update --fix-missing && apt-get -y install libdb5.3-dev gcc make wget tar libssl-dev && \
    groupadd postfix && groupadd postdrop && useradd postfix -g postfix -s /bin/false && \
    cd /opt && wget ${DOWNLOAD_URL} && \
    tar xvf postfix-${POST_VERSION}.tar.gz && \
    cd /opt/postfix-${POST_VERSION} && \
    make -f Makefile.init makefiles \
    CCARGS=' \
    -I/usr/include \
    -DUSE_SASL_AUTH \
    -DDEF_SERVER_SASL_TYPE=\"dovecot\" \
    -DDEF_CONFIG_DIR=\"${postfix_program_dir}/etc\" \
    -DDEF_MAILQ_PATH=\"${postfix_program_dir}/bin/mailq\" \
    -DDEF_NEWALIAS_PATH=\"${postfix_program_dir}/bin/newaliases\" \
    -DDEF_DAEMON_DIR=\"${postfix_program_dir}/libexec\" \
    -DDEF_MANPAGE_DIR=\"${postfix_program_dir}/man\" \
    -DDEF_COMMAND_DIR=\"${postfix_program_dir}/sbin\" \
    -DDEF_SENDMAIL_PATH=\"${postfix_program_dir}/sbin/sendmail\" \
    -DDEF_DATA_DIR=\"${postfix_program_dir}/data\" \
    -DDEF_QUEUE_DIR=\"${postfix_program_dir}/spool\" \
    -DUSE_TLS \
    ' \
    AUXLIBS=' \
    -L/usr/lib \
    -ldb \
    -lssl -lcrypto \
    ' && \
    DEBIAN_FRONTEND=noninteractive make upgrade && \
    rm -rf /opt && \
    apt-get -y install sasl2-bin opendkim opendkim-tools && \
    apt-get -y purge libssl-dev && \
    apt-get clean && apt -y autoremove

ENV CONFIG_PATH_POSTFIX  /config/postfix
RUN mkdir -p /opt && mkdir -p /etc/postfix && mkdir -p ${CONFIG_PATH_POSTFIX} && chown -R postfix:postfix ${CONFIG_PATH_POSTFIX}
VOLUME ${CONFIG_PATH_POSTFIX}
VOLUME /var/spool/postfix

COPY postfix/main.cf /etc/postfix/main.cf
COPY dovecot/dovecot.conf /usr/local/etc/dovecot/dovecot.conf
COPY dovecot/dict-default.conf /usr/local/etc/dovecot/dict-default.conf
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord/supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisord/conf.d/dovecot.conf /etc/supervisor/conf.d/dovecot.conf
COPY supervisord/conf.d/postfix.conf /etc/supervisor/conf.d/postfix.conf

EXPOSE 110 143 995 993 25 465
CMD ["supervisord","-n","-c","/etc/supervisor/supervisord.conf"]
