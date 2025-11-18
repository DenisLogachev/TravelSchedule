import Foundation

protocol StationSearchProtocol: Actor {
    func findStationCode(for cityCode: String, in allStations: AllStations) -> String?
    func findSpecificStationCode(cityCode: String, stationName: String, in allStations: AllStations) -> String?
    func clearCache()
}

