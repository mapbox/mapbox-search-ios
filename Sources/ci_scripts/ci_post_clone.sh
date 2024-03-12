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

# Relocate to the top level directory
cd ../../

# Set up build dependencies
brew update
brew bundle install

# Clear caches
rm -rf  ~/Library/Caches/carthage/
rm -rf ~/Library/Caches/org.carthage.CarthageKit

# Fetch Carthage package dependencies
make dependencies
