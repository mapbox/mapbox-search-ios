#!/usr/bin/env bash

export GITHUB_TOKEN=$(mbx-ci github writer token 2>/dev/null)
BRANCH_NAME="search-sdk/ios/${VERSION}"

git clone https://x-access-token:${GITHUB_TOKEN}@github.com/mapbox/ios-sdk.git --branch ${BRANCH_NAME} --depth=1
pushd ios-sdk

# git checkout -b "${BRANCH_NAME}"
# echo "$(jq ".VERSION_IOS_SEARCH_SDK = \"$VERSION\"" src/constants.json)" > src/constants.json
# echo "$(jq ". + [\"${VERSION}\"]" src/data/ios-search-sdk-versions.json)" > src/data/ios-search-sdk-versions.json
# git config user.email "release-bot@mapbox.com"
# git config user.name "Release SDK bot"

# git add src/constants.json src/data/ios-search-sdk-versions.json

# git commit -m "Add Search SDK for iOS ${VERSION} release"
# git push --set-upstream origin "${BRANCH_NAME}" --force-with-lease



TITLE="Search SDK for iOS: Update documentation @ ${VERSION}"
BODY="* Release ${VERSION} documentation — Search SDK for iOS"

echo ">>> Creating PR to mapbox/ios-sdk"
gh pr create --title "${TITLE}" --body "${BODY}" --reviewer don1ck --draft
popd
