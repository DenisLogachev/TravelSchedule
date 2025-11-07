import SwiftUI

struct StationSelectionView: View {
    
    let city: String
    @Binding var selectedCity: String
    @Binding var path: [Route]
    @Binding var isPresented: Bool
    
    @State private var searchText = ""
    
    private let sampleStations = [
        "Станция 1",
        "Станция 2",
        "Станция 3",
        "Станция 4",
        "Станция 5",
        "Станция 6",
        "Станция 7",
        "Станция 8",
    ]
    
    var body: some View {
        SelectionScreen(title: "Выбор станции") {
            SelectionList(
                items: sampleStations,
                searchText: $searchText,
                onItemSelected: { station in
                    selectedCity = "\(city) (\(station))"
                    path.removeAll()
                    isPresented = false
                },
                showChevron: false,
                emptyMessage: "Станция не найдена"
            )
        }
    }
}
