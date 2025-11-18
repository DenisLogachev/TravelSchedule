import Foundation

protocol CitiesExtractorProtocol {
    func extractCities(from allStations: AllStations) -> [City]
}

struct CitiesExtractor: CitiesExtractorProtocol {
    func extractCities(from allStations: AllStations) -> [City] {
        guard let countries = allStations.countries else { return [] }
        
        let targetCountry = AppConstants.Country.russia
        
        let settlements = countries
            .filter { ($0.title ?? "") == targetCountry }
            .flatMap { $0.regions ?? [] }
            .flatMap { $0.settlements ?? [] }
        
        var cityMap: [String: (city: City, stationCount: Int)] = [:]
        
        for settlement in settlements {
            guard StationValidator.hasRailwayStations(settlement) else { continue }
            guard let stations = settlement.stations else { continue }
            
            let cityName = settlement.title ?? ""
            let validStationsCount = stations.reduce(into: 0) { count, station in
                guard StationValidator.isRailwayStation(station),
                      StationValidator.shouldIncludeStation(station),
                      let _ = station.cleanedName(cityName: cityName) else { return }
                count += 1
            }
            
            guard validStationsCount >= 1 else { continue }
            guard let cityCode = settlement.codes?.yandex_code, !cityCode.isEmpty else { continue }
            guard let title = settlement.title, !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { continue }
            
            let city = City(id: cityCode, name: title)
            let key = cityCode
            
            if let existing = cityMap[key] {
                cityMap[key] = (city: city, stationCount: max(existing.stationCount, validStationsCount))
            } else {
                cityMap[key] = (city: city, stationCount: validStationsCount)
            }
        }
        
        var uniqueByName: [String: (city: City, stationCount: Int)] = [:]
        for (_, info) in cityMap {
            let name = info.city.name
            if let existing = uniqueByName[name] {
                if info.stationCount > existing.stationCount {
                    uniqueByName[name] = info
                }
            } else {
                uniqueByName[name] = info
            }
        }
        
        let sorted = uniqueByName.values.sorted { a, b in
            if a.stationCount != b.stationCount { return a.stationCount > b.stationCount }
            return a.city.name < b.city.name
        }
        
        return sorted.map { $0.city }
    }
}


