import SwiftUI

struct SearchButton: View {
    let action: () -> Void
    
    private enum Constants {
        static let fontSize: CGFloat = 17
        static let minHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 16
    }
    
    var body: some View {
        Button(action: action) {
            Text("Найти")
                .font(.system(size: Constants.fontSize, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: Constants.minHeight)
                .background(DesignSystem.primaryAccent)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
    }
}

