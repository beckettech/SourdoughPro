import Foundation

protocol RecipeService: AnyObject {
    func listRecipes(includePremium: Bool) async throws -> [Recipe]
    func getRecipe(_ id: UUID) async throws -> Recipe
    func searchRecipes(query: String) async throws -> [Recipe]
}

final class MockRecipeService: RecipeService {
    private let all: [Recipe] = MockRecipes.all

    func listRecipes(includePremium: Bool) async throws -> [Recipe] {
        try await Task.sleep(nanoseconds: 200_000_000)
        return includePremium ? all : all.filter { !$0.isPremium }
    }
    func getRecipe(_ id: UUID) async throws -> Recipe {
        try await Task.sleep(nanoseconds: 100_000_000)
        guard let r = all.first(where: { $0.id == id }) else {
            throw APIError.serverError(404, "Recipe not found")
        }
        return r
    }
    func searchRecipes(query: String) async throws -> [Recipe] {
        try await Task.sleep(nanoseconds: 100_000_000)
        let q = query.lowercased()
        return all.filter {
            $0.name.lowercased().contains(q)
            || $0.summary.lowercased().contains(q)
            || $0.tags.contains { $0.lowercased().contains(q) }
        }
    }
}

final class SupabaseRecipeService: RecipeService {
    private let client: APIClient
    init(client: APIClient) { self.client = client }
    func listRecipes(includePremium: Bool) async throws -> [Recipe] { throw APIError.notImplemented }
    func getRecipe(_ id: UUID) async throws -> Recipe { throw APIError.notImplemented }
    func searchRecipes(query: String) async throws -> [Recipe]      { throw APIError.notImplemented }
}
