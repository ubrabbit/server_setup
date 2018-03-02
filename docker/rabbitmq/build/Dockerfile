FROM rabbitmq:3.7-rc-management

RUN set -eux && apt-get update && apt-get install -y --no-install-recommends openssl vim procps net-tools
ADD docker-init.sh /docker-init.sh

EXPOSE 4369 5671 5672 15671 15672 25672
CMD ["/docker-init.sh"]
