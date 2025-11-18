import SwiftUI

struct SettingsView: View {
    @AppStorage(ThemeManager.appThemeKey) private var appThemeRawValue: String = AppTheme.light.rawValue
    @StateObject private var themeManager = ThemeManager.shared
    
    private var isDarkTheme: Binding<Bool> {
        Binding(
            get: { themeManager.currentTheme == .dark },
            set: { newValue in
                appThemeRawValue = newValue ? AppTheme.dark.rawValue : AppTheme.light.rawValue
                themeManager.updateTheme(from: appThemeRawValue)
            }
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
                        .tint(DesignSystem.primaryAccent)
                }
                .padding([.horizontal, .top])
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
                    .foregroundStyle(.primary)
                    .tracking(0.4)
                
                Text("Версия 1.0 (beta)")
                    .font(.caption)
                    .foregroundStyle(.primary)
                    .tracking(0.4)
            }
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignSystem.surface.ignoresSafeArea())
        .onChange(of: appThemeRawValue) { newValue in
            themeManager.updateTheme(from: newValue)
        }
        .onAppear {
            themeManager.updateTheme(from: appThemeRawValue)
        }
    }
}

