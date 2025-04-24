#!/usr/bin/env bash

git config --global --add safe.directory /app
rubocop \
  --require ./rdjson_formatter/rdjson_formatter.rb \
  --format RdjsonFormatter \
  --fail-level error test/only_changed/few_relevant/files/ | reviewdog -f=rdjson -reporter=github-pr-review -level=warning -guess
