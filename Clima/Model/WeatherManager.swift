//
//  WeatherManager.swift
//  Clima
//
//  Created by J on 4/27/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherUrl = ""
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        // 1. Create URL String
        // 2. Create a URL Session
        // 3. Give the session a task
        // 4. Start the task
        
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in // trailing Closure syntax
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let weatherId = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(weatherId: weatherId, cityName: name, temperature: temp)
            return weather
             
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
   
}
        
        
//    func performRequest(urlString: String) {
//        // 1. Create URL String
//        // 2. Create a URL Session
//        // 3. Give the session a task
//        // 4. Start the task
//
//        // 1. Create URL String
//        if let url = URL(string: urlString) {
//
//            // 2. Create a URL Session
//            let session = URLSession(configuration: .default)
//
//            // 3. Give the session a task
//            let task = session.dataTask(with: url) { (data, response, error) in // trailing Closure syntax
//                if error != nil {
//                    print(error!)
//                    return
//                }
//
//                if let safeData = data {
//                    self.parseJSON(weatherData: safeData)
//                }
//            }
//
//            // 4. Start the task
//            task.resume()
//
//        }
//    }
    

    
//    func performRequest(urlString: String) {
//
//        // 1. Create URL String
//        // 2. Create a URL Session
//        // 3. Give the session a task
//        // 4. Start the task
//
//
//        // 1. Create URL String
//        if let url = URL(string: urlString) {
//
//            // 2. Create a URL Session
//            let session = URLSession(configuration: .default)
//
//            // 3. Give the session a task
//            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
//
//            // 4. Start the task
//            task.resume()
//
//        }
//
//
//
//    }
//
//    func handle(data: Data?, response: URLResponse?, error: Error?) {
//        if error != nil {
//            print(error!)
//            return
//        }
//
//        if let safeData = data {
//            let dataString = String(data: safeData, encoding: .utf8)
//            print(dataString)
//        }
//
//    }
// }
