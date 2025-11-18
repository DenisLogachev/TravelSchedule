import SwiftUI

struct CitySelectionView: View {
    @Binding var selectedCity: String
    @Binding var path: [Route]
    @Binding var isPresented: Bool
    
    @StateObject private var viewModel: CitySelectionViewModel = {
        CitySelectionViewModel(networkClient: NetworkClientFactory.makeSharedOrFatal())
    }()
    
    var body: some View {
        SelectionScreen(title: "Выбор города", onDismiss: {
            isPresented = false
        }) {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    SelectionList(
                        items: viewModel.filteredCities.map { $0.name },
                        searchText: $viewModel.searchText,
                        onItemSelected: { cityName in
                            if let city = viewModel.filteredCities.first(where: { $0.name == cityName }) {
                                path.append(.station(city: city))
                            }
                        },
                        showChevron: true,
                        emptyMessage: "Город не найден"
                    )
                }
            }
        }
        .task {
            await viewModel.loadCities()
        }
        .onChange(of: viewModel.appError) { error in
            if let route = viewModel.getErrorRoute(), !path.contains(route) {
                path.append(route)
            }
        }
    }
}
