import XCTest
@testable import SourdoughApp

final class FeedingSchedulerTests: XCTestCase {

    // MARK: Helpers

    private func starter(lastFed: Date, feedings: [Feeding] = []) -> Starter {
        Starter(
            name: "Test",
            createdAt: lastFed.addingTimeInterval(-7 * 86400),
            flourType: .bread,
            feedings: feedings,
            lastFedAt: lastFed
        )
    }

    private func makeFeedings(count: Int, intervalHours: Int, endingAt end: Date) -> [Feeding] {
        (0..<count).map { i in
            let offset = Double(-(count - 1 - i) * intervalHours * 3600)
            return Feeding(starterId: UUID(), date: end.addingTimeInterval(offset),
                           starterGrams: 25, flourGrams: 50, waterGrams: 50)
        }
    }

    // MARK: Tests

    func testNextFeedingUsesAverageInterval() {
        let now = Date()
        let feedings = makeFeedings(count: 5, intervalHours: 12, endingAt: now.addingTimeInterval(-12 * 3600))
        var s = starter(lastFed: now.addingTimeInterval(-12 * 3600), feedings: feedings)
        s.nextFeedingAt = FeedingScheduler.nextFeeding(for: s, now: now)

        guard let next = s.nextFeedingAt else { return XCTFail("Expected a next feeding date") }
        let delta = next.timeIntervalSince(now)
        // Should be approximately 0 hours from now (last fed 12h ago, avg interval 12h)
        XCTAssertLessThanOrEqual(delta, 3700, "Expected next feeding within ~1 hour")
    }

    func testFallsBackTo12HourDefault() {
        let now = Date()
        let fed = now.addingTimeInterval(-6 * 3600)
        let s = starter(lastFed: fed) // no feedings array, can't compute avg
        guard let next = FeedingScheduler.nextFeeding(for: s, now: now) else {
            return XCTFail("Expected a date")
        }
        let delta = next.timeIntervalSince(now)
        // With 12h default, fed 6h ago → next ≈ 6h from now
        XCTAssertGreaterThan(delta, 5 * 3600)
        XCTAssertLessThan(delta, 7 * 3600)
    }

    func testIsOverdueWhenPastNextFeeding() {
        let now = Date()
        let lastFed = now.addingTimeInterval(-30 * 3600) // 30 hours ago
        let s = starter(lastFed: lastFed)
        XCTAssertTrue(FeedingScheduler.isOverdue(s, now: now))
    }

    func testNotOverdueWhenRecentlyFed() {
        let now = Date()
        let lastFed = now.addingTimeInterval(-2 * 3600) // 2 hours ago
        let s = starter(lastFed: lastFed)
        XCTAssertFalse(FeedingScheduler.isOverdue(s, now: now))
    }

    func testNoNextFeedingWithoutLastFed() {
        let s = Starter(name: "Empty", createdAt: Date(), flourType: .bread)
        XCTAssertNil(FeedingScheduler.nextFeeding(for: s))
    }

    func testHoursUntilNextFeedingNonNegative() {
        let now = Date()
        let overdueStarter = starter(lastFed: now.addingTimeInterval(-48 * 3600))
        let hours = FeedingScheduler.hoursUntilNextFeeding(for: overdueStarter, now: now)
        XCTAssertEqual(hours, 0)
    }
}
