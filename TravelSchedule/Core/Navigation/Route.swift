import SwiftUI

enum Route: Hashable, @unchecked Sendable {
    case station(city: City)
    case carrierDetail(carrierID: String, carrierName: String? = nil)
    case filters
    case serverError
    case noInternet
}

