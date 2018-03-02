FROM mysql:8.0.4-rc

RUN set -x && apt-get update && apt-get install -y --no-install-recommends openssl vim procps net-tools
COPY mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
RUN chown root:root /etc/mysql/mysql.conf.d/mysqld.cnf

EXPOSE 3306
CMD ["mysqld"]
