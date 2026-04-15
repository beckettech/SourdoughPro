import Foundation

/// Utilities for baker's-percentage math (total flour = 100 %).
enum BakersPercentage {

    /// Compute baker's percentages for each ingredient given a `flour` reference.
    /// Returns a new array with `bakersPercent` populated.
    static func annotated(ingredients: [Ingredient]) -> [Ingredient] {
        guard let totalFlour = ingredients.first(where: { $0.name.lowercased().contains("flour") })?.grams,
              totalFlour > 0 else { return ingredients }
        return ingredients.map { ing in
            var copy = ing
            copy.bakersPercent = (Double(ing.grams) / Double(totalFlour)) * 100
            return copy
        }
    }

    /// Scale a recipe's ingredients by a factor (e.g. 0.5 halves the dough).
    static func scale(_ ingredients: [Ingredient], by factor: Double) -> [Ingredient] {
        ingredients.map { ing in
            var copy = ing
            copy.grams = Int((Double(ing.grams) * factor).rounded())
            return copy
        }
    }

    /// Overall hydration percentage, given a list of ingredients.
    /// Computed as total water grams / total flour grams * 100.
    static func hydration(ingredients: [Ingredient]) -> Int {
        let flour = ingredients.filter { $0.name.lowercased().contains("flour") }
            .reduce(0) { $0 + $1.grams }
        let water = ingredients.filter { $0.name.lowercased().contains("water") }
            .reduce(0) { $0 + $1.grams }
        guard flour > 0 else { return 0 }
        return Int((Double(water) / Double(flour) * 100).rounded())
    }
}
