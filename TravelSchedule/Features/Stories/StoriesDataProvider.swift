import Foundation

struct StoriesDataProvider {
    private enum Constants {
        static let titleText = "Text Text Text Text Text Text Text Text Text Text"
        static let mainText = "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
    }
    
    private static let storyImageNames = [
        StoriesPictures.story1,
        StoriesPictures.story2,
        StoriesPictures.story3,
        StoriesPictures.story4,
        StoriesPictures.story5,
        StoriesPictures.story6
    ]
    
    private static let baseStories: [StoryItem] = (0..<6).map {
        StoryItem(
            id: $0,
            imageName: storyImageNames[$0],
            title: Constants.titleText,
            text: Constants.mainText
        )
    }
    
    static var storiesForList: [StoryItem] {
        baseStories.map { StoryItem(id: $0.id, imageName: $0.imageName, title: $0.title) }
    }
    
    static var storiesForFullScreen: [StoryItem] {
        baseStories
    }
}

