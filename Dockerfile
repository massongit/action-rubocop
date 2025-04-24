FROM ruby:3.4.3-bookworm

RUN curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin \
    && gem install -N rubocop
COPY entrypoint.sh .

ENTRYPOINT ["/entrypoint.sh"]
