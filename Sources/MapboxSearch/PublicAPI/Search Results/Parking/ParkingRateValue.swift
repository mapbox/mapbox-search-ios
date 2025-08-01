/// Value for parking rate pricing - either ISO duration string or custom value.
@_spi(Experimental)
public enum ParkingRateValue: Codable, Hashable, Sendable {
    case iso8601DurationFormat(String)
    case customValue(ParkingRateCustomValue)
}

extension CoreParkingRateValue {
    var parkingRateValue: ParkingRateValue? {
        if isNSString() {
            return .iso8601DurationFormat(getNSString())
        }
        if isParkingRateCustomValue() {
            return .customValue(getParkingRateCustomValue().parkingRateCustomValue)
        }
        return nil
    }
}
