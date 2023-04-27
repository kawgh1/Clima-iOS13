//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

// UITextFieldDelegate is actually a protocol (like an interface) that allows access to various methods and behaviors

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // A delete informs the View Controller of user events on the element
        // - user started typing
        // - user stopped typing
        // - user clicked off of the element, etc.
        searchTextField.delegate = self
        weatherManager.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true) // dismiss keyboard
    }
    
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
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
    // WeatherDelegateManagaer methods
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {

// have to run async in the background on the main thread since it is a network request to display UI elements
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)

        }
    }
    
    func didFailWithError(error: Error) {
        print("Error -- ", error)
    }
}

