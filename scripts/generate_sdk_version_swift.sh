#!/usr/bin/env bash

set -euo pipefail
BASEDIR=$(dirname "$0")
PROJECT_ROOT="${BASEDIR}/.."
VERSION_FILE_PATH="${PROJECT_ROOT}/Sources/MapboxSearch/PublicAPI/MapboxSearchVersion.swift"

LATEST_GIT_TAG=$(make -C "${PROJECT_ROOT}" git-version)
STRING_VERSION="${LATEST_GIT_TAG#v}"
set +e
if grep "\"$STRING_VERSION\"" "$VERSION_FILE_PATH" &>/dev/null; then
    echo "Version variable is already set"
else
    echo "Outdated version variable. Updating…"
        cat > "${VERSION_FILE_PATH}" << EOF
/// Mapbox Search SDK version variable
public let mapboxSearchSDKVersion = "${STRING_VERSION}"
EOF
fi
set -e
