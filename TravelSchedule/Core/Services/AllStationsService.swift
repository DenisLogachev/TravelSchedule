import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

typealias AllStations = Components.Schemas.AllStationsResponse

protocol AllStationsServiceProtocol {
    func getAllStations() async throws -> AllStations
}

final class AllStationsService: AllStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    private enum Constants {
        static let maxResponseSize = 50 * 1024 * 1024
    }

    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    func getAllStations() async throws -> AllStations {
        let response = try await client.getAllStations(query: .init(apikey: apikey))

        guard case let .ok(okResponse) = response else {
            throw URLError(.badServerResponse)
        }

        guard case let .text_html_charset_utf_hyphen_8(body) = okResponse.body else {
            throw URLError(.cannotParseResponse)
        }

        let data = try await Data(collecting: body, upTo: Constants.maxResponseSize)

        let decoded = try JSONDecoder().decode(AllStations.self, from: data)
        return decoded
    }
}
