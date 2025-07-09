@_spi(Experimental)
public enum ParkingRateValue: Codable, Hashable {
    case unknown
    case iso8601DurationFormat(String)
    case customValue(ParkingRateCustomValue)
}

extension CoreParkingRateValue {
    var parkingRateValue: ParkingRateValue {
        if isNSString() {
            return .iso8601DurationFormat(getNSString())
        } else if isParkingRateCustomValue() {
            return .customValue(getParkingRateCustomValue().parkingRateCustomValue)
        } else {
            return .unknown
        }
    }
}
