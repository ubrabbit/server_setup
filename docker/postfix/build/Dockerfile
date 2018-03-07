From ubuntu:trusty
MAINTAINER Elliott Ye

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update && apt-get -y install supervisor postfix sasl2-bin opendkim opendkim-tools && \
    apt clean && apt autoremove

# Add files
ADD assets/install.sh /opt/install.sh

# Run
CMD /opt/install.sh;/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
