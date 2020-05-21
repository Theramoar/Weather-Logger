//
//  WeatherData.swift
//  Weather Logger
//
//  Created by Mihails Kuznecovs on 18/05/2020.
//  Copyright © 2020 Mihails Kuznecovs. All rights reserved.
//

import Foundation

class UserData {
    static let shared = UserData()
    var currentWeatherData: CurrentWeatherData?
    var savedWeatherData = [SavedWeatherData]()
    private init() {}
}

struct SavedWeatherData {
    var weatherData: WeatherData
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: weatherData.date!)
    }
    func getTimeString(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = DateFormatter.Style.medium
        formatter.dateStyle = DateFormatter.Style.none
        formatter.timeZone = .current
        return formatter.string(from: time)
    }
    var weatherImageName: String {
        switch (weatherData.condition) {
        case 0...300 : return "tstorm1"
        case 301...500 : return "light_rain"
        case 501...600 : return "shower3"
        case 601...700 : return "snow4"
        case 701...771 : return "fog"
        case 772...799 : return "tstorm3"
        case 800 : return "sunny"
        case 801...804 : return "cloudy2"
        case 900...903, 905...1000  : return "tstorm3"
        case 903 : return "snow5"
        case 904 : return "sunny"
        default : return "dunno"
        }
    } 
}


struct CurrentWeatherData: Decodable {
    var main: MainData
    var weather: [WeatherResponseData]
    var sys: SunData
}
struct WeatherResponseData: Decodable {
    var id: Int
    var description: String
}
struct MainData: Decodable {
    var temp: Float
}
struct SunData: Decodable {
    var sunrise: Int
    var sunset: Int
}
