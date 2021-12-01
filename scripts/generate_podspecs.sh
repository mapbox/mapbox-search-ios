#!/usr/bin/env bash

set +u
if [[ -z $VERSION ]];then
    exit 1
fi
set -u

sed -i '' "s/\(s.version.*\)=.*/\1= '${VERSION}'/g" MapboxSearch.podspec
sed -i '' "s/\(s.version.*\)=.*/\1= '${VERSION}'/g" MapboxSearchUI.podspec
sed -i '' "s/\(dependency 'MapboxSearch', \).*/\1\">= ${VERSION}\", \"< 2.0\"/g" MapboxSearchUI.podspec
