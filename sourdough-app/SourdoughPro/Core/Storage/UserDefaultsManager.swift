import Foundation

/// Thin, typed facade over UserDefaults for non-secure app state.
enum DefaultsKey: String {
    case hasCompletedOnboarding
    case currentUserId
    case preferredTheme
    case preferredUnits
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    private init() {}

    func bool(_ key: DefaultsKey) -> Bool {
        defaults.bool(forKey: key.rawValue)
    }
    func set(_ value: Bool, for key: DefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
    func string(_ key: DefaultsKey) -> String? {
        defaults.string(forKey: key.rawValue)
    }
    func set(_ value: String?, for key: DefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
}
