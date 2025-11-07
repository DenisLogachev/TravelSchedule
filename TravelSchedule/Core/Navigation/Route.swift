import SwiftUI

enum Route: Hashable {
    case station(city: String)
    case carrierDetail(carrierID: String)
    case filters
    case serverError
    case noInternet
}

