#!/usr/bin/env bash

# Improvements:
# 1. Put xcarchives into unique tmp folder (mktemp)
# 2. Build only MapboxSearchUI. MapboxSearch will be built as a dependency

set -euo pipefail
BASEDIR=$(dirname "$0")
PROJECT_ROOT="$(cd "${BASEDIR}/.." && pwd)"
RESULT_PRODUCTS_DIR="${PROJECT_ROOT}/Products"
PACKAGE_FILE="${PROJECT_ROOT}/Package.swift"
BACKUP_FILE="${PROJECT_ROOT}/Package.swift.bak"

cp "$PACKAGE_FILE" "$BACKUP_FILE"

INFO_PLIST_COMMIT_HASH_KEY="MBXCommitHash"
INFO_PLIST_BRANCH_KEY="MBXBranch"

rm -rf "${RESULT_PRODUCTS_DIR}"

BASEDIR=$(dirname "$0")

LATEST_GIT_TAG=$(git describe --tags $(git rev-list --tags --max-count=1))
MARKETING_VERSION=$(echo "${LATEST_GIT_TAG}" | perl -nle 'print $v if ($v)=/([0-9]+([.][0-9]+)+)/')
echo "Compiling frameworks, marketing version: ${MARKETING_VERSION}, git tag: ${LATEST_GIT_TAG}"

pushd "${PROJECT_ROOT}" > /dev/null

for frameworkName in "MapboxSearch" "MapboxSearchUI" 
do
  sed -i '' "s/targets: \[\"$frameworkName\"\]/type: .dynamic, targets: [\"$frameworkName\"]/g" "$PACKAGE_FILE"
done

build_xcframework() {
  local frameworkName="$1"

  local SIMULATOR_ARCHIVE_NAME="${RESULT_PRODUCTS_DIR}/Search-iphonesimulator.xcarchive"
  local DEVICE_ARCHIVE_NAME="${RESULT_PRODUCTS_DIR}/Search-iphoneos.xcarchive"

  echo "Building ${frameworkName} for iOS Simulator..."
  xcodebuild archive \
    -project MapboxSearch.xcodeproj \
    -scheme "${frameworkName}" \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "${SIMULATOR_ARCHIVE_NAME}" \
    -configuration Release \
    SKIP_INSTALL=NO \
    ${MARKETING_VERSION:+MARKETING_VERSION=${MARKETING_VERSION}} \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

  echo "Building ${frameworkName} for iOS Device..."
  xcodebuild archive \
    -project MapboxSearch.xcodeproj \
    -scheme "${frameworkName}" \
    -destination "generic/platform=iOS" \
    -archivePath "${DEVICE_ARCHIVE_NAME}" \
    -configuration Release \
    SKIP_INSTALL=NO \
    ${MARKETING_VERSION:+MARKETING_VERSION=${MARKETING_VERSION}} \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO
    
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
    rm -r "${frameworkName}.xcframework"
    popd
    
    rm -r "${SIMULATOR_ARCHIVE_NAME}"
    rm -r "${DEVICE_ARCHIVE_NAME}"
}

for frameworkName in "MapboxSearch" "MapboxSearchUI" 
do
    build_xcframework ${frameworkName}
done

mv "$BACKUP_FILE" "$PACKAGE_FILE"

if [ -x "$(command -v tree)" ]; then
  tree -L 2 "${RESULT_PRODUCTS_DIR}"
fi

popd
