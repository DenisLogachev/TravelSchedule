import SwiftUI

struct CarrierRoute: Identifiable, Hashable {
    let id = UUID()
    let carrierName: String
    let carrierCode: Int?
    let carrierLogoURL: String?
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let date: String
    let transferStation: String?
    let threadUID: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CarrierRoute, rhs: CarrierRoute) -> Bool {
        lhs.id == rhs.id
    }
}

