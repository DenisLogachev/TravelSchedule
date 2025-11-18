import Foundation

@MainActor
protocol CacheProtocol {
    func getAllStations(using networkClient: NetworkClientProtocol) async throws -> AllStations
    func getCities(using networkClient: NetworkClientProtocol) async throws -> [City]
    func findCityCode(by cityName: String, using networkClient: NetworkClientProtocol) async throws -> String?
    var hasCachedData: Bool { get }
    var isCurrentlyLoading: Bool { get }
    func clearCache()
}

