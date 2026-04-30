import Foundation
import Combine

protocol BakeService: AnyObject {
    var sessionsPublisher: AnyPublisher<[BakeSession], Never> { get }

    func listSessions() async throws -> [BakeSession]
    func getSession(_ id: UUID) async throws -> BakeSession
    func startSession(starterId: UUID, recipe: Recipe) async throws -> BakeSession
    func updateSession(_ session: BakeSession) async throws -> BakeSession
    func completeStep(sessionId: UUID, stepId: UUID) async throws -> BakeSession
    func completeSession(_ id: UUID, rating: Int?) async throws -> BakeSession
}

final class MockBakeService: BakeService {
    private let store: JSONFileStore<[BakeSession]>?
    @Published private var sessions: [BakeSession]
    var sessionsPublisher: AnyPublisher<[BakeSession], Never> { $sessions.eraseToAnyPublisher() }

    init(persisted: Bool = true) {
        if persisted {
            let store = JSONFileStore<[BakeSession]>(filename: "bakes.json")
            self.store = store
            self.sessions = store.load(fallback: [])
        } else {
            self.store = nil
            self.sessions = MockBakes.recent
        }
    }

    private func persist() { store?.save(sessions) }

    func listSessions() async throws -> [BakeSession] {
        try await Task.sleep(nanoseconds: 200_000_000)
        return sessions
    }
    func getSession(_ id: UUID) async throws -> BakeSession {
        guard let s = sessions.first(where: { $0.id == id }) else {
            throw APIError.serverError(404, "Bake session not found")
        }
        return s
    }
    func startSession(starterId: UUID, recipe: Recipe) async throws -> BakeSession {
        try await Task.sleep(nanoseconds: 300_000_000)
        let session = BakeSession(
            starterId: starterId,
            recipeId: recipe.id,
            recipeName: recipe.name,
            startedAt: Date(),
            currentStepIndex: 0
        )
        sessions.insert(session, at: 0)
        persist()
        return session
    }
    func updateSession(_ session: BakeSession) async throws -> BakeSession {
        if let idx = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[idx] = session
            persist()
        }
        return session
    }
    func completeStep(sessionId: UUID, stepId: UUID) async throws -> BakeSession {
        guard let idx = sessions.firstIndex(where: { $0.id == sessionId }) else {
            throw APIError.serverError(404, "Session not found")
        }
        sessions[idx].stepHistory.append(StepCompletion(stepId: stepId, completedAt: Date()))
        sessions[idx].currentStepIndex += 1
        persist()
        return sessions[idx]
    }
    func completeSession(_ id: UUID, rating: Int?) async throws -> BakeSession {
        guard let idx = sessions.firstIndex(where: { $0.id == id }) else {
            throw APIError.serverError(404, "Session not found")
        }
        sessions[idx].completedAt = Date()
        sessions[idx].rating = rating
        persist()
        return sessions[idx]
    }
}

final class SupabaseBakeService: BakeService {
    private let client: APIClient
    @Published private var sessions: [BakeSession] = []
    var sessionsPublisher: AnyPublisher<[BakeSession], Never> { $sessions.eraseToAnyPublisher() }
    init(client: APIClient) { self.client = client }
    func listSessions() async throws -> [BakeSession] { throw APIError.notImplemented }
    func getSession(_ id: UUID) async throws -> BakeSession { throw APIError.notImplemented }
    func startSession(starterId: UUID, recipe: Recipe) async throws -> BakeSession { throw APIError.notImplemented }
    func updateSession(_ session: BakeSession) async throws -> BakeSession { throw APIError.notImplemented }
    func completeStep(sessionId: UUID, stepId: UUID) async throws -> BakeSession { throw APIError.notImplemented }
    func completeSession(_ id: UUID, rating: Int?) async throws -> BakeSession { throw APIError.notImplemented }
}
