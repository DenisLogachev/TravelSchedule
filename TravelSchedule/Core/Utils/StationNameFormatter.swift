import Foundation

enum StationNameFormatter {
    static func removeCityDuplication(from stationName: String, cityName: String) -> String {
        let cityLower = cityName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let stationLower = stationName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if stationLower.hasPrefix(cityLower) {
            let remaining = String(stationName.dropFirst(cityLower.count))
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if remaining.hasPrefix("(") {
                let cleaned = remaining.dropFirst().trimmingCharacters(in: .whitespacesAndNewlines)
                if cleaned.hasSuffix(")") {
                    return String(cleaned.dropLast()).trimmingCharacters(in: .whitespacesAndNewlines)
                }
                return cleaned
            }
            
            if remaining.hasPrefix(" ") || remaining.hasPrefix(",") {
                return remaining.trimmingCharacters(in: CharacterSet(charactersIn: " ,"))
            }
            
            return remaining.isEmpty ? stationName : remaining
        }
        
        if let openParen = stationName.firstIndex(of: "("),
           let closeParen = stationName.firstIndex(of: ")"),
           openParen < closeParen {
            let beforeParen = String(stationName[..<openParen]).trimmingCharacters(in: .whitespacesAndNewlines)
            let inParen = String(stationName[stationName.index(after: openParen)..<closeParen])
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if beforeParen.lowercased() == cityLower {
                return inParen
            }
        }
        
        return stationName
    }
    
    static func formatCityStation(city: String, station: String) -> String {
        let cleanedStation = removeCityDuplication(from: station, cityName: city)
        return "\(city) (\(cleanedStation))"
    }
}

