//
//  WeatherModel.swift
//  Clima
//
//  Created by J on 4/27/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let weatherId: Int
    let cityName: String
    let temperature: Double
    
    // Swift - "Computed Property"
    var tempString: String {
        return String(format: "%.0f", temperature)
    }
    
    // Swift - "Computed Property"
    var conditionName: String {
        switch weatherId {
                case 200...232:
                    return "cloud.bolt"
                case 300...321:
                    return "cloud.drizzle"
                case 500...531:
                    return "cloud.rain"
                case 600...622:
                    return "cloud.snow"
                case 701...781:
                    return "cloud.fog"
                case 800:
                    return "sun.max"
                case 801...804:
                    return "cloud"
                default:
                    return "cloud"
                }
        
    }
    
}
