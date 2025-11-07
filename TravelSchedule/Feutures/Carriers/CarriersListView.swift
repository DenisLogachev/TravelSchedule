import SwiftUI

struct CarriersListView: View {
    
    let fromCity: String
    let toCity: String
    @Binding var path: [Route]
    var isPresented: Binding<Bool>?
    @Binding var filters: RouteFilters
    
    private let allRoutes: [CarrierRoute] = [
        CarrierRoute(
            carrierName: "РЖД",
            carrierLogo: CarrierLogos.rzhd,
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "14 января",
            transferStation: "Костроме"
        ),
        CarrierRoute(
            carrierName: "ФГК",
            carrierLogo: CarrierLogos.fgk,
            departureTime: "01:15",
            arrivalTime: "09:00",
            duration: "9 часов",
            date: "15 января",
            transferStation: nil
        ),
        CarrierRoute(
            carrierName: "Урал логистика",
            carrierLogo: CarrierLogos.uralLogistics,
            departureTime: "12:30",
            arrivalTime: "21:00",
            duration: "9 часов",
            date: "16 января",
            transferStation: nil
        ),
        CarrierRoute(
            carrierName: "РЖД",
            carrierLogo: CarrierLogos.rzhd,
            departureTime: "22:30",
            arrivalTime: "08:15",
            duration: "20 часов",
            date: "17 января",
            transferStation: "Костроме"
        ),
        CarrierRoute(
            carrierName: "РЖД",
            carrierLogo: CarrierLogos.rzhd,
            departureTime: "15:00",
            arrivalTime: "21:15",
            duration: "6 часов",
            date: "17 января",
            transferStation: nil
        ),
        CarrierRoute(
            carrierName: "РЖД",
            carrierLogo: CarrierLogos.rzhd,
            departureTime: "20:30",
            arrivalTime: "02:15",
            duration: "5 часов",
            date: "17 января",
            transferStation: nil
        )
    ]
    
    private var routeTitle: String {
        return "\(fromCity) → \(toCity)"
    }
    
    private var routes: [CarrierRoute] {
        allRoutes.filter { route in
            let matchesTransfers = filters.showTransfers.map { showTransfers in
                showTransfers || route.transferStation == nil
            } ?? true
            
            let matchesTimeRange = filters.departureTimeRanges.isEmpty || filters.departureTimeRanges.contains { timeRange in
                isTimeInRange(route.departureTime, timeRange: timeRange)
            }
            
            return matchesTransfers && matchesTimeRange
        }
    }
    
    private func isTimeInRange(_ departureTime: String, timeRange: TimeRange) -> Bool {
        let routeMinutes = timeToMinutes(departureTime)
        guard routeMinutes >= 0 else { return false }
        
        let fromMinutes = timeToMinutes(timeRange.timeFrom)
        let toMinutes = timeToMinutes(timeRange.timeTo)
        
        let crossesMidnight = toMinutes < fromMinutes
        
        if crossesMidnight {
            return routeMinutes >= fromMinutes || routeMinutes < toMinutes
        } else {
            return routeMinutes >= fromMinutes && routeMinutes < toMinutes
        }
    }
    
    private func timeToMinutes(_ time: String) -> Int {
        let components = time.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2,
              components[0] >= 0 && components[0] < 24,
              components[1] >= 0 && components[1] < 60 else {
            return -1
        }
        return components[0] * 60 + components[1]
    }
    
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
    
    var body: some View {
        SelectionScreen(title: "", onDismiss: {
            isPresented?.wrappedValue = false
        }) {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    Text(routeTitle)
                        .font(.system(size: Constants.titleFontSize, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(3)
                        .padding([.horizontal, .top, .bottom], Constants.horizontalPadding)
                    
                    ScrollView {
                        if routes.isEmpty {
                            VStack {
                                Text("Вариантов нет")
                                    .font(.system(size: Constants.titleFontSize, weight: .bold))
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(.top, Constants.emptyStateTopPadding)
                            }
                            .frame(height: Constants.emptyStateHeight)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(routes) { route in
                                    CarrierRouteCell(route: route) {
                                        path.append(.carrierDetail(carrierID: route.carrierName))
                                    }
                                }
                            }
                            .padding(.bottom, Constants.routesBottomPadding)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Button {
                    path.append(.filters)
                } label: {
                    HStack(spacing: Constants.buttonSpacing) {
                        Text("Уточнить время")
                            .font(.system(size: Constants.buttonFontSize, weight: .bold))
                            .foregroundColor(.white)
                        
                        if filters.hasActiveFilters {
                            Circle()
                                .fill(DS.accentColor)
                                .frame(width: Constants.indicatorSize, height: Constants.indicatorSize)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: Constants.buttonHeight)
                    .background(DS.primaryAccent)
                    .cornerRadius(Constants.buttonCornerRadius)
                }
                .padding([.horizontal, .top, .bottom], Constants.horizontalPadding)
            }
        }
    }
}


