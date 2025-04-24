#!/usr/bin/env bash

rubocop \
  --require ./rdjson_formatter/rdjson_formatter.rb \
  --format RdjsonFormatter \
  --fail-level error  | reviewdog -f=rdjson -reporter=github-pr-review -level=warning -guess
