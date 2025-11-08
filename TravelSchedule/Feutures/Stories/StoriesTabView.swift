import SwiftUI

struct StoryDetailView: View {
    let story: StoryItem
    let onLeftTap: () -> Void
    let onRightTap: () -> Void
    let onSwipeDown: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let imageBottomPadding: CGFloat = 40
        static let textFontSize: CGFloat = 20
        static let titleFontSize: CGFloat = 34
        static let textLetterSpacing: CGFloat = 0.4
        static let titleLetterSpacing: CGFloat = 0.4
        static let swipeDownThreshold: CGFloat = 100
        static let imageCornerRadius: CGFloat = 40
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(story.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .cornerRadius(Constants.imageCornerRadius)
                    .offset(y: dragOffset.height)
                    .contentShape(Rectangle())
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if abs(value.translation.height) > abs(value.translation.width) && value.translation.height > 0 {
                                    dragOffset.height = min(value.translation.height, 200)
                                } else if abs(value.translation.width) > abs(value.translation.height) {
                                    dragOffset = .zero
                                }
                            }
                            .onEnded { value in
                                let screenWidth = geometry.size.width
                                let tapX = value.startLocation.x
                                
                                if abs(value.translation.height) > abs(value.translation.width) && value.translation.height > Constants.swipeDownThreshold {
                                    onSwipeDown()
                                } else if abs(value.translation.width) < 10 && abs(value.translation.height) < 10 {
                                    if tapX < screenWidth / 2 {
                                        onLeftTap()
                                    } else {
                                        onRightTap()
                                    }
                                }
                                dragOffset = .zero
                            }
                    )
                
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 12) {
                        Text(story.title)
                            .font(.system(size: Constants.titleFontSize, weight: .bold))
                            .foregroundColor(.white)
                            .tracking(Constants.titleLetterSpacing)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let text = story.text {
                            Text(text)
                                .font(.system(size: Constants.textFontSize, weight: .regular))
                                .foregroundColor(.white)
                                .tracking(Constants.textLetterSpacing)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.horizontal, Constants.horizontalPadding)
                    .padding(.bottom, Constants.imageBottomPadding)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct StoriesTabView: View {
    let stories: [StoryItem]
    @Binding var currentStoryIndex: Int
    let onLeftTap: () -> Void
    let onRightTap: () -> Void
    let onSwipeDown: () -> Void
    let onStoryChange: (Int) -> Void
    
    private enum Constants {
        static let initializationDelay: TimeInterval = 0.2
    }
    
    @State private var isReady = false
    let initialIndex: Int
    
    init(
        stories: [StoryItem],
        currentStoryIndex: Binding<Int>,
        initialIndex: Int,
        onLeftTap: @escaping () -> Void,
        onRightTap: @escaping () -> Void,
        onSwipeDown: @escaping () -> Void,
        onStoryChange: @escaping (Int) -> Void
    ) {
        self.stories = stories
        self._currentStoryIndex = currentStoryIndex
        self.initialIndex = initialIndex
        self.onLeftTap = onLeftTap
        self.onRightTap = onRightTap
        self.onSwipeDown = onSwipeDown
        self.onStoryChange = onStoryChange
    }
    
    var body: some View {
        TabView(selection: $currentStoryIndex) {
            ForEach(Array(stories.enumerated()), id: \.element.id) { index, story in
                StoryDetailView(
                    story: story,
                    onLeftTap: onLeftTap,
                    onRightTap: onRightTap,
                    onSwipeDown: onSwipeDown
                )
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .opacity(isReady ? 1 : 0)
        .id("tabview-\(initialIndex)")
        .onAppear {
            isReady = false
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.initializationDelay) {
                isReady = true
                if currentStoryIndex != initialIndex {
                    currentStoryIndex = initialIndex
                }
            }
        }
        .onChange(of: initialIndex) { oldValue, newValue in
            if currentStoryIndex != newValue {
                currentStoryIndex = newValue
            }
        }
        .onChange(of: currentStoryIndex) { oldValue, newValue in
            if isReady {
                onStoryChange(newValue)
            }
        }
    }
}

