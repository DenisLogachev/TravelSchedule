import Foundation

actor StationSearchService: StationSearchProtocol {
    private var stationCodeCache: [String: String?] = [:]
    
    func findStationCode(for cityCode: String, in allStations: AllStations) -> String? {
        let cacheKey = "cityCode:\(cityCode)"
        
        if let cached = stationCodeCache[cacheKey] {
            return cached
        }
        
        guard let settlement = findSettlement(by: cityCode, in: allStations) else {
            stationCodeCache[cacheKey] = nil
            return nil
        }
        
        let code = extractStationCode(from: settlement, matching: nil)
        stationCodeCache[cacheKey] = code
        return code
    }

    func findSpecificStationCode(
        cityCode: String,
        stationName: String,
        in allStations: AllStations
    ) -> String? {
        let stationNameLower = stationName.lowercased()
        let cacheKey = "cityCode:\(cityCode):station:\(stationNameLower)"
        
        if let cached = stationCodeCache[cacheKey] {
            return cached
        }
        
        guard let settlement = findSettlement(by: cityCode, in: allStations) else {
            stationCodeCache[cacheKey] = nil
            return nil
        }
        
        let code = extractStationCode(from: settlement, matching: stationNameLower)
        stationCodeCache[cacheKey] = code
        return code
    }
    
    func clearCache() {
        stationCodeCache.removeAll()
    }
    
    private func extractStationCode(
        from settlement: Components.Schemas.Settlement,
        matching stationName: String?
    ) -> String? {
        guard let stations = settlement.stations else { return nil }
        
        for station in stations {
            guard StationValidator.isRailwayStation(station) else { continue }
            
            if let stationName = stationName {
                let stationTitle = (station.popular_title ?? station.title ?? station.short_title ?? "").lowercased()
                guard stationTitle.contains(stationName) || stationName.contains(stationTitle) else {
                    continue
                }
            }
            
            if let code = station.code {
                return code
            } else if let codes = station.codes,
                      let yandexCode = codes.yandex_code {
                return yandexCode
            }
        }
        
        return nil
    }
    
    private func findSettlement(by cityCode: String, in allStations: AllStations) -> Components.Schemas.Settlement? {
        guard let countries = allStations.countries else {
            return nil
        }
        
        for country in countries {
            guard let regions = country.regions else { continue }
            
            for region in regions {
                guard let settlements = region.settlements else { continue }
                
                for settlement in settlements {
                    let settlementCode = settlement.codes?.yandex_code ?? ""
                    if settlementCode == cityCode {
                        return settlement
                    }
                }
            }
        }
        
        return nil
    }
}

extension StationSearchService {
    static let shared = StationSearchService()
}
