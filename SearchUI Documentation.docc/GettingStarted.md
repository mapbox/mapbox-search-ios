#  Getting Started

Integrate Mapbox Search UI right into your application

## Overview 

Built-in UI is implemented via ``MapboxSearchController`` and provides options to make:
- Search locations by name or address 
- Search locations by name of the POI category (e.g. `bar`, `ATM` or `Hotel`)
- Save and match search results with user favorite records and search history

## Getting Started

#### Instantiate Mapbox Search Controller
First, to start Search UI integration, you have to instantiate ``MapboxSearchController``:

> Tip: It's recommended to include your access token through the `MBXAccessToken` key in application `Info.plist` file.

**Option 1**:

```swift
let searchController = MapboxSearchController()
```

**Option 2**:

```swift
let searchController = MapboxSearchController(accessToken: "YOUR_TOKEN")
```

To control data flow, implement ``SearchControllerDelegate`` and assign ``MapboxSearchController/delegate``. That protocol has next required methods:
1. ``SearchControllerDelegate/searchResultSelected(_:)`` method to return representable `SearchResult` object that match input query.
2. ``SearchControllerDelegate/categorySearchResultsReceived(category:results:)`` returns a collection of `SearchResult` object matches with requested category name.
3. ``SearchControllerDelegate/userFavoriteSelected(_:)`` returns `FavoriteRecord` representing user-provided record.

#### Presentation 

Out of the box you can present ``MapboxSearchController`` in a floating panel with a ``MapboxPanelController``. Initialize Panel Controller as following:

```swift
let panelController = MapboxPanelController(rootViewController: searchController)
```

Afterwards, add panel controller as a child controller:

```swift
rootViewController.addChild(panelController)
```
