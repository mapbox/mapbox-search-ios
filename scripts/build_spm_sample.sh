#!/usr/bin/env bash
set -euo pipefail

BASEDIR=$(dirname "$0")

# SAMPLE_ROOT_PATH=$(mktemp -d -t "SearchSPMSample.Products")
SAMPLE_ROOT_PATH="${BASEDIR}/../spm-sample-build"
trap 'rm -rf ${SAMPLE_ROOT_PATH}' INT TERM HUP EXIT # Remove folder on exit or error
mkdir -p "${SAMPLE_ROOT_PATH}"

pushd "${SAMPLE_ROOT_PATH}" > /dev/null

cat > project.yml <<EOF
name: CircleCIApp
options:
  bundleIdPrefix: com.mapbox.search.test
settings:
  DEVELOPMENT_TEAM: GJZR2MEM28
packages:
  MapboxSearchUI:
    path: ../
targets:
  CircleCIApp:
    type: application
    platform: iOS
    deploymentTarget: 12.0
    info:
      path: App.plist
    dependencies:
      - package: MapboxSearchUI
    sources: [main.swift]
EOF

cat > main.swift << EOF
import MapboxSearch
import MapboxSearchUI
EOF

BASEDIR="${BASEDIR}" xcodegen
xcodebuild -resolvePackageDependencies -derivedDataPath derivedData -scheme CircleCIApp
xcodebuild -scheme "CircleCIApp" -destination 'platform=iOS Simulator,name=iPhone 14,OS=16.1' -derivedDataPath derivedData/ -project CircleCIApp.xcodeproj CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO

popd

rm -rf ${SAMPLE_ROOT_PATH}