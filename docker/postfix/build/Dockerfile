FROM debian:stretch

RUN echo "deb http://mirrors.aliyun.com/debian stretch main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian stretch main contrib non-free" >> /etc/apt/sources.list  && \
    echo "deb http://mirrors.aliyun.com/debian stretch-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian stretch-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
    apt update --fix-missing && apt install -y git procps net-tools supervisor rsyslog

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

EXPOSE 25 465
CMD ["/usr/sbin/postfix","start"]
