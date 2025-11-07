import SwiftUI

struct CarrierLogoView: View {
    let logoName: String
    let size: CGFloat
    
    private enum Constants {
        static let defaultLogoSize: CGFloat = 38
        static let largeLogoSize: CGFloat = 104
        static let cornerRadius: CGFloat = 12
        static let sfSymbolPrefix = "sf."
    }
    
    init(logoName: String, size: CGFloat = Constants.defaultLogoSize) {
        self.logoName = logoName
        self.size = size
    }
    
    var body: some View {
        if logoName.hasPrefix(Constants.sfSymbolPrefix) {
            let symbolName = String(logoName.dropFirst(Constants.sfSymbolPrefix.count))
            Image(systemName: symbolName)
                .font(.system(size: size * 0.63))
                .foregroundColor(DS.primaryAccent)
                .frame(width: size, height: size)
                .background(Color.white)
                .cornerRadius(size == Constants.largeLogoSize ? size / 2 : Constants.cornerRadius)
        } else {
            Group {
                if size == Constants.largeLogoSize {
                    Image(logoName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                } else {
                    Image(logoName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size, height: size)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                }
            }
        }
    }
}

