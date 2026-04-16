#!/usr/bin/env bash

set -euo pipefail

BASEDIR=$(dirname "$0")
PROJECT_ROOT="$(cd "${BASEDIR}/.." && pwd)"
PACKAGE_FILE="${PROJECT_ROOT}/Package.swift"
PROJECT_YML="${PROJECT_ROOT}/project.yml"

if [ ! -f "$PACKAGE_FILE" ]; then
  echo "$PACKAGE_FILE not found in current directory"
  exit 1
fi

extract_version() {
  local variable_name="$1"
  local version
  local pattern

  pattern='^let '"${variable_name}"'(: Version)? = "([^"]+)"$'
  version=$(sed -nE "s/${pattern}/\\2/p" "$PACKAGE_FILE")

  if [ -z "$version" ]; then
    echo "Failed to extract ${variable_name} from Package.swift" >&2
    exit 1
  fi

  printf '%s\n' "$version"
}

MAPBOX_COMMON_VERSION=$(extract_version "mapboxCommonSDKVersion")
if [ -z "$MAPBOX_COMMON_VERSION" ]; then
  echo "Failed to extract MapboxCommon version from Package.swift"
  exit 1
fi

echo "$PROJECT_YML"
sed -i '' -E "/MapboxCommon:/,/exactVersion:/s/exactVersion: \"[^\"]+\"/exactVersion: \"$MAPBOX_COMMON_VERSION\"/" "$PROJECT_YML"
echo "project.yml updated with MapboxCommon version $MAPBOX_COMMON_VERSION"

CORE_SEARCH_VERSION=$(extract_version "coreSearchVersion")
if [ -z "$CORE_SEARCH_VERSION" ]; then
  echo "Failed to extract CoreSearch version from Package.swift"
  exit 1
fi

if [[ "$CORE_SEARCH_VERSION" == *"-SNAPSHOT-"* ]]; then
  RELEASE_TYPE="snapshots"
else
  RELEASE_TYPE="releases"
fi

URL="https://api.mapbox.com/downloads/v2/search-core-sdk/${RELEASE_TYPE}/ios/packages/$CORE_SEARCH_VERSION/MapboxCoreSearch.xcframework.zip"

TARGET_DIR="$PROJECT_ROOT/libraries"
FRAMEWORK_NAME="MapboxCoreSearch.xcframework"
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"
curl -L --netrc -o "$TARGET_DIR/temp.zip" "$URL"
unzip -qq -o "$TARGET_DIR/temp.zip" -d "$TARGET_DIR"
rm "$TARGET_DIR/temp.zip"

echo "MapboxCoreSearch $CORE_SEARCH_VERSION is downloaded from ${RELEASE_TYPE}"
