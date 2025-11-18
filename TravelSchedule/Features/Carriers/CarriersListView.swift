import SwiftUI

struct CarriersListView: View {
    // MARK: - Properties
    let fromCity: String
    let toCity: String
    @Binding var path: [Route]
    var isPresented: Binding<Bool>?
    @Binding var filters: RouteFilters
    
    @StateObject private var viewModel: CarriersListViewModel = {
        CarriersListViewModel(networkClient: NetworkClientFactory.makeSharedOrFatal())
    }()
    
    // MARK: - Constants
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
    
    // MARK: - Body
    var body: some View {
        SelectionScreen(title: "", onDismiss: {
            isPresented?.wrappedValue = false
        }) {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    Text(viewModel.routeTitle)
                        .font(.system(size: Constants.titleFontSize, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(3)
                        .padding([.horizontal, .top, .bottom], Constants.horizontalPadding)
                    
                    if viewModel.isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                            Text("Поиск маршрутов...")
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            if viewModel.filteredRoutes.isEmpty {
                                VStack {
                                    Text("Вариантов нет")
                                        .font(.system(size: Constants.titleFontSize, weight: .bold))
                                        .foregroundStyle(.primary)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding(.top, Constants.emptyStateTopPadding)
                                }
                                .frame(height: Constants.emptyStateHeight)
                            } else {
                                VStack(spacing: 0) {
                                    ForEach(viewModel.filteredRoutes) { route in
                                        CarrierRouteCell(route: route) {
                                            let carrierID = route.carrierCode.map { "\($0)" } ?? route.carrierName
                                            path.append(.carrierDetail(carrierID: carrierID, carrierName: route.carrierName))
                                        }
                                    }
                                }
                                .padding(.bottom, Constants.routesBottomPadding)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                
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
        }
        .task {
            await viewModel.loadRoutes(from: fromCity, to: toCity)
        }
        .onChange(of: filters) { newFilters in
            viewModel.filters = newFilters
        }
        .onChange(of: viewModel.appError) { error in
            if let route = viewModel.getErrorRoute(), !path.contains(route) {
                path.append(route)
            }
        }
    }
}
