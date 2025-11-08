import SwiftUI

struct RouteFilters: Equatable {
    var showTransfers: Bool?
    var departureTimeRanges: Set<TimeRange> = []
    
    var hasActiveFilters: Bool {
        showTransfers != nil || !departureTimeRanges.isEmpty
    }
    
    static let `default` = RouteFilters()
}

enum TimeRange: String, CaseIterable, Hashable {
    case morning = "06:00-12:00"
    case day = "12:00-18:00"
    case evening = "18:00-00:00"
    case night = "00:00-06:00"
    
    var label: String {
        switch self {
        case .morning: return "Утро"
        case .day: return "День"
        case .evening: return "Вечер"
        case .night: return "Ночь"
        }
    }
    
    var timeFrom: String {
        switch self {
        case .morning: return "06:00"
        case .day: return "12:00"
        case .evening: return "18:00"
        case .night: return "00:00"
        }
    }
    
    var timeTo: String {
        switch self {
        case .morning: return "12:00"
        case .day: return "18:00"
        case .evening: return "00:00"
        case .night: return "06:00"
        }
    }
}

