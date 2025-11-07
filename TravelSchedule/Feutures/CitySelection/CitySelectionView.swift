import SwiftUI

struct CitySelectionView: View {
    
    @Binding var selectedCity: String
    @Binding var path: [Route]
    @Binding var isPresented: Bool
    
    @State private var searchText = ""
    
    private let sampleCities = [
        "Москва",
        "Санкт-Петербург",
        "Сочи",
        "Горный воздух",
        "Краснодар",
        "Казань",
        "Омск"
    ]
    
    var body: some View {
        SelectionScreen(title: "Выбор города", onDismiss: {
            isPresented = false
        }) {
            SelectionList(
                items: sampleCities,
                searchText: $searchText,
                onItemSelected: { city in
                    path.append(.station(city: city))
                },
                showChevron: true,
                emptyMessage: "Город не найден"
            )
        }
    }
}
