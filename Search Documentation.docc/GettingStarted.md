#  Getting Started

Run your first search

## Overview 
In this article we would get through initialization phase, run our first request and discuss how to process response options.

## Discussion
#### Instantiate SearchEngine
After you successfully install the SDK (<doc:Installation>), you are able to run a simple Search example. First of all, you have to initialize
``SearchEngine`` instance.
> Tip: It's possible to pass access token through `MBXAccessToken` key in application `Info.plist` file.

**Option 1**:

```swift
let searchEngine = SearchEngine()
```

**Option 2**:

```swift
let searchEngine = SearchEngine(accessToken: "YOUR_TOKEN")
```

#### Assign delegate

``SearchEngine`` communication happens through ``SearchEngine/delegate``. That allows make complex search flows simple.

```swift
searchEngine.delegate = self
```

Afterwards, we have to implement ``SearchEngineDelegate`` protocol. It provides three required methods:
1. ``SearchEngineDelegate/searchErrorHappened(searchError:searchEngine:)`` – that method would be called for any error that happened during engine usage.
2. ``SearchEngineDelegate/suggestionsUpdated(suggestions:searchEngine:)`` – suggestions are textual representation of search completions according to ``SearchEngine/query`` and ``SearchOptions``. We are going to reuse ``SearchSuggestion`` on the next step.
3. ``SearchEngineDelegate/resultResolved(result:searchEngine:)`` – in this method we would get a concrete ``SearchResult`` with ``SearchResult/coordinate`` data.

Basically, protocol implementation would be similar to:

```swift
extension LocationFinderController: SearchEngineDelegate {
    func suggestionsUpdated(suggestions: [SearchSuggestion], searchEngine: SearchEngine) {
        showLocationSuggestions(suggestions)
    }
    
    func resultResolved(result: SearchResult, searchEngine: SearchEngine) {
        showSelectedLocation(result)
    }
    
    func searchErrorHappened(searchError: SearchError, searchEngine: SearchEngine) {
        processSearchError(searchError)
    }
}
```

#### User choose location suggestion

As soon as user will choose one of displayed suggestions, we have to pass it into ``SearchEngine/select(suggestion:)`` to fetch suggestion details.

```swift
searchEngine.select(suggestion: userSelectedSuggestion)
```

``SearchEngine`` would process this suggestion and perform any required network requests to build finalizing ``SearchResult`` instance, result would come through ``SearchEngineDelegate/resultResolved(result:searchEngine:)`` method.

#### Start the search

Now we are ready to start our very first search 🎉!

There are two options to trigger a search request:
1. Update ``SearchEngine/query`` property to start new search with ``AbstractSearchEngine/defaultSearchOptions``. It easy to use in pair with text fields or bindings.
2. Call ``SearchEngine/search(query:options:)`` function with explicit ``SearchOptions`` per concrete search request. That function provides more granular control over the search options.  
