import SwiftUI

struct MainScreenView: View {
    // MARK: - Properties
    @StateObject private var viewModel = MainScreenViewModel()
    
    @State private var showFromCitySelection = false
    @State private var showToCitySelection = false
    @State private var showCarriers = false
    @State private var showStories = false
    @State private var selectedStoryId: Int = 0
    @State private var path: [Route] = []
    
    // MARK: - Constants
    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let storiesTopPadding: CGFloat = 24
        static let mainViewTopPadding: CGFloat = 24
        static let searchButtonWidth: CGFloat = 150
        static let searchButtonTopPadding: CGFloat = 16
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: .zero) {
                StoriesView(
                    viewedStories: viewModel.viewedStories,
                    onStoryTap: { storyId in
                        Task { @MainActor in
                            selectedStoryId = storyId
                            showStories = true
                        }
                    }
                )
                .padding(.top, Constants.storiesTopPadding)
                
                MainView(
                    fromCity: $viewModel.fromCity,
                    toCity: $viewModel.toCity,
                    showFrom: { showFromCitySelection = true },
                    showTo: { showToCitySelection = true },
                    onSwap: { viewModel.swapCities() }
                )
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.top, Constants.mainViewTopPadding)
                
                if viewModel.isSearchButtonVisible {
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
                    selectedCity: $viewModel.fromCity,
                    isPresented: $showFromCitySelection
                )
            }
            .fullScreenCover(isPresented: $showToCitySelection) {
                CitySelectionFullScreenView(
                    selectedCity: $viewModel.toCity,
                    isPresented: $showToCitySelection
                )
            }
            .fullScreenCover(isPresented: $showCarriers) {
                CarriersFullScreenView(
                    fromCity: viewModel.fromCity,
                    toCity: viewModel.toCity,
                    isPresented: $showCarriers
                )
            }
        }
        .fullScreenCover(isPresented: $showStories) {
            StoriesFullScreenView(
                isPresented: $showStories,
                selectedStoryId: selectedStoryId,
                onStoryViewed: { storyId in
                    Task { @MainActor in
                        viewModel.markStoryAsViewed(storyId)
                    }
                }
            )
        }
    }
}
