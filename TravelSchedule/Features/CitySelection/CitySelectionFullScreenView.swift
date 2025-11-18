import SwiftUI

struct CitySelectionFullScreenView: View {
    
    @Binding var selectedCity: String
    @Binding var isPresented: Bool
    
    @State private var path: [Route] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            CitySelectionView(
                selectedCity: $selectedCity,
                path: $path,
                isPresented: $isPresented
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .station(let city):
                    StationSelectionView(
                        city: city,
                        selectedCity: $selectedCity,
                        path: $path,
                        isPresented: $isPresented
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

