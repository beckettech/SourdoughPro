import XCTest
@testable import SourdoughPro

@MainActor
final class MockServiceTests: XCTestCase {

    // MARK: StarterService

    func testListStartersReturnsMockData() async throws {
        let svc = MockStarterService(persisted: false)
        let starters = try await svc.listStarters()
        XCTAssertEqual(starters.count, 2)
        XCTAssertTrue(starters.contains(where: { $0.name == "Bubbles" }))
        XCTAssertTrue(starters.contains(where: { $0.name == "Gerty" }))
    }

    func testCreateStarterPersists() async throws {
        let svc = MockStarterService(persisted: false)
        let new = Starter(name: "Sparky", createdAt: Date(), flourType: .allPurpose)
        _ = try await svc.createStarter(new)
        let all = try await svc.listStarters()
        XCTAssertTrue(all.contains(where: { $0.name == "Sparky" }))
    }

    func testDeleteStarterRemovesIt() async throws {
        let svc = MockStarterService(persisted: false)
        try await svc.deleteStarter(MockStarters.bubblesId)
        let all = try await svc.listStarters()
        XCTAssertFalse(all.contains(where: { $0.id == MockStarters.bubblesId }))
    }

    func testAddFeedingUpdatesLastFedAt() async throws {
        let svc = MockStarterService(persisted: false)
        let feeding = Feeding(starterId: MockStarters.bubblesId, date: Date(),
                              starterGrams: 25, flourGrams: 50, waterGrams: 50)
        _ = try await svc.addFeeding(feeding)
        let updated = try await svc.getStarter(MockStarters.bubblesId)
        XCTAssertNotNil(updated.lastFedAt)
    }

    func testGetUnknownStarterThrows() async {
        let svc = MockStarterService(persisted: false)
        do {
            _ = try await svc.getStarter(UUID())
            XCTFail("Expected an error")
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }

    // MARK: RecipeService

    func testListRecipesReturnsTen() async throws {
        let svc = MockRecipeService()
        let recipes = try await svc.listRecipes(includePremium: true)
        XCTAssertEqual(recipes.count, 10)
    }

    func testGetRecipeById() async throws {
        let svc = MockRecipeService()
        let recipe = try await svc.getRecipe(MockRecipes.classicSourdoughId)
        XCTAssertEqual(recipe.name, "Classic Sourdough")
    }

    // MARK: BakeService

    func testStartSessionCreatesEntry() async throws {
        let svc = MockBakeService(persisted: false)
        let session = try await svc.startSession(starterId: MockStarters.bubblesId,
                                                  recipe: MockRecipes.classicSourdough)
        XCTAssertEqual(session.recipeId, MockRecipes.classicSourdoughId)
        XCTAssertEqual(session.currentStepIndex, 0)
    }

    func testCompleteStepAdvancesIndex() async throws {
        let svc = MockBakeService(persisted: false)
        let session = try await svc.startSession(starterId: MockStarters.bubblesId,
                                                  recipe: MockRecipes.classicSourdough)
        let step = MockRecipes.classicSourdough.steps[0]
        let updated = try await svc.completeStep(sessionId: session.id, stepId: step.id)
        XCTAssertEqual(updated.currentStepIndex, 1)
    }

    func testCompleteSessionSetsRatingAndCompletedAt() async throws {
        let svc = MockBakeService(persisted: false)
        let session = try await svc.startSession(starterId: MockStarters.bubblesId,
                                                  recipe: MockRecipes.classicSourdough)
        let done = try await svc.completeSession(session.id, rating: 5)
        XCTAssertEqual(done.rating, 5)
        XCTAssertNotNil(done.completedAt)
    }
}
