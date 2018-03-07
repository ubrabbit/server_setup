FROM rabbitmq:3.7-rc-management

RUN echo "deb http://mirrors.aliyun.com/debian stretch main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian stretch main contrib non-free" >> /etc/apt/sources.list  && \
    echo "deb http://mirrors.aliyun.com/debian stretch-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian stretch-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
    set -eux && apt-get update && apt-get install -y --no-install-recommends openssl vim procps net-tools && \
    apt clean && apt autoremove

ADD docker-init.sh /docker-init.sh

EXPOSE 4369 5671 5672 15671 15672 25672
CMD ["/docker-init.sh"]
