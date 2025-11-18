import Foundation

extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: AppConstants.Locale.russian)
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    static let searchDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

enum DateFormattingUtils {
    private static let posixFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: AppConstants.Locale.posix)
        return formatter
    }()
    
    private static let isoFormatterWithFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    static func parseDate(from dateString: Any?) -> Date? {
        if let date = dateString as? Date {
            return date
        }
        guard let string = dateString as? String else {
            return nil
        }
        
        let timeFormats = ["HH:mm:ss", "HH:mm"]
        for format in timeFormats {
            posixFormatter.dateFormat = format
            if let time = posixFormatter.date(from: string) {
                let calendar = Calendar.current
                let now = Date()
                let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
                var dateComponents = calendar.dateComponents([.year, .month, .day], from: now)
                dateComponents.hour = timeComponents.hour
                dateComponents.minute = timeComponents.minute
                dateComponents.second = timeComponents.second ?? 0
                
                return calendar.date(from: dateComponents)
            }
        }
        
        posixFormatter.timeZone = TimeZone.current
        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd HH:mm"
        ]
        
        for format in dateFormats {
            posixFormatter.dateFormat = format
            if let date = posixFormatter.date(from: string) {
                return date
            }
        }
        
        if let date = isoFormatterWithFractional.date(from: string) {
            return date
        }
        
        return isoFormatter.date(from: string)
    }
    
    static func formatTime(from date: Date?) -> String {
        guard let date = date else {
            return "--:--"
        }
        return DateFormatter.timeFormatter.string(from: date)
    }
    
    static func formatDate(from date: Date?) -> String {
        guard let date = date else {
            return "--"
        }
        return DateFormatter.dateFormatter.string(from: date)
    }
    
    static func formatDuration(from seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return formatDurationString(hours: hours, minutes: minutes)
    }
    
    static func calculateDuration(from departure: Date?, to arrival: Date?) -> String {
        guard let departure = departure,
              let arrival = arrival else {
            return "--"
        }
        
        let duration = arrival.timeIntervalSince(departure)
        let hours = Int(duration / 3600)
        let minutes = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)
        return formatDurationString(hours: hours, minutes: minutes)
    }
    
    private static func formatDurationString(hours: Int, minutes: Int) -> String {
        if hours > 0 && minutes > 0 {
            return "\(hours) ч \(minutes) мин"
        } else if hours > 0 {
            return "\(hours) ч"
        } else if minutes > 0 {
            return "\(minutes) мин"
        } else {
            return "--"
        }
    }
    
    static func formatSearchDate(from date: Date = Date()) -> String {
        return DateFormatter.searchDateFormatter.string(from: date)
    }
}

