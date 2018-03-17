FROM mysql:8.0.4-rc

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends openssl vim procps net-tools supervisor \
    && apt-get clean \
    && apt-get -y autoremove

COPY my.cnf /etc/mysql/my.cnf
COPY init /mysql_init
RUN mkdir -p /var/log/mysql && chown -R mysql:mysql /var/log/mysql
COPY supervisord/supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 3306
CMD ["supervisord","-n","-c","/etc/supervisor/supervisord.conf"]
