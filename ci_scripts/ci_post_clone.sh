# Support Xcode Cloud for Sources/Demo.xcodeproj

# Propagate environment secrets
echo $MAPBOX_API_TOKEN > ~/.mapbox

# Fetch Carthage dependencies
make dependencies
