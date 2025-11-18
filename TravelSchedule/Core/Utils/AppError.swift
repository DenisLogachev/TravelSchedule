import Foundation

enum AppError: LocalizedError, Equatable {
    case network(Error)
    case server(Int, String?)
    case notFound
    case timeout
    case decoding(Error)
    case unknown(Error)

    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.network, .network),
             (.notFound, .notFound),
             (.timeout, .timeout):
            return true
        case (.server(let lhsCode, _), .server(let rhsCode, _)):
            return lhsCode == rhsCode
        case (.decoding, .decoding),
             (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .network(let error):
            return "Ошибка сети: \(error.localizedDescription)"
        case .server(let code, let message):
            return message ?? "Ошибка сервера: \(code)"
        case .notFound:
            return "Ресурс не найден"
        case .timeout:
            return "Превышено время ожидания"
        case .decoding(let error):
            return "Ошибка декодирования: \(error.localizedDescription)"
        case .unknown(let error):
            return "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }
    
    static func from(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }
        
        if error is CancellationError {
            return .unknown(error)
        }
        
        if error is TimeoutError {
            return .timeout
        }
        
        if let factoryError = error as? NetworkClientFactoryError {
            switch factoryError {
            case .apiKeyNotFound:
                return .unknown(error)
            case .clientCreationFailed(let underlyingError):
                return .from(underlyingError)
            }
        }
        
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .cannotConnectToHost:
                return .network(error)
            case .timedOut:
                return .timeout
            case .badServerResponse:
                return .server(0, "Неверный ответ сервера")
            case .cannotParseResponse:
                return .decoding(error)
            default:
                return .network(error)
            }
        }
        
        if let nsError = error as NSError?,
           nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet,
                 NSURLErrorNetworkConnectionLost,
                 NSURLErrorCannotConnectToHost:
                return .network(error)
            case NSURLErrorTimedOut:
                return .timeout
            case NSURLErrorBadServerResponse:
                return .server(0, "Неверный ответ сервера")
            case NSURLErrorCannotParseResponse:
                return .decoding(error)
            default:
                return .network(error)
            }
        }
        
        if let httpError = error as NSError?,
           httpError.domain != NSURLErrorDomain {
            var statusCode: Int?
            
            if let code = httpError.userInfo["statusCode"] as? Int {
                statusCode = code
            } else if let code = httpError.userInfo["HTTPStatusCode"] as? Int {
                statusCode = code
            } else if let code = httpError.userInfo["status"] as? Int {
                statusCode = code
            }
            
            if statusCode == nil,
               let description = httpError.userInfo[NSLocalizedDescriptionKey] as? String {
                let patterns = ["404", "500", "503", "400", "401", "403", "502", "504"]
                for pattern in patterns {
                    if description.contains(pattern) {
                        statusCode = Int(pattern)
                        break
                    }
                }
            }
            
            let isHTTPError = httpError.domain.contains("HTTP") ||
            httpError.domain.contains("OpenAPI") ||
            httpError.domain.contains("URLError") ||
            statusCode != nil
            
            if let code = statusCode, isHTTPError {
                if code == 404 {
                    return .notFound
                } else if code >= 500 {
                    return .server(code, httpError.localizedDescription)
                } else if code >= 400 {
                    return .server(code, httpError.localizedDescription)
                }
            }
        }
        
        if error is DecodingError {
            return .decoding(error)
        }
        
        return .unknown(error)
    }
    
    var shouldShowToUser: Bool {
        switch self {
        case .network, .server, .timeout:
            return true
        case .notFound:
            return false
        case .decoding, .unknown:
            return true
        }
    }
}

