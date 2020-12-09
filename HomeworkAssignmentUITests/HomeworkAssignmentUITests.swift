//
//  HomeworkAssignmentUITests.swift
//  HomeworkAssignmentUITests
//
//  Created by Greg Hughes on 12/7/20.
//

import XCTest
class HomeworkAssignmentUITests: XCTestCase {

    override func setUpWithError() throws {

        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["postMessage"].tap()
        app.textFields["usernameTextField"].typeText("albert")

        app.textFields["subjectTextField"].tap()
        
        app.textFields["subjectTextField"].typeText("albert Subject")
        app.textFields["messageTextField"].tap()
        app.textFields["messageTextField"].typeText("albert Message")
        app.buttons["Ok"].tap()
        sleep(2)
        XCTAssert(app.staticTexts["albert Message"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
