import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

enum NetworkClientFactoryError: LocalizedError {
    case apiKeyNotFound
    case clientCreationFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .apiKeyNotFound:
            return "YandexScheduleAPIKey not found in Info.plist or is empty"
        case .clientCreationFailed(let error):
            return "Failed to create NetworkClient: \(error.localizedDescription)"
        }
    }
}

enum NetworkClientFactory {
    // MARK: - Constants
    private static let apiKeyKey = AppConstants.API.apiKeyKey
    
    private static func getApiKey() throws -> String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: apiKeyKey) as? String,
              !apiKey.isEmpty else {
            throw NetworkClientFactoryError.apiKeyNotFound
        }
        return apiKey
    }
    
    // MARK: - Client Creation
    private static func createClient() throws -> Client {
        return Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        )
    }
    
    // MARK: - Shared Instance
    static var shared: NetworkClient {
        get throws {
            do {
                let apiKey = try getApiKey()
                let client = try createClient()
                return NetworkClient(client: client, apikey: apiKey)
            } catch let error as NetworkClientFactoryError {
                throw error
            } catch {
                throw NetworkClientFactoryError.clientCreationFailed(error)
            }
        }
    }
    
    // MARK: - Factory Method
    static func create(apiKey: String? = nil) throws -> NetworkClient {
        let key: String
        if let providedKey = apiKey {
            key = providedKey
        } else {
            key = try getApiKey()
        }
        
        do {
            let client = try createClient()
            return NetworkClient(client: client, apikey: key)
        } catch {
            throw NetworkClientFactoryError.clientCreationFailed(error)
        }
    }
    
    // MARK: - Helper for Views
    static func makeShared() throws -> NetworkClient {
        return try shared
    }
    
    // MARK: - Helper for SwiftUI Views (non-throwing)
    static func makeSharedOrFatal() -> NetworkClient {
        do {
            return try shared
        } catch {
            fatalError("Failed to create NetworkClient: \(error.localizedDescription)")
        }
    }
}
