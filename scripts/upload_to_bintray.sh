#!/usr/bin/env bash
set -euo pipefail

BASEDIR=$(dirname "$0")

if [ "$#" -ne 1 ]; then
    echo "Expected 1 argument for version number"
    exit 1
fi
VERSION=$1

echo "Starts bintray upload for version: $VERSION"
XC_SEARCH_VERSION=$(/usr/libexec/PlistBuddy -c "Print:CFBundleShortVersionString" ${BASEDIR}/../Products/MapboxSearch.xcframework/ios-arm64/MapboxSearch.framework/Info.plist)
XC_SEARCHUI_VERSION=$(/usr/libexec/PlistBuddy -c "Print:CFBundleShortVersionString" ${BASEDIR}/../Products/MapboxSearchUI.xcframework/ios-arm64/MapboxSearchUI.framework/Info.plist)

if ! [[ "$VERSION" == "$XC_SEARCH_VERSION"  && "$XC_SEARCH_VERSION" == "$XC_SEARCHUI_VERSION" ]]; then
    echo "Cannot proceed with different framework versions"
    printf "%20s %7s\n" "Expected:" "${VERSION}"
    printf "%20s %7s\n" "MapboxSearch:" "${XC_SEARCH_VERSION}"
    printf "%20s %7s\n" "MapboxSearchUI:" "${XC_SEARCHUI_VERSION}"
    exit 1
fi

for FILE in "${BASEDIR}/../Products/MapboxSearch.xcframework.zip" "${BASEDIR}/../Products/MapboxSearchUI.xcframework.zip"
do
    if [ ! -f "${FILE}" ]; then
        echo "File doesn't exist: ${FILE}"
        exit 1
    fi

    echo "Begin file upload: ${FILE}"
    HTTP_STATUS_CODE=$(curl -n -H X-Bintray-Publish:1 -H X-Bintray-Override:1 \
                    -T "${FILE}" \
                    --write-out %{http_code}\
                    --silent --output /dev/null\
                    https://api.bintray.com/content/mapbox/mapbox_collab/mapbox-search-ios/${VERSION}/${VERSION}/)

    if [ ${HTTP_STATUS_CODE} -ge 400 ] ; then
        >&2 echo "Cannot upload binary to Bintray. Status code: ${HTTP_STATUS_CODE}"
        exit 1
    fi
done
