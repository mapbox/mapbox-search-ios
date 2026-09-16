# Compatibility Guide

What does SDK support

## Overview

Mapbox Search SDK works with:
- iOS 12 or newer on any supported iOS powered device including iPad.
- iOS or Mac Catalyst.

    It's not possible to run SDK on watchOS or tvOS. macOS support is limited to [Mac Catalyst](https://developer.apple.com/mac-catalyst/).
- Swift 5.9 or newer.
- Xcode 15.0 or newer is recommended for [Swift Package Manager](https://developer.apple.com/documentation/swift_packages) integration.
    For non-SPM integration Xcode 15.0 is a minimal requirement.
- A public Mapbox access token is required at runtime (`MBXAccessToken` in `Info.plist`). Stable releases do not require a download token. Snapshot builds still need a `Downloads:Read` token in `~/.netrc` for `api.mapbox.com`.

## Integration with the other Mapbox SDKs

To make integration with Mapbox Maps SDK or Mapbox Navigation SDK simple, it is highly recommended
to keep Mapbox Search SDK updated. Mapbox SDKs has Mapbox Common SDK as common dependency so it's extremely important
to have the same Common SDK version.


## See Also

- <doc:Installation>
- <doc:GettingStarted>
- ``SearchEngine``
