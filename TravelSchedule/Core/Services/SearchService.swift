import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

typealias SearchResults = Components.Schemas.Segments

protocol SearchServiceProtocol {
    func searchRoutes(from: String, to: String, date: String?) async throws -> SearchResults
}

final class SearchService: SearchServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func searchRoutes(from: String, to: String, date: String? = nil) async throws -> SearchResults {
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            date: date
        ))

        let searchResults = try response.ok.body.json
        
        return searchResults
    }
}
