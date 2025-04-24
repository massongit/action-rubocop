FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl rubocop \
    && curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin \
    && rm -rf /var/lib/apt/lists
COPY entrypoint.sh .

ENTRYPOINT ["/entrypoint.sh"]
