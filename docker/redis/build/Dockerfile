FROM debian:jessie-slim

RUN set -x && apt-get update && apt-get install -y --no-install-recommends openssl vim procps

FROM redis:4.0

EXPOSE 6379
CMD ["redis-server"]
