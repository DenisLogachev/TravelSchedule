import SwiftUI

struct ContactInfoView: View {
    let title: String
    let value: String
    
    private enum Constants {
        static let titleFontSize: CGFloat = 17
        static let valueFontSize: CGFloat = 12
        static let spacing: CGFloat = 8
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            Text(title)
                .font(.system(size: Constants.titleFontSize))
                .foregroundColor(.primary)
            Text(value)
                .font(.system(size: Constants.valueFontSize))
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

