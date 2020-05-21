//
//  NetworkDataFetcher.swift
//  Weather Logger
//
//  Created by Mihails Kuznecovs on 18/05/2020.
//  Copyright © 2020 Mihails Kuznecovs. All rights reserved.
//

import CoreLocation

class NetworkDataFetcher {
    private let network = NetworkService()
    
    func getWeatherData(for location: CLLocation, completion: @escaping (CurrentWeatherData) -> Void) {
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        let path = "?lat=\(latitude)&lon=\(longitude)&APPID=\(API.appID)"
        network.makeGetRequest(path: path) { (data) in
            guard let decoded = self.decodeJSON(type: CurrentWeatherData.self, from: data) else { print("FAILED DECODING JSON") ; return }
            completion(decoded)
        }
    }
    
    //MARK: - Private Methods
    private func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = data, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
