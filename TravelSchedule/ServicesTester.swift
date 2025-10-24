import Foundation
import OpenAPIURLSession

final class ServicesTester {
    private let client: Client
    private let apikey: String
    
    init() throws {
        self.client = Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        )
        self.apikey = "API_KEY"
    }
    
    // MARK: - Public
    func testAll() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.testSearchService() }
            group.addTask { await self.testScheduleService() }
            group.addTask { await self.testThreadService() }
            group.addTask { await self.testNearestCityService() }
            group.addTask { await self.testCarrierService() }
            group.addTask { await self.testCopyrightService() }
            group.addTask { await self.testAllStationsService() }
            group.addTask { await self.testNearestStationsService() }
        }
    }
    
    // MARK: - Private service tests
    private func testSearchService() async {
        await run("SearchService") {
            let service = SearchService(client: self.client, apikey: self.apikey)
            let result = try await service.searchRoutes(from: "s9637148", to: "s9654496")
            print("Найдено маршрутов: \(result.segments?.count ?? 0)")
        }
    }
    
    private func testScheduleService() async {
        await run("ScheduleService") {
            let service = ScheduleService(client: self.client, apikey: self.apikey)
            let result = try await service.getStationSchedule(station: "s9602496")
            
            if let schedule = result.schedule, !schedule.isEmpty {
                for item in schedule.prefix(5) {
                    guard let thread = item.thread else {
                        print("Thread отсутствует")
                        continue
                    }
                    let title = thread.title
                    let departure = item.departure ?? "-"
                    let arrival = item.arrival ?? "-"
                    let days = item.days ?? "-"
                    let platform = item.platform ?? "-"
                    let terminal = item.terminal ?? "-"
                    let stops = item.stops ?? "-"
                    print("\(title): \(departure) → \(arrival), дни: \(days), платформа: \(platform), терминал: \(terminal), остановки: \(stops)")
                }
            } else {
                print("Расписание пустое")
            }
        }
    }
    
    private func testThreadService() async {
        await run("ThreadService") {
            let service = ThreadService(client: self.client, apikey: self.apikey)
            let result = try await service.getRouteStations(uid: "6509_1_9602496_g25_4")
            print("Количество остановок: \(result.stops?.count ?? 0)")
        }
    }
    
    private func testNearestCityService() async {
        await run("NearestCityService") {
            let service = NearestCityService(client: self.client, apikey: self.apikey)
            let result = try await service.getNearestCity(lat: 59.864177, lng: 30.319163)
            print("Ближайший город: \(result.title ?? "-")")
        }
    }
    
    private func testCarrierService() async {
        await run("CarrierService") {
            let service = CarrierService(client: self.client, apikey: self.apikey)
            let result = try await service.getCarrierInfo(code: "112")
            if let firstCarrier = result.carriers?.first {
                print("Carrier: \(firstCarrier.title ?? "-")")
            } else {
                print("Carrier отсутствует")
            }
        }
    }
    private func testCopyrightService() async {
        await run("CopyrightService") {
            let service = CopyrightService(client: self.client, apikey: self.apikey)
            let result = try await service.getCopyright()
            print("Copyright: \(result.copyright?.text ?? "-")")
        }
    }
    
    private func testAllStationsService() async {
        await run("AllStationsService") {
            let service = AllStationsService(client: self.client, apikey: self.apikey)
            let result = try await service.getAllStations()
            print("Всего станций: \(result.countries?.count ?? 0)")
        }
    }
    
    private func testNearestStationsService() async {
        await run("NearestStationsService") {
            let service = NearestStationsService(client: self.client, apikey: self.apikey)
            let result = try await service.getNearestStations(
                lat: 59.864177,
                lng: 30.319163,
                distance: 50
            )
            print("Найдено станций поблизости: \(result.stations?.count ?? 0)")
        }
    }
    
    // MARK: - Runner
    private func run<T>(_ title: String, block: @escaping () async throws -> T) async {
        log("Testing \(title)...", type: "⚙️")
        do {
            _ = try await block()
            print("✅ \(title) выполнен успешно\n")
        } catch {
            print("❌ \(title) ошибка: \(error)\n")
        }
    }
    
    // MARK: - Helpers
    private func log(_ message: String, type: String = "ℹ️") {
        print("\(type) \(message)")
    }
}
