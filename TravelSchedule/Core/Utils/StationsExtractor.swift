import Foundation
import OpenAPIRuntime

protocol StationsExtractorProtocol {
    func extractStations(for cityCode: String, from allStations: AllStations) -> [String]
}

struct StationsExtractor: StationsExtractorProtocol {
    func extractStations(for cityCode: String, from allStations: AllStations) -> [String] {
        guard let countries = allStations.countries else { return [] }
        
        let settlements = countries
            .flatMap { $0.regions ?? [] }
            .flatMap { $0.settlements ?? [] }
        
        guard let settlement = settlements.first(where: { ($0.codes?.yandex_code ?? "") == cityCode }) else {
            return []
        }
        
        let cityName = settlement.title ?? ""
        var stationMap: [String: StationInfo] = [:]
        
        for station in settlement.stations ?? [] {
            guard StationValidator.isRailwayStation(station),
                  StationValidator.shouldIncludeStation(station) else {
                continue
            }
            
            guard let cleanedName = station.cleanedName(cityName: cityName) else {
                continue
            }
            
            let lowered = cleanedName.lowercased()
            let importance = StationImportance(
                nameLowercased: lowered,
                codes: station.codes,
                direction: station.direction,
                code: station.code
            )
            
            let info = StationInfo(name: cleanedName, importance: importance)
            
            if var existing = stationMap[cleanedName] {
                existing.merge(with: info)
                stationMap[cleanedName] = existing
            } else {
                stationMap[cleanedName] = info
            }
        }
        
        let sorted = stationMap.values.sorted(by: StationInfo.sort)
        return sorted.map { $0.name }
    }
}
