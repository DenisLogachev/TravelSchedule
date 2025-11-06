import SwiftUI

struct CarriersFullScreenView: View {
    
    let fromCity: String
    let toCity: String
    @Binding var isPresented: Bool
    
    @State private var path: [Route] = []
    @State private var filters: RouteFilters = .default
    
    var body: some View {
        NavigationStack(path: $path) {
            CarriersListView(
                fromCity: fromCity,
                toCity: toCity,
                path: $path,
                isPresented: $isPresented,
                filters: $filters
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .carrierDetail(let carrierID):
                    CarrierCardView(carrierID: carrierID)
                case .filters:
                    FiltersView(
                        filters: $filters,
                        path: $path
                    )
                case .serverError:
                    ServerErrorView()
                case .noInternet:
                    NoInternetView()
                default:
                    EmptyView()
                }
            }
        }
    }
}

