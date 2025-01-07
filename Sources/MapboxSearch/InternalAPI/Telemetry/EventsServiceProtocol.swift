import Foundation
import MapboxCommon_Private

protocol EventsServiceProtocol {
    func sendEvent(for event: Event, callback: EventsServiceResponseCallback?)
}

extension EventsService: EventsServiceProtocol {}
