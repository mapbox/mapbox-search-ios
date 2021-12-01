[![CircleCI](https://circleci.com/gh/mapbox/mapbox-search-ios.svg?style=shield&circle-token=7fab5769f3e6feb4c439727c69a05e69382d969e)](https://app.circleci.com/pipelines/github/mapbox/mapbox-search-ios)
[![Swift version](https://img.shields.io/badge/swift-4.2+-orange.svg?style=flat&logo=swift)](https://developer.apple.com/swift)
[![iOS version](https://img.shields.io/badge/iOS-11.0+-green.svg?style=flat&logo=apple)](https://developer.apple.com/ios/)
[![Xcode version](https://img.shields.io/badge/Xcode-11.3+-DeepSkyBlue.svg?style=flat&logo=xcode&logoColor=lightGray)](https://developer.apple.com/xcode/)
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
- [Distribution](#distribution)
    - [Binary](#binary)
    - [Cocoapods](#cocoapods)
    - [Carthage](#carthage)
    - [Swift Package Manager](#swift-package-manager)
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

- iOS 11.0 and newer
- Xcode 11.3 and newer
- Swift 4.2 and newer
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
1. Update Homebrew data to install latest tools versions  
    `brew update`
1. Install Carthage (required version: 0.35 and newer)
    `brew install carthage` or `brew upgrade carthage`
1. Setup .netrc file for sdk registry access
    1. Create .netrc file in user home directory (`$HOME/.netrc`, e.g. `/Users/victorprivalov/.netrc`)
    2. File content:
```
machine api.mapbox.com
login mapbox
password sk.ey_your_access_token_wit_Read_permission
```
1. Build dependencies:
    `make dependencies`
1. Mapbox APIs require a Mapbox account and access token. Get an access token from the [Mapbox account page](https://account.mapbox.com/access-tokens/). To run a Demo you can provide a token in different ways:
    1. Create a new file named `mapbox` or `.mapbox` in your home directory with content of your access token. We also support `.mapbox` file in the repository root folder. MapboxSearchDemoApplication will automatically handle this key and insert it in corresponding place.

        _Note: Run `pbpaste > ~/.mapbox` in Terminal.app to insert you Pastebord (Command+C buffer) into `.mapbox` in Home directory._
    1. Open the Workspace, choose `MapboxSearchDemoApplication` project and select "Info" tab for "MapboxSearchDemoApplication" target. Here you can set your accessToken for `MGLMapboxAccessToken` key in "Custom iOS Target Properties" section.
    1. Provide your accessToken directly in argument named `accessToken` in `SearchDrawer.make(:)` method

## Getting Started

Once you've installed the prerequisites, no additional steps are needed: Open the Workspace and use any available scheme. The SDK includes a demo app that you can run on your iOS device or simulator by choosing MapboxSearchDemoApplication. 

## Documentation

_The link to iOS documentation will be added soon (instruction on how to build, usage the API, ready-to-use examples)._

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

## Distribution

Search SDK can be distributed by source code and binaries. Currently `mapbox-search-ios` repository is private and distribution by source code is for internal usage only (SPM, Carthage). `SDK Registry` with `cocoapods` used for the binaries distribution.
 Also there is `search-ios` public repo for binaries distribution via `SPM` and `carthage`.

### Automated Distribution Guide

1. _(optional)_ Create release branch with `semver` compatible name `(release/v1.5.0-alpha.14)`
1. Create `semver` compatible tag `git tag v1.2.3-alpha.4`
1. Push tag to the origin `git push --tags`
1. CircleCI job should be triggered, process can be tracked in [Circle CI](https://app.circleci.com/pipelines/github/mapbox/mapbox-search-ios)
1. The job has multiple steps, creates PRs into docs and sdk-registry repos and has one blocking step, which requires manual approval (`request-post-SDK_Registry-release`).
    1. `release-ios` will post a PR into [ios-sdk](https://github.com/mapbox/ios-sdk) repository with documentation. You should approve and merge it. ([example](https://github.com/mapbox/ios-sdk/pull/1204))
    1. `release-ios` will also post a PR into [sdk-registry](https://github.com/mapbox/api-downloads) (aka api-downloads) It also should be approved and merged.([example](https://github.com/mapbox/api-downloads/pull/819))
    1. Now the job will stop and wait for approval of `request-post-SDK_Registry-release`. We should wait for sdk-registry to make our binaries available. Usually it takes about 20 mins. You can check that new version became available in [carthage json](https://api.mapbox.com/downloads/v2/carthage/search-sdk/MapboxSearch.json) 
    1. Approve `request-post-SDK_Registry-release`.
1. Sanity check:
    1. New version available in cocoapods
    1. New version available SPM (binaries from public repo)
    1. New version available in carthage (binaries from public repo)


### Manual Distribution Guide

### SDK Registry (Binaries)
1. Build frameworks:
    1. To build both MapboxSearch and MapboxSearchUI frameworks run `make products`. The default output folder is `Products` in the repository root.

1. Upload binary to SDK-Registry:
	1. Make sure you have Mapbox AWS account, if not then should create ticket in user-isolation repository [request AWS account](https://github.com/mapbox/user-isolation/issues/new/choose)
	1. You need to install [mbxcli](https://github.com/mapbox/mbxcli) to be able to upload artifacts to AWS S3.
	1. Run command `mbx login default`. After successful login AWS console will open in your default browser.
	1. In section `AWS services' find subsection `All services` and then inside of it `Storage`. You should select the `S3` item from it.
	1. From the list of buckets we should select `mapbox-api-downloads-production`.
	1. All search SDK versions published in `v2/search-sdk/releases/`. For each new version you should create a separate folder named as version number. Example of correct structure and naming you can see in `0.7.0` folder.For more details on SDK registry  you can see [SDK Registry FAQ](https://docs.google.com/document/d/1b2hW3iep3bTO0O9RwD_8beMTPhIJF-SV67EC7SKG52U/edit) and [SDK Registry documentation](https://platform.tilestream.net/managed-infrastructure/sdk-registry/reference/)

1. Prepare sdk-registry config:
	1. Configs are located in [api-downloads/config/search-sdk](https://github.com/mapbox/api-downloads) repository. Config specification can be found [here](https://platform.tilestream.net/managed-infrastructure/sdk-registry/reference/#configure-the-sdk-registry).
	1. Create new config file or update existing. Each version requires a separate config file and should be named appropriate (e.g. `0.7.0.yaml`).
	1. Config file content should contain a list of ios packages, look at `0.7.0.yaml` for the [example](https://github.com/mapbox/api-downloads/pull/172/files).
	1. Open PR with updated config file.

### Cocoapods (Binaries)
1. Update podspecs files:
	1. Podspec files located in `mapbox-search-ios` repository (`MapboxSearch.podspec` and `MapboxSearchUI.podspec`).
	1. In podspec files update the version field (`s.version = 'new.version.number'`) and url to binaries if changed (`s.source = { :http => "" }`).
	1. In MapboxSearchUI.podspec file update dependency version (`s.dependency 'MapboxSearch', "~> new.version.number"`).
	1. Validate updated podspecs by running `mapbox-search-ios/scripts/pod_lint.sh` (it will lint both podspec files).
    1. Open `PR` with updated podspecs.
	1. Upload podspecs to repository ([internal](https://github.com/mapbox/pod-specs-internal) or [public](https://github.com/mapbox/pod-specs)). Instructions for how to upload pospec are in `readme.md` of podspecs repositories.

### SPM (Sources)
Currently `mapbox-search-ios` repository is private and SPM only available for _internal_ distribution.
1. Make `semver` tag `git tag v0.12.3`
2. Push tag to the origin `git push --tags`
3. Create a new [Github Release](https://github.com/mapbox/mapbox-search-ios/releases/new) based on the created tag. 
4. Github releases used **only** to notify subscribers about new releases. **Do Not attach any artefacts to the release.**

### Carthage (Sources, **Deprecated**)
Currently `mapbox-search-ios` repository is private and Carthage only available for _internal_ distribution.
But we do support carthage distribution with XCFrameworks (Required **Carthage 0.38.0**)
Artifacts should be uploaded to SDK Registry (see section **SDK Registry (Binaries)** above)

## CoreSearchSDK update
Mapbox-search-ios depends on CoreSearch framework. Dependency defined in:
1. `Package.swift` ->  `let (coreSearchVersion, coreSearchVersionHash) = ("0.0.0", "hash")`
2. `Cartfile` -> `binary "https://api.mapbox.com/downloads/v2/carthage/search-core-sdk/MapboxCoreSearch.xcframework.json" ~> 0.0.0`

###### Hint: update version in spm and wait xcode calculate hash for you ;)

## Integration

### Cocoapods
##### MapboxSearch
To integrate latest preview version of `MapboxSearch` into your Xcode project using CocoaPods, specify it in your `Podfile`:  
```
pod 'MapboxSearch', ">= 1.0.0-beta", "< 2.0"
```

##### MapboxSearchUI
To integrate latest preview version of `MapboxSearchUI` into your Xcode project using CocoaPods, specify it in your `Podfile`:  
```
pod 'MapboxSearchUI', ">= 1.0.0-beta", "< 2.0"
```

### Carthage
Carthage integration by Source code is available for everybody with repository read access.
Binaries available for public access. 
#### Sources (internal)
Add following line in your project `Cartfile`:
```
github "mapbox/mapbox-search-ios" ~> 1.0.0-beta.7
```
Pay an attention that Carthage integration build `MapboxSearch` and `MapboxSearchUI` from sources and simultaneously. 

#### Binaries (public)
Add following line in your project `Cartfile`:
```
github "mapbox/search-ios" ~> 1.0.0-beta.7
```


#### Binaries (public)
Carthage integration is available with XCFrameworks binaries(Required **Carthage 0.38.0**)
Add following line in your project `Cartfile`:
```
binary "https://api.mapbox.com/downloads/v2/carthage/search-sdk/MapboxSearch.json" ~> 1.0.0-beta
```
Use this command to build dependencies.
```
carthage bootstrap --use-netrc --use-xcframeworks
```
 Please keep in mind that Authorization done by `netrc`, check `Prerequisites` section above.

### Swift Package Manager
#### Sources (internal)
```swift
dependencies: [
    .package(url: "https://github.com/mapbox/mapbox-search-ios.git")
]
```
#### Binaries (public)
```swift
dependencies: [
    .package(url: "https://github.com/mapbox/search-ios.git")
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
