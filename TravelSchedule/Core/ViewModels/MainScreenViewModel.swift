import Foundation
import SwiftUI
import Combine

@MainActor
class MainScreenViewModel: BaseViewModel {
    // MARK: - Published Properties
    @Published var fromCity: String = ""
    @Published var toCity: String = ""
    @Published var viewedStories: Set<Int> = []
    
    // MARK: - Computed Properties
    var isSearchButtonVisible: Bool {
        !fromCity.isEmpty && !toCity.isEmpty
    }
    
    // MARK: - Public Methods
    func swapCities() {
        (fromCity, toCity) = (toCity, fromCity)
    }
    
    func markStoryAsViewed(_ storyId: Int) {
        viewedStories.insert(storyId)
    }
}
