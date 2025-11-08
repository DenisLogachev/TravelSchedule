import SwiftUI
import Combine

enum AppTheme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    var displayName: String {
        switch self {
        case .light:
            return "Светлая"
        case .dark:
            return "Тёмная"
        }
    }
}

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "appTheme")
            applyTheme()
        }
    }
    
    private init() {
        let savedTheme = UserDefaults.standard.string(forKey: "appTheme") ?? AppTheme.light.rawValue
        self.currentTheme = AppTheme(rawValue: savedTheme) ?? .light
    }
    
    func applyTheme() {
        DispatchQueue.main.async {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .forEach { window in
                    window.overrideUserInterfaceStyle = self.currentTheme.userInterfaceStyle
                }
        }
    }
}

