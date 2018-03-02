FROM mongo:3.6
RUN set -x && apt-get update && apt-get install -y --no-install-recommends openssl vim procps net-tools

EXPOSE 27017
CMD ["mongod", "--bind_ip_all"]
