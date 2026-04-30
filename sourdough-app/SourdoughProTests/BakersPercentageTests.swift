import XCTest
@testable import SourdoughPro

final class BakersPercentageTests: XCTestCase {

    private let classicIngredients: [Ingredient] = [
        Ingredient(name: "Bread flour",    grams: 500),
        Ingredient(name: "Water (warm)",   grams: 375),
        Ingredient(name: "Active starter", grams: 100),
        Ingredient(name: "Salt",           grams: 10),
    ]

    func testHydrationClassicSourdough() {
        let result = BakersPercentage.hydration(ingredients: classicIngredients)
        XCTAssertEqual(result, 75)
    }

    func testHydrationZeroFlour() {
        let result = BakersPercentage.hydration(ingredients: [
            Ingredient(name: "Water", grams: 100)
        ])
        XCTAssertEqual(result, 0)
    }

    func testScaleDouble() {
        let doubled = BakersPercentage.scale(classicIngredients, by: 2.0)
        XCTAssertEqual(doubled[0].grams, 1000) // flour
        XCTAssertEqual(doubled[1].grams, 750)  // water
        XCTAssertEqual(doubled[2].grams, 200)  // starter
        XCTAssertEqual(doubled[3].grams, 20)   // salt
    }

    func testScaleHalf() {
        let halved = BakersPercentage.scale(classicIngredients, by: 0.5)
        XCTAssertEqual(halved[0].grams, 250)
        XCTAssertEqual(halved[1].grams, 188) // 375 * 0.5 = 187.5 → rounds to 188
    }

    func testAnnotatedPercentages() {
        let annotated = BakersPercentage.annotated(ingredients: classicIngredients)
        let flour   = annotated.first(where: { $0.name.lowercased().contains("flour") })!
        let water   = annotated.first(where: { $0.name.lowercased().contains("water") })!
        let starter = annotated.first(where: { $0.name.lowercased().contains("starter") })!

        XCTAssertEqual(flour.bakersPercent ?? 0,   100, accuracy: 0.1)
        XCTAssertEqual(water.bakersPercent ?? 0,    75, accuracy: 0.1)
        XCTAssertEqual(starter.bakersPercent ?? 0,  20, accuracy: 0.1)
    }

    func testAnnotatedNoFlour() {
        let noFlour = [Ingredient(name: "Water", grams: 100)]
        let annotated = BakersPercentage.annotated(ingredients: noFlour)
        // Returns unchanged when no flour found
        XCTAssertEqual(annotated.count, 1)
    }
}
