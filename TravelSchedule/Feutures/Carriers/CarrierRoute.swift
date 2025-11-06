import SwiftUI

struct CarrierRoute: Identifiable {
    let id = UUID()
    let carrierName: String
    let carrierLogo: String?
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let date: String
    let transferStation: String?
}

