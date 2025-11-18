import SwiftUI

struct CarrierCardView: View {
    let carrierID: String
    let carrierName: String?
    @Binding var path: [Route]
    
    @StateObject private var viewModel: CarrierCardViewModel
    
    // MARK: - Initialization
    init(carrierID: String, carrierName: String? = nil, path: Binding<[Route]>) {
        self.carrierID = carrierID
        self.carrierName = carrierName
        self._path = path
        self._viewModel = StateObject(wrappedValue: CarrierCardViewModel(
            carrierID: carrierID,
            carrierName: carrierName,
            networkClient: NetworkClientFactory.makeSharedOrFatal()
        ))
    }
    
    // MARK: - Constants
    private enum Constants {
        static let logoTopPadding: CGFloat = 24
        static let vStackSpacing: CGFloat = 24
        static let horizontalPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 24
        static let titleFontSize: CGFloat = 24
        static let imageHeight: CGFloat = 104
        static let imageTopPadding: CGFloat = 29
        static let imageCornerRadius: CGFloat = 24
        static let imageHorizontalPadding: CGFloat = 16
    }
    
    // MARK: - Body
    var body: some View {
        SelectionScreen(title: "Информация о перевозчике") {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: .zero) {
                        CarrierLogoView(
                            logoURL: viewModel.carrierLogoURL,
                            height: Constants.imageHeight,
                            cornerRadius: Constants.imageCornerRadius
                        )
                        .padding(.horizontal, Constants.imageHorizontalPadding)
                        .padding(.top, Constants.imageTopPadding)
                        
                        VStack(spacing: Constants.vStackSpacing) {
                            Text(viewModel.carrierFullName)
                                .font(.system(size: Constants.titleFontSize, weight: .bold))
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ContactInfoView(title: "E-mail", value: viewModel.carrierEmail)
                            ContactInfoView(title: "Телефон", value: viewModel.carrierPhone)
                            
                            Spacer()
                        }
                        .padding(.horizontal, Constants.horizontalPadding)
                        .padding(.top, Constants.logoTopPadding)
                        .padding(.bottom, Constants.bottomPadding)
                    }
                }
                .background(DesignSystem.surface.ignoresSafeArea())
            }
        }
        .task {
            await viewModel.loadCarrierInfo()
        }
        .onChange(of: viewModel.appError) {
            if let route = viewModel.getErrorRoute(), !path.contains(route) {
                path.append(route)
            }
        }
    }
}

