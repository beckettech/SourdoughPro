import Foundation

enum MockRecipes {

    static let classicSourdoughId = UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa01")!

    static let all: [Recipe] = [
        classicSourdough,
        jalapeñoCheddar,
        pizzaLoaf,
        sandwichLoaf,
        focaccia,
        roastedGarlicAsiago,
        honeyOat,
        cinnamonRaisin,
        lemonBlueberry,
        bagels,
        chocolateCherry,
        sunDriedTomatoOlive,
        countryLoaf,
        walnutCranberry,
        seededRye,
        baguette,
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

    // MARK: 4. Soft Loaf
    static let sandwichLoaf = Recipe(
        name: "Soft Sourdough Loaf",
        summary: "A tender enriched loaf with milk and butter. Slices beautifully — great for toast or sandwiches.",
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
        tags: ["soft", "enriched"], rating: 4.9, reviewCount: 312
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
        summary: "A sweet, swirled enriched loaf packed with plump raisins and a cinnamon sugar filling.",
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

    // MARK: 11. Jalapeño Cheddar
    static let jalapeñoCheddar = Recipe(
        id: UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa11")!,
        name: "Jalapeño Cheddar",
        summary: "The crowd-pleaser. Molten pockets of sharp cheddar and roasted jalapeños folded into a crackling boule.",
        difficulty: .intermediate,
        prepTimeMinutes: 45, totalDurationHours: 22, servings: 1,
        ingredients: [
            Ingredient(name: "Bread flour",          grams: 450, bakersPercent: 90),
            Ingredient(name: "Whole wheat flour",    grams: 50,  bakersPercent: 10),
            Ingredient(name: "Water (warm)",         grams: 360, bakersPercent: 72),
            Ingredient(name: "Active starter",       grams: 90,  bakersPercent: 18, notes: "At peak activity"),
            Ingredient(name: "Salt",                 grams: 10,  bakersPercent: 2),
            Ingredient(name: "Sharp cheddar, cubed", grams: 120, bakersPercent: 24, notes: "Room temperature"),
            Ingredient(name: "Jalapeños, roasted",   grams: 60,  bakersPercent: 12, notes: "Slice & char under broiler, remove seeds for less heat"),
        ],
        steps: [
            RecipeStep(order: 1, title: "Feed starter",       instructions: "Feed your starter and wait until it doubles and is bubbly.", durationMinutes: 300, timerType: .feed),
            RecipeStep(order: 2, title: "Autolyse",           instructions: "Mix flour and water until no dry flour remains. Rest 45 minutes.", durationMinutes: 45, timerType: .rest),
            RecipeStep(order: 3, title: "Add starter & salt", instructions: "Add starter and salt, use pinch-and-fold to fully incorporate.", durationMinutes: 10, timerType: .mix),
            RecipeStep(order: 4, title: "Bulk ferment",       instructions: "Perform 4 sets of stretch-and-folds 30 minutes apart. Add cheddar and jalapeños on the second fold, gently incorporating. Bulk until dough has risen 50%.", durationMinutes: 300, timerType: .bulk),
            RecipeStep(order: 5, title: "Shape",              instructions: "Pre-shape into a round, bench rest 20 minutes. Final shape into a tight boule — tuck inclusions inside. Place seam-up in a well-floured banneton.", durationMinutes: 25, timerType: .shape),
            RecipeStep(order: 6, title: "Cold proof",         instructions: "Cover with a shower cap and refrigerate 10–14 hours.", durationMinutes: 720, timerType: .proof),
            RecipeStep(order: 7, title: "Bake",               instructions: "Preheat Dutch oven to 500°F for 1 hour. Score dough with a bold cross. Bake covered 20 min, uncover, reduce to 450°F and bake 20–25 min until deep mahogany.", durationMinutes: 50, timerType: .bake),
        ],
        hydration: 72, flourType: .mixed, imageUrl: nil, authorId: nil, isPremium: false,
        tags: ["jalapeño", "cheddar", "trending", "inclusions"], rating: 4.9, reviewCount: 412
    )

    // MARK: 12. Pizza Loaf
    static let pizzaLoaf = Recipe(
        id: UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa12")!,
        name: "Pizza Loaf",
        summary: "Pepperoni, mozzarella, and sun-dried tomatoes swirled through a savory sourdough pull-apart loaf. Game day essential.",
        difficulty: .intermediate,
        prepTimeMinutes: 40, totalDurationHours: 16, servings: 2,
        ingredients: [
            Ingredient(name: "Bread flour",              grams: 500, bakersPercent: 100),
            Ingredient(name: "Water (warm)",             grams: 325, bakersPercent: 65),
            Ingredient(name: "Active starter",           grams: 100, bakersPercent: 20),
            Ingredient(name: "Olive oil",                grams: 30,  bakersPercent: 6),
            Ingredient(name: "Salt",                     grams: 10,  bakersPercent: 2),
            Ingredient(name: "Garlic powder",            grams: 5,   bakersPercent: 1),
            Ingredient(name: "Dried oregano",            grams: 4,   bakersPercent: 0.8),
            Ingredient(name: "Pepperoni, sliced thin",   grams: 80,  bakersPercent: 16),
            Ingredient(name: "Low-moisture mozzarella",  grams: 100, bakersPercent: 20, notes: "Cubed — fresh mozzarella is too wet"),
            Ingredient(name: "Sun-dried tomatoes",       grams: 40,  bakersPercent: 8,  notes: "Oil-packed, drained and chopped"),
            Ingredient(name: "Pizza sauce",              grams: 60,  bakersPercent: 12, notes: "For spreading"),
        ],
        steps: [
            RecipeStep(order: 1, title: "Mix dough",        instructions: "Combine flour, water, starter, olive oil, garlic powder, oregano, and salt. Mix until cohesive.", durationMinutes: 10, timerType: .mix),
            RecipeStep(order: 2, title: "Bulk ferment",     instructions: "3–4 hours with 3 sets of stretch-and-folds, 30 minutes apart.", durationMinutes: 240, timerType: .bulk),
            RecipeStep(order: 3, title: "Roll out",         instructions: "On a floured surface roll into a 12×16 inch rectangle, about ½ inch thick.", durationMinutes: 10, timerType: .shape),
            RecipeStep(order: 4, title: "Fill & roll",      instructions: "Spread pizza sauce, layer pepperoni, mozzarella, and sun-dried tomatoes. Roll up tightly from the long edge. Cut into 12 equal rounds.", durationMinutes: 15, timerType: .shape),
            RecipeStep(order: 5, title: "Pan & cold proof", instructions: "Arrange rolls cut-side-up in a greased 9×13 pan. Cover, cold proof overnight in the fridge.", durationMinutes: 720, timerType: .proof),
            RecipeStep(order: 6, title: "Bake",             instructions: "Remove from fridge, let sit 30 min. Bake at 400°F for 30–35 minutes until golden and bubbling. Optional: brush with garlic butter immediately.", durationMinutes: 65, timerType: .bake),
        ],
        hydration: 65, flourType: .bread, imageUrl: nil, authorId: nil, isPremium: false,
        tags: ["pizza", "savory", "pull-apart", "trending", "fun"], rating: 4.8, reviewCount: 198
    )

    // MARK: 13. Honey Oat Sandwich
    static let honeyOat = Recipe(
        id: UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa13")!,
        name: "Honey Oat Loaf",
        summary: "Pillowy soft loaf with rolled oats and a touch of honey. Slices beautifully — works great for toast or sandwiches.",
        difficulty: .beginner,
        prepTimeMinutes: 25, totalDurationHours: 14, servings: 1,
        ingredients: [
            Ingredient(name: "Bread flour",        grams: 450, bakersPercent: 90),
            Ingredient(name: "Rolled oats",        grams: 50,  bakersPercent: 10, notes: "Plus extra for topping"),
            Ingredient(name: "Water (warm)",       grams: 300, bakersPercent: 60),
            Ingredient(name: "Active starter",     grams: 100, bakersPercent: 20),
            Ingredient(name: "Honey",              grams: 40,  bakersPercent: 8),
            Ingredient(name: "Butter (soft)",      grams: 30,  bakersPercent: 6),
            Ingredient(name: "Salt",               grams: 10,  bakersPercent: 2),
        ],
        steps: [
            RecipeStep(order: 1, title: "Soak oats",       instructions: "Pour boiling water over oats, let cool to lukewarm. This hydrates the oats so they don't dry out the dough.", durationMinutes: 20, timerType: .rest),
            RecipeStep(order: 2, title: "Mix",             instructions: "Combine oat mixture with flour, starter, honey, butter, and salt. Knead 8–10 minutes until smooth.", durationMinutes: 15, timerType: .mix),
            RecipeStep(order: 3, title: "Bulk ferment",    instructions: "3–4 hours at room temperature.", durationMinutes: 240, timerType: .bulk),
            RecipeStep(order: 4, title: "Shape",           instructions: "Shape into a log and place in a greased loaf pan. Brush top with water and press rolled oats on top.", durationMinutes: 10, timerType: .shape),
            RecipeStep(order: 5, title: "Proof",           instructions: "Proof 3–4 hours until dough domes above the pan rim.", durationMinutes: 240, timerType: .proof),
            RecipeStep(order: 6, title: "Bake",            instructions: "Bake at 375°F for 38–42 minutes until deep golden. Cool fully before slicing.", durationMinutes: 42, timerType: .bake),
        ],
        hydration: 60, flourType: .bread, imageUrl: nil, authorId: nil, isPremium: false,
        tags: ["oat", "honey", "beginner-friendly", "soft"], rating: 4.8, reviewCount: 267
    )

    // MARK: 14. Roasted Garlic & Asiago
    static let roastedGarlicAsiago = Recipe(
        id: UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa14")!,
        name: "Roasted Garlic & Asiago",
        summary: "Whole roasted garlic cloves and shards of nutty Asiago melt into a fragrant, golden-crusted boule.",
        difficulty: .intermediate,
        prepTimeMinutes: 60, totalDurationHours: 22, servings: 1,
        ingredients: [
            Ingredient(name: "Bread flour",           grams: 500, bakersPercent: 100),
            Ingredient(name: "Water (warm)",          grams: 375, bakersPercent: 75),
            Ingredient(name: "Active starter",        grams: 100, bakersPercent: 20),
            Ingredient(name: "Salt",                  grams: 10,  bakersPercent: 2),
            Ingredient(name: "Garlic bulbs",          grams: 80,  bakersPercent: 16, notes: "2 heads — roast whole at 400°F, 40 min"),
            Ingredient(name: "Asiago, coarsely grated", grams: 90, bakersPercent: 18, notes: "Aged Asiago has the best flavour"),
            Ingredient(name: "Fresh rosemary",        grams: 5,   bakersPercent: 1,  notes: "Finely chopped"),
        ],
        steps: [
            RecipeStep(order: 1, title: "Roast garlic",      instructions: "Slice tops off garlic bulbs, drizzle with olive oil, wrap in foil. Roast at 400°F for 40–45 minutes until caramel-soft. Squeeze out cloves and set aside.", durationMinutes: 45, timerType: .rest),
            RecipeStep(order: 2, title: "Autolyse",          instructions: "Mix flour and water, rest 45 minutes.", durationMinutes: 45, timerType: .rest),
            RecipeStep(order: 3, title: "Add starter & salt",instructions: "Work in starter and salt with pinch-and-fold.", durationMinutes: 10, timerType: .mix),
            RecipeStep(order: 4, title: "Bulk ferment",      instructions: "4 sets of stretch-and-folds 30 min apart. On the second fold, add garlic cloves, Asiago, and rosemary. Bulk 4–5 hours total.", durationMinutes: 300, timerType: .bulk),
            RecipeStep(order: 5, title: "Shape",             instructions: "Shape into a boule, place seam-up in a floured banneton. Scatter a few Asiago shards on top of the dough before covering.", durationMinutes: 20, timerType: .shape),
            RecipeStep(order: 6, title: "Cold proof",        instructions: "Refrigerate 10–14 hours.", durationMinutes: 720, timerType: .proof),
            RecipeStep(order: 7, title: "Bake",              instructions: "Bake in a 500°F Dutch oven covered 20 min, uncovered 22 min at 460°F. The cheese on top will form a golden crust.", durationMinutes: 45, timerType: .bake),
        ],
        hydration: 75, flourType: .bread, imageUrl: nil, authorId: nil, isPremium: false,
        tags: ["garlic", "cheese", "asiago", "savory", "trending"], rating: 4.9, reviewCount: 341
    )

    // MARK: 15. Lemon Blueberry
    static let lemonBlueberry = Recipe(
        id: UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa15")!,
        name: "Lemon Blueberry",
        summary: "Bursting blueberries and bright lemon zest in a lightly sweet boule with a stunning purple crumb.",
        difficulty: .intermediate,
        prepTimeMinutes: 40, totalDurationHours: 20, servings: 1,
        ingredients: [
            Ingredient(name: "Bread flour",          grams: 450, bakersPercent: 90),
            Ingredient(name: "Whole wheat flour",    grams: 50,  bakersPercent: 10),
            Ingredient(name: "Water (warm)",         grams: 350, bakersPercent: 70),
            Ingredient(name: "Active starter",       grams: 90,  bakersPercent: 18),
            Ingredient(name: "Honey",                grams: 30,  bakersPercent: 6),
            Ingredient(name: "Salt",                 grams: 9,   bakersPercent: 1.8),
            Ingredient(name: "Lemon zest",           grams: 8,   bakersPercent: 1.6, notes: "2 large lemons"),
            Ingredient(name: "Blueberries (frozen)", grams: 150, bakersPercent: 30,  notes: "Keep frozen until use — they won't burst during folding"),
        ],
        steps: [
            RecipeStep(order: 1, title: "Mix",              instructions: "Combine flour, water, starter, honey, and salt. Add lemon zest and mix well.", durationMinutes: 10, timerType: .mix),
            RecipeStep(order: 2, title: "Bulk ferment",     instructions: "On the first stretch-and-fold, gently work in the frozen blueberries. Do 3 more sets of folds 30 min apart. Bulk 4–5 hours until dough is puffy and jiggly.", durationMinutes: 300, timerType: .bulk),
            RecipeStep(order: 3, title: "Shape",            instructions: "Shape gently into a boule — try not to break too many blueberries. Dust banneton generously as blueberry juice makes dough sticky.", durationMinutes: 15, timerType: .shape),
            RecipeStep(order: 4, title: "Cold proof",       instructions: "Cold proof 10–12 hours.", durationMinutes: 720, timerType: .proof),
            RecipeStep(order: 5, title: "Bake",             instructions: "Score and bake at 500°F in a Dutch oven, covered 20 min, uncovered 18 min at 450°F. The crust will be a beautiful deep purple where blueberries meet the surface.", durationMinutes: 42, timerType: .bake),
        ],
        hydration: 70, flourType: .mixed, imageUrl: nil, authorId: nil, isPremium: false,
        tags: ["sweet", "lemon", "blueberry", "trending", "colorful"], rating: 4.8, reviewCount: 287
    )

    // MARK: 16. Sourdough Bagels
    static let bagels = Recipe(
        id: UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa16")!,
        name: "New York-Style Bagels",
        summary: "Chewy, shiny sourdough bagels boiled in barley-malt water. Everything, sesame, plain — your call.",
        difficulty: .intermediate,
        prepTimeMinutes: 45, totalDurationHours: 16, servings: 2,
        ingredients: [
            Ingredient(name: "Bread flour (high-protein)", grams: 500, bakersPercent: 100, notes: "Sir Lancelot or King Arthur Sir Lancelot if available"),
            Ingredient(name: "Water (cool)",               grams: 275, bakersPercent: 55),
            Ingredient(name: "Active starter",             grams: 100, bakersPercent: 20),
            Ingredient(name: "Salt",                       grams: 10,  bakersPercent: 2),
            Ingredient(name: "Sugar",                      grams: 15,  bakersPercent: 3),
            Ingredient(name: "Barley malt syrup",          grams: 20,  bakersPercent: 4,  notes: "For the boil water — gives that iconic sheen"),
            Ingredient(name: "Baking soda",                grams: 10,  bakersPercent: 2,  notes: "For the boil water"),
            Ingredient(name: "Toppings of choice",         grams: 0,   bakersPercent: 0,  notes: "Everything blend, sesame, poppy seeds, flaky salt"),
        ],
        steps: [
            RecipeStep(order: 1, title: "Mix & knead",    instructions: "Combine all dough ingredients. Knead 10–12 minutes until very smooth and stiff. Bagel dough should be much stiffer than a regular sourdough.", durationMinutes: 15, timerType: .mix),
            RecipeStep(order: 2, title: "Bulk ferment",   instructions: "2–3 hours at room temperature until noticeably puffy.", durationMinutes: 180, timerType: .bulk),
            RecipeStep(order: 3, title: "Divide & shape", instructions: "Divide into 8 pieces (≈115g each). Roll each into a 9-inch rope and join ends to form a ring, overlapping 1 inch. Seal firmly.", durationMinutes: 20, timerType: .shape),
            RecipeStep(order: 4, title: "Cold proof",     instructions: "Place on parchment, cover, cold proof 8–12 hours. They're ready when a bagel floats within 15 seconds in a bowl of cold water.", durationMinutes: 600, timerType: .proof),
            RecipeStep(order: 5, title: "Boil",           instructions: "Bring a wide pot of water to a rolling boil. Add barley malt and baking soda. Boil each bagel 45 seconds per side.", durationMinutes: 15, timerType: .mix),
            RecipeStep(order: 6, title: "Top & bake",     instructions: "Immediately dip boiled bagels in toppings. Bake on a parchment sheet at 450°F for 20–22 minutes until deep golden.", durationMinutes: 25, timerType: .bake),
        ],
        hydration: 55, flourType: .bread, imageUrl: nil, authorId: nil, isPremium: false,
        tags: ["bagels", "boiled", "new york", "trending"], rating: 4.7, reviewCount: 189
    )

    // MARK: 17. Chocolate Cherry
    static let chocolateCherry = Recipe(
        id: UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa17")!,
        name: "Chocolate Cherry Boule",
        summary: "Dark cocoa, bittersweet chocolate chunks, and tart dried cherries. The bakery secret weapon.",
        difficulty: .intermediate,
        prepTimeMinutes: 40, totalDurationHours: 22, servings: 1,
        ingredients: [
            Ingredient(name: "Bread flour",               grams: 450, bakersPercent: 90),
            Ingredient(name: "Dutch-process cocoa powder", grams: 50, bakersPercent: 10, notes: "Sift before adding"),
            Ingredient(name: "Water (warm)",              grams: 380, bakersPercent: 76),
            Ingredient(name: "Active starter",            grams: 90,  bakersPercent: 18),
            Ingredient(name: "Honey",                     grams: 25,  bakersPercent: 5),
            Ingredient(name: "Salt",                      grams: 9,   bakersPercent: 1.8),
            Ingredient(name: "Dark chocolate (70%+)",     grams: 100, bakersPercent: 20, notes: "Roughly chopped"),
            Ingredient(name: "Dried tart cherries",       grams: 80,  bakersPercent: 16, notes: "Soak in hot water 10 min, drain"),
        ],
        steps: [
            RecipeStep(order: 1, title: "Mix",             instructions: "Whisk cocoa into flour, then add water, starter, honey, and salt. Mix until no dry streaks remain.", durationMinutes: 10, timerType: .mix),
            RecipeStep(order: 2, title: "Autolyse",        instructions: "Rest 30 minutes.", durationMinutes: 30, timerType: .rest),
            RecipeStep(order: 3, title: "Bulk ferment",    instructions: "On the second stretch-and-fold, add chocolate and drained cherries. 4 sets of folds total over 4 hours. Dough is ready when it's puffy and holds its shape.", durationMinutes: 270, timerType: .bulk),
            RecipeStep(order: 4, title: "Shape",           instructions: "Shape into a tight boule. The dough will be deeply dark — don't worry, it's normal.", durationMinutes: 15, timerType: .shape),
            RecipeStep(order: 5, title: "Cold proof",      instructions: "Refrigerate 10–14 hours.", durationMinutes: 720, timerType: .proof),
            RecipeStep(order: 6, title: "Bake",            instructions: "Bake in a 500°F Dutch oven covered 20 min, uncovered 20 min at 460°F. The cocoa crust won't brown like a regular loaf — look for a matte, firm surface.", durationMinutes: 45, timerType: .bake),
        ],
        hydration: 76, flourType: .bread, imageUrl: nil, authorId: nil, isPremium: false,
        tags: ["chocolate", "cherry", "sweet", "trending", "dessert"], rating: 4.9, reviewCount: 223
    )

    // MARK: 18. Sun-Dried Tomato & Olive
    static let sunDriedTomatoOlive = Recipe(
        id: UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaa18")!,
        name: "Sun-Dried Tomato & Olive",
        summary: "A deeply savory Mediterranean loaf with sun-dried tomatoes, Kalamata olives, and fresh basil. Pairs with everything.",
        difficulty: .intermediate,
        prepTimeMinutes: 40, totalDurationHours: 20, servings: 1,
        ingredients: [
            Ingredient(name: "Bread flour",          grams: 450, bakersPercent: 90),
            Ingredient(name: "Semolina flour",       grams: 50,  bakersPercent: 10, notes: "Adds a subtle crunch to the crust"),
            Ingredient(name: "Water (warm)",         grams: 355, bakersPercent: 71),
            Ingredient(name: "Active starter",       grams: 90,  bakersPercent: 18),
            Ingredient(name: "Olive oil",            grams: 20,  bakersPercent: 4),
            Ingredient(name: "Salt",                 grams: 9,   bakersPercent: 1.8),
            Ingredient(name: "Sun-dried tomatoes",   grams: 80,  bakersPercent: 16, notes: "Oil-packed, drained, rough chop"),
            Ingredient(name: "Kalamata olives",      grams: 80,  bakersPercent: 16, notes: "Pitted, halved, patted dry"),
            Ingredient(name: "Fresh basil",          grams: 15,  bakersPercent: 3,  notes: "Tear — don't chop — to prevent bruising"),
            Ingredient(name: "Dried oregano",        grams: 3,   bakersPercent: 0.6),
        ],
        steps: [
            RecipeStep(order: 1, title: "Mix",              instructions: "Combine flours, water, starter, olive oil, oregano, and salt. Mix until cohesive.", durationMinutes: 10, timerType: .mix),
            RecipeStep(order: 2, title: "Autolyse",         instructions: "Rest 30 minutes.", durationMinutes: 30, timerType: .rest),
            RecipeStep(order: 3, title: "Bulk ferment",     instructions: "4 sets of stretch-and-folds 30 min apart. Add tomatoes, olives, and basil on fold two, being gentle. Bulk 4 hours until puffy.", durationMinutes: 270, timerType: .bulk),
            RecipeStep(order: 4, title: "Shape",            instructions: "Shape into a round or oval batard. Place seam-up in a banneton dusted with semolina.", durationMinutes: 15, timerType: .shape),
            RecipeStep(order: 5, title: "Cold proof",       instructions: "Refrigerate 10–12 hours.", durationMinutes: 720, timerType: .proof),
            RecipeStep(order: 6, title: "Bake",             instructions: "Bake in a 500°F Dutch oven covered 20 min, uncovered 22 min at 460°F.", durationMinutes: 45, timerType: .bake),
        ],
        hydration: 71, flourType: .mixed, imageUrl: nil, authorId: nil, isPremium: false,
        tags: ["mediterranean", "savory", "olive", "tomato", "trending"], rating: 4.8, reviewCount: 176
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
