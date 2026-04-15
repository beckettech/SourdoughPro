import Foundation

enum MockBakes {

    static let recent: [BakeSession] = [
        BakeSession(
            starterId: MockStarters.bubblesId,
            recipeId: MockRecipes.classicSourdoughId,
            recipeName: "Classic Sourdough",
            startedAt: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            completedAt: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
            currentStepIndex: MockRecipes.classicSourdough.steps.count,
            stepHistory: [],
            rating: 4
        ),
        BakeSession(
            starterId: MockStarters.bubblesId,
            recipeId: MockRecipes.seededRye.id,
            recipeName: "Seeded Rye",
            startedAt: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            completedAt: Calendar.current.date(byAdding: .day, value: -4, to: Date()),
            currentStepIndex: MockRecipes.seededRye.steps.count,
            stepHistory: [],
            rating: 5
        ),
        BakeSession(
            starterId: MockStarters.bubblesId,
            recipeId: MockRecipes.focaccia.id,
            recipeName: "Rosemary Focaccia",
            startedAt: Calendar.current.date(byAdding: .day, value: -12, to: Date()) ?? Date(),
            completedAt: Calendar.current.date(byAdding: .day, value: -11, to: Date()),
            currentStepIndex: MockRecipes.focaccia.steps.count,
            stepHistory: [],
            rating: 5
        ),
    ]
}
