//
//  Weather_Logger_Unit_Tests.swift
//  Weather Logger Unit Tests
//
//  Created by Mihails Kuznecovs on 20/05/2020.
//  Copyright © 2020 Mihails Kuznecovs. All rights reserved.
//

import XCTest
@testable import Weather_Logger

class Weather_Logger_Unit_Tests: XCTestCase {

    var mainController: MainViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainController = storyboard.instantiateViewController(withIdentifier: String(describing: MainViewController.self)) as? MainViewController
        mainController.loadViewIfNeeded()
    }


    func testMainControllerHasAllOutlets() throws {
        XCTAssertNotNil(mainController.tableView)
        XCTAssertNotNil(mainController.saveButton)
        XCTAssertNotNil(mainController.noDataStackView)
        XCTAssertNotNil(mainController.infoView)
        XCTAssertNotNil(mainController.currentTemperatureLabel)
    }
    
    func testIfCurrentWeatherDataIsLoaded() throws {
        expectation(forNotification: NSNotification.Name(NotificationNames.dataReceived), object: nil) { notification -> Bool in
            return UserData.shared.currentWeatherData != nil
        }
        waitForExpectations(timeout: 4, handler: nil)
    }
    
    func testCurrentWeatherIsSavedToLocalStorage() {
        let existingSavedData = UserData.shared.savedWeatherData.count
        expectation(forNotification: NSNotification.Name(NotificationNames.dataReceived), object: nil) { notification -> Bool in
            return UserData.shared.currentWeatherData != nil
        }
        waitForExpectations(timeout: 4, handler: nil)

        mainController.viewModel.saveCurrentWeather { (saved) in
            if saved {
                XCTAssertTrue(UserData.shared.savedWeatherData.count > existingSavedData)
            }
        }
    }
    
    func testSavedDataAddsRows() {
        let oldRowNumber = mainController.tableView.numberOfRows(inSection: 0)
        createAndSaveDummyData()
        let newRowNumber = mainController.tableView.numberOfRows(inSection: 0)
        XCTAssertTrue(newRowNumber > oldRowNumber)
    }
    
    func testSavedWeatherIsDeleted() {
        let savedDataCount = UserData.shared.savedWeatherData.count
        createAndSaveDummyData()
        let lastIndexPath = IndexPath(row: mainController.tableView.numberOfRows(inSection: 0) - 1, section: 0)
        mainController.viewModel.deleteSavedData(at: lastIndexPath) {
            let updatedDataCount = UserData.shared.savedWeatherData.count
            XCTAssertTrue(savedDataCount == updatedDataCount)
        }
    }
    
    
    private func createAndSaveDummyData() {
        let data = CurrentWeatherData(main: MainData(temp: 10), weather: [WeatherResponseData(id: 800, description: "clear sky")], sys: SunData(sunrise: 1560281377, sunset: 1560333478))
        let savedData = CoreDataManager.saveDataToContainer(data: data)
        XCTAssertTrue(savedData != nil)
        UserData.shared.savedWeatherData.append(SavedWeatherData(weatherData: savedData!))
        mainController.tableView.reloadData()
    }
}


