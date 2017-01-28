//
//  BookMe5iOSUITests.swift
//  BookMe5iOSUITests
//
//  Created by Remi Robert on 06/12/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import XCTest

class BookMe5iOSUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testExample() {
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Profile"].tap()
        tabBarsQuery.buttons["Messages"].tap()
        tabBarsQuery.buttons["Notifications"].tap()
        tabBarsQuery.buttons["Home"].tap()
        app.navigationBars["BookMe5"].buttons["search"].tap()
        app.tables.staticTexts["Restaurant"].tap()
        app.navigationBars["Rechercher"].buttons["Stop"].tap()
    }
}
