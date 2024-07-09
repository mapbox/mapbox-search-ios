[![CircleCI](https://dl.circleci.com/status-badge/img/gh/mapbox/mapbox-search-ios/tree/main.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/mapbox/mapbox-search-ios/tree/main)
[![Swift version](https://img.shields.io/badge/swift-5.7.1+-orange.svg?style=flat&logo=swift)](https://developer.apple.com/swift)
[![iOS version](https://img.shields.io/badge/iOS-12.0+-green.svg?style=flat&logo=apple)](https://developer.apple.com/ios/)
[![Xcode version](https://img.shields.io/badge/Xcode-15.2+-DeepSkyBlue.svg?style=flat&logo=xcode&logoColor=lightGray)](https://developer.apple.com/xcode/)
[![codecov](https://codecov.io/gh/mapbox/mapbox-search-ios/branch/develop/graph/badge.svg?token=js3DSKdda4)](https://codecov.io/gh/mapbox/mapbox-search-ios)
[![swift-doc](https://img.shields.io/badge/swift--doc-64.94%25-orange?logo=read-the-docs)](https://github.com/SwiftDocOrg/swift-doc)
# Mapbox Search SDK for iOS

# Table of contents

- [Overview](#overview)
- [Requirements](#requirements)
- [Main features](#main-features)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Documentation](#documentation)
- [Project structure overview](#project-structure-overview)
- [Integration](#integration)
- [Contributing](#contributing)
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

## Requirements

- iOS 12.0 and newer
- Xcode 15 and newer
- Swift 5.7.1 and newer
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

## Prerequisites
The SDK requires Carthage which you can install using Homebrew.
1. Check that Homebrew is installed by running `brew -v`. If you don't have Homebrew, [install before proceeding.](https://brew.sh/)
1. Update Homebrew data to install latest tools versions including Carthage (v0.39.1 or newer)
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

        _Note: Run `pbpaste > ~/.mapbox` in Terminal.app to insert you Pastebord (Command+C buffer) into `.mapbox` in Home directory._
    1. Open the Workspace, choose `MapboxSearchDemoApplication` project and select "Info" tab for "MapboxSearchDemoApplication" target. Here you may set your accessToken for `MBXAccessToken` key in "Custom iOS Target Properties" section.
1. Alternatively, you could provide your accessToken as a parameter to `SearchEngine.init` and other initializers that accept an `accessToken` parameter. Use this approach to deliver your key dynamically and implement a key rotation schedule.

## Getting Started

Once you've installed the prerequisites, no additional steps are needed: Open the Workspace and use any available scheme. The SDK includes a demo app that you can run on your iOS device or simulator by choosing MapboxSearchDemoApplication.

## Documentation

You can find the following documentation pages helpful:
- [Search SDK for iOS guide](https://docs.mapbox.com/ios/search/guides/)
- [MapboxSearch reference](https://docs.mapbox.com/ios/search/api/core/2.0.0-alpha.1/)
- [MapboxSearchUI reference](https://docs.mapbox.com/ios/search/api/ui/2.0.0-alpha.1/)

## Project structure overview

MapboxSearch project consist of five targets:
1. search-native.a (hidden; Bindgen generated Xcode project)
1. MapboxCoreSearch.framework (hidden; Bindgen generated Xcode project)
1. MapboxSearch.framework
1. MapboxSearchUI.framework
1. MapboxSearchDemoApplication

search-native.a written in C++ and MapboxCoreSearch.framework is generated by [bindgen](https://github.com/mapbox/mapbox-bindgen) using Objective-C++ language. Both targets live in submodule and get compiled by scripts in this submodule.

While search-native.a implements most of the shared logic, MapboxSearch.framework contains all the platform business logic for Search.

MapboxSearchUI.framework provides a default UI implementation with customization points to meet the most common customer needs. The UI elements include a search bar with result list, category search icons, history and favorites management, and a combined search/category search UI. (Screenshots coming soon)

MapboxSearchDemoApplication provides a Demo app wih MapboxSearchUI.framework presentation over the basic MapView. To get access to nightly builds in TestFlight, make a request to Search iOS developers.

## Integration

### Cocoapods
##### MapboxSearch
To integrate latest preview version of `MapboxSearch` into your Xcode project using CocoaPods, specify it in your `Podfile`:  
```
pod 'MapboxSearch', ">= 1.4.1", "< 2.0"
```

##### MapboxSearchUI
To integrate latest preview version of `MapboxSearchUI` into your Xcode project using CocoaPods, specify it in your `Podfile`:  
```
pod 'MapboxSearchUI', ">= 1.4.1", "< 2.0"
```

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/mapbox/mapbox-search-ios.git")
]
```

## Contributing

We welcome feedback and code contributions!

If you found a bug or want to request a feature [open a github issue](https://github.com/mapbox/mapbox-search-ios/issues). Please use the appropriate issue template.

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
