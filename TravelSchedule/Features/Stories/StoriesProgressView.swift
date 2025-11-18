import SwiftUI

struct StoriesProgressView: View {
    let storiesCount: Int
    @Binding var currentStoryIndex: Int
    @ObservedObject var timerManager: StoriesTimerManager
    
    enum Constants {
        static let progressBarHeight: CGFloat = 6
        static let progressBarCornerRadius: CGFloat = 6
        static let progressBarSpacing: CGFloat = 4
        static let horizontalPadding: CGFloat = 16
        static let topIndicatorPadding: CGFloat = 28
    }
    
    private var overallProgress: CGFloat {
        let completedStories = CGFloat(currentStoryIndex)
        let currentProgress = CGFloat(timerManager.progress)
        return (completedStories + currentProgress) / CGFloat(storiesCount)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let progressWidth = min(overallProgress * geometry.size.width, geometry.size.width)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: Constants.progressBarCornerRadius)
                    .frame(width: geometry.size.width, height: Constants.progressBarHeight)
                    .foregroundStyle(.white)
                
                RoundedRectangle(cornerRadius: Constants.progressBarCornerRadius)
                    .frame(width: progressWidth, height: Constants.progressBarHeight)
                    .foregroundStyle(DesignSystem.primaryAccent)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
            }
            .mask {
                ProgressBarMask(numberOfSections: storiesCount, spacing: Constants.progressBarSpacing)
            }
        }
        .frame(height: Constants.progressBarHeight)
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.top, Constants.topIndicatorPadding)
        .drawingGroup()
    }
}

private struct ProgressBarMask: View {
    let numberOfSections: Int
    let spacing: CGFloat
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<numberOfSections, id: \.self) { _ in
                ProgressBarMaskFragment()
            }
        }
    }
}

private struct ProgressBarMaskFragment: View {
    var body: some View {
        RoundedRectangle(cornerRadius: StoriesProgressView.Constants.progressBarCornerRadius)
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: StoriesProgressView.Constants.progressBarHeight)
            .foregroundStyle(.white)
    }
}


