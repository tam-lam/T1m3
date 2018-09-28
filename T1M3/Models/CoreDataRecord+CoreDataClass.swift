//
//  CoreDataRecord+CoreDataClass.swift
//  
//
//  Created by Graphene on 28/9/18.
//
//

import Foundation
import CoreData


public class CoreDataRecord: NSManagedObject {

    var weather: WeatherSituation?{
        get{
            let value :Int = Int(self.rawWeatherValue)
            return WeatherSituation(rawValue: value)
        } 
    }
}
