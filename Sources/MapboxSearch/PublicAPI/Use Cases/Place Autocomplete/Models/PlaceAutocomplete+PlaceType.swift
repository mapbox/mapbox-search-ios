import Foundation

extension PlaceAutocomplete {
    /// Values to filter Place Autocomplete results to include only a subset (one or more) of the available feature
    /// types.
    public enum PlaceType: Equatable {
        /// Poi query type.
        case POI
        case administrativeUnit(AdministrativeUnit)

        public static var allTypes: [PlaceType] {
            [.POI] + AdministrativeUnit.all.map(PlaceType.administrativeUnit)
        }

        var coreType: SearchQueryType {
            switch self {
            case .POI: return .poi
            case .administrativeUnit(let unit): return unit.rawValue
            }
        }

        static func from(_ coreType: SearchQueryType) -> PlaceType {
            if coreType == .poi {
                return .POI
            } else {
                return .administrativeUnit(.init(rawValue: coreType))
            }
        }
    }
}
