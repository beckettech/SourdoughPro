import Foundation
import Combine

protocol AuthService: AnyObject {
    var currentUser: User? { get }
    var userPublisher: AnyPublisher<User?, Never> { get }

    func signIn(email: String, password: String) async throws -> User
    func signUp(email: String, password: String, displayName: String?) async throws -> User
    func signInWithApple() async throws -> User
    func signInWithGoogle() async throws -> User
    func signOut() async throws
    func refresh() async throws
}

// MARK: Mock

final class MockAuthService: AuthService {
    @Published private var user: User?
    var currentUser: User? { user }
    var userPublisher: AnyPublisher<User?, Never> { $user.eraseToAnyPublisher() }

    init(startSignedIn: Bool = false) {
        self.user = startSignedIn ? MockUser.sample : nil
    }

    func signIn(email: String, password: String) async throws -> User {
        try await Task.sleep(nanoseconds: 400_000_000)
        var u = MockUser.sample
        u.email = email
        self.user = u
        return u
    }

    func signUp(email: String, password: String, displayName: String?) async throws -> User {
        try await Task.sleep(nanoseconds: 600_000_000)
        var u = MockUser.sample
        u.email = email
        u.displayName = displayName
        u.subscriptionTier = .free
        u.aiScansRemaining = 3
        self.user = u
        return u
    }

    func signInWithApple() async throws -> User {
        try await Task.sleep(nanoseconds: 500_000_000)
        self.user = MockUser.sample
        return MockUser.sample
    }

    func signInWithGoogle() async throws -> User {
        try await Task.sleep(nanoseconds: 500_000_000)
        self.user = MockUser.sample
        return MockUser.sample
    }

    func signOut() async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        self.user = nil
    }

    func refresh() async throws {
        try await Task.sleep(nanoseconds: 100_000_000)
    }
}

// MARK: Real (Supabase stub)

final class SupabaseAuthService: AuthService {
    @Published private var user: User?
    var currentUser: User? { user }
    var userPublisher: AnyPublisher<User?, Never> { $user.eraseToAnyPublisher() }

    private let client: APIClient

    init(client: APIClient) { self.client = client }

    func signIn(email: String, password: String) async throws -> User {
        // TODO: POST /auth/v1/token?grant_type=password, set bearer, fetch /auth/v1/user
        throw APIError.notImplemented
    }
    func signUp(email: String, password: String, displayName: String?) async throws -> User {
        throw APIError.notImplemented
    }
    func signInWithApple() async throws -> User  { throw APIError.notImplemented }
    func signInWithGoogle() async throws -> User { throw APIError.notImplemented }
    func signOut()  async throws { throw APIError.notImplemented }
    func refresh() async throws  { throw APIError.notImplemented }
}
