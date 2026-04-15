import Foundation

/// URLSession-backed API client. The real Supabase/OpenAI service
/// implementations compose this with their own endpoint + header logic.
///
/// Kept intentionally simple — auth header injection and retry logic live
/// on specific services so this layer stays testable.
actor APIClient {

    let baseURL: URL
    let session: URLSession
    var bearerToken: String?

    init(baseURL: URL, session: URLSession = .shared, bearerToken: String? = nil) {
        self.baseURL = baseURL
        self.session = session
        self.bearerToken = bearerToken
    }

    func setToken(_ token: String?) { bearerToken = token }

    func get<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        try await send(endpoint, method: "GET", body: nil as EmptyBody?)
    }

    func post<Body: Encodable, T: Decodable>(_ endpoint: Endpoint, body: Body) async throws -> T {
        try await send(endpoint, method: "POST", body: body)
    }

    func patch<Body: Encodable, T: Decodable>(_ endpoint: Endpoint, body: Body) async throws -> T {
        try await send(endpoint, method: "PATCH", body: body)
    }

    func delete(_ endpoint: Endpoint) async throws {
        let _: EmptyResponse = try await send(endpoint, method: "DELETE", body: nil as EmptyBody?)
    }

    // MARK: Core
    private func send<Body: Encodable, T: Decodable>(
        _ endpoint: Endpoint, method: String, body: Body?
    ) async throws -> T {
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            throw APIError.network("Invalid URL")
        }
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let bearerToken { req.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization") }
        if let body {
            req.httpBody = try JSONEncoder.iso.encode(body)
        }

        let (data, resp) = try await session.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw APIError.unknown }
        switch http.statusCode {
        case 200..<300:
            if T.self == EmptyResponse.self { return EmptyResponse() as! T }
            return try JSONDecoder.iso.decode(T.self, from: data)
        case 401:
            throw APIError.unauthorized
        case 429:
            throw APIError.rateLimited
        default:
            throw APIError.serverError(http.statusCode, String(data: data, encoding: .utf8))
        }
    }
}

private struct EmptyBody: Encodable {}
private struct EmptyResponse: Decodable {}

extension JSONEncoder {
    static let iso: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()
}
extension JSONDecoder {
    static let iso: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
}
