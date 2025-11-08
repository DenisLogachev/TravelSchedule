import SwiftUI

struct StoriesView: View {
    let viewedStories: Set<Int>
    let onStoryTap: (Int) -> Void
    
    private enum Constants {
        static let itemWidth: CGFloat = 92
        static let itemHeight: CGFloat = 140
        static let cornerRadius: CGFloat = 16
        static let spacing: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
    }
    
    private let stories = StoriesDataProvider.storiesForList
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: Constants.spacing) {
                ForEach(stories) { story in
                    StoryItemView(
                        story: story,
                        isViewed: viewedStories.contains(story.id)
                    ) {
                        onStoryTap(story.id)
                    }
                }
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.verticalPadding)
        }
        .scrollIndicators(.hidden)
    }
}

