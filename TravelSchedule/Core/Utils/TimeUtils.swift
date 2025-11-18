import Foundation

enum TimeUtils {
    static func timeToMinutes(_ time: String) -> Int {
        let components = time.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2,
              components[0] >= 0 && components[0] < 24,
              components[1] >= 0 && components[1] < 60 else {
            return -1
        }
        return components[0] * 60 + components[1]
    }
    
    static func parseDurationToSeconds(_ duration: String) -> Int {
        let components = duration.components(separatedBy: CharacterSet.whitespaces)
        var hours = 0
        var minutes = 0
        
        for (index, component) in components.enumerated() {
            if component == "ч" && index > 0 {
                hours = Int(components[index - 1]) ?? 0
            } else if component == "мин" && index > 0 {
                minutes = Int(components[index - 1]) ?? 0
            }
        }
        
        return (hours * 3600) + (minutes * 60)
    }
    
    static func isTimeInRange(_ departureTime: String, timeRange: TimeRange) -> Bool {
        let routeMinutes = timeToMinutes(departureTime)
        guard routeMinutes >= 0 else { return false }
        
        let fromMinutes = timeToMinutes(timeRange.timeFrom)
        let toMinutes = timeToMinutes(timeRange.timeTo)
        
        let crossesMidnight = toMinutes < fromMinutes
        
        if crossesMidnight {
            return routeMinutes >= fromMinutes || routeMinutes < toMinutes
        } else {
            return routeMinutes >= fromMinutes && routeMinutes < toMinutes
        }
    }
}

