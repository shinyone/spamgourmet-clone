FROM perl:5.30.3-slim-threaded-buster
COPY scripts sg-server-config.sh /
COPY scripts/* /scripts/
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
ENV SCRIPT_BASE_DIR=/ 
RUN bash -vx /scripts/install-certs.sh
RUN bash -vx /scripts/config-certs-provisioning.sh
RUN bash -vx /scripts/install-sg-mariadb.sh
RUN bash -vx /scripts/install-sg-exim.sh
RUN bash -vx /scripts/install-spamgourmet.sh
