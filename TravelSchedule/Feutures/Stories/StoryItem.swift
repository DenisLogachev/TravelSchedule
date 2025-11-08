import Foundation

struct StoryItem: Identifiable {
    let id: Int
    let imageName: String
    let title: String
    let text: String?
    
    init(id: Int, imageName: String, title: String, text: String? = nil) {
        self.id = id
        self.imageName = imageName
        self.title = title
        self.text = text
    }
}
