import SwiftUI

struct FiltersView: View {
    
    @Binding var filters: RouteFilters
    @Binding var path: [Route]
    
    @State private var selectedTimeRanges: Set<TimeRange> = []
    @State private var showTransfers: Bool? = nil
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 24
        static let itemSpacing: CGFloat = 16
        static let rowHeight: CGFloat = 60
        static let titleFontSize: CGFloat = 24
        static let textFontSize: CGFloat = 17
        static let buttonFontSize: CGFloat = 17
        static let buttonHeight: CGFloat = 60
        static let buttonCornerRadius: CGFloat = 16
        static let textTracking: CGFloat = -0.41
    }
    
    var body: some View {
        SelectionScreen(title: "", onDismiss: {
            if !hasSelectedFilters {
                filters.departureTimeRanges = []
                filters.showTransfers = nil
            }
            path.removeLast()
        }) {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: Constants.sectionSpacing) {
                        VStack(alignment: .leading, spacing: Constants.itemSpacing) {
                            Text("Время отправления")
                                .font(.system(size: Constants.titleFontSize, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.horizontal, Constants.horizontalPadding)
                            
                            VStack(spacing: 0) {
                                ForEach(TimeRange.allCases, id: \.self) { timeRange in
                                    HStack {
                                        Text("\(timeRange.label) \(timeRange.rawValue)")
                                            .font(.system(size: Constants.textFontSize))
                                            .tracking(Constants.textTracking)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        CheckboxView(isSelected: selectedTimeRanges.contains(timeRange))
                                    }
                                    .frame(height: Constants.rowHeight)
                                    .padding(.horizontal, Constants.horizontalPadding)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        if selectedTimeRanges.contains(timeRange) {
                                            selectedTimeRanges.remove(timeRange)
                                        } else {
                                            selectedTimeRanges.insert(timeRange)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, Constants.sectionSpacing)
                        
                        VStack(alignment: .leading, spacing: Constants.itemSpacing) {
                            Text("Показывать варианты с пересадками")
                                .font(.system(size: Constants.titleFontSize, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.horizontal, Constants.horizontalPadding)
                            
                            VStack(spacing: 0) {
                                HStack {
                                    Text("Да")
                                        .font(.system(size: Constants.textFontSize))
                                        .tracking(Constants.textTracking)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    RadioButtonView(isSelected: showTransfers == true)
                                }
                                .frame(height: Constants.rowHeight)
                                .padding(.horizontal, Constants.horizontalPadding)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if showTransfers == true {
                                        showTransfers = nil
                                    } else {
                                        showTransfers = true
                                    }
                                }
                                
                                HStack {
                                    Text("Нет")
                                        .font(.system(size: Constants.textFontSize))
                                        .tracking(Constants.textTracking)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    RadioButtonView(isSelected: showTransfers == false)
                                }
                                .frame(height: Constants.rowHeight)
                                .padding(.horizontal, Constants.horizontalPadding)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if showTransfers == false {
                                        showTransfers = nil
                                    } else {
                                        showTransfers = false
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                if hasSelectedFilters {
                    Button {
                        applyFilters()
                    } label: {
                        Text("Применить")
                            .font(.system(size: Constants.buttonFontSize, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: Constants.buttonHeight)
                            .background(DS.primaryAccent)
                            .cornerRadius(Constants.buttonCornerRadius)
                    }
                    .padding([.horizontal, .top, .bottom], Constants.horizontalPadding)
                }
            }
        }
        .onAppear {
            selectedTimeRanges = filters.departureTimeRanges
            showTransfers = filters.showTransfers
        }
    }
    
    private var hasSelectedFilters: Bool {
        !selectedTimeRanges.isEmpty || showTransfers != nil
    }
    
    private func applyFilters() {
        filters.departureTimeRanges = selectedTimeRanges
        filters.showTransfers = showTransfers
        path.removeLast()
    }
}
