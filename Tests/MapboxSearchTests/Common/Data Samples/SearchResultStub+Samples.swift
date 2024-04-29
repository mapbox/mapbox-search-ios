import MapboxSearch

extension SearchResultStub {
    static let sample1 = SearchResultStub(
        id: "sample-1",
        mapboxId: nil,
        categories: ["sample-1", "sample-2"],
        name: "Sample No 1",
        matchingName: nil,
        serverIndex: nil,
        iconName: Maki.bar.name,
        resultType: .POI,
        routablePoints: [.routablePointForSample1],
        coordinate: .sample1,
        address: .fullAddress,
        metadata: .pizzaMetadata,
        dataLayerIdentifier: "sample-data-layer-identifier"
    )
}
