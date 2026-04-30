import Foundation

enum APIError: LocalizedError {
    case notImplemented
    case network(String)
    case decoding(String)
    case unauthorized
    case rateLimited
    case serverError(Int, String?)
    case quotaExceeded
    case unknown

    var errorDescription: String? {
        switch self {
        case .notImplemented:    return "Real backend not wired — running on mocks."
        case .network(let msg):  return "Network error: \(msg)"
        case .decoding(let msg): return "Couldn't parse response: \(msg)"
        case .unauthorized:      return "Please sign in again."
        case .rateLimited:       return "Too many requests, please slow down."
        case .serverError(let code, let msg): return "Server error \(code): \(msg ?? "—")"
        case .quotaExceeded:     return "You've used all your AI scans this month. Upgrade to Pro."
        case .unknown:           return "Something went wrong."
        }
    }
}
