import SwiftUI

struct StoryItemView: View {
    let story: StoryItem
    let isViewed: Bool
    let onTap: () -> Void
    
    private enum Constants {
        static let width: CGFloat = 92
        static let height: CGFloat = 140
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 3
        static let viewedOpacity: Double = 0.5
        static let titleFontSize: CGFloat = 12
        static let titleLetterSpacing: CGFloat = 0.4
        static let titlePadding: CGFloat = 8
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottom) {
                Image(story.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Constants.width, height: Constants.height)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    .opacity(isViewed ? Constants.viewedOpacity : 1.0)
                
                Text(story.title)
                    .font(.system(size: Constants.titleFontSize, weight: .regular))
                    .foregroundStyle(.white)
                    .tracking(Constants.titleLetterSpacing)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, Constants.titlePadding)
                    .padding(.bottom, Constants.titlePadding)
                    .frame(maxWidth: Constants.width, alignment: .leading)
                    .opacity(isViewed ? Constants.viewedOpacity : 1.0)
            }
            .overlay(
                Group {
                    if !isViewed {
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .stroke(DesignSystem.primaryAccent, lineWidth: Constants.borderWidth)
                    }
                }
            )
        }
    }
}

