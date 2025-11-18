import Foundation
import SwiftUI
import Combine

@MainActor
class CarriersListViewModel: BaseViewModel {
    // MARK: - Published Properties
    @Published var routes: [CarrierRoute] = []
    @Published var filteredRoutes: [CarrierRoute] = []
    
    var filters: RouteFilters = .default {
        didSet {
            applyFilters()
        }
    }
    
    // MARK: - Private Properties
    private let networkClient: NetworkClientProtocol
    private let cache: CacheProtocol
    private let stationSearch: StationSearchProtocol
    private let cityStationParser: CityStationParserProtocol
    private let routeMapper: CarrierRouteMapperProtocol
    
    private var fromCity: String = ""
    private var toCity: String = ""
    
    // MARK: - Computed Properties
    var routeTitle: String {
        "\(fromCity) → \(toCity)"
    }
    
    // MARK: - Initialization
    init(
        networkClient: NetworkClientProtocol,
        cache: CacheProtocol = StationsCache.shared,
        stationSearch: StationSearchProtocol = StationSearchService.shared,
        cityStationParser: CityStationParserProtocol = CityStationParser(),
        routeMapper: CarrierRouteMapperProtocol = CarrierRouteMapper()
    ) {
        self.networkClient = networkClient
        self.cache = cache
        self.stationSearch = stationSearch
        self.cityStationParser = cityStationParser
        self.routeMapper = routeMapper
    }
    
    // MARK: - Public Methods
    func loadRoutes(from: String, to: String) async {
        guard !isLoading else { return }
        
        self.fromCity = from
        self.toCity = to
        
        startLoading()
        routes = []
        filteredRoutes = []
        
        do {
            let allStations = try await cache.getAllStations(using: networkClient)
            
            guard !Task.isCancelled else {
                stopLoading()
                return
            }
            
            let fromParsed = cityStationParser.parseCityAndStation(from)
            let toParsed = cityStationParser.parseCityAndStation(to)
            
            guard let fromCityCode = try await cache.findCityCode(by: fromParsed.city, using: networkClient),
                  let toCityCode = try await cache.findCityCode(by: toParsed.city, using: networkClient) else {
                routes = []
                filteredRoutes = []
                stopLoading()
                return
            }
            
            let fromStationCode = await findStationCode(cityCode: fromCityCode, stationName: fromParsed.station, in: allStations)
            let toStationCode = await findStationCode(cityCode: toCityCode, stationName: toParsed.station, in: allStations)
            
            guard let fromCode = fromStationCode,
                  let toCode = toStationCode else {
                routes = []
                filteredRoutes = []
                stopLoading()
                return
            }
            
            let searchDate = DateFormattingUtils.formatSearchDate()
            
            let searchResults: SearchResults
            do {
                searchResults = try await withTimeout(seconds: 30) {
                    try await self.networkClient.searchRoutes(
                        from: fromCode,
                        to: toCode,
                        date: searchDate
                    )
                }
            } catch {
                if !handleError(error) {
                    routes = []
                    filteredRoutes = []
                }
                stopLoading()
                return
            }
            
            guard !Task.isCancelled else {
                stopLoading()
                return
            }
            
            routes = routeMapper.convertSearchResultsToCarrierRoutes(searchResults)
            routes.sort { TimeUtils.timeToMinutes($0.departureTime) < TimeUtils.timeToMinutes($1.departureTime) }
            
            applyFilters()
        } catch {
            if !handleError(error) {
                routes = []
                filteredRoutes = []
            }
            return
        }
        
        stopLoading()
    }
    
    func applyFilters() {
        filteredRoutes = routes.filter { route in
            let matchesTransfers = filters.showTransfers.map { showTransfers in
                showTransfers || route.transferStation == nil
            } ?? true
            
            let matchesTimeRange = filters.departureTimeRanges.isEmpty || filters.departureTimeRanges.contains { timeRange in
                TimeUtils.isTimeInRange(route.departureTime, timeRange: timeRange)
            }
            
            return matchesTransfers && matchesTimeRange
        }
    }
    
    // MARK: - Private Methods
    private func findStationCode(cityCode: String, stationName: String?, in allStations: AllStations) async -> String? {
        if let stationName = stationName {
            return await stationSearch.findSpecificStationCode(
                cityCode: cityCode,
                stationName: stationName,
                in: allStations
            )
        } else {
            return await stationSearch.findStationCode(for: cityCode, in: allStations)
        }
    }
}
