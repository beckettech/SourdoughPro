import Foundation

/// Lightweight JSON-on-disk persistence for mock services.
///
/// Writes a single Codable value to a file in the user's documents directory.
/// Designed for the mock-only era — when the real Supabase backend lands, services
/// can keep this as an offline cache or drop it entirely.
final class JSONFileStore<T: Codable> {
    private let url: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(filename: String) {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.url = docs.appendingPathComponent(filename)

        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .iso8601
        enc.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder = enc

        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        self.decoder = dec
    }

    /// Loads the persisted value, or returns the fallback if there's no file
    /// (first launch) or it can't be decoded (schema mismatch — silent reset).
    func load(fallback: T) -> T {
        guard FileManager.default.fileExists(atPath: url.path) else { return fallback }
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(T.self, from: data)
        } catch {
            #if DEBUG
            print("[JSONFileStore] decode failed for \(url.lastPathComponent): \(error). Falling back to seed.")
            #endif
            return fallback
        }
    }

    /// Writes the value to disk. Errors are logged in DEBUG and swallowed in release —
    /// failing to persist is bad but shouldn't crash the user's flow.
    func save(_ value: T) {
        do {
            let data = try encoder.encode(value)
            try data.write(to: url, options: .atomic)
        } catch {
            #if DEBUG
            print("[JSONFileStore] save failed for \(url.lastPathComponent): \(error)")
            #endif
        }
    }

    /// Deletes the persisted file. Useful for "reset app data" actions.
    func reset() {
        try? FileManager.default.removeItem(at: url)
    }
}
