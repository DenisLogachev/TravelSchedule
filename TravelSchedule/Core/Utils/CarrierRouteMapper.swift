import Foundation

protocol CarrierRouteMapperProtocol {
    func convertSearchResultsToCarrierRoutes(_ searchResults: SearchResults) -> [CarrierRoute]
}

struct CarrierRouteMapper: CarrierRouteMapperProtocol {
    func convertSearchResultsToCarrierRoutes(_ searchResults: SearchResults) -> [CarrierRoute] {
        var routeMap: [String: CarrierRoute] = [:]
        
        if let segments = searchResults.segments, !segments.isEmpty {
            for segment in segments {
                if let route = convertSegmentToCarrierRoute(segment) {
                    addRouteToMap(route, to: &routeMap)
                }
            }
        }
        
        return Array(routeMap.values)
    }
    
    private func addRouteToMap(_ route: CarrierRoute, to routeMap: inout [String: CarrierRoute]) {
        let trainNumber = extractTrainNumber(from: route.threadUID)
        let key = "\(trainNumber)|\(route.departureTime)"
        
        if let existingRoute = routeMap[key] {
            let existingDuration = TimeUtils.parseDurationToSeconds(existingRoute.duration)
            let newDuration = TimeUtils.parseDurationToSeconds(route.duration)
            
            if newDuration < existingDuration {
                routeMap[key] = route
            }
        } else {
            routeMap[key] = route
        }
    }
    
    private func extractTrainNumber(from threadUID: String?) -> String {
        guard let uid = threadUID else { return "" }
        if let underscoreIndex = uid.firstIndex(of: "_") {
            return String(uid[..<underscoreIndex])
        }
        return uid
    }
    
    private func convertSegmentToCarrierRoute(_ segment: Components.Schemas.Segment) -> CarrierRoute? {
        guard let departure = segment.departure,
              let arrival = segment.arrival,
              let thread = segment.thread else {
            return nil
        }
        
        let carrierName = thread.carrier?.title ?? "Неизвестно"
        let carrierCode = thread.carrier?.code
        let carrierLogoURL = thread.carrier?.logo
        let threadUID = thread.uid
        
        let departureDate = DateFormattingUtils.parseDate(from: departure)
        let arrivalDate = DateFormattingUtils.parseDate(from: arrival)
        let departureTime = DateFormattingUtils.formatTime(from: departureDate)
        let arrivalTime = DateFormattingUtils.formatTime(from: arrivalDate)
        
        guard departureTime != "--:--", arrivalTime != "--:--" else {
            return nil
        }
        
        let duration: String
        if let durationSeconds = segment.duration {
            duration = DateFormattingUtils.formatDuration(from: durationSeconds)
        } else {
            duration = DateFormattingUtils.calculateDuration(from: departureDate, to: arrivalDate)
        }
        
        let date = DateFormattingUtils.formatDate(from: departureDate)
        
        return CarrierRoute(
            carrierName: carrierName,
            carrierCode: carrierCode,
            carrierLogoURL: carrierLogoURL,
            departureTime: departureTime,
            arrivalTime: arrivalTime,
            duration: duration,
            date: date,
            transferStation: nil,
            threadUID: threadUID
        )
    }
}


