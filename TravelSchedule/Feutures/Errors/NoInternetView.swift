import SwiftUI

struct NoInternetView: View {
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(ErrorLogos.noInternet)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 223, height: 223)
                .clipShape(RoundedRectangle(cornerRadius: 70))
            Text("Нет интернета")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.primary)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignSystem.surface.ignoresSafeArea())
    }
}

#Preview {
    NoInternetView()
}

