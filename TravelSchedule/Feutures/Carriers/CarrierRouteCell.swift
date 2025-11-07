import SwiftUI

struct CarrierRouteCell: View {
    let route: CarrierRoute
    let onTap: () -> Void
    
    private enum Constants {
        static let cellHeight: CGFloat = 104
        static let cellCornerRadius: CGFloat = 24
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
        static let topPadding: CGFloat = 8
        static let vStackSpacing: CGFloat = 12
        static let hStackSpacing: CGFloat = 8
        static let timeLineHeight: CGFloat = 20
        static let logoSize: CGFloat = 38
        static let titleFontSize: CGFloat = 17
        static let subtitleFontSize: CGFloat = 12
        static let dateTopPadding: CGFloat = 16
        static let dateTrailingPadding: CGFloat = 16
        static let timeLineBackgroundOpacity: Double = 0.3
        static let timeLineHorizontalPadding: CGFloat = 8
        static let transferInfoSpacing: CGFloat = 4
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: Constants.vStackSpacing) {
                    HStack {
                        CarrierLogoView(
                            logoName: route.carrierLogo ?? CarrierLogos.trainSymbol,
                            size: Constants.logoSize
                        )
                        
                        VStack(alignment: .leading, spacing: Constants.transferInfoSpacing) {
                            Text(route.carrierName)
                                .font(.system(size: Constants.titleFontSize))
                                .foregroundColor(.black)
                            
                            if let transferStation = route.transferStation {
                                Text("С пересадкой в \(transferStation)")
                                    .font(.system(size: Constants.subtitleFontSize))
                                    .foregroundColor(DS.accentColor)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    HStack(spacing: Constants.hStackSpacing) {
                        Text(route.departureTime)
                            .font(.system(size: Constants.titleFontSize))
                            .foregroundColor(.black)
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(Constants.timeLineBackgroundOpacity))
                                .frame(height: 1)
                            
                            Text(route.duration)
                                .font(.system(size: Constants.subtitleFontSize))
                                .foregroundColor(.black)
                                .tracking(0.4)
                                .padding(.horizontal, Constants.timeLineHorizontalPadding)
                                .background(DS.cellBackground)
                        }
                        
                        Text(route.arrivalTime)
                            .font(.system(size: Constants.titleFontSize))
                            .foregroundColor(.black)
                    }
                    .frame(height: Constants.timeLineHeight)
                }
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.vertical, Constants.verticalPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(route.date)
                    .font(.system(size: Constants.subtitleFontSize))
                    .foregroundColor(.black)
                    .tracking(0.4)
                    .padding(.top, Constants.dateTopPadding)
                    .padding(.trailing, Constants.dateTrailingPadding)
            }
            .frame(maxWidth: .infinity, minHeight: Constants.cellHeight, alignment: .leading)
            .background(DS.cellBackground)
            .cornerRadius(Constants.cellCornerRadius)
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.top, Constants.topPadding)
    }
}

