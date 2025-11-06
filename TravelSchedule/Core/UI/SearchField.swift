import SwiftUI

struct SearchField: View {
    
    @Binding var text: String
    
    private enum Constants {
        static let cornerRadius: CGFloat = 10
        static let iconPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 10
    }
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, Constants.iconPadding)
            TextField("Введите запрос", text: $text)
                .disableAutocorrection(true)
                .autocapitalization(.words)
                .padding(.vertical, Constants.verticalPadding)
        }
        .background(DS.surfaceSecondary)
        .cornerRadius(Constants.cornerRadius)
    }
}

