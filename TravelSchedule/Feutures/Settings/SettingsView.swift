import SwiftUI

struct SettingsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    
    private var isDarkTheme: Binding<Bool> {
        Binding(
            get: { themeManager.currentTheme == .dark },
            set: { themeManager.currentTheme = $0 ? .dark : .light }
        )
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Темная тема")
                        .font(.system(size: 17))
                        .tracking(-0.41)
                    
                    Spacer()
                    
                    Toggle("", isOn: isDarkTheme)
                        .tint(DS.primaryAccent)
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 12)
                
                NavigationLink(destination: TermsOfServiceView()) {
                    HStack {
                        Text("Пользовательское соглашение")
                            .padding(.leading, 16)
                            .tracking(-0.41)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .padding(.trailing, 16)
                    }
                    .frame(maxWidth: .infinity, minHeight: 60)
                }
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Text("Приложение использует API «Яндекс.Расписания»")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .tracking(0.4)
                
                Text("Версия 1.0 (beta)")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .tracking(0.4)
            }
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DS.surface.ignoresSafeArea())
    }
}

