import Foundation

@MainActor
class StationsCache: CacheProtocol {
    // MARK: - Singleton
    static let shared = StationsCache()
    
    // MARK: - Cache Properties
    private var cachedAllStations: AllStations?
    private var cachedCities: [City]?
    private var isLoading = false
    private var loadingTask: Task<AllStations, Error>?
    private let citiesExtractor: CitiesExtractorProtocol
    
    var hasCachedData: Bool {
        cachedAllStations != nil
    }
    
    var isCurrentlyLoading: Bool {
        isLoading
    }
    
    // MARK: - Initialization
    private init(citiesExtractor: CitiesExtractorProtocol = CitiesExtractor()) {
        self.citiesExtractor = citiesExtractor
    }
    
    // MARK: - Public Methods
    func getAllStations(using networkClient: NetworkClientProtocol) async throws -> AllStations {
        if let cached = cachedAllStations {
            return cached
        }
        
        if let existingTask = loadingTask {
            return try await existingTask.value
        }
        
        let task = Task<AllStations, Error> {
            let stations = try await networkClient.getAllStations()
            self.cachedAllStations = stations
            self.loadingTask = nil
            self.isLoading = false
            return stations
        }
        
        loadingTask = task
        isLoading = true
        
        return try await task.value
    }
    
    func getCities(using networkClient: NetworkClientProtocol) async throws -> [City] {
        if let cached = cachedCities {
            return cached
        }
        
        let allStations = try await getAllStations(using: networkClient)
        let cities = citiesExtractor.extractCities(from: allStations)
        
        cachedCities = cities
        return cities
    }
    
    func findCityCode(by cityName: String, using networkClient: NetworkClientProtocol) async throws -> String? {
        let cities = try await getCities(using: networkClient)
        let cityNameLower = cityName.lowercased()
        return cities.first(where: { $0.name.lowercased() == cityNameLower })?.id
    }
    
    func clearCache() {
        cachedAllStations = nil
        cachedCities = nil
        loadingTask?.cancel()
        loadingTask = nil
        isLoading = false
    }
    
    deinit {
        loadingTask?.cancel()
    }
}

