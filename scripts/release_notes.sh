#!/usr/bin/env bash

set -euo pipefail

export GITHUB_TOKEN=$(mbx-ci github writer token 2>/dev/null)

# Get dependency versions (MapboxCommon, MapboxMobileEvents)
MAPBOX_COMMON_DEPENDENCY_VERSION="$(grep -o 'MapboxCommon.*' Cartfile | grep -o '\d.*')"
MAPBOX_MOBILE_EVENTS_DEPENDENCY_VERSION="$(grep -o "MapboxMobileEvents.*" Cartfile | grep -o "\d.*")"

git config user.email "release-bot@mapbox.com"
git config user.name "Release SDK bot"

CHANGELOG_NOTES=$(parse-changelog CHANGELOG.md "$VERSION")

gh api --silent -X POST "/repos/{owner}/{repo}/releases" -F tag_name="v${VERSION}" -F name="Release v${VERSION}" \
-f body="## Changelog:
${CHANGELOG_NOTES}

## Dependencies
**MapboxCommon**: \`${MAPBOX_COMMON_DEPENDENCY_VERSION//.0/.x}\`
**MapboxMobileEvents**: \`${MAPBOX_MOBILE_EVENTS_DEPENDENCY_VERSION//.0/.x}\`
"
