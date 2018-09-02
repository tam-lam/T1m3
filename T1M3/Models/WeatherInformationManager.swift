//
//  WeatherInformationManager.swift
//  T1M3
//
//  Created by Bob on 8/29/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import UIKit

public enum WeatherSituation: Int {
    case sunny
    case partlyCloudy
    case cloudy
    case rainy
    case mixed
    
    var image: UIImage {
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
            
        }
    }
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
