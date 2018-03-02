FROM mysql:8.0.4-rc

COPY mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
RUN chown root:root /etc/mysql/mysql.conf.d/mysqld.cnf

FROM debian:stretch
RUN set -x && apt-get update && apt-get install -y --no-install-recommends openssl vim procps net-tools

EXPOSE 3306
CMD ["mysqld"]
