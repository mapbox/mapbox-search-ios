#!/usr/bin/env bash

set -euo pipefail

export GITHUB_TOKEN=$(mbx-ci github writer token 2>/dev/null)

[ -d "search-ios" ] && rm -rf search-ios

git clone https://x-access-token:${GITHUB_TOKEN}@github.com/mapbox/search-ios.git


{
    sed '/MapboxCoreSearch/d' Cartfile
    echo -n 'binary "https://api.mapbox.com/downloads/v2/carthage/search-sdk/MapboxSearch.json"'
    echo " == ${VERSION}"
    echo -n 'binary "https://api.mapbox.com/downloads/v2/carthage/search-sdk/MapboxSearchUI.json"'
    echo " == ${VERSION}"
} > search-ios/Cartfile

cd search-ios || exit 1

curl -OJ --fail "https://api.mapbox.com/downloads/v2/search-sdk/releases/ios/packages/${VERSION}/MapboxSearch.zip" --netrc
curl -OJ --fail "https://api.mapbox.com/downloads/v2/search-sdk/releases/ios/packages/${VERSION}/MapboxSearchUI.zip" --netrc

# Update MapboxSearch and MapboxSearchUI versions in Package.swift
sed -i '' "s/\(version.*=\).*/\1 \"${VERSION}\"/g" Package.swift
sed -i '' "s/\(searchVersionHash.*=\).*/\1 \"$(swift package compute-checksum MapboxSearch.zip)\"/g" Package.swift
sed -i '' "s/\(searchUIVersionHash.*=\).*/\1 \"$(swift package compute-checksum MapboxSearchUI.zip)\"/g" Package.swift

# Update dependency versions (MapboxCommon, MapboxMobileEvents)
MAPBOX_COMMON_DEPENDENCY_VERSION="$(grep -o 'MapboxCommon.*' Cartfile | grep -o '\d.*')"
MAPBOX_MOBILE_EVENTS_DEPENDENCY_VERSION="$(grep -o "MapboxMobileEvents.*" Cartfile | grep -o "\d.*")"

sed -i '' "s/\(mapboxCommonVersion.*=\).*/\1 \"${MAPBOX_COMMON_DEPENDENCY_VERSION}\"/g" Package.swift
sed -i '' "s/\(mapboxMobileEventsVersion.*=\).*/\1 \"${MAPBOX_MOBILE_EVENTS_DEPENDENCY_VERSION}\"/g" Package.swift


git config user.email "release-bot@mapbox.com"
git config user.name "Release SDK bot"

git add Cartfile Package.swift
git commit -m "Release ${VERSION} version"
git tag "v${VERSION}" HEAD
git push # Push main branch
git push --tags # Push tags

CHANGELOG_NOTES=$(parse-changelog ../CHANGELOG.md "$VERSION")
gh api --silent -X POST "/repos/{owner}/{repo}/releases" -F tag_name="v${VERSION}" -F name="Release v${VERSION}" \
-f body="## Changelog:
${CHANGELOG_NOTES}

## Dependencies
**MapboxCommon**: \`${MAPBOX_COMMON_DEPENDENCY_VERSION//.0/.x}\`
**MapboxMobileEvents**: \`${MAPBOX_MOBILE_EVENTS_DEPENDENCY_VERSION//.0/.x}\`
"
