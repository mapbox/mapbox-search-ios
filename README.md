# Mapbox Search SDK binaries for iOS

Public dependency manager manifests for Search SDK by Mapbox

* [Documentation](https://docs.mapbox.com/ios/search/guides/)
* [API Reference](https://docs.mapbox.com/ios/search/api-reference/)
* [Examples](https://docs.mapbox.com/ios/search/examples/)

## Requirements

* iOS 11.0 and newer
* Swift 4.2 and newer
* Mapbox access token in `~/.netrc`

## Supported Dependency Managers

* Swift Package Manager
* CocoaPods (1.10+)
* Carthage (0.38.0+)

### Swift Package Manager support

There are few steps to integrate SDK with SPM:

1. (!) Generate Mapbox private access token with `DOWNLOADS:READ` permission scope and write it down to the `~/.netrc` file for `mapbox` user and `api.mapbox.com` domain  
[Read more](https://docs.mapbox.com/ios/search/guides/install/#configure-credentials)

2. Add repository link to the Packages list
    * Xcode:
        1. Open Project Setting – Swift Packages
          ![SPM dep](https://i.imgur.com/H3oc7tl.jpg)
        2. Choose "Add Package Dependency" button, insert `https://github.com/mapbox/search-ios.git` to the search field and press "Next"
        3. Choose you dependency update rules (`Up to Next major` is recommended)
          ![Update rules](https://i.imgur.com/HWGLnoO.png)
    * Package.swift
        1. Add new item in `.dependencies` list:

        ```swift
        .package(url: "https://github.com/mapbox/search-ios.git", from: "1.0.0-beta")
        ```

### CocoaPods

1. (!) Generate Mapbox private access token with `DOWNLOADS:READ` permission scope and write it down to the `~/.netrc` file for `mapbox` user and `api.mapbox.com` domain  
[Read more](https://docs.mapbox.com/ios/search/guides/install/#configure-credentials)
2. Add pods to your Podfile:

```ruby
pod 'MapboxSearch', '~> 1.0.0-beta'
pod 'MapboxSearchUI', '~> 1.0.0-beta'
```

CocoaPods supports XCFrameworks since 1.10 version and enables `~/.netrc` support by default.

### Carthage

1. (!) Generate Mapbox private access token with `DOWNLOADS:READ` permission scope and write it down to the `~/.netrc` file for `mapbox` user and `api.mapbox.com` domain  
[Read more](https://docs.mapbox.com/ios/search/guides/install/#configure-credentials)
2. Add next line to Cartfile:

```ruby
github "mapbox/search-ios" ~> 1.0.0-beta
```

Note that carthage support requires few flags:

1. `--use-netrc` for `~/.netrc` credentials support
2. and `--use-xcframeworks` to support XCFramework distribution (requires Carthage 0.38.0+)

Resulting call may look like `carthage update --use-netrc --use-xcframeworks`.

Note: Carthage setup may complete with non-error lines:

```sh
*** Skipped building search-ios due to the error:
Dependency "search-ios" has no shared framework schemes

If you believe this to be an error, please file an issue with the maintainers at https://github.com/mapbox/search-ios/issues/new
```

It's an expected behavior that we cannot avoid.
