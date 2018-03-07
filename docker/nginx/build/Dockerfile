FROM nginx:1.13

RUN echo "deb http://mirrors.aliyun.com/debian stretch main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian stretch main contrib non-free" >> /etc/apt/sources.list  && \
    echo "deb http://mirrors.aliyun.com/debian stretch-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian stretch-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.aliyun.com/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y procps net-tools

ADD nginx.conf /etc/nginx/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
