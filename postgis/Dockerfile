FROM kartoza/postgis:9.6-2.4
MAINTAINER Fabio Ferrari <fabio@particles.io>

RUN set -eux \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
    && apt-get install openssh-server passwd curl socat -y \
    && apt-get -y --purge autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY cc-entrypoint.sh /cc-entrypoint.sh
COPY cc-secrets.sh /cc-secrets.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 22 9999 5432