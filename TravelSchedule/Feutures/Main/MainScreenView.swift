import SwiftUI

struct MainScreenView: View {
    
    @State private var fromCity: String = ""
    @State private var toCity: String = ""
    
    @State private var showFromCitySelection = false
    @State private var showToCitySelection = false
    @State private var showCarriers = false
    @State private var path: [Route] = []
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat = 208
        static let searchButtonWidth: CGFloat = 150
        static let searchButtonTopPadding: CGFloat = 16
    }
    
    private var isSearchButtonVisible: Bool {
        !fromCity.isEmpty && !toCity.isEmpty
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                MainView(
                    fromCity: $fromCity,
                    toCity: $toCity,
                    showFrom: { showFromCitySelection = true },
                    showTo: { showToCitySelection = true }
                )
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.top, Constants.topPadding)
                
                if isSearchButtonVisible {
                    SearchButton {
                        showCarriers = true
                    }
                    .frame(width: Constants.searchButtonWidth)
                    .padding(.top, Constants.searchButtonTopPadding)
                }
                
                Spacer()
            }
            .background(DS.surface.ignoresSafeArea())
            .toolbar(.visible, for: .tabBar)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .serverError:
                    ServerErrorView()
                case .noInternet:
                    NoInternetView()
                case .station, .carrierDetail, .filters:
                    EmptyView()
                }
            }
            .fullScreenCover(isPresented: $showFromCitySelection) {
                CitySelectionFullScreenView(
                    selectedCity: $fromCity,
                    isPresented: $showFromCitySelection
                )
            }
            .fullScreenCover(isPresented: $showToCitySelection) {
                CitySelectionFullScreenView(
                    selectedCity: $toCity,
                    isPresented: $showToCitySelection
                )
            }
            .fullScreenCover(isPresented: $showCarriers) {
                CarriersFullScreenView(
                    fromCity: fromCity,
                    toCity: toCity,
                    isPresented: $showCarriers
                )
            }
        }
    }
}
