FROM alpine

RUN apk --update add \
      ca-certificates \
      curl \
      glib \
      libevent \
      libffi \
      libxml2 \
      libxslt \
      ncurses \
      openssl \
      readline \
      ruby \
      ruby-io-console \
      yaml \
      zlib \
    && rm -rf /var/cache/apk/*

# Install bundler
RUN echo "gem: --no-document" >> ~/.gemrc \
    && gem install bundler \
    && bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install dependencies
ADD Gemfile Gemfile.lock /usr/src/app/
ENV BUILD_PACKAGAGES="build-base ruby-dev" \
    RUNTIME_PACKAGES="ruby-rake"
RUN apk --update add $BUILD_PACKAGAGES $RUNTIME_PACKAGES \
    && bundle install --deployment \
    && apk del $BUILD_PACKAGAGES \
    && rm -rf /var/cache/apk/* \
    && find /usr/lib/ruby/gems/ -name '*.gem' -delete

# Add app
ADD . /usr/src/app

ENTRYPOINT [ "bundle", "exec", "./trello" ]