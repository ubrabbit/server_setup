FROM redis:4.0
RUN set -x && apt-get update && apt-get install -y --no-install-recommends openssl vim procps net-tools

EXPOSE 6379
CMD ["redis-server"]
