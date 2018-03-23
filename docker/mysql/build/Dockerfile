FROM mysql:8.0.4-rc

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends openssl vim procps net-tools \
    && apt-get clean \
    && apt-get -y autoremove

COPY my.cnf /etc/mysql/my.cnf
