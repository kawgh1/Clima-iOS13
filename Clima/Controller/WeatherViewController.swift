//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

// UITextFieldDelegate is actually a protocol (like an interface) that allows access to various methods and behaviors

//class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate { // these Delegates were removed and placed into "extensions" below

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
   
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A delegate informs the View Controller of user events on the element
        // - user started typing
        // - user stopped typing
        // - user clicked off of the element, etc.
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        // locationManager.delegate must be provided before methods can be called on it
        
        // Device Location Services
        locationManager.requestWhenInUseAuthorization() // displays modal popup to request location permissions in app
//      locationManager.startUpdatingLocation() // this method is for driving apps where turn by turn location data is needed
        locationManager.requestLocation() // one time location request for basic info
        
        
   
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        // first trigger current user location re-request to send to API
        locationManager.requestLocation()
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true) // dismiss keyboard
    }
    
    
    
   
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    // UITextFieldDelegate methods
    
    // These textField methods are managed by the UITextField itself
    // These methods are never explicitly called but run in the background
    // based on user interaction
    
    // this function returns true if the user entered some text
    // allows us to capture the user clicking keyboard 'go' event
    // so they dont have to click the search icon to search
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) // dismiss keyboard
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Please enter a city name"
            return false
        }
    }
    
    // clear text field when endEditing == true
    func textFieldDidEndEditing(_ textField: UITextField) {
        // grab what city the user entered
        if let city = searchTextField.text {
            weatherManager.fetchWeatherByCityName(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    // WeatherManagerDelegate methods
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {

        // have to run async in the background on the main thread since it is a network request to display UI elements
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.descriptionLabel.text = weather.descripion.capitalized

        }
    }
    
    func didFailWithError(error: Error) {
        print("Error -- ", error)
    }
    
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last { // .last provides the last, most recent location data in the array
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            // we can send the latitude and longitude to weather API
            weatherManager.fetchWeatherByLatAndLon(latitude: lat, longitude: lon)
        }
        print("got location data: -- ")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error: --")
    }
}
