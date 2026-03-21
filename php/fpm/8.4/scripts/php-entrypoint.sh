#!/usr/bin/env sh
set -eu

EXTRA_DIR="${PHP_EXTRA_INI_DIR:-/php-extra-ini}"
TARGET_DIR="/usr/local/etc/php/conf.d"
SCRIPTS_DIR="${SCRIPTS_DIR:-/var/www/html/scripts}"

if [ -d "$EXTRA_DIR" ]; then
  echo "Loading custom PHP ini files from: $EXTRA_DIR"
  find "$EXTRA_DIR" -maxdepth 1 -type f -name '*.ini' | sort | while IFS= read -r file; do
    base="$(basename "$file")"
    cp "$file" "$TARGET_DIR/zz-custom-${base}"
  done
fi

# Run custom scripts recursively in lexical order if the directory exists.
if [ -d "$SCRIPTS_DIR" ]; then
  if [ -z "${SKIP_CHMOD:-}" ]; then
    chmod -Rf 750 "$SCRIPTS_DIR"
    sync
  fi

  find "$SCRIPTS_DIR" -mindepth 1 -type f | sort | while IFS= read -r script; do
    echo "Running custom script: $script"
    "$script"
  done
else
  echo "Can't find script directory: $SCRIPTS_DIR"
fi

exec docker-php-entrypoint "$@"
