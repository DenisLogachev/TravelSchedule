import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

actor NetworkClient: NetworkClientProtocol {
    // MARK: - Properties
    private let client: Client
    private let apikey: String
    
    // MARK: - Initialization
    nonisolated init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    // MARK: - All Stations Service
    func getAllStations() async throws -> AllStations {
        let service = AllStationsService(client: client, apikey: apikey)
        return try await service.getAllStations()
    }
    
    // MARK: - Carrier Service
    func getCarrierInfo(code: String, system: String? = nil) async throws -> CarrierInfo {
        let response = try await client.getCarrierInfo(query: .init(
            apikey: apikey,
            code: code,
            system: system
        ))
        return try response.ok.body.json
    }
    
    // MARK: - Copyright Service
    func getCopyright() async throws -> CopyrightInfo {
        let response = try await client.getCopyright(query: .init(apikey: apikey))
        return try response.ok.body.json
    }
    
    // MARK: - Nearest City Service
    func getNearestCity(lat: Double, lng: Double, distance: Int? = nil) async throws -> NearestCity {
        let response = try await client.getNearestCity(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng,
            distance: distance
        ))
        return try response.ok.body.json
    }
    
    // MARK: - Nearest Stations Service
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        let response = try await client.getNearestStations(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng,
            distance: distance
        ))
        return try response.ok.body.json
    }
    
    // MARK: - Schedule Service
    func getStationSchedule(station: String, date: String? = nil) async throws -> StationSchedule {
        let response = try await client.getStationSchedule(query: .init(
            apikey: apikey,
            station: station,
            date: date
        ))
        return try response.ok.body.json
    }
    
    // MARK: - Search Service
    func searchRoutes(from: String, to: String, date: String? = nil) async throws -> SearchResults {
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            lang: AppConstants.Locale.russian,
            date: date,
            transport_types: AppConstants.TransportType.train
        ))
        return try response.ok.body.json
    }
    
    // MARK: - Thread Service
    func getRouteStations(uid: String, from: String? = nil, to: String? = nil) async throws -> ThreadStations {
        let response = try await client.getRouteStations(query: .init(
            apikey: apikey,
            uid: uid,
            from: from,
            to: to
        ))
        return try response.ok.body.json
    }
}
