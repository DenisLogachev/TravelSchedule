import SwiftUI

struct ServerErrorView: View {
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(ErrorLogos.serverError)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 223, height: 223)
                .clipShape(RoundedRectangle(cornerRadius: 70))
            Text("Ошибка сервера")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DS.surface.ignoresSafeArea())
    }
}

#Preview {
    ServerErrorView()
}

