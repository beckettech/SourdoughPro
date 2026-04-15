import Foundation

enum MockRecipes {

    static let classicSourdoughId = UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa01")!

    static let all: [Recipe] = [
        classicSourdough,
        seededRye,
        countryLoaf,
        sandwichLoaf,
        focaccia,
        baguette,
        cinnamonRaisin,
        walnutCranberry,
        wholeWheat,
        ryeSourdough,
    ]

    // MARK: 1. Classic Sourdough (featured)
    static let classicSourdough: Recipe = Recipe(
        id: classicSourdoughId,
        name: "Classic Sourdough",
        summary: "A rustic country loaf with a crackling crust and open crumb. A solid starting point for any home baker.",
        difficulty: .intermediate,
        prepTimeMinutes: 45,
        totalDurationHours: 24,
        servings: 2,
        ingredients: [
            Ingredient(name: "Bread flour",     grams: 500, bakersPercent: 100, notes: "King Arthur recommended"),
            Ingredient(name: "Water (warm)",    grams: 375, bakersPercent: 75),
            Ingredient(name: "Active starter",  grams: 100, bakersPercent: 20, notes: "At peak activity"),
            Ingredient(name: "Salt",            grams: 10,  bakersPercent: 2),
        ],
        steps: [
            RecipeStep(order: 1, title: "Feed starter",      instructions: "Feed your starter 4-8 hours before mixing. It should double in size and pass the float test.", durationMinutes: 480, timerType: .feed),
            RecipeStep(order: 2, title: "Autolyse",          instructions: "Mix flour and water until no dry spots remain. Cover and rest 1 hour.", durationMinutes: 60,  timerType: .rest),
            RecipeStep(order: 3, title: "Add starter & salt",instructions: "Add the active starter and salt. Use pinch-and-fold to incorporate.", durationMinutes: 10,  timerType: .mix),
            RecipeStep(order: 4, title: "Bulk ferment",      instructions: "Four sets of stretch-and-folds, 30 minutes apart. Then rest until dough has grown 50-75 %.", durationMinutes: 270, timerType: .bulk),
            RecipeStep(order: 5, title: "Shape",             instructions: "Pre-shape, bench rest 20 min, final shape into a tight boule. Place seam-up in a floured banneton.", durationMinutes: 20,  timerType: .shape),
            RecipeStep(order: 6, title: "Cold proof",        instructions: "Cover and refrigerate overnight (8-14 hours).", durationMinutes: 12 * 60, timerType: .proof),
            RecipeStep(order: 7, title: "Bake",              instructions: "Preheat Dutch oven to 500°F. Score the dough. Bake covered 20 min, uncovered 25 min at 450°F.", durationMinutes: 45,  timerType: .bake),
        ],
        hydration: 75,
        flourType: .bread,
        imageUrl: nil,
        authorId: nil,
        isPremium: false,
        tags: ["classic", "beginner-friendly", "country"],
        rating: 4.8,
        reviewCount: 234
    )

    // MARK: 2. Seeded Rye
    static let seededRye = Recipe(
        name: "Seeded Rye",
        summary: "A dense, tangy rye loaf studded with caraway, sesame, and sunflower seeds.",
        difficulty: .intermediate,
        prepTimeMinutes: 30, totalDurationHours: 20, servings: 1,
        ingredients: [
            Ingredient(name: "Rye flour",         grams: 300, bakersPercent: 60),
            Ingredient(name: "Bread flour",       grams: 200, bakersPercent: 40),
            Ingredient(name: "Water",             grams: 400, bakersPercent: 80),
            Ingredient(name: "Active starter",    grams: 100, bakersPercent: 20),
            Ingredient(name: "Salt",              grams: 10,  bakersPercent: 2),
            Ingredient(name: "Caraway seeds",     grams: 8,   bakersPercent: 1.6),
            Ingredient(name: "Sesame seeds",      grams: 20,  bakersPercent: 4, notes: "Toasted"),
        ],
        steps: [
            RecipeStep(order: 1, title: "Mix",            instructions: "Combine everything and mix to a shaggy dough.", durationMinutes: 10, timerType: .mix),
            RecipeStep(order: 2, title: "Bulk ferment",   instructions: "4-6 hours at room temperature, with two folds in the first hour.", durationMinutes: 240, timerType: .bulk),
            RecipeStep(order: 3, title: "Shape and proof",instructions: "Shape into a boule and cold proof 12 hours.", durationMinutes: 720, timerType: .proof),
            RecipeStep(order: 4, title: "Bake",           instructions: "Bake in Dutch oven at 450°F for 50 minutes.", durationMinutes: 50, timerType: .bake),
        ],
        hydration: 80, flourType: .rye, isPremium: false,
        tags: ["rye", "seeded"], rating: 4.7, reviewCount: 89
    )

    // MARK: 3. Country Loaf
    static let countryLoaf = Recipe(
        name: "Country Loaf",
        summary: "A balanced blend of white and whole wheat with a moderate hydration — an everyday loaf.",
        difficulty: .beginner,
        prepTimeMinutes: 30, totalDurationHours: 18, servings: 2,
        ingredients: [
            Ingredient(name: "Bread flour",     grams: 400, bakersPercent: 80),
            Ingredient(name: "Whole wheat flour",grams: 100, bakersPercent: 20),
            Ingredient(name: "Water",           grams: 350, bakersPercent: 70),
            Ingredient(name: "Active starter",  grams: 100, bakersPercent: 20),
            Ingredient(name: "Salt",            grams: 10,  bakersPercent: 2),
        ],
        steps: [
            RecipeStep(order: 1, title: "Mix", instructions: "Mix to a shaggy dough.", durationMinutes: 15, timerType: .mix),
            RecipeStep(order: 2, title: "Bulk ferment", instructions: "4 hours with stretch-and-folds every 45 min.", durationMinutes: 240, timerType: .bulk),
            RecipeStep(order: 3, title: "Shape and proof", instructions: "Shape and cold proof overnight.", durationMinutes: 720, timerType: .proof),
            RecipeStep(order: 4, title: "Bake", instructions: "Bake at 475°F, covered 20 min, uncovered 20 min.", durationMinutes: 40, timerType: .bake),
        ],
        hydration: 70, flourType: .mixed, isPremium: false,
        tags: ["beginner", "everyday"], rating: 4.6, reviewCount: 156
    )

    // MARK: 4. Sandwich Loaf
    static let sandwichLoaf = Recipe(
        name: "Soft Sourdough Sandwich",
        summary: "A tender sandwich loaf enriched with milk and butter. Perfect for toast and lunch boxes.",
        difficulty: .beginner,
        prepTimeMinutes: 30, totalDurationHours: 16, servings: 1,
        ingredients: [
            Ingredient(name: "Bread flour", grams: 500, bakersPercent: 100),
            Ingredient(name: "Milk",        grams: 300, bakersPercent: 60),
            Ingredient(name: "Active starter", grams: 100, bakersPercent: 20),
            Ingredient(name: "Butter (soft)", grams: 40, bakersPercent: 8),
            Ingredient(name: "Sugar",       grams: 30,  bakersPercent: 6),
            Ingredient(name: "Salt",        grams: 10,  bakersPercent: 2),
        ],
        steps: [
            RecipeStep(order: 1, title: "Mix", instructions: "Knead until smooth, 10 minutes.", durationMinutes: 10, timerType: .mix),
            RecipeStep(order: 2, title: "Bulk ferment", instructions: "3 hours.", durationMinutes: 180, timerType: .bulk),
            RecipeStep(order: 3, title: "Shape", instructions: "Shape into a log, place in a loaf pan.", durationMinutes: 10, timerType: .shape),
            RecipeStep(order: 4, title: "Proof", instructions: "Proof 4-6 hours until the dough crowns the pan.", durationMinutes: 300, timerType: .proof),
            RecipeStep(order: 5, title: "Bake", instructions: "Bake at 375°F for 40 minutes.", durationMinutes: 40, timerType: .bake),
        ],
        hydration: 60, flourType: .bread, isPremium: false,
        tags: ["sandwich", "soft"], rating: 4.9, reviewCount: 312
    )

    // MARK: 5. Focaccia
    static let focaccia = Recipe(
        name: "Rosemary Focaccia",
        summary: "High-hydration Italian flatbread with a dimpled surface and a blanket of olive oil and rosemary.",
        difficulty: .beginner,
        prepTimeMinutes: 30, totalDurationHours: 20, servings: 4,
        ingredients: [
            Ingredient(name: "Bread flour",    grams: 500, bakersPercent: 100),
            Ingredient(name: "Water",          grams: 450, bakersPercent: 90),
            Ingredient(name: "Active starter", grams: 100, bakersPercent: 20),
            Ingredient(name: "Olive oil",      grams: 40,  bakersPercent: 8),
            Ingredient(name: "Salt",           grams: 10,  bakersPercent: 2),
        ],
        steps: [
            RecipeStep(order: 1, title: "Mix", instructions: "Combine all ingredients, mix until cohesive.", durationMinutes: 10, timerType: .mix),
            RecipeStep(order: 2, title: "Bulk ferment", instructions: "4 hours at room temperature with 3 coil folds.", durationMinutes: 240, timerType: .bulk),
            RecipeStep(order: 3, title: "Cold proof", instructions: "Transfer to a well-oiled tray and cold proof overnight.", durationMinutes: 720, timerType: .proof),
            RecipeStep(order: 4, title: "Dimple & top", instructions: "Dimple the dough, top with olive oil, rosemary, flaky salt.", durationMinutes: 10, timerType: .shape),
            RecipeStep(order: 5, title: "Bake", instructions: "Bake at 475°F for 20-25 minutes until golden.", durationMinutes: 25, timerType: .bake),
        ],
        hydration: 90, flourType: .bread, isPremium: false,
        tags: ["focaccia", "italian", "high-hydration"], rating: 4.9, reviewCount: 278
    )

    // MARK: 6. Baguette
    static let baguette = Recipe(
        name: "Sourdough Baguette",
        summary: "Crisp crust, open crumb, classic Parisian shape. Requires confident shaping.",
        difficulty: .advanced,
        prepTimeMinutes: 60, totalDurationHours: 18, servings: 3,
        ingredients: [
            Ingredient(name: "Bread flour",    grams: 500, bakersPercent: 100),
            Ingredient(name: "Water",          grams: 360, bakersPercent: 72),
            Ingredient(name: "Active starter", grams: 75,  bakersPercent: 15),
            Ingredient(name: "Salt",           grams: 10,  bakersPercent: 2),
        ],
        steps: [
            RecipeStep(order: 1, title: "Mix & autolyse", instructions: "Mix flour and water, rest 1 hour.", durationMinutes: 60, timerType: .rest),
            RecipeStep(order: 2, title: "Add starter & salt", instructions: "Incorporate the starter and salt.", durationMinutes: 10, timerType: .mix),
            RecipeStep(order: 3, title: "Bulk ferment", instructions: "4 hours with stretch-and-folds every 45 min.", durationMinutes: 240, timerType: .bulk),
            RecipeStep(order: 4, title: "Divide & pre-shape", instructions: "Divide into 3 pieces, pre-shape into logs.", durationMinutes: 20, timerType: .shape),
            RecipeStep(order: 5, title: "Final shape", instructions: "Shape into 14-inch baguettes, rest on a couche.", durationMinutes: 30, timerType: .shape),
            RecipeStep(order: 6, title: "Proof & bake", instructions: "Proof 1 hour, score, bake at 500°F with steam for 22 minutes.", durationMinutes: 82, timerType: .bake),
        ],
        hydration: 72, flourType: .bread, isPremium: true,
        tags: ["baguette", "french", "advanced"], rating: 4.7, reviewCount: 66
    )

    // MARK: 7. Cinnamon Raisin
    static let cinnamonRaisin = Recipe(
        name: "Cinnamon Raisin Swirl",
        summary: "A sweet, swirled sandwich loaf packed with plump raisins and a cinnamon sugar filling.",
        difficulty: .intermediate,
        prepTimeMinutes: 45, totalDurationHours: 14, servings: 1,
        ingredients: [
            Ingredient(name: "Bread flour", grams: 500, bakersPercent: 100),
            Ingredient(name: "Milk", grams: 300, bakersPercent: 60),
            Ingredient(name: "Active starter", grams: 100, bakersPercent: 20),
            Ingredient(name: "Butter (soft)", grams: 50, bakersPercent: 10),
            Ingredient(name: "Sugar", grams: 40, bakersPercent: 8),
            Ingredient(name: "Salt", grams: 10, bakersPercent: 2),
            Ingredient(name: "Raisins", grams: 150, bakersPercent: 30, notes: "Soak in warm water 20 min"),
            Ingredient(name: "Cinnamon sugar", grams: 50, bakersPercent: 10, notes: "For the swirl"),
        ],
        steps: [
            RecipeStep(order: 1, title: "Mix & knead", instructions: "Knead until smooth.", durationMinutes: 15, timerType: .mix),
            RecipeStep(order: 2, title: "Add raisins", instructions: "Work drained raisins in after the first fold.", durationMinutes: 5, timerType: .mix),
            RecipeStep(order: 3, title: "Bulk ferment", instructions: "4 hours.", durationMinutes: 240, timerType: .bulk),
            RecipeStep(order: 4, title: "Roll & fill", instructions: "Roll out, sprinkle cinnamon sugar, roll up and place in loaf pan.", durationMinutes: 15, timerType: .shape),
            RecipeStep(order: 5, title: "Proof & bake", instructions: "Proof 4 hours, bake at 375°F for 40 minutes.", durationMinutes: 280, timerType: .bake),
        ],
        hydration: 60, flourType: .bread, isPremium: false,
        tags: ["sweet", "raisin"], rating: 4.8, reviewCount: 124
    )

    // MARK: 8. Walnut Cranberry
    static let walnutCranberry = Recipe(
        name: "Walnut Cranberry Boule",
        summary: "A holiday-ready boule with toasted walnuts and tart dried cranberries.",
        difficulty: .intermediate,
        prepTimeMinutes: 30, totalDurationHours: 20, servings: 1,
        ingredients: [
            Ingredient(name: "Bread flour", grams: 400, bakersPercent: 80),
            Ingredient(name: "Whole wheat flour", grams: 100, bakersPercent: 20),
            Ingredient(name: "Water", grams: 375, bakersPercent: 75),
            Ingredient(name: "Active starter", grams: 100, bakersPercent: 20),
            Ingredient(name: "Salt", grams: 10, bakersPercent: 2),
            Ingredient(name: "Walnuts (toasted)", grams: 100, bakersPercent: 20),
            Ingredient(name: "Dried cranberries", grams: 100, bakersPercent: 20),
        ],
        steps: [
            RecipeStep(order: 1, title: "Autolyse", instructions: "Mix flour and water, rest 1 hour.", durationMinutes: 60, timerType: .rest),
            RecipeStep(order: 2, title: "Add starter, salt, inclusions", instructions: "Work in starter, salt, walnuts and cranberries.", durationMinutes: 15, timerType: .mix),
            RecipeStep(order: 3, title: "Bulk ferment", instructions: "4 hours, three folds in the first 90 minutes.", durationMinutes: 240, timerType: .bulk),
            RecipeStep(order: 4, title: "Shape & cold proof", instructions: "Shape into a boule, cold proof overnight.", durationMinutes: 720, timerType: .proof),
            RecipeStep(order: 5, title: "Bake", instructions: "Bake in Dutch oven at 475°F covered 20 min, uncovered 25 min.", durationMinutes: 45, timerType: .bake),
        ],
        hydration: 75, flourType: .mixed, isPremium: false,
        tags: ["holiday", "walnut", "cranberry"], rating: 4.9, reviewCount: 98
    )

    // MARK: 9. Whole Wheat
    static let wholeWheat = Recipe(
        name: "Hearty Whole Wheat",
        summary: "A 100% whole wheat loaf with a rich, nutty flavour and moist crumb.",
        difficulty: .intermediate,
        prepTimeMinutes: 30, totalDurationHours: 18, servings: 1,
        ingredients: [
            Ingredient(name: "Whole wheat flour", grams: 500, bakersPercent: 100),
            Ingredient(name: "Water", grams: 425, bakersPercent: 85),
            Ingredient(name: "Active starter", grams: 100, bakersPercent: 20),
            Ingredient(name: "Honey", grams: 30, bakersPercent: 6),
            Ingredient(name: "Salt", grams: 10, bakersPercent: 2),
        ],
        steps: [
            RecipeStep(order: 1, title: "Mix", instructions: "Mix all ingredients to a shaggy dough.", durationMinutes: 15, timerType: .mix),
            RecipeStep(order: 2, title: "Bulk ferment", instructions: "4-5 hours — whole wheat ferments faster.", durationMinutes: 270, timerType: .bulk),
            RecipeStep(order: 3, title: "Shape & cold proof", instructions: "Shape and cold proof overnight.", durationMinutes: 720, timerType: .proof),
            RecipeStep(order: 4, title: "Bake", instructions: "Bake at 450°F for 45 minutes.", durationMinutes: 45, timerType: .bake),
        ],
        hydration: 85, flourType: .wholeWheat, isPremium: false,
        tags: ["whole wheat", "hearty"], rating: 4.5, reviewCount: 73
    )

    // MARK: 10. Pure Rye
    static let ryeSourdough = Recipe(
        name: "Pure Rye Sourdough",
        summary: "100% rye — dense, tangy, and deeply flavourful. Traditional Northern European style.",
        difficulty: .advanced,
        prepTimeMinutes: 30, totalDurationHours: 24, servings: 1,
        ingredients: [
            Ingredient(name: "Rye flour",        grams: 500, bakersPercent: 100),
            Ingredient(name: "Water",            grams: 450, bakersPercent: 90),
            Ingredient(name: "Rye starter",      grams: 150, bakersPercent: 30),
            Ingredient(name: "Salt",             grams: 10,  bakersPercent: 2),
            Ingredient(name: "Caraway seeds",    grams: 10,  bakersPercent: 2),
        ],
        steps: [
            RecipeStep(order: 1, title: "Mix", instructions: "Stir vigorously — rye has no gluten to develop.", durationMinutes: 5, timerType: .mix),
            RecipeStep(order: 2, title: "Bulk ferment", instructions: "3 hours.", durationMinutes: 180, timerType: .bulk),
            RecipeStep(order: 3, title: "Pan & proof", instructions: "Transfer to a greased loaf pan, proof 3-4 hours.", durationMinutes: 210, timerType: .proof),
            RecipeStep(order: 4, title: "Bake", instructions: "Bake at 425°F for 60 minutes with steam.", durationMinutes: 60, timerType: .bake),
            RecipeStep(order: 5, title: "Rest 24 hours", instructions: "Rye needs a full day to set before slicing.", durationMinutes: 1440, timerType: .rest),
        ],
        hydration: 90, flourType: .rye, isPremium: true,
        tags: ["rye", "pure-rye", "traditional"], rating: 4.6, reviewCount: 42
    )
}
