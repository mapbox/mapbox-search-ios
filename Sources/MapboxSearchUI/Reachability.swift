import CoreFoundation
import Foundation
import MapboxSearch
import SystemConfiguration

private enum Defaults {
    static let queueName = "com.mapbox.search.reachability"
    static let notificationName = "ReachabilityStatusChanged"
    static let notificationKey = "ReachabilityStatusKey"
}

extension Notification.Name {
    /// Reachability state change notification name.
    public static let ReachabilityStatusChanged = Notification.Name(Defaults.notificationName)
}

class Reachability {
    enum Status {
        case unknown
        case unavailable
        case available
    }

    static let userInfoKey = Defaults.notificationKey

    private let reachability: SCNetworkReachability
    private let queue = DispatchQueue(label: Defaults.queueName, qos: .default)

    var statusChangeHandler: ((Status) -> Void)?

    private var flags: SCNetworkReachabilityFlags? {
        didSet {
            guard flags != oldValue else { return }
            notifyReachabilityChanged()
        }
    }

    var status: Status {
        guard let flags else { return .unknown }
        return flags.status
    }

    init(hostname: String) {
        self.reachability = SCNetworkReachabilityCreateWithName(nil, hostname)!
    }

    deinit {
        stop()
    }

    private func notifyReachabilityChanged() {
        DispatchQueue.main.async {
            self.statusChangeHandler?(self.status)
            let notification = Notification(
                name: .ReachabilityStatusChanged,
                object: self,
                userInfo: [Reachability.userInfoKey: self.status]
            )
            NotificationQueue.default.enqueue(notification, postingStyle: .asap)
        }
    }
}

extension Reachability {
    func start() {
        let unmanagedSelf = Unmanaged<Reachability>.passUnretained(self).toOpaque()
        var context = SCNetworkReachabilityContext(
            version: 0,
            info: unmanagedSelf,
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        // A C function pointer cannot be formed from a closure that captures context
        // info parameter used to pass self pointer into callback
        let callback: SCNetworkReachabilityCallBack = { _, flags, info in
            guard let info else { return }

            let reachability = Unmanaged<Reachability>.fromOpaque(info).takeUnretainedValue()
            reachability.flags = flags
        }
        SCNetworkReachabilitySetCallback(reachability, callback, &context)
        SCNetworkReachabilitySetDispatchQueue(reachability, queue)
        updateFlags()
    }

    func stop() {
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
    }

    private func updateFlags() {
        queue.async {
            var flags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(self.reachability, &flags)
            self.flags = flags
        }
    }
}

extension SCNetworkReachabilityFlags {
    fileprivate var status: Reachability.Status {
        guard contains(.reachable) else { return .unavailable }
        return .available
    }
}
