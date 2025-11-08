import Foundation
import Combine

class StoriesTimerManager: ObservableObject {
    @Published var progress: Double = 0.0
    
    private var cancellable: Cancellable?
    var onProgressComplete: (() -> Void)?
    
    private enum Constants {
        static let storyDuration: TimeInterval = 10.0
        static let timerTickInterval: TimeInterval = 0.05
        static var progressPerTick: CGFloat {
            CGFloat(timerTickInterval) / CGFloat(storyDuration)
        }
    }
    
    init(onProgressComplete: (() -> Void)? = nil) {
        self.onProgressComplete = onProgressComplete
    }
    
    func start() {
        stop()
        progress = 0.0
        cancellable = Timer.publish(
            every: Constants.timerTickInterval,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            self?.timerTick()
        }
    }
    
    func stop() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    func reset() {
        stop()
        progress = 0.0
        start()
    }
    
    private func timerTick() {
        let nextProgress = min(progress + Constants.progressPerTick, 1.0)
        progress = nextProgress
        
        if nextProgress >= 1.0 {
            stop()
            onProgressComplete?()
        }
    }
    
    deinit {
        stop()
    }
}

