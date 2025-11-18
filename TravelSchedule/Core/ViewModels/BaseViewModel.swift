import Foundation
import SwiftUI
import Combine

@MainActor
class BaseViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var appError: AppError?
    
    // MARK: - Public Methods
    func handleError(_ error: Error) -> Bool {
        if Task.isCancelled || error is CancellationError {
            isLoading = false
            return true
        }
        
        let appError = AppError.from(error)
        self.error = error
        self.appError = appError.shouldShowToUser ? appError : nil
        isLoading = false
        return false
    }
    
    func clearError() {
        error = nil
        appError = nil
    }
    
    func startLoading() {
        isLoading = true
        error = nil
        appError = nil
    }
    
    func stopLoading() {
        isLoading = false
    }
    
    func getErrorRoute() -> Route? {
        guard let appError = appError else { return nil }
        switch appError {
        case .network:
            return .noInternet
        case .server:
            return .serverError
        case .timeout:
            return .serverError
        case .notFound, .decoding, .unknown:
            return nil
        }
    }

    @discardableResult
    func clearErrorIfNeeded() -> Bool {
        guard appError != nil else { return false }
        clearError()
        return true
    }
}

// MARK: - Loading Pattern Extension
extension BaseViewModel {
    func executeWithLoading<T>(
        operation: @escaping () async throws -> T,
        onSuccess: @escaping (T) -> Void,
        onError: ((Error) -> Void)? = nil
    ) async {
        guard !isLoading else { return }
        startLoading()
        
        do {
            let result = try await operation()
            
            guard !Task.isCancelled else {
                stopLoading()
                return
            }
            
            onSuccess(result)
        } catch {
            if !handleError(error) {
                onError?(error)
            }
            return
        }
        
        stopLoading()
    }
}

// MARK: - Filterable Protocol
protocol FilterableViewModel: BaseViewModel {
    associatedtype Item
    var items: [Item] { get set }
    var filteredItems: [Item] { get set }
    func filterKey(for item: Item) -> String
}

extension FilterableViewModel {
    func filter(by text: String) {
        if text.isEmpty {
            filteredItems = items
        } else {
            let searchText = text.lowercased()
            filteredItems = items.filter { 
                filterKey(for: $0).lowercased().contains(searchText) 
            }
        }
    }
}

