#!/usr/bin/env bash
set -eo pipefail

# Exit if not git checkout
if [[ ! -d ".git/" ]]; then
    exit 0
fi

if [[ -z "${SCRIPT_INPUT_FILE_0}" ]]; then
    exit 1
fi

LATEST_GIT_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
FULL_VERSION=${LATEST_GIT_TAG#v}
MARKETING_VERSION=$(echo "${LATEST_GIT_TAG}" | perl -nle 'print $v if ($v)=/([0-9]+([.][0-9]+)+)/')

sed -i '' -e "s/^  s\.version *= .*$/  s\.version          = '${FULL_VERSION}'/" "${SCRIPT_INPUT_FILE_0}"

if [[ -f "${SCRIPT_INPUT_FILE_1}" ]]; then
    echo "File exists: ${SCRIPT_INPUT_FILE_1}"

    DEPENDENCY_MINOR_VERSION=$(echo "${MARKETING_VERSION}" | perl -nle 'print "$v.0" if ($v)=/([0-9]+([.][0-9]+))/')
    echo "Minor version: ${DEPENDENCY_MINOR_VERSION}"

    sed -i '' -e "s/\"~> .*\"$/\"~> ${DEPENDENCY_MINOR_VERSION}\"/" "${SCRIPT_INPUT_FILE_0}"
fi
