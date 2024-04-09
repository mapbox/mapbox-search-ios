// Copyright © 2024 Mapbox. All rights reserved.

import Foundation

class OfflineIndexObserver: CoreOfflineIndexObserver {
    enum Types {
        typealias indexChangedBlock = (CoreOfflineIndexChangeEvent) -> Void
        typealias errorBlock = (CoreOfflineIndexError) -> Void
    }

    private var onIndexChangedBlock: Types.indexChangedBlock
    private var onErrorBlock: Types.errorBlock

    init(
        onIndexChangedBlock: @escaping Types.indexChangedBlock = { _ in },
        onErrorBlock: @escaping Types.errorBlock = { _ in }
    ) {
        self.onIndexChangedBlock = onIndexChangedBlock
        self.onErrorBlock = onErrorBlock
    }

    func onIndexChanged(for event: CoreOfflineIndexChangeEvent) {
        onIndexChangedBlock(event)
    }

    func onError(forError error: CoreOfflineIndexError) {
        onErrorBlock(error)
    }
}
