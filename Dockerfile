FROM ruby:2.5.7-alpine

RUN apk add --update --no-cache \
  bash \
  build-base \
  libxml2-dev \
  libxslt-dev \
  sqlite-dev \

WORKDIR /usr/src/app

COPY . ./

ENTRYPOINT ["/usr/src/app/bin/docker-entrypoint.sh"]

CMD ["bundle", "exec", "rake", "spec"]
