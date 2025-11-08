import SwiftUI

struct MainScreenView: View {
    // MARK: - Properties
    @State private var fromCity: String = ""
    @State private var toCity: String = ""
    
    @State private var showFromCitySelection = false
    @State private var showToCitySelection = false
    @State private var showCarriers = false
    @State private var showStories = false
    @State private var selectedStoryId: Int = 0
    @State private var viewedStories: Set<Int> = []
    @State private var path: [Route] = []
    
    // MARK: - Constants
    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let storiesTopPadding: CGFloat = 24
        static let mainViewTopPadding: CGFloat = 24
        static let searchButtonWidth: CGFloat = 150
        static let searchButtonTopPadding: CGFloat = 16
    }
    
    // MARK: - Computed Properties
    private var isSearchButtonVisible: Bool {
        !fromCity.isEmpty && !toCity.isEmpty
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                StoriesView(
                    viewedStories: viewedStories,
                    onStoryTap: { storyId in
                        selectedStoryId = storyId
                        showStories = true
                    }
                )
                .padding(.top, Constants.storiesTopPadding)
                
                MainView(
                    fromCity: $fromCity,
                    toCity: $toCity,
                    showFrom: { showFromCitySelection = true },
                    showTo: { showToCitySelection = true }
                )
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.top, Constants.mainViewTopPadding)
                
                if isSearchButtonVisible {
                    SearchButton {
                        showCarriers = true
                    }
                    .frame(width: Constants.searchButtonWidth)
                    .padding(.top, Constants.searchButtonTopPadding)
                }
                
                Spacer()
            }
            .background(DesignSystem.surface.ignoresSafeArea())
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
            .fullScreenCover(isPresented: $showStories) {
                StoriesFullScreenView(
                    isPresented: $showStories,
                    selectedStoryId: selectedStoryId,
                    onStoryViewed: { storyId in
                        viewedStories.insert(storyId)
                    }
                )
            }
        }
    }
}
