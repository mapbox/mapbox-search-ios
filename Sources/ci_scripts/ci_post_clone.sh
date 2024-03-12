#!/usr/bin/env sh

# Support Xcode Cloud for Sources/Demo.xcodeproj

if [[ -z $MAPBOX_API_TOKEN ]];then
	echo "Please provide an API token environment variable in Xcode Cloud"
    exit 1
fi

# Propagate environment secrets
echo $MAPBOX_API_TOKEN > ~/.mapbox

# Set up netrc for packages
echo "machine api.mapbox.com" >> ~/.netrc
echo "login mapbox" >> ~/.netrc
echo "password $MAPBOX_API_TOKEN" >> ~/.netrc
chmod 0600 ~/.netrc

# Fetch Carthage dependencies
cd ../../
make dependencies
