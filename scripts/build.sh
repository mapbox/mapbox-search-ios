#!/usr/bin/env bash

# Improvements:
# 1. Put xcarchives into unique tmp folder (mktemp)
# 2. Build only MapboxSearchUI. MapboxSearch will be built as a dependency

set -euo pipefail
BASEDIR=$(dirname "$0")
PROJECT_ROOT="${BASEDIR}/.."
RESULT_PRODUCTS_DIR="${PROJECT_ROOT}/Products"

INFO_PLIST_COMMIT_HASH_KEY="MBXCommitHash"
INFO_PLIST_BRANCH_KEY="MBXBranch"

rm -rf "${RESULT_PRODUCTS_DIR}"


BASEDIR=$(dirname "$0")

LATEST_GIT_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
MARKETING_VERSION=$(echo "${LATEST_GIT_TAG}" | perl -nle 'print $v if ($v)=/([0-9]+([.][0-9]+)+)/')
echo "Compiling frameworks, marketing version: ${MARKETING_VERSION}, git tag: ${LATEST_GIT_TAG}"

pushd "${PROJECT_ROOT}" > /dev/null

SIMULATOR_ARCHIVE_NAME="${RESULT_PRODUCTS_DIR}/Search-iphonesimulator.xcarchive"
DEVICE_ARCHIVE_NAME="${RESULT_PRODUCTS_DIR}/Search-iphoneos.xcarchive"

xcodebuild archive -scheme "MapboxSearchUI" -destination "generic/platform=iOS Simulator" SKIP_INSTALL=NO ${MARKETING_VERSION:+MARKETING_VERSION=${MARKETING_VERSION}} -archivePath "${SIMULATOR_ARCHIVE_NAME}" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
xcodebuild archive -scheme "MapboxSearchUI" -destination "generic/platform=iOS" SKIP_INSTALL=NO ${MARKETING_VERSION:+MARKETING_VERSION=${MARKETING_VERSION}}  -archivePath "${DEVICE_ARCHIVE_NAME}" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO

for frameworkName in "MapboxSearch" "MapboxSearchUI"
do
    ### OUTPUT ###

    # Products
    # ├── LICENSE.md
    # ├── MapboxSearch.xcframework
    # │   ├── Info.plist
    # │   ├── LICENSE.md
    # │   ├── ios-arm64
    # │   └── ios-arm64_x86_64-simulator
    # ├── MapboxSearch.xcframework.zip
    # ├── MapboxSearchUI.xcframework
    # │   ├── Info.plist
    # │   ├── LICENSE.md
    # │   ├── ios-arm64
    # │   └── ios-arm64_x86_64-simulator
    # ├── MapboxSearchUI.xcframework.zip
    # └── ${frameworkName}.xcframework.zip

    rm -rf "${frameworkName}.xcframework"

    # Make an XCFramework
    DSYM_UUID=$(dwarfdump --uuid "${DEVICE_ARCHIVE_NAME}/dSYMs/${frameworkName}.framework.dSYM" | head -n 1 | cut -d ' ' -f2)

    xcodebuild -create-xcframework -output "${RESULT_PRODUCTS_DIR}/${frameworkName}.xcframework" \
      -framework "${DEVICE_ARCHIVE_NAME}/Products/Library/Frameworks/${frameworkName}.framework" \
          -debug-symbols "${DEVICE_ARCHIVE_NAME}/dSYMs/${frameworkName}.framework.dSYM" \
      -framework "${SIMULATOR_ARCHIVE_NAME}/Products/Library/Frameworks/${frameworkName}.framework" \
          -debug-symbols "${SIMULATOR_ARCHIVE_NAME}/dSYMs/${frameworkName}.framework.dSYM"

    # Set commit short SHA1 hash into .xcframework/Info.Plist:$INFO_PLIST_COMMIT_HASH_KEY
    plutil -insert "${INFO_PLIST_COMMIT_HASH_KEY}" -string "$(git rev-parse --short HEAD)" "${RESULT_PRODUCTS_DIR}/${frameworkName}.xcframework/Info.plist"
    
    # Set branch name hash into .xcframework/Info.Plist:$INFO_PLIST_BRANCH_KEY
    plutil -insert "${INFO_PLIST_BRANCH_KEY}" -string "$(git rev-parse --abbrev-ref HEAD)" "${RESULT_PRODUCTS_DIR}/${frameworkName}.xcframework/Info.plist"

    cp "${PROJECT_ROOT}/LICENSE.md" "${RESULT_PRODUCTS_DIR}/"
    cp "${PROJECT_ROOT}/LICENSE.md" "${RESULT_PRODUCTS_DIR}/${frameworkName}.xcframework/"

    pushd "${RESULT_PRODUCTS_DIR}"
    zip -r "${frameworkName}.zip" "${frameworkName}.xcframework" > /dev/null
    popd
done

rm -r "${SIMULATOR_ARCHIVE_NAME}"
rm -r "${DEVICE_ARCHIVE_NAME}"

if [ -x "$(command -v tree)" ]; then
  tree -L 2 "${RESULT_PRODUCTS_DIR}"
fi

popd
