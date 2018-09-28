//
//  WeatherInformationManager.swift
//  T1M3
//
//  Created by Bob on 8/29/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import UIKit
import MapKit

public enum WeatherSituation: Int {
    case sunny
    case partlyCloudy
    case cloudy
    case rainy
    case mixed
    case none
    
    var image: UIImage? {
        switch self {
        case .sunny:
            return #imageLiteral(resourceName: "Sunny")
        case .partlyCloudy:
            return #imageLiteral(resourceName: "PartlyCloudy")
        case .cloudy:
            return #imageLiteral(resourceName: "Cloudy")
        case .rainy:
            return #imageLiteral(resourceName: "Rain")
        case .mixed:
            return #imageLiteral(resourceName: "Mixed")
        case .none:
            return nil
            
        }
    }
    
    static func weatherFromShortcut(_ shortcut: String) -> WeatherSituation {
        switch shortcut {
        case "sn","sl","h","t","hr":
            return .rainy
        case "lr","s":
            return .cloudy
        case "hc","lc":
            return .mixed
        case "c":
            return .sunny
        default:
            return  .none
        }
    }
}

/**
 
 (First one is used to get the parameter for the second API which returns weather data)
 https://www.metaweather.com/api/location/search/?lattlong=50.068,-5.316
 https://www.metaweather.com/api/location/44418/
 */

class WeatherInformationManager {
    
    static func getWeatherInformation(forCoordinates coordinates: CLLocationCoordinate2D, weatherSituation: @escaping (WeatherSituation) -> ())  {
        // The Api will sit here
        

        guard let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(coordinates.latitude),\(coordinates.longitude)") else {
            return
        }
        URLSession.shared.invalidateAndCancel()
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                weatherSituation(.none)
                return
            }
            // Data to Swift Dictionary
            if let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                let woeid = array?.first?["woeid"]{
                
                guard let secondURL = URL.init(string: "https://www.metaweather.com/api/location/\(woeid)/") else {
                    weatherSituation(.none)
                    return
                }
                let task2 = URLSession.shared.dataTask(with: secondURL) { (data, _, error) in
                    guard let secondData = data, error == nil else {
                        weatherSituation(.none)
                        return
                    }
                    if let weatherData = try? JSONSerialization.jsonObject(with: secondData, options: []) as? [String: Any],
                        let weatherArray = weatherData?["consolidated_weather"] as? [[String: Any]] {
                        
                        let weatherShortcut = weatherArray.first?["weather_state_abbr"] as? String ?? "none"
                        
                        weatherSituation(WeatherSituation.weatherFromShortcut(weatherShortcut))
                        
                        
                    }
                    
                    
                }
                task2.resume()
                
                
            }
            
        }
        task.resume()
        
    }
    public var randomSituation: WeatherSituation {
        let val = Int(arc4random_uniform(6))
        return WeatherSituation.init(rawValue: val%6) ?? .cloudy
    }
}
