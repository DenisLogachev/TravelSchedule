import SwiftUI

private enum Constants {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 16
    static let titleFontSize: CGFloat = 24
    static let buttonFontSize: CGFloat = 17
    static let buttonHeight: CGFloat = 60
    static let buttonCornerRadius: CGFloat = 16
    static let buttonSpacing: CGFloat = 8
    static let indicatorSize: CGFloat = 8
    static let emptyStateTopPadding: CGFloat = 100
    static let emptyStateHeight: CGFloat = 300
    static let routesBottomPadding: CGFloat = 100
}

// MARK: - CarriersListView
struct CarriersListView: View {
    
    // MARK: - Properties
    let fromCity: String
    let toCity: String
    var isPresented: Binding<Bool>?
    
    @Binding var path: [Route]
    @Binding var filters: RouteFilters
    
    // MARK: - ViewModel
    @StateObject private var viewModel: CarriersListViewModel = {
        CarriersListViewModel(networkClient: NetworkClientFactory.makeSharedOrFatal())
    }()
    
    // MARK: - Content
    var body: some View {
        SelectionScreen(title: "", onDismiss: dismissView) {
            ZStack(alignment: .bottom) {
                content
                footerButtons
            }
        }
        .task {
            await viewModel.loadRoutes(from: fromCity, to: toCity)
        }
        .onChange(of: filters) {
            viewModel.filters = filters
        }
        .onChange(of: viewModel.appError) {
            if let route = viewModel.getErrorRoute(), !path.contains(route) {
                path.append(route)
            }
        }
    }
    
    // MARK: - Views
    @ViewBuilder
    private var content: some View {
        VStack(spacing: .zero) {
            titleView
            
            if viewModel.isLoading {
                loadingView
            } else {
                routesScroll
            }
        }
    }
    
    private var titleView: some View {
        Text(viewModel.routeTitle)
            .font(.system(size: Constants.titleFontSize, weight: .semibold))
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(3)
            .padding([.horizontal, .top, .bottom], Constants.horizontalPadding)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Поиск маршрутов...")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var routesScroll: some View {
        ScrollView {
            if viewModel.filteredRoutes.isEmpty {
                emptyStateView
            } else {
                routesList
                    .padding(.bottom, Constants.routesBottomPadding)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack {
            Text("Вариантов нет")
                .font(.system(size: Constants.titleFontSize, weight: .bold))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, Constants.emptyStateTopPadding)
        }
        .frame(height: Constants.emptyStateHeight)
    }
    
    private var routesList: some View {
        VStack(spacing: .zero) {
            ForEach(viewModel.filteredRoutes) { route in
                CarrierRouteCell(route: route) {
                    let carrierID = route.carrierCode.map { "\($0)" } ?? route.carrierName
                    path.append(.carrierDetail(carrierID: carrierID, carrierName: route.carrierName))
                }
            }
        }
    }
    
    private var footerButtons: some View {
        VStack(spacing: Constants.buttonSpacing) {
            Button {
                path.append(.filters)
            } label: {
                HStack(spacing: Constants.buttonSpacing) {
                    Text("Уточнить время")
                        .font(.system(size: Constants.buttonFontSize, weight: .bold))
                        .foregroundStyle(.white)
                    
                    if filters.hasActiveFilters {
                        Circle()
                            .fill(DesignSystem.accentColor)
                            .frame(width: Constants.indicatorSize, height: Constants.indicatorSize)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: Constants.buttonHeight)
                .background(DesignSystem.primaryAccent)
                .clipShape(RoundedRectangle(cornerRadius: Constants.buttonCornerRadius))
            }
        }
        .padding([.horizontal, .top, .bottom], Constants.horizontalPadding)
    }
    
    // MARK: - Actions
    private func dismissView() {
        isPresented?.wrappedValue = false
    }
}
