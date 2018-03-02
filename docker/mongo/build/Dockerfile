FROM debian:jessie-slim

RUN set -x && apt-get update && apt-get install -y --no-install-recommends openssl vim procps

FROM mongo:3.6

EXPOSE 27017
CMD ["mongod", "--bind_ip_all"]
