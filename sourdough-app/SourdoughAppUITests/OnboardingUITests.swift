import XCTest

final class OnboardingUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Happy path: Welcome → Sign In (mock) → Home tab
    func testSignInLeadsToHomeScreen() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--uitesting", "--reset-onboarding"]
        app.launch()

        // Welcome screen
        let getStartedBtn = app.buttons["I have an account"]
        XCTAssertTrue(getStartedBtn.waitForExistence(timeout: 5))
        getStartedBtn.tap()

        // Sign In screen
        let emailField = app.textFields["Email"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))
        emailField.tap()
        emailField.typeText("test@example.com")

        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText("password123")

        app.buttons["Sign In"].tap()

        // Should arrive at Home
        let homeTitle = app.navigationBars["Home"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 10))
    }
}
