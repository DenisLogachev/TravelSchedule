import SwiftUI

struct ContentView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        MainTabView()
            .onAppear {
                themeManager.applyTheme()
            }
    }
}

#Preview {
    ContentView()
}
