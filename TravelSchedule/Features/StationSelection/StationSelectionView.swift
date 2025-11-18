import SwiftUI

struct StationSelectionView: View {
    let city: City
    @Binding var selectedCity: String
    @Binding var path: [Route]
    @Binding var isPresented: Bool
    
    @StateObject private var viewModel: StationSelectionViewModel = {
        StationSelectionViewModel(networkClient: NetworkClientFactory.makeSharedOrFatal())
    }()
    
    var body: some View {
        SelectionScreen(title: "Выбор станции") {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    SelectionList(
                        items: viewModel.filteredStations,
                        searchText: $viewModel.searchText,
                        onItemSelected: { station in
                            selectedCity = StationNameFormatter.formatCityStation(city: city.name, station: station)
                            path.removeAll()
                            isPresented = false
                        },
                        showChevron: false,
                        emptyMessage: "Станция не найдена"
                    )
                }
            }
        }
        .task {
            await viewModel.loadStations(for: city.id)
        }
        .onChange(of: viewModel.appError) {
            if let route = viewModel.getErrorRoute(), !path.contains(route) {
                path.append(route)
            }
        }
    }
}
