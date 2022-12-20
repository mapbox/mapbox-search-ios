#!/usr/bin/env bash

set -euo pipefail

set +u
if [[ -z $VERSION ]];then
    exit 1
fi
set -u

# VERSION=${CIRCLE_TAG#v}
export GITHUB_TOKEN=$(mbx-ci github writer private token 2>/dev/null)

BRANCH_NAME="search-sdk/ios/${VERSION}"

git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/mapbox/api-downloads.git"
git -C api-downloads checkout -b "${BRANCH_NAME}"

#
# Add config file
#

scripts/update_registry_yaml.py "api-downloads/config/search-sdk/${VERSION}.yaml"

pushd api-downloads
git config user.email "release-bot@mapbox.com"
git config user.name "Release SDK bot"

#
# Commit to branch
#
git add -A
git commit -m "[search-sdk] Release v${VERSION}"
git push --set-upstream origin "${BRANCH_NAME}" --force-with-lease

#
# Create PR
# Requires that GITHUB_TOKEN environment variable is set, which is done on line 12
#
TITLE="Update config for Search Core SDK @ ${VERSION}"
BODY="* Release new ${VERSION} of Search Core SDK"

echo ">>> Creating PR to mapbox/api-downloads"
gh pr create --title "${TITLE}" --body "${BODY}" --reviewer don1ck --draft
