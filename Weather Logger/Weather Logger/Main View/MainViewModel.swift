//
//  MainViewModel.swift
//  Weather Logger
//
//  Created by Mihails Kuznecovs on 18/05/2020.
//  Copyright © 2020 Mihails Kuznecovs. All rights reserved.
//

import CoreLocation

protocol TableViewViewModelType {
    var numberOfRows: Int { get }
    func cellViewModel(forIndexPath indexPath: IndexPath) -> CellViewModelType?
    func viewModelForSelectedRow(at indexPath: IndexPath) -> DetailViewModelType?
}

protocol CellViewModelType {}
protocol DetailViewModelType {}

class MainViewModel: NSObject, CLLocationManagerDelegate {
    private let fetcher = NetworkDataFetcher()
    private let locationManager = CLLocationManager()
    private var savedData: [SavedWeatherData] {
        UserData.shared.savedWeatherData
    }
    
    var tableIsEmpty: Bool {
        savedData.count == 0
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        CoreDataManager.loadDataFromContainer()
    }
    

    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            fetcher.getWeatherData(for: location) { weatherData in
                UserData.shared.currentWeatherData = weatherData
                let tempInCelsius = (weatherData.main.temp - 273.15).rounded()
                UserData.shared.currentWeatherData?.main.temp = tempInCelsius
                NotificationCenter.default.post(name: NSNotification.Name(NotificationNames.dataReceived), object: nil)
            }
        }
    }
    
    func saveCurrentWeather(completion: @escaping (Bool) -> Void) {
        guard
            let currentData = UserData.shared.currentWeatherData,
            let weatherData = CoreDataManager.saveDataToContainer(data: currentData)
        else {
            completion(false)
            return
        }
        
        UserData.shared.savedWeatherData.append(SavedWeatherData(weatherData: weatherData))
        completion(true)
    }
    
    func deleteSavedData(at indexPath: IndexPath, completion: @escaping () -> Void) {
        let weatherData = savedData[indexPath.row].weatherData
        CoreDataManager.deleteDataFromContainer(data: weatherData)
        UserData.shared.savedWeatherData.remove(at: indexPath.row)
        completion()
    }
}

extension MainViewModel: TableViewViewModelType {
    var numberOfRows: Int {
        savedData.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> CellViewModelType? {
        WeatherCellViewModel(savedData: savedData[indexPath.row])
    }
    
    func viewModelForSelectedRow(at indexPath: IndexPath) -> DetailViewModelType? {
        let savedData = UserData.shared.savedWeatherData[indexPath.row]
        return DetailsViewModel(savedData: savedData)
    }
}

