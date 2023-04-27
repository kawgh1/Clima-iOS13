//
//  WeatherData.swift
//  Clima
//
//  Created by J on 4/27/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

// Decodable is a protocol interface that says this data can be decoded from an external data representation (like JSON)

// Codable == Decodable and Encodable

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int // weather code from the API used to show different icons
}
