import Foundation
import SwiftUI
import Combine

@MainActor
class StationSelectionViewModel: BaseViewModel, FilterableViewModel {
    // MARK: - FilterableViewModel Conformance
    typealias Item = String
    @Published var items: [String] = [] {
        didSet {
            filteredItems = items
        }
    }
    @Published var filteredItems: [String] = []
    
    func filterKey(for item: String) -> String {
        return item
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
    private let stationsExtractor: StationsExtractorProtocol
    
    // MARK: - Initialization
    init(
        networkClient: NetworkClientProtocol,
        cache: CacheProtocol = StationsCache.shared,
        stationsExtractor: StationsExtractorProtocol = StationsExtractor()
    ) {
        self.networkClient = networkClient
        self.cache = cache
        self.stationsExtractor = stationsExtractor
    }
    
    // MARK: - Computed Properties
    var stations: [String] {
        get { items }
        set { items = newValue }
    }
    
    var filteredStations: [String] {
        get { filteredItems }
        set { filteredItems = newValue }
    }
    
    // MARK: - Public Methods
    func loadStations(for cityCode: String) async {
        await executeWithLoading(
            operation: { [weak self] in
                guard let self = self else { throw CancellationError() }
                let allStations = try await self.cache.getAllStations(using: self.networkClient)
                return self.stationsExtractor.extractStations(for: cityCode, from: allStations)
            },
            onSuccess: { [weak self] extractedStations in
                self?.stations = extractedStations
            },
            onError: { [weak self] _ in
                self?.stations = []
            }
        )
    }
}
