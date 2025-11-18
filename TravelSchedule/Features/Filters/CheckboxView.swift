import SwiftUI

struct CheckboxView: View {
    let isSelected: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    private enum Constants {
        static let size: CGFloat = 24
        static let cornerRadius: CGFloat = 4
        static let strokeWidth: CGFloat = 2
        static let checkmarkFontSize: CGFloat = 14
    }
    
    private var checkmarkColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(Color.primary, lineWidth: Constants.strokeWidth)
                .frame(width: Constants.size, height: Constants.size)
            
            if isSelected {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .fill(Color.primary)
                    .frame(width: Constants.size, height: Constants.size)
                
                Image(systemName: "checkmark")
                    .font(.system(size: Constants.checkmarkFontSize, weight: .bold))
                    .foregroundStyle(checkmarkColor)
            }
        }
    }
}

