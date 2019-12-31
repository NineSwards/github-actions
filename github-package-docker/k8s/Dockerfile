FROM docker:stable

RUN apk add --update \
    bash \
    curl \
  && rm -rf /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]