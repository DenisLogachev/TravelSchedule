import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

final class AllStationsService {
    // MARK: - Constants
    private enum Constants {
        static let maxResponseSize = 50 * 1024 * 1024
    }
    
    // MARK: - Properties
    private let client: Client
    private let apikey: String
    
    // MARK: - Initialization
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }

    // MARK: - Public Methods
    func getAllStations() async throws -> AllStations {
        let response = try await client.getAllStations(query: .init(apikey: apikey))

        guard case let .ok(okResponse) = response else {
            throw URLError(.badServerResponse)
        }

        guard case let .text_html_charset_utf_hyphen_8(body) = okResponse.body else {
            throw URLError(.cannotParseResponse)
        }

        let data = try await Data(collecting: body, upTo: Constants.maxResponseSize)
        return try JSONDecoder().decode(AllStations.self, from: data)
    }
}
