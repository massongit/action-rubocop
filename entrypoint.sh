#!/bin/sh
version() {
  if [ -n "$1" ]; then
    echo "-v $1"
  fi
}

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# if 'latest' rubocop version selected
if [[ $INPUT_RUBOCOP_VERSION = "latest" ]]; then
  # if Gemfile.lock is here
  if [[ -f 'Gemfile.lock' ]]; then
    # grep for rubocop version
    RUBOCOP_GEMFILE_VERSION=`cat Gemfile.lock | grep -oP '^\s{4}rubocop\s\(\K.*(?=\))'`

    # if rubocop version found, then pass it to the gem install
    # left it empty otherwise, so no version will be passed
    if [[ -n "$RUBOCOP_GEMFILE_VERSION" ]]; then
      RUBOCOP_VERSION=$RUBOCOP_GEMFILE_VERSION
    fi
  fi
  else
    # set desired rubocop version
    RUBOCOP_VERSION=$INPUT_RUBOCOP_VERSION
fi

gem install -N rubocop $(version $RUBOCOP_VERSION)

# Traverse over list of rubocop extensions
for extension in $INPUT_RUBOCOP_EXTENSIONS; do
  # grep for name and version
  INPUT_RUBOCOP_EXTENSION_NAME=`echo $extension | grep -oP '^rubocop-\w*'`
  INPUT_RUBOCOP_EXTENSION_VERSION=`echo $extension | grep -oP '^rubocop-\w*:\K(.*)'`

  # if version is 'latest'
  if [[ $INPUT_RUBOCOP_EXTENSION_VERSION = "latest" ]]; then
    # if Gemfile.lock is here
    if [[ -f 'Gemfile.lock' ]]; then
      # grep for rubocop extension version
      RUBOCOP_EXTENSION_GEMFILE_VERSION=`cat Gemfile.lock | grep -oP "^\s{4}$INPUT_RUBOCOP_EXTENSION_NAME\s\(\K.*(?=\))"`

      # if rubocop extension version found, then pass it to the gem install
      # left it empty otherwise, so no version will be passed
      if [[ -n "$RUBOCOP_EXTENSION_GEMFILE_VERSION" ]]; then
        RUBOCOP_EXTENSION_VERSION=$RUBOCOP_EXTENSION_GEMFILE_VERSION
      fi
    fi
  else
    # set desired rubocop extension version
    RUBOCOP_EXTENSION_VERSION=$INPUT_RUBOCOP_EXTENSION_VERSION
  fi

  gem install -N $INPUT_RUBOCOP_EXTENSION_NAME $(version $RUBOCOP_EXTENSION_VERSION)
done

rubocop ${INPUT_RUBOCOP_FLAGS} \
  | reviewdog -f=rubocop \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
