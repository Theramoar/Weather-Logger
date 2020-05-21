//
//  Weather_Logger_UITests.swift
//  Weather Logger UITests
//
//  Created by Mihails Kuznecovs on 20/05/2020.
//  Copyright © 2020 Mihails Kuznecovs. All rights reserved.
//

import XCTest

class Weather_Logger_UITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testIfSafeButtonAddsCellToTable() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.isOnMainView)
        let oldRowsNumber = app.tables.cells.count
        addOneRow()
        XCTAssertTrue(app.tables.cells.count > oldRowsNumber)
    }
    
    func testCellSwipeDeletesRow() throws {
        let app = XCUIApplication()
        app.launch()
        addOneRow()
        let oldRowsNumber = app.tables.cells.count
        let tablesQuery = app.tables.cells
        tablesQuery.element(boundBy: 0).swipeLeft()
        tablesQuery.element(boundBy: 0).buttons["Delete"].tap()
        XCTAssertTrue(app.tables.cells.count < oldRowsNumber)
    }
    
    func testCellTapTransfersToDetailsView() throws {
        let app = XCUIApplication()
        app.launch()
        addOneRow()
        let tablesQuery = app.tables.cells
        tablesQuery.element(boundBy: 0).tap()
        XCTAssertTrue(app.isOnDetailsView)
    }
    
    func testChangeDateButtonChangesNameOnTap() throws {
        let app = XCUIApplication()
        app.launch()
        if app.tables.cells.count == 0 {
            addOneRow()
        }
        app.tables.cells.element(boundBy: 0).tap()
        XCTAssertTrue(app.navigationBars.buttons["Change Date"].exists)
        app.navigationBars.buttons["Change Date"].tap()
        XCTAssertTrue(app.navigationBars.buttons["Done"].exists)
        app.navigationBars.buttons["Done"].tap()
        XCTAssertTrue(app.navigationBars.buttons["Change Date"].exists)
    }
    
    func testChangeDateButtonShowsAndHidesDateTextField() throws {
        let app = XCUIApplication()
        app.launch()
        if app.tables.cells.count == 0 {
            addOneRow()
        }
        app.tables.cells.element(boundBy: 0).tap()
        app.navigationBars.buttons["Change Date"].tap()
        XCTAssertTrue(app.textFields["dateTextField"].exists)
        app.navigationBars.buttons["Done"].tap()
        XCTAssertFalse(app.textFields["dateTextField"].exists)
    }
    
    private func addOneRow() {
        let app = XCUIApplication()
        XCTAssertTrue(app.buttons["Save weather data"].exists)
        wait(for: [], timeout: 4)
        app.buttons["Save weather data"].tap()
    }
}

extension XCUIApplication {
    var isOnMainView: Bool {
        return otherElements["mainView"].exists
    }
    
    var isOnDetailsView: Bool {
          return otherElements["detailsView"].exists
      }
}
