import Foundation

enum StationValidator {
    // MARK: - Public Methods
    static func isTrainStation(_ station: Components.Schemas.Station) -> Bool {
        guard let stationType = station.station_type else { return false }
        return stationType.lowercased() == AppConstants.StationType.trainStation
    }
    
    static func isRailwayStation(_ station: Components.Schemas.Station) -> Bool {
        guard isTrainStation(station) else { return false }
        
        guard let transportType = station.transport_type else { return false }
        return transportType.lowercased() == AppConstants.TransportType.train
    }
    
    static func hasRailwayStations(_ settlement: Components.Schemas.Settlement) -> Bool {
        guard let stations = settlement.stations else {
            return false
        }
        
        return stations.contains { station in
            isTrainStation(station)
        }
    }
    
    static func shouldIncludeStation(_ station: Components.Schemas.Station) -> Bool {
        let hasTitle = (station.popular_title != nil && !station.popular_title!.isEmpty) ||
        (station.title != nil && !station.title!.isEmpty) ||
        (station.short_title != nil && !station.short_title!.isEmpty)
        guard hasTitle else { return false }
        
        if let stationType = station.station_type {
            let stationTypeLower = stationType.lowercased()
            let excludedTypes = ["platform", "stop", "checkpoint", "post", "crossing", "overtaking_point"]
            if excludedTypes.contains(stationTypeLower) {
                return false
            }
        }
        
        if let majority = station.majority {
            let minMajority = 1
            if majority < minMajority {
                return false
            }
        }
        
        if let stationTypeName = station.station_type_name {
            let stationTypeNameLower = stationTypeName.lowercased()
            let excludedTypeNames = ["остановка", "платформа", "разъезд", "пост"]
            if excludedTypeNames.contains(where: { stationTypeNameLower.contains($0) }) {
                return false
            }
        }
        
        guard let esrCode = station.codes?.esr_code, !esrCode.isEmpty else {
            return false
        }
        
        return true
    }
}


