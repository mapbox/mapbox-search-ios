#!/usr/bin/env bash
set -euo pipefail

AUTHOR="Mapbox"
AUTHOR_URL="https://mapbox.com"
COPYRIGHT_TEXT="Copyright © 2020 - $(date '+%Y') Mapbox, Inc. You may use this code with your Mapbox account and under the Mapbox Terms of Service (available at: https://www.mapbox.com/legal/tos). All other rights reserved."
JAZZY_THEME="jazzy-theme"
[[ -d jazzy-theme ]] || git clone git@github.com:mapbox/jazzy-theme.git

bundle exec jazzy \
  --clean \
  --author "${AUTHOR}" \
  --author_url "${AUTHOR_URL}" \
  --copyright "${COPYRIGHT_TEXT}" \
  --theme "${JAZZY_THEME}" \
  --module-version "${VERSION}" \
  --build-tool-arguments -scheme,MapboxSearch,-project,MapboxSearchFramework.xcodeproj \
  --module MapboxSearch \
  --output docs/MapboxSearch

bundle exec jazzy \
  --clean \
  --author "${AUTHOR}" \
  --author_url "${AUTHOR_URL}" \
  --copyright "${COPYRIGHT_TEXT}" \
  --theme "${JAZZY_THEME}" \
  --module-version "${VERSION}" \
  --build-tool-arguments -scheme,MapboxSearchUI,-project,MapboxSearchFramework.xcodeproj \
  --module MapboxSearchUI \
  --output docs/MapboxSearchUI

rm -rf jazzy-theme