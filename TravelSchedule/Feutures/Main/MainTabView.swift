import SwiftUI

struct MainTabView: View {
    
    private enum Constants {
        static let separatorHeight: CGFloat = 0.5
        static let separatorOpacity: Double = 0.4
        static let separatorBottomPadding: CGFloat = 49
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                MainScreenView()
            }
            .tabItem {
                Image(systemName: "arrow.up.message.fill")
            }
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
            }
        }
        .tint(.primary)
        .background(DesignSystem.surface.ignoresSafeArea())
        .overlay(
            Rectangle()
                .frame(height: Constants.separatorHeight)
                .foregroundStyle(Color.gray.opacity(Constants.separatorOpacity))
                .ignoresSafeArea(.container, edges: .horizontal)
                .padding(.bottom, Constants.separatorBottomPadding),
            alignment: .bottom
        )
    }
}
