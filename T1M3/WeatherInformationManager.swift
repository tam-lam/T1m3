//
//  WeatherInformationManager.swift
//  T1M3
//
//  Created by Bob on 8/29/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation

public enum WeatherSituation: Int {
    case sunny
    case partlyCloudy
    case cloudy
    case rainy
    case mixed
}

class WeatherInformationManager {
    
    func getWeatherInformation(weatherSituation: (WeatherSituation) -> ())  {
        // The Api will sit here
        weatherSituation(randomSituation)
    }
    public var randomSituation: WeatherSituation {
        let val = Int(arc4random_uniform(6))
        return WeatherSituation.init(rawValue: val%6) ?? .cloudy
    }
}
