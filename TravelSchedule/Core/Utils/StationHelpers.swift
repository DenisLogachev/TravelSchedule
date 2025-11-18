import Foundation
import OpenAPIRuntime

// MARK: - Station Extension for name cleaning
extension Components.Schemas.Station {
    func cleanedName(cityName: String) -> String? {
        let raw = (popular_title ?? title ?? short_title ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !raw.isEmpty else { return nil }
        
        let cleaned = StationNameFormatter.removeCityDuplication(from: raw, cityName: cityName)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return nil }
        
        guard let first = cleaned.first, first.isLetter || first.isNumber else { return nil }
        
        let noSpaces = cleaned.replacingOccurrences(of: " ", with: "")
        guard noSpaces.rangeOfCharacter(from: .letters) != nil else { return nil }
        
        return cleaned
    }
}

// MARK: - Helper structures for station processing
struct StationImportance {
    let isMain: Bool
    let isCentral: Bool
    let hasEsr: Bool
    let hasDirection: Bool
    let hasCode: Bool
    
    init(nameLowercased: String, codes: Components.Schemas.Station.codesPayload?, direction: String?, code: String?) {
        self.isMain = nameLowercased.contains("вокзал")
        self.isCentral = nameLowercased.contains("главный")
            || nameLowercased.contains("гл ")
            || nameLowercased.contains("центральный")
            || nameLowercased.hasSuffix(" гл")
        self.hasEsr = !(codes?.esr_code ?? "").isEmpty
        self.hasDirection = !(direction ?? "").isEmpty
        self.hasCode = !(code ?? "").isEmpty
    }
    
    init(isMain: Bool, isCentral: Bool, hasEsr: Bool, hasDirection: Bool, hasCode: Bool) {
        self.isMain = isMain
        self.isCentral = isCentral
        self.hasEsr = hasEsr
        self.hasDirection = hasDirection
        self.hasCode = hasCode
    }
}

struct StationInfo {
    let name: String
    var importance: StationImportance
    
    mutating func merge(with other: StationInfo) {
        importance = StationImportance(
            isMain: importance.isMain || other.importance.isMain,
            isCentral: importance.isCentral || other.importance.isCentral,
            hasEsr: importance.hasEsr || other.importance.hasEsr,
            hasDirection: importance.hasDirection || other.importance.hasDirection,
            hasCode: importance.hasCode || other.importance.hasCode
        )
    }
    
    static func sort(_ lhs: StationInfo, _ rhs: StationInfo) -> Bool {
        if lhs.importance.isMain != rhs.importance.isMain { return lhs.importance.isMain && !rhs.importance.isMain }
        if lhs.importance.isCentral != rhs.importance.isCentral { return lhs.importance.isCentral && !rhs.importance.isCentral }
        if lhs.importance.hasEsr != rhs.importance.hasEsr { return lhs.importance.hasEsr && !rhs.importance.hasEsr }
        if lhs.importance.hasDirection != rhs.importance.hasDirection { return lhs.importance.hasDirection && !rhs.importance.hasDirection }
        if lhs.importance.hasCode != rhs.importance.hasCode { return lhs.importance.hasCode && !rhs.importance.hasCode }
        return lhs.name < rhs.name
    }
}
