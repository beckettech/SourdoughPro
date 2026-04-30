import Foundation

enum MockBakes {

    static let recent: [BakeSession] = [
        // Most recent — finished yesterday, Classic Sourdough, 4-star
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
        // Seeded Rye — perfect bake with Bubbles
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
        // Rosemary Focaccia — Gerty's debut bake, crowd favourite
        BakeSession(
            starterId: MockStarters.gertyId,
            recipeId: MockRecipes.focaccia.id,
            recipeName: "Rosemary Focaccia",
            startedAt: Calendar.current.date(byAdding: .day, value: -8, to: Date()) ?? Date(),
            completedAt: Calendar.current.date(byAdding: .day, value: -7, to: Date()),
            currentStepIndex: MockRecipes.focaccia.steps.count,
            stepHistory: [],
            rating: 5
        ),
        // Jalapeño Cheddar — highlight of last week
        BakeSession(
            starterId: MockStarters.bubblesId,
            recipeId: MockRecipes.jalapeñoCheddar.id,
            recipeName: "Jalapeño Cheddar",
            startedAt: Calendar.current.date(byAdding: .day, value: -11, to: Date()) ?? Date(),
            completedAt: Calendar.current.date(byAdding: .day, value: -10, to: Date()),
            currentStepIndex: MockRecipes.jalapeñoCheddar.steps.count,
            stepHistory: [],
            rating: 5
        ),
        // Whole Wheat — Gerty, slight under-proof (3 stars)
        BakeSession(
            starterId: MockStarters.gertyId,
            recipeId: MockRecipes.wholeWheat.id,
            recipeName: "Whole Wheat Sourdough",
            startedAt: Calendar.current.date(byAdding: .day, value: -16, to: Date()) ?? Date(),
            completedAt: Calendar.current.date(byAdding: .day, value: -15, to: Date()),
            currentStepIndex: MockRecipes.wholeWheat.steps.count,
            stepHistory: [],
            rating: 3
        ),
        // Country Loaf — weekend project
        BakeSession(
            starterId: MockStarters.bubblesId,
            recipeId: MockRecipes.countryLoaf.id,
            recipeName: "Country Loaf",
            startedAt: Calendar.current.date(byAdding: .day, value: -21, to: Date()) ?? Date(),
            completedAt: Calendar.current.date(byAdding: .day, value: -20, to: Date()),
            currentStepIndex: MockRecipes.countryLoaf.steps.count,
            stepHistory: [],
            rating: 4
        ),
    ]
}
