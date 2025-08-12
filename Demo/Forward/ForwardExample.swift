// Copyright © 2024 Mapbox. All rights reserved.

import SwiftUI

struct ForwardExample: View {
    @StateObject var observableSearchEngine = ForwardExampleSearchEngine()

    var body: some View {
        VStack {
            Text(
                "In contrast to Interactive Search, the /forward endpoint will not provide type-ahead suggestions, e.g., brand and category suggestions, but will only provide relevant search results. [Documentation](https://docs.mapbox.com/api/search/search-box/#search-request)"
            )
            .padding()
            HStack {
                TextField(text: $observableSearchEngine.query) {
                    Text("Search with forward/ endpoint")
                }
                Button("Forward") {
                    observableSearchEngine.forwardSearch()
                }
            }.padding()
            if let results = observableSearchEngine.queryResult.results {
                List(results, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text(item.name.trimmingCharacters(in: .whitespaces))
                        Text(item.address?.formattedAddress(style: .short) ?? "")
                            .font(.caption)
                    }
                }
            }
        }
        .environment(\.openURL, OpenURLAction(handler: { url in
            UIApplication.shared.open(url)
            return .handled
        }))
    }
}

#Preview {
    NavigationView {
        ForwardExample(observableSearchEngine: ForwardExampleSearchEngine())
            .navigationTitle("forward/")
            .navigationBarTitleDisplayMode(.inline)
    }
}
