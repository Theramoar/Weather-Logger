//
//  CoreDataManager.swift
//  Weather Logger
//
//  Created by Mihails Kuznecovs on 18/05/2020.
//  Copyright © 2020 Mihails Kuznecovs. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager {
    private static var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    static func loadDataFromContainer() {
        var weatherData = [WeatherData]()
        let fetchRequest: NSFetchRequest<WeatherData> = WeatherData.fetchRequest()
        
        do {
            weatherData = try context.fetch(fetchRequest)
        }
        catch {
            print("Error loading context")
        }
        weatherData.forEach({
            UserData.shared.savedWeatherData.append(SavedWeatherData(weatherData: $0))
        })
    }
    
    static func saveDataToContainer(data: CurrentWeatherData) -> WeatherData? {
        guard let entity = NSEntityDescription.entity(forEntityName: "WeatherData", in: context) else { return nil }
        let weatherData = NSManagedObject(entity: entity, insertInto: context) as! WeatherData
        weatherData.date = Date()
        weatherData.temp = data.main.temp
        weatherData.condition = Int16(data.weather[0].id)
        weatherData.sunset = Date(timeIntervalSince1970: TimeInterval(data.sys.sunset))
        weatherData.sunrise = Date(timeIntervalSince1970: TimeInterval(data.sys.sunrise))
        weatherData.weatherDescription = data.weather[0].description
        
        saveContext()
        return weatherData
    }
    
    static func deleteDataFromContainer(data: WeatherData) {
        context.delete(data)
        saveContext()
    }
    
    static func editDataWithNewDate(weatherData: WeatherData, newDate: Date) {
        weatherData.date = newDate
        saveContext()
    }
    
    private static func saveContext() {
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
