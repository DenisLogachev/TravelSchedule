import SwiftUI

struct CarrierCardView: View {
    
    let carrierID: String
    
    private var carrierFullName: String {
        switch carrierID {
        case "РЖД":
            return "ОАО \"РЖД\""
        case "ФГК":
            return "ОАО \"ФГК\""
        case "Урал логистика":
            return "ОАО \"Урал логистика\""
        default:
            return carrierID
        }
    }
    
    private var carrierLogo: String {
        switch carrierID {
        case "РЖД":
            return CarrierLogos.rzhd
        case "ФГК":
            return CarrierLogos.fgk
        case "Урал логистика":
            return CarrierLogos.uralLogistics
        default:
            return CarrierLogos.trainSymbol
        }
    }
    
    private var carrierEmail: String {
        switch carrierID {
        case "РЖД":
            return "info@rzd.ru"
        case "ФГК":
            return "info@fgk.ru"
        case "Урал логистика":
            return "info@ural-logistics.ru"
        default:
            return "-"
        }
    }
    
    private var carrierPhone: String {
        switch carrierID {
        case "РЖД":
            return "+7 (904) 329-27-71"
        case "ФГК":
            return "+7 (904) 329-27-72"
        case "Урал логистика":
            return "+7 (904) 329-27-73"
        default:
            return "-"
        }
    }
    
    private enum Constants {
        static let logoTopPadding: CGFloat = 24
        static let vStackSpacing: CGFloat = 24
        static let horizontalPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 24
        static let titleFontSize: CGFloat = 24
        static let imageHeight: CGFloat = 104
        static let imageTopPadding: CGFloat = 29
    }
    
    var body: some View {
        SelectionScreen(title: "Информация о перевозчике") {
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        DesignSystem.surface
                            .frame(maxWidth: .infinity)
                            .frame(height: Constants.imageHeight)
                        
                        Image(carrierLogo)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .frame(height: Constants.imageHeight)
                    }
                    
                    .mask(Circle())
                    .padding(.top, Constants.imageTopPadding)
                    
                    VStack(spacing: Constants.vStackSpacing) {
                        Text(carrierFullName)
                            .font(.system(size: Constants.titleFontSize, weight: .bold))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ContactInfoView(title: "E-mail", value: carrierEmail)
                        ContactInfoView(title: "Телефон", value: carrierPhone)
                        
                        Spacer()
                    }
                    .padding(.horizontal, Constants.horizontalPadding)
                    .padding(.top, Constants.logoTopPadding)
                    .padding(.bottom, Constants.bottomPadding)
                }
            }
            .background(DesignSystem.surface.ignoresSafeArea())
        }
    }
}

