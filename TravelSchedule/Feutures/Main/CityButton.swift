import SwiftUI

struct CityButton: View {
    let title: String
    let placeholder: String
    let action: () -> Void
    
    private enum Constants {
        static let verticalPadding: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title.isEmpty ? placeholder : title)
                    .foregroundColor(title.isEmpty ? .gray : .black)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
            }
            .padding(.vertical, Constants.verticalPadding)
            .padding(.horizontal, Constants.horizontalPadding)
            .background(Color.white)
        }
    }
}

