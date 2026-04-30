import XCTest
@testable import SourdoughPro

// MARK: - BakeSessionViewModelTests

@MainActor
final class BakeSessionViewModelTests: XCTestCase {

    // MARK: tempAdjustmentFactor

    func test_tempAdjustmentFactor_at24C_isOne() {
        let vm = BakeSessionViewModel(recipe: MockRecipes.classicSourdough)
        vm.kitchenTempC = 24
        XCTAssertEqual(vm.tempAdjustmentFactor, 1.0, accuracy: 0.001)
    }

    func test_tempAdjustmentFactor_at14C_doublesTime() {
        // 2^((24-14)/10) = 2^1 = 2.0
        let vm = BakeSessionViewModel(recipe: MockRecipes.classicSourdough)
        vm.kitchenTempC = 14
        XCTAssertEqual(vm.tempAdjustmentFactor, 2.0, accuracy: 0.001)
    }

    func test_tempAdjustmentFactor_at34C_halvesTime() {
        // 2^((24-34)/10) = 2^(-1) = 0.5
        let vm = BakeSessionViewModel(recipe: MockRecipes.classicSourdough)
        vm.kitchenTempC = 34
        XCTAssertEqual(vm.tempAdjustmentFactor, 0.5, accuracy: 0.001)
    }

    func test_tempAdjustmentFactor_at18C_isApprox1point52() {
        // 2^((24-18)/10) = 2^0.6 ≈ 1.5157
        let vm = BakeSessionViewModel(recipe: MockRecipes.classicSourdough)
        vm.kitchenTempC = 18
        XCTAssertEqual(vm.tempAdjustmentFactor, 1.5157, accuracy: 0.001)
    }

    // MARK: tempAdjustmentLabel

    func test_tempAdjustmentLabel_at24C_returnsNoAdjustment() {
        let vm = BakeSessionViewModel(recipe: MockRecipes.classicSourdough)
        vm.kitchenTempC = 24
        XCTAssertEqual(vm.tempAdjustmentLabel, "No adjustment")
    }

    func test_tempAdjustmentLabel_at18C_showsLonger() {
        let vm = BakeSessionViewModel(recipe: MockRecipes.classicSourdough)
        vm.kitchenTempC = 18
        XCTAssert(vm.tempAdjustmentLabel.contains("longer"),
                  "Expected 'longer' in label, got: \(vm.tempAdjustmentLabel)")
        XCTAssert(vm.tempAdjustmentLabel.hasPrefix("+"),
                  "Expected label to start with '+' for cold kitchen")
    }

    func test_tempAdjustmentLabel_at30C_showsFaster() {
        let vm = BakeSessionViewModel(recipe: MockRecipes.classicSourdough)
        vm.kitchenTempC = 30
        XCTAssert(vm.tempAdjustmentLabel.contains("faster"),
                  "Expected 'faster' in label, got: \(vm.tempAdjustmentLabel)")
    }
}

// MARK: - StarterReadinessTests

final class StarterReadinessTests: XCTestCase {

    private func makeStarter(lastFedMinutesAgo: Int?, avgPeakMinutes: Int) -> Starter {
        var starter = MockStarters.bubbles
        starter.feedings = []

        let now = Date()

        // Old feeding with a known peak time → establishes average
        let pastFeedDate = Calendar.current.date(byAdding: .hour, value: -48, to: now)!
        var pastFeeding = Feeding(
            starterId: starter.id, date: pastFeedDate,
            starterGrams: 25, flourGrams: 50, waterGrams: 50
        )
        pastFeeding.peakTimeMinutes = avgPeakMinutes
        starter.feedings.append(pastFeeding)

        // Current feeding (no peak observed yet)
        if let minutesAgo = lastFedMinutesAgo {
            let feedDate = now.addingTimeInterval(-Double(minutesAgo * 60))
            starter.feedings.append(
                Feeding(starterId: starter.id, date: feedDate,
                        starterGrams: 25, flourGrams: 50, waterGrams: 50)
            )
            starter.lastFedAt = feedDate
        }

        return starter
    }

    func test_noData_whenNoPeakTimesRecorded() {
        var starter = MockStarters.bubbles
        starter.feedings = [
            Feeding(starterId: starter.id, date: Date(),
                    starterGrams: 25, flourGrams: 50, waterGrams: 50)
        ]
        if case .noData = starter.readinessStatus { /* pass */ }
        else { XCTFail("Expected .noData, got \(starter.readinessStatus)") }
    }

    func test_readySoon_whenJustFed() {
        // Avg peak 4h, fed 30min ago → ~210min remaining → .readySoon
        let starter = makeStarter(lastFedMinutesAgo: 30, avgPeakMinutes: 240)
        if case .readySoon(let mins) = starter.readinessStatus {
            XCTAssert(mins > 0, "Expected positive minutes remaining, got \(mins)")
        } else {
            XCTFail("Expected .readySoon, got \(starter.readinessStatus)")
        }
    }

    func test_readyNow_whenAtPeak() {
        // Avg peak 4h, fed 4h ago → right at peak → .readyNow
        let starter = makeStarter(lastFedMinutesAgo: 240, avgPeakMinutes: 240)
        if case .readyNow = starter.readinessStatus { /* pass */ }
        else { XCTFail("Expected .readyNow, got \(starter.readinessStatus)") }
    }

    func test_pastPeak_whenOverFermented() {
        // Avg peak 4h, fed 6h ago → 2h past peak → .pastPeak
        let starter = makeStarter(lastFedMinutesAgo: 360, avgPeakMinutes: 240)
        if case .pastPeak(let mins) = starter.readinessStatus {
            XCTAssert(mins > 0, "Expected positive minutes since peak, got \(mins)")
        } else {
            XCTFail("Expected .pastPeak, got \(starter.readinessStatus)")
        }
    }

    func test_averagePeakMinutes_averagesCorrectly() {
        var starter = MockStarters.bubbles
        starter.feedings = [180, 240, 300].map { peak in
            var f = Feeding(starterId: starter.id, date: Date(),
                            starterGrams: 25, flourGrams: 50, waterGrams: 50)
            f.peakTimeMinutes = peak
            return f
        }
        XCTAssertEqual(starter.averagePeakMinutes, 240)
    }

    func test_averagePeakMinutes_nilWhenNoData() {
        var starter = MockStarters.bubbles
        starter.feedings = [
            Feeding(starterId: starter.id, date: Date(),
                    starterGrams: 25, flourGrams: 50, waterGrams: 50)
        ]
        XCTAssertNil(starter.averagePeakMinutes)
    }
}

// MARK: - DiscardCalculatorViewModelTests

@MainActor
final class DiscardCalculatorViewModelTests: XCTestCase {

    func test_discardGrams_correctlyCalculated() {
        let vm = DiscardCalculatorViewModel()
        vm.currentGramsText = "100"
        vm.keepGramsText = "25"
        XCTAssertEqual(vm.discardGrams, 75)
    }

    func test_discardGrams_clampedToZeroWhenKeepExceedsCurrent() {
        let vm = DiscardCalculatorViewModel()
        vm.currentGramsText = "50"
        vm.keepGramsText = "100"
        XCTAssertEqual(vm.discardGrams, 0)
    }

    func test_flourGrams_matchesRatioMultiplier() {
        let vm = DiscardCalculatorViewModel()
        vm.currentGramsText = "100"
        vm.keepGramsText = "25"
        vm.ratio = .oneToOneToOne  // flour = keep × 1.0 = 25
        XCTAssertEqual(vm.flourGrams, 25)
    }

    func test_totalAfterFeed_isCorrect() {
        let vm = DiscardCalculatorViewModel()
        vm.currentGramsText = "100"
        vm.keepGramsText = "25"
        vm.ratio = .oneToOneToOne  // keep=25, flour=25, water=25 → total=75
        XCTAssertEqual(vm.totalAfterFeed, 75)
    }

    func test_validationNil_whenKeepLessThanCurrent() {
        let vm = DiscardCalculatorViewModel()
        vm.currentGramsText = "100"
        vm.keepGramsText = "25"
        XCTAssertNil(vm.validation)
    }

    func test_validationMessage_whenKeepExceedsCurrent() {
        let vm = DiscardCalculatorViewModel()
        vm.currentGramsText = "50"
        vm.keepGramsText = "100"
        XCTAssertNotNil(vm.validation)
    }
}
