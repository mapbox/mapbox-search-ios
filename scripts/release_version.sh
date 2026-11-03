#!/usr/bin/env bash
set -euo pipefail

BASEDIR=$(dirname "$0")

LATEST_GIT_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
MARKETING_VERSION=$(echo "${LATEST_GIT_TAG}" | perl -nle 'print $v if ($v)=/([0-9]+([.][0-9]+)+)/')

# Build framework binaries
echo "Framework version: ${MARKETING_VERSION}"
MARKETING_VERSION="${MARKETING_VERSION}" "${BASEDIR}"/build.sh

"${BASEDIR}/upload_to_bintray.sh" ${MARKETING_VERSION}
