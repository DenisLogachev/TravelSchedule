import SwiftUI

struct MainView: View {
    @Binding var fromCity: String
    @Binding var toCity: String
    let showFrom: () -> Void
    let showTo: () -> Void
    
    private enum Constants {
        static let hStackSpacing: CGFloat = 12
        static let cornerRadius: CGFloat = 12
        static let swapButtonSize: CGFloat = 36
        static let swapButtonFontSize: CGFloat = 16
        static let shadowOpacity: Double = 0.1
        static let shadowRadius: CGFloat = 4
        static let shadowY: CGFloat = 2
        static let padding: CGFloat = 16
        static let containerCornerRadius: CGFloat = 20
    }
    
    var body: some View {
        HStack(spacing: Constants.hStackSpacing) {
            VStack(spacing: 0) {
                CityButton(
                    title: fromCity,
                    placeholder: "Откуда",
                    action: showFrom
                )
                
                CityButton(
                    title: toCity,
                    placeholder: "Куда",
                    action: showTo
                )
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            
            Button(action: swapCities) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: Constants.swapButtonFontSize, weight: .medium))
                    .foregroundStyle(DesignSystem.primaryAccent)
                    .frame(width: Constants.swapButtonSize, height: Constants.swapButtonSize)
                    .background(Color.white)
                    .clipShape(Circle())
            }
        }
        .shadow(
            color: Color.black.opacity(Constants.shadowOpacity),
            radius: Constants.shadowRadius,
            x: 0,
            y: Constants.shadowY
        )
        .padding(Constants.padding)
        .background(DesignSystem.primaryAccent)
        .clipShape(RoundedRectangle(cornerRadius: Constants.containerCornerRadius))
    }
    
    private func swapCities() {
        let temp = fromCity
        fromCity = toCity
        toCity = temp
    }
}
