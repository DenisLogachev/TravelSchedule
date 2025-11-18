import SwiftUI

struct ContentView: View {
    @AppStorage(ThemeManager.appThemeKey) private var appThemeRawValue: String = AppTheme.light.rawValue
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        MainTabView()
            .onAppear {
                themeManager.updateTheme(from: appThemeRawValue)
                themeManager.applyTheme()
            }
            .onChange(of: appThemeRawValue) {
                themeManager.updateTheme(from: appThemeRawValue)
            }
    }
}

#Preview {
    ContentView()
}
