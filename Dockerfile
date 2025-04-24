FROM ruby:3.4.3-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin \
    && gem install -N rubocop \
    && apt-get remove -y ca-certificates curl \
    && rm -rf /var/lib/apt/lists
COPY entrypoint.sh .

ENTRYPOINT ["/entrypoint.sh"]
