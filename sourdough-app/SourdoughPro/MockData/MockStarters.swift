import Foundation

enum MockStarters {

    /// Deterministic UUIDs so mocks stay stable across relaunches.
    static let bubblesId = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    static let gertyId   = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!

    static let all: [Starter] = [bubbles, gerty]

    /// Primary "healthy, recently fed" starter used on the Home card.
    static let bubbles: Starter = {
        let now = Date()
        let created = Calendar.current.date(byAdding: .day, value: -89, to: now) ?? now
        let feedings = makeFeedings(starterId: bubblesId, count: 45, spacingHours: 12, endingAt: now.addingTimeInterval(-18 * 3600))
        var s = Starter(
            id: bubblesId,
            name: "Bubbles",
            createdAt: created,
            flourType: .bread,
            hydration: 100,
            feedings: feedings,
            photos: [],
            healthScore: 8.5,
            lastFedAt: feedings.last?.date,
            nextFeedingAt: nil,
            isActive: true,
            notes: "Kept on the kitchen counter. Doubles in ~4 hours."
        )
        s.nextFeedingAt = FeedingScheduler.nextFeeding(for: s)
        return s
    }()

    /// Secondary starter — whole-wheat, slightly overdue for a feed (triggers warning state).
    static let gerty: Starter = {
        let now = Date()
        let created = Calendar.current.date(byAdding: .day, value: -42, to: now) ?? now
        // Last fed ~30 hours ago — intentionally overdue to demo the warning banner
        let lastFed = now.addingTimeInterval(-30 * 3600)
        let feedings = makeFeedings(starterId: gertyId, count: 20, spacingHours: 24, endingAt: lastFed)
        var s = Starter(
            id: gertyId,
            name: "Gerty",
            createdAt: created,
            flourType: .wholeWheat,
            hydration: 80,
            feedings: feedings,
            photos: [],
            healthScore: 6.2,
            lastFedAt: lastFed,
            nextFeedingAt: nil,
            isActive: true,
            notes: "Whole-wheat starter. Slower rise, stronger tang. Keep in fridge between bakes."
        )
        s.nextFeedingAt = FeedingScheduler.nextFeeding(for: s)
        return s
    }()

    private static func makeFeedings(starterId: UUID, count: Int, spacingHours: Int, endingAt end: Date) -> [Feeding] {
        (0..<count).map { i -> Feeding in
            let offset = Double(-(count - 1 - i) * spacingHours * 3600)
            let date = end.addingTimeInterval(offset)
            let isRecent = i >= count - 3
            return Feeding(
                starterId: starterId,
                date: date,
                starterGrams: 25,
                flourGrams: 50,
                waterGrams: 50,
                notes: isRecent ? "Doubled in 4 hours, pleasant smell." : nil,
                photoUrl: nil,
                riseHeightCm: isRecent ? Int.random(in: 3...5) : nil,
                smellRating: isRecent ? .pleasant : nil,
                bubbleSize: isRecent ? .large : nil
            )
        }
    }
}
