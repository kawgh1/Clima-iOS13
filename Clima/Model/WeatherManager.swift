//
//  WeatherManager.swift
//  Clima
//
//  Created by J on 4/27/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    // should not store API key in plaintext -- should be stored on device keychain
    var API_KEY = "no api key"
    var weatherUrl = "no url string"
    
    init() {
        API_KEY = valueForAPIKey(named: "API_KEY")
        weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=\(API_KEY)&units=imperial"
    }
    var delegate: WeatherManagerDelegate?
    
    func fetchWeatherByCityName(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func fetchWeatherByLatAndLon(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
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
            let desc = decodedData.weather[0].description
            
            let weather = WeatherModel(weatherId: weatherId, cityName: name, temperature: temp, descripion: desc)
            print(weather)
            return weather
             
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func valueForAPIKey(named keyname:String) -> String {
      // Credit to the original source for this technique at
      // http://blog.lazerwalker.com/blog/2014/05/14/handling-private-api-keys-in-open-source-ios-apps
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
      let plist = NSDictionary(contentsOfFile:filePath!)
      let value = plist?.object(forKey: keyname) as! String
      return value
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
