import Foundation
import SwiftUI
import Combine

@MainActor
class CarrierCardViewModel: BaseViewModel {
    // MARK: - Published Properties
    @Published var carrierInfo: CarrierInfo? {
        didSet {
            updateCarrierData()
        }
    }
 
    @Published var carrierFullName: String = ""
    @Published var carrierEmail: String = ""
    @Published var carrierPhone: String = ""
    @Published var carrierLogoURL: String?
    
    // MARK: - Private Properties
    private let networkClient: NetworkClientProtocol
    private let contactParser: ContactParserProtocol
    private let carrierID: String
    private let carrierName: String?
    
    // MARK: - Initialization
    init(
        carrierID: String,
        carrierName: String? = nil,
        networkClient: NetworkClientProtocol,
        contactParser: ContactParserProtocol = ContactParser()
    ) {
        self.carrierID = carrierID
        self.carrierName = carrierName
        self.networkClient = networkClient
        self.contactParser = contactParser
        self.carrierFullName = carrierName ?? carrierID
        self.carrierEmail = "-"
        self.carrierPhone = "-"
        self.carrierLogoURL = nil
    }
    
    // MARK: - Public Methods
    func loadCarrierInfo(code: String? = nil, system: String? = nil) async {
        guard !isLoading else { return }
        
        startLoading()
        
        do {
            let carrierCode = code ?? carrierID
            let info = try await networkClient.getCarrierInfo(code: carrierCode, system: system ?? "yandex")
            
            guard !Task.isCancelled else {
                stopLoading()
                return
            }
            
            carrierInfo = (info.carrier != nil || (info.carriers?.isEmpty == false)) ? info : nil
        } catch {
            let appError = AppError.from(error)
            
            if case .notFound = appError {
                carrierInfo = nil
                clearError()
                updateCarrierData()
            } else {
                if !handleError(error) {
                    carrierInfo = nil
                    updateCarrierData()
                }
            }
            stopLoading()
            return
        }
        
        stopLoading()
    }
    
    // MARK: - Private Methods
    private func updateCarrierData() {
        let carrier: Components.Schemas.Carrier? = {
            if let singleCarrier = carrierInfo?.carrier {
                return singleCarrier
            } else if let carriers = carrierInfo?.carriers, let first = carriers.first {
                return first
            }
            return nil
        }()
        
        if let carrier = carrier {
            let fallbackName = carrierName ?? carrierID
            carrierFullName = carrier.title ?? fallbackName
            
            if let email = carrier.email, !email.isEmpty {
                carrierEmail = email
            } else if let contacts = carrier.contacts, !contacts.isEmpty, contacts.contains("@") {
                carrierEmail = contactParser.extractEmail(from: contacts) ?? "-"
            } else {
                carrierEmail = "-"
            }
            
            if let phone = carrier.phone, !phone.isEmpty {
                carrierPhone = phone
            } else if let contacts = carrier.contacts, !contacts.isEmpty {
                carrierPhone = contactParser.extractPhone(from: contacts) ?? "-"
            } else {
                carrierPhone = "-"
            }
            
            carrierLogoURL = carrier.logo?.isEmpty == false ? carrier.logo : nil
        } else {
            applyFallbackData()
        }
    }
    
    private func applyFallbackData() {
        carrierFullName = carrierName ?? carrierID
        carrierEmail = "-"
        carrierPhone = "-"
        carrierLogoURL = nil
    }
}
