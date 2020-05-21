//
//  NetworkService.swift
//  Weather Logger
//
//  Created by Mihails Kuznecovs on 18/05/2020.
//  Copyright © 2020 Mihails Kuznecovs. All rights reserved.
//

import Foundation

class NetworkService {
        
    func makeGetRequest(path: String, completion: @escaping (Data) -> Void) {
        guard let url = creareUrl(from: path) else { print("ERROR, CREATING URL") ; return }
        let request = createRequest(url: url)
        let task = createDataTask(from: request) { (data, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No Data")
                return
            }
            completion(data)
        }
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
        
    private func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    

    private func creareUrl(from path: String) -> URL? {
        let url = URL(string: "\(API.urlBase)\(path)")
        return url
    }
}
