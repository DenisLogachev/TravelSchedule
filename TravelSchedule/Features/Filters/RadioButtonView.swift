import SwiftUI

struct RadioButtonView: View {
    let isSelected: Bool
    
    private enum Constants {
        static let outerSize: CGFloat = 24
        static let innerSize: CGFloat = 12
        static let strokeWidth: CGFloat = 2
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.primary, lineWidth: Constants.strokeWidth)
                .frame(width: Constants.outerSize, height: Constants.outerSize)
            
            if isSelected {
                Circle()
                    .fill(Color.primary)
                    .frame(width: Constants.innerSize, height: Constants.innerSize)
            }
        }
    }
}

