import Foundation

/// Raw representation of feedback event. Can be stored and sent later.
/// Full access to the event content via attributes field. Be careful with keys!
public class RawFeedbackEvent {
    /// Event all data.
    public var attributes: [String: Any]
    
    /// Feedback reason. Modifies `attributes` field
    public var reason: String? {
        get { attributes["feedbackReason"] as? String }
        set { attributes["feedbackReason"] = newValue }
    }
    
    /// Feedback text. Modifies `attributes` field
    public var text: String? {
        get { attributes["feedbackText"] as? String }
        set { attributes["feedbackText"] = newValue }
    }
    
    /// Direct access to attributes
    public subscript(key: String) -> Any {
        get { attributes[key] as Any }
        set { attributes[key] = newValue }
    }
    
    /// Build RawFeedbackEvent with provided attributes dictionary.
    /// Does not apply any content check.
    /// - Parameter attributes: event field
    public init(attributes: [String: Any]) {
        self.attributes = attributes
    }
    
    /// Build RawFeedbackEvent with provided attributes dictionary.
    /// - Parameter json: jsonObject as `[String: Any]`
    public convenience init?(json: Data) {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: json, options: [.mutableContainers]) as? [String: Any] else {
            return nil
        }
        self.init(attributes: jsonObject)
    }
    
    /// JSON data build from `attributes` field.
    /// - Returns: Returns JSON data
    public func json() -> Data? {
         try? JSONSerialization.data(withJSONObject: attributes, options: [])
    }
}
