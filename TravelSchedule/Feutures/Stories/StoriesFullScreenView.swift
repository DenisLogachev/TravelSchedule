import SwiftUI

struct StoriesFullScreenView: View {
    @Binding var isPresented: Bool
    let selectedStoryId: Int
    let onStoryViewed: (Int) -> Void
    
    @State private var currentStoryIndex: Int
    @State private var viewedStories: Set<Int>
    @StateObject private var timerManager: StoriesTimerManager
    @State private var isInitializing: Bool = true
    
    private enum Constants {
        static let closeButtonSize: CGFloat = 24
        static let closeButtonIconSize: CGFloat = 9.7
        static let closeButtonTopPadding: CGFloat = 50
        static let closeButtonTrailingPadding: CGFloat = 16
        static let timerDelay: TimeInterval = 0.1
    }
    
    private let stories = StoriesDataProvider.storiesForFullScreen
    
    private var initialIndex: Int {
        stories.firstIndex(where: { $0.id == selectedStoryId }) ?? 0
    }
    
    private static func findInitialIndex(for storyId: Int, in stories: [StoryItem]) -> Int {
        stories.firstIndex(where: { $0.id == storyId }) ?? 0
    }
    
    init(isPresented: Binding<Bool>, selectedStoryId: Int, onStoryViewed: @escaping (Int) -> Void) {
        self._isPresented = isPresented
        self.selectedStoryId = selectedStoryId
        self.onStoryViewed = onStoryViewed
        
        let stories = StoriesDataProvider.storiesForFullScreen
        let computedInitialIndex = Self.findInitialIndex(for: selectedStoryId, in: stories)
        self._currentStoryIndex = State(initialValue: computedInitialIndex)
        self._viewedStories = State(initialValue: [stories[computedInitialIndex].id])
        self._isInitializing = State(initialValue: true)
        self._timerManager = StateObject(wrappedValue: StoriesTimerManager {})
        
        onStoryViewed(stories[computedInitialIndex].id)
    }
    
    var body: some View {
        ZStack {
            DS.surface.ignoresSafeArea()
            
            ZStack {
                StoriesTabView(
                    stories: stories,
                    currentStoryIndex: $currentStoryIndex,
                    initialIndex: initialIndex,
                    onLeftTap: {
                        if currentStoryIndex > 0 {
                            switchToStory(at: currentStoryIndex - 1)
                        }
                    },
                    onRightTap: {
                        if currentStoryIndex < stories.count - 1 {
                            switchToStory(at: currentStoryIndex + 1)
                        } else {
                            isPresented = false
                        }
                    },
                    onSwipeDown: {
                        isPresented = false
                    },
                    onStoryChange: { newIndex in
                        handleStoryChange(newIndex)
                    }
                )
                
                VStack {
                    StoriesProgressView(
                        storiesCount: stories.count,
                        currentStoryIndex: $currentStoryIndex,
                        timerManager: timerManager
                    )
                    Spacer()
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "multiply")
                            .font(.system(size: Constants.closeButtonIconSize, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: Constants.closeButtonSize, height: Constants.closeButtonSize)
                            .background(
                                Circle()
                                    .fill(Color.black)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, Constants.closeButtonTopPadding)
                    .padding(.trailing, Constants.closeButtonTrailingPadding)
                }
                Spacer()
            }
        }
        .onAppear {
            setupInitialState()
        }
        .onDisappear {
            timerManager.stop()
        }
        .onChange(of: isPresented) { oldValue, newValue in
            if newValue {
                isInitializing = true
                currentStoryIndex = initialIndex
                if !viewedStories.contains(selectedStoryId) {
                    viewedStories.insert(selectedStoryId)
                    onStoryViewed(selectedStoryId)
                }
            } else {
                isInitializing = false
            }
        }
    }
    
    private func setupInitialState() {
        timerManager.onProgressComplete = {
            if currentStoryIndex < stories.count - 1 {
                switchToStory(at: currentStoryIndex + 1)
            } else {
                timerManager.stop()
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timerDelay) {
                    isPresented = false
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timerDelay * 2) {
            timerManager.progress = 0.0
            timerManager.start()
            isInitializing = false
        }
    }
    
    private func handleStoryChange(_ newIndex: Int) {
        guard !isInitializing else { return }
        
        let storyId = stories[newIndex].id
        timerManager.reset()
        
        if !viewedStories.contains(storyId) {
            viewedStories.insert(storyId)
            onStoryViewed(storyId)
        }
    }
    
    private func switchToStory(at index: Int) {
        timerManager.stop()
        timerManager.progress = 0.0
        withAnimation {
            currentStoryIndex = index
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timerDelay) {
            timerManager.start()
        }
    }
}
