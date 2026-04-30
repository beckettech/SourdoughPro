import Foundation
import Combine

protocol StarterService: AnyObject {
    var startersPublisher: AnyPublisher<[Starter], Never> { get }

    func listStarters() async throws -> [Starter]
    func getStarter(_ id: UUID) async throws -> Starter
    func createStarter(_ starter: Starter) async throws -> Starter
    func updateStarter(_ starter: Starter) async throws -> Starter
    func deleteStarter(_ id: UUID) async throws

    func addFeeding(_ feeding: Feeding) async throws -> Feeding
    func listFeedings(for starterId: UUID) async throws -> [Feeding]
    func deleteFeeding(_ feedingId: UUID, starterId: UUID) async throws
}

// MARK: Mock (in-memory, observable)

final class MockStarterService: StarterService {

    private let store: JSONFileStore<[Starter]>?
    @Published private var starters: [Starter]
    var startersPublisher: AnyPublisher<[Starter], Never> { $starters.eraseToAnyPublisher() }

    /// Pass `persisted: false` for previews & tests where you want a fresh in-memory copy.
    init(persisted: Bool = true) {
        if persisted {
            let store = JSONFileStore<[Starter]>(filename: "starters.json")
            self.store = store
            // Fresh installs start empty — no fake Bubbles/Gerty seeding.
            // Previews and tests that need fixture data use persisted: false.
            self.starters = store.load(fallback: [])
        } else {
            self.store = nil
            self.starters = MockStarters.all
        }
    }

    private func persist() { store?.save(starters) }

    func listStarters() async throws -> [Starter] {
        try await Task.sleep(nanoseconds: 200_000_000)
        return starters
    }

    func getStarter(_ id: UUID) async throws -> Starter {
        try await Task.sleep(nanoseconds: 100_000_000)
        guard let s = starters.first(where: { $0.id == id }) else {
            throw APIError.serverError(404, "Starter not found")
        }
        return s
    }

    func createStarter(_ starter: Starter) async throws -> Starter {
        try await Task.sleep(nanoseconds: 300_000_000)
        starters.append(starter)
        persist()
        return starter
    }

    func updateStarter(_ starter: Starter) async throws -> Starter {
        try await Task.sleep(nanoseconds: 200_000_000)
        guard let idx = starters.firstIndex(where: { $0.id == starter.id }) else {
            throw APIError.serverError(404, "Starter not found")
        }
        starters[idx] = starter
        persist()
        return starter
    }

    func deleteStarter(_ id: UUID) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        starters.removeAll { $0.id == id }
        persist()
    }

    func addFeeding(_ feeding: Feeding) async throws -> Feeding {
        try await Task.sleep(nanoseconds: 250_000_000)
        guard let idx = starters.firstIndex(where: { $0.id == feeding.starterId }) else {
            throw APIError.serverError(404, "Starter not found")
        }
        starters[idx].feedings.append(feeding)
        starters[idx].lastFedAt = feeding.date
        starters[idx].nextFeedingAt = FeedingScheduler.nextFeeding(for: starters[idx])
        persist()
        return feeding
    }

    func listFeedings(for starterId: UUID) async throws -> [Feeding] {
        try await Task.sleep(nanoseconds: 150_000_000)
        return starters.first(where: { $0.id == starterId })?.feedings ?? []
    }

    func deleteFeeding(_ feedingId: UUID, starterId: UUID) async throws {
        try await Task.sleep(nanoseconds: 150_000_000)
        guard let idx = starters.firstIndex(where: { $0.id == starterId }) else { return }
        starters[idx].feedings.removeAll { $0.id == feedingId }
        persist()
    }
}

// MARK: Real (Supabase stub)

final class SupabaseStarterService: StarterService {
    private let client: APIClient
    @Published private var starters: [Starter] = []
    var startersPublisher: AnyPublisher<[Starter], Never> { $starters.eraseToAnyPublisher() }

    init(client: APIClient) { self.client = client }

    func listStarters() async throws -> [Starter]    { throw APIError.notImplemented }
    func getStarter(_ id: UUID) async throws -> Starter { throw APIError.notImplemented }
    func createStarter(_ starter: Starter) async throws -> Starter { throw APIError.notImplemented }
    func updateStarter(_ starter: Starter) async throws -> Starter { throw APIError.notImplemented }
    func deleteStarter(_ id: UUID) async throws      { throw APIError.notImplemented }
    func addFeeding(_ feeding: Feeding) async throws -> Feeding { throw APIError.notImplemented }
    func listFeedings(for starterId: UUID) async throws -> [Feeding] { throw APIError.notImplemented }
    func deleteFeeding(_ feedingId: UUID, starterId: UUID) async throws { throw APIError.notImplemented }
}
