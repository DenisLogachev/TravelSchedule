import Foundation

struct StoriesDataProvider {
    private enum Constants {
        static let titleText = "Text Text Text Text Text Text Text Text Text Text"
        static let mainText = "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
    }
    
    private static let baseStories: [StoryItem] = [
        StoryItem(id: 0, imageName: StoriesPictures.SP1, title: Constants.titleText, text: Constants.mainText),
        StoryItem(id: 1, imageName: StoriesPictures.SP2, title: Constants.titleText, text: Constants.mainText),
        StoryItem(id: 2, imageName: StoriesPictures.SP3, title: Constants.titleText, text: Constants.mainText),
        StoryItem(id: 3, imageName: StoriesPictures.SP4, title: Constants.titleText, text: Constants.mainText),
        StoryItem(id: 4, imageName: StoriesPictures.SP5, title: Constants.titleText, text: Constants.mainText),
        StoryItem(id: 5, imageName: StoriesPictures.SP6, title: Constants.titleText, text: Constants.mainText)
    ]
    
    static var storiesForList: [StoryItem] {
        baseStories.map { StoryItem(id: $0.id, imageName: $0.imageName, title: $0.title) }
    }
    
    static var storiesForFullScreen: [StoryItem] {
        baseStories
    }
}

