import Foundation
import OpenAPIRuntime

protocol NetworkClientProtocol: Actor {
    func getAllStations() async throws -> AllStations
    func getCarrierInfo(code: String, system: String?) async throws -> CarrierInfo
    func getCopyright() async throws -> CopyrightInfo
    func getNearestCity(lat: Double, lng: Double, distance: Int?) async throws -> NearestCity
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations
    func getStationSchedule(station: String, date: String?) async throws -> StationSchedule
    func searchRoutes(from: String, to: String, date: String?) async throws -> SearchResults
    func getRouteStations(uid: String, from: String?, to: String?) async throws -> ThreadStations
}

