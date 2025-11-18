import Foundation

protocol ContactParserProtocol {
    func extractEmail(from contacts: String) -> String?
    func extractPhone(from contacts: String) -> String?
}

struct ContactParser: ContactParserProtocol {
    func extractEmail(from contacts: String) -> String? {
        let emailRegex = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"#
        if let range = contacts.range(of: emailRegex, options: .regularExpression) {
            return String(contacts[range])
        }
        return nil
    }
    
    func extractPhone(from contacts: String) -> String? {
        let phoneRegex = #"[\+]?[0-9\s\-\(\)]{10,}"#
        if let range = contacts.range(of: phoneRegex, options: .regularExpression) {
            return String(contacts[range]).trimmingCharacters(in: .whitespaces)
        }
        return nil
    }
}

