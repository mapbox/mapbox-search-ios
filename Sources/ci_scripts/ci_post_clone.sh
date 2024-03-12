#!/usr/bin/env sh

# Support Xcode Cloud for Sources/Demo.xcodeproj

# Propagate environment secrets
echo $MAPBOX_API_TOKEN > ~/.mapbox

# Set up netrc for packages
echo "machine api.mapbox.com" >> ~/.netrc
echo "login mapbox" >> ~/.netrc
echo "password $MAPBOX_API_TOKEN" >> ~/.netrc
chmod 0600 ~/.netrc

# Fetch Carthage dependencies
make dependencies
