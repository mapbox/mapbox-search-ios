#!/usr/bin/env bash

# Get dependency versions (MapboxCommon, MapboxMobileEvents)
MAPBOX_COMMON_DEPENDENCY_VERSION="$(grep -o 'MapboxCommon.*' Cartfile | grep -o '\d.*')"
MAPBOX_MOBILE_EVENTS_DEPENDENCY_VERSION="$(grep -o "MapboxMobileEvents.*" Cartfile | grep -o "\d.*")"


CHANGELOG_NOTES=$(parse-changelog CHANGELOG.md "$VERSION")

# disabled auto release creation
# gh api --silent -X POST "/repos/{owner}/{repo}/releases" -F tag_name="v${VERSION}" -F name="Release v${VERSION}" \
# -f body=

echo "## Changelog:

${CHANGELOG_NOTES}

## Dependencies
**MapboxCommon**: \`${MAPBOX_COMMON_DEPENDENCY_VERSION//.0/.x}\`
**MapboxMobileEvents**: \`${MAPBOX_MOBILE_EVENTS_DEPENDENCY_VERSION//.0/.x}\`
"
