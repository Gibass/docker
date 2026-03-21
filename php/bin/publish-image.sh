#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-gibass/php}"
VERSION_TAG="${VERSION_TAG:-8.4}"
COMPOSE_FILE="${COMPOSE_FILE:-fpm/docker-compose.yml}"

VERSION_IMAGE="${IMAGE_NAME}:${VERSION_TAG}"
LATEST_IMAGE="${IMAGE_NAME}:latest"

docker compose -f "${COMPOSE_FILE}" build php
docker tag "${VERSION_IMAGE}" "${LATEST_IMAGE}"
docker push "${VERSION_IMAGE}"
docker push "${LATEST_IMAGE}"
