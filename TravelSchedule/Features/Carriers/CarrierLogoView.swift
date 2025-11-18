import SwiftUI

struct CarrierLogoView: View {
    let logoURL: String?
    let height: CGFloat
    let cornerRadius: CGFloat?
    let isFullWidth: Bool
    
    private enum Constants {
        static let defaultLogoSize: CGFloat = 38
        static let defaultCornerRadius: CGFloat = 12
        static let largeLogoSize: CGFloat = 104
        static let fallbackSymbol = "train.side.front.car"
    }
    
    init(logoURL: String? = nil, height: CGFloat = Constants.defaultLogoSize, cornerRadius: CGFloat? = nil) {
        self.logoURL = logoURL
        self.height = height
        self.cornerRadius = cornerRadius ?? Constants.defaultCornerRadius
        self.isFullWidth = true
    }
    
    init(logoURL: String? = nil, size: CGFloat = Constants.defaultLogoSize) {
        self.logoURL = logoURL
        self.height = size
        self.cornerRadius = size == Constants.largeLogoSize ? nil : Constants.defaultCornerRadius
        self.isFullWidth = false
    }
    
    var body: some View {
        if isFullWidth {
            GeometryReader { geometry in
                logoContentView(width: geometry.size.width)
            }
            .frame(height: height)
        } else {
            logoContentView(width: height)
        }
    }
    
    @ViewBuilder
    private func logoContentView(width: CGFloat) -> some View {
        if let logoURL = logoURL, let url = URL(string: logoURL) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: width, height: height)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width, height: height)
                        .background(Color.white)
                        .clipShape(logoShape())
                case .failure:
                    fallbackView(width: width)
                @unknown default:
                    fallbackView(width: width)
                }
            }
        } else {
            fallbackView(width: width)
        }
    }
    
    private func logoShape() -> AnyShape {
        if isFullWidth {
            return AnyShape(RoundedRectangle(cornerRadius: cornerRadius ?? Constants.defaultCornerRadius))
        } else {
            return height == Constants.largeLogoSize
                ? AnyShape(Circle())
                : AnyShape(RoundedRectangle(cornerRadius: cornerRadius ?? Constants.defaultCornerRadius))
        }
    }
    
    @ViewBuilder
    private func fallbackView(width: CGFloat) -> some View {
        let shape: AnyShape = isFullWidth
            ? AnyShape(RoundedRectangle(cornerRadius: cornerRadius ?? Constants.defaultCornerRadius))
            : (height == Constants.largeLogoSize ? AnyShape(Circle()) : AnyShape(RoundedRectangle(cornerRadius: cornerRadius ?? Constants.defaultCornerRadius)))
        fallbackLogoView(width: width, height: height, shape: shape)
    }
    
    @ViewBuilder
    private func fallbackLogoView(width: CGFloat, height: CGFloat, shape: AnyShape) -> some View {
        Image(systemName: Constants.fallbackSymbol)
            .font(.system(size: height * 0.63))
            .foregroundStyle(DesignSystem.primaryAccent)
            .frame(width: width, height: height)
            .background(Color.white)
            .clipShape(shape)
    }
}

private struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = shape.path(in:)
    }
    
    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

