import Foundation
import SwiftUI
import Combine

@MainActor
class CitySelectionViewModel: BaseViewModel, FilterableViewModel {
    // MARK: - FilterableViewModel Conformance
    typealias Item = City
    @Published var items: [City] = [] {
        didSet {
            filteredItems = items
        }
    }
    @Published var filteredItems: [City] = []
    
    func filterKey(for item: City) -> String {
        return item.name
    }
    
    // MARK: - Published Properties
    @Published var searchText: String = "" {
        didSet {
            filter(by: searchText)
        }
    }
    
    // MARK: - Private Properties
    private let networkClient: NetworkClientProtocol
    private let cache: CacheProtocol
    
    // MARK: - Initialization
    init(
        networkClient: NetworkClientProtocol,
        cache: CacheProtocol = StationsCache.shared
    ) {
        self.networkClient = networkClient
        self.cache = cache
    }
    
    // MARK: - Computed Properties
    var cities: [City] {
        get { items }
        set { items = newValue }
    }
    
    var filteredCities: [City] {
        get { filteredItems }
        set { filteredItems = newValue }
    }
    
    // MARK: - Public Methods
    func loadCities() async {
        if cache.hasCachedData || cache.isCurrentlyLoading {
            await executeWithLoading(
                operation: { [weak self] in
                    guard let self = self else { throw CancellationError() }
                    return try await self.cache.getCities(using: self.networkClient)
                },
                onSuccess: { [weak self] loadedCities in
                    self?.cities = loadedCities
                },
                onError: { [weak self] _ in
                    self?.cities = []
                }
            )
            return
        }
        
        await executeWithLoading(
            operation: { [weak self] in
                guard let self = self else { throw CancellationError() }
                return try await self.cache.getCities(using: self.networkClient)
            },
            onSuccess: { [weak self] loadedCities in
                self?.cities = loadedCities
            },
            onError: { [weak self] _ in
                self?.cities = []
            }
        )
    }
}
