import Foundation

protocol CityStationParserProtocol {
    func parseCityAndStation(_ input: String) -> (city: String, station: String?)
}

struct CityStationParser: CityStationParserProtocol {
    func parseCityAndStation(_ input: String) -> (city: String, station: String?) {
        if let openParen = input.firstIndex(of: "("),
           let closeParen = input.firstIndex(of: ")"),
           openParen < closeParen {
            let city = String(input[..<openParen]).trimmingCharacters(in: .whitespacesAndNewlines)
            let station = String(input[input.index(after: openParen)..<closeParen])
                .trimmingCharacters(in: .whitespacesAndNewlines)
            return (city, station.isEmpty ? nil : station)
        }
        
        return (input.trimmingCharacters(in: .whitespacesAndNewlines), nil)
    }
}

