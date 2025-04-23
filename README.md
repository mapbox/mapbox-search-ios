[![CircleCI](https://dl.circleci.com/status-badge/img/gh/mapbox/mapbox-search-ios/tree/main.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/mapbox/mapbox-search-ios/tree/main)
[![Swift version](https://img.shields.io/badge/swift-5.9+-orange.svg?style=flat&logo=swift)](https://developer.apple.com/swift)
[![iOS version](https://img.shields.io/badge/iOS-12.0+-green.svg?style=flat&logo=apple)](https://developer.apple.com/ios/)
[![Xcode version](https://img.shields.io/badge/Xcode-15.0+-DeepSkyBlue.svg?style=flat&logo=xcode&logoColor=lightGray)](https://developer.apple.com/xcode/)
[![swift-doc](https://img.shields.io/badge/swift--doc-64.94%25-orange?logo=read-the-docs)](https://github.com/SwiftDocOrg/swift-doc)
# Mapbox Search SDK for iOS

[![Latest Pre-Release](https://img.shields.io/github/v/release/mapbox/mapbox-search-ios?include_prereleases&label=Pre-release)](https://github.com/mapbox/mapbox-search-ios/releases)

[![Latest Release](https://img.shields.io/github/v/release/mapbox/mapbox-search-ios)](https://github.com/mapbox/mapbox-search-ios/releases)

# Table of contents

- [Overview](#overview)
- [Documentation](#documentation)
- [Requirements](#requirements)
- [Main features](#main-features)
- [Getting Started](#getting-started)
- [Contributing](#contributing)
- [Code of Conduct](#code-of-conduct)
- [Versioning](#versioning)

# Overview

The Mapbox Search SDK is a developer toolkit to add location search on mobile devices.
With the same speed and scale of the Mapbox Search API, the SDK is built specifically for on-demand and local search use cases, like ride-share, food delivery, and store finders apps.
Whether your users are trying to find a place among the vast amount of data on a global map, or to find the exact location of a venue a few miles down the road, the Search SDK provides location search for countries all over the globe, in many different languages.

Previously, implementing search into your application required custom tuning with every API request to set a language, location biasing, and result types.
There was no pre-built UI and no option for a user to see their search history, or save favorites.

The Mapbox Search SDK allows you to drop pre-tuned search into your application, removing the complexity of API configuration, while still giving you control to customize.
It ships with an optional UI framework, or you can build a completely custom implementation with your own UI elements by using the core library.
The Search SDK is pre-configured for autocomplete, local search biasing, and includes new features like category search, search history, and search favorites.

## Documentation

You can find more documentation at docs.mapbox.com:

- [iOS Search SDK Guides](https://docs.mapbox.com/ios/search/guides/)
- [iOS Search SDK Examples](https://docs.mapbox.com/ios/search/examples/)
- [iOS Search SDK API Reference](https://docs.mapbox.com/ios/search/api-reference/)

## Requirements

- iOS 12.0 and newer
- Xcode 15.0 and newer
- Swift 5.9 and newer
- Objective-C is not supported
- macOS/tvOS/watchOS platforms currently are not supported

## Main features

- Easy-to-use pre-tuned search options to integrate search into your app quickly.
  - Local search for a specific address or POI
- Pre-configured and customizable category search for popular categories like cafes, ATMs, hotels, and gas stations.
- On-device user search history
- On-device favorites
- Import/export customer data with your own protocols
- Provide you own persistent providers for customer data like History or Favorites

## Getting Started

You can install MapboxSearch and/or MapboxSearchUI packages with Swift Package Manager, Cocoapods, or Carthage. Swift Package Manage is our preferred distribution system.

### Swift Package Manager

Add the MapboxSearch dependency to your Package.swift or use the Xcode > Project settings > Package Dependencies tab.
```swift
dependencies: [
    .package(url: "https://github.com/mapbox/mapbox-search-ios.git")
]
```

### Cocoapods

1. Set up .netrc file for sdk registry access
    1. Create .netrc file in user home directory (`$HOME/.netrc`, e.g. `/Users/victorprivalov/.netrc`)
    2. File content:
    ```
    machine api.mapbox.com
    login mapbox
    password sk.ey_Your_Access_Token_With_Read_permission
    ```

##### MapboxSearch
To integrate latest pre-release version of `MapboxSearch` into your Xcode project using CocoaPods, specify it in your `Podfile`:
```
pod 'MapboxSearch', ">= 2.9.3", "< 3.0"
```

##### MapboxSearchUI
To integrate latest pre-release version of `MapboxSearchUI` into your Xcode project using CocoaPods, specify it in your `Podfile`:
```
pod 'MapboxSearchUI', ">= 2.9.3", "< 3.0"
```

### Carthage

1. Set up .netrc file for sdk registry access
    1. Create .netrc file in user home directory (`$HOME/.netrc`, e.g. `/Users/victorprivalov/.netrc`)
    2. File content:
    ```
    machine api.mapbox.com
    login mapbox
    password sk.ey_Your_Access_Token_With_Read_permission
    ```

2. Follow the [Carthage Quick Start](https://github.com/Carthage/Carthage?tab=readme-ov-file#quick-start) and specificy the MapboxSearch dependency in your `Cartfile`:

```
github "Mapbox/mapbox-search-ios" ~> 2.9.3
```

## Contributing

We welcome feedback and code contributions!

If you found a bug or want to request a feature [open a github issue](https://github.com/mapbox/mapbox-search-ios/issues). Please use the appropriate issue template.

### Development

The SDK requires Carthage which you can install using Homebrew.
1. Check that Homebrew is installed by running `brew -v`. If you don't have Homebrew, [install before proceeding.](https://brew.sh/)
1. Update Homebrew data to install latest tools versions including Carthage (v0.38 or newer)
    - `brew update && brew bundle install`
1. Set up .netrc file for sdk registry access
    1. Create .netrc file in user home directory (`$HOME/.netrc`, e.g. `/Users/victorprivalov/.netrc`)
    2. File content:
    ```
    machine api.mapbox.com
    login mapbox
    password sk.ey_Your_Access_Token_With_Read_permission
    ```
1. Set up commit hooks with
    `./scripts/install_git_hooks`
1. Build dependencies:
    `make dependencies`
1. Mapbox APIs require a Mapbox account and access token. Get an access token from the [Mapbox account page](https://account.mapbox.com/access-tokens/). To run a Demo you can provide a token in different ways:
    1. Create a new file named `mapbox` or `.mapbox` in your home directory with content of your access token. We also support `.mapbox` file in the repository root folder. MapboxSearchDemoApplication will automatically handle this key and insert it in corresponding place.
    1. Open the Workspace, choose `MapboxSearchDemoApplication` project and select "Info" tab for "MapboxSearchDemoApplication" target. Here you may set your accessToken for `MBXAccessToken` key in "Custom iOS Target Properties" section.
1. Alternatively, you could provide your accessToken as a parameter to `SearchEngine.init` and other initializers that accept an `accessToken` parameter. Use this approach to deliver your key dynamically and implement a key rotation schedule.

## Code of Conduct

### Our Standards

Examples of behavior that contributes to creating a positive environment include:

- Using welcoming and inclusive language.
- Being respectful of differing viewpoints and experiences.
- Gracefully accepting constructive criticism.
- Focusing on what is best for the community.
- Showing empathy towards other community members.

We recommend reading [this blog post from Github on writing great PRs.](https://github.blog/2015-01-21-how-to-write-the-perfect-pull-request/).

# Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on repository](https://github.com/mapbox/mapbox-search-ios/tags).
