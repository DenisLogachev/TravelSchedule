import SwiftUI
import Combine

enum AppTheme: String, CaseIterable {
    case light
    case dark
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light: .light
        case .dark: .dark
        }
    }
    
    var displayName: String {
        switch self {
        case .light: "Светлая"
        case .dark: "Тёмная"
        }
    }
}

final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    static let appThemeKey = "appTheme"
    
    @Published var currentTheme: AppTheme = .light {
        didSet {
            applyTheme()
        }
    }
    
    private init() {
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
    
    func updateTheme(from rawValue: String) {
        if let theme = AppTheme(rawValue: rawValue) {
            currentTheme = theme
        }
    }
}

