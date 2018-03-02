FROM nginx:1.13

RUN apt-get update && apt-get install -y procps net-tools
ADD nginx.conf /etc/nginx/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
