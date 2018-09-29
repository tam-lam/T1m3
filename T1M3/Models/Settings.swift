//
//  Settings.swift
//  T1M3
//
//  Created by Graphene on 9/9/18.
//  Copyright © 2018 Bob. All rights reserved.
//
import Foundation
import UIKit
class Settings{
    private let lightBgImage : UIImage
    private let darkBgImage : UIImage
    private let lightBgName = "bg"
    private let darkBgName = "darkbg"
    private var bgImage :UIImage
    
    public static let shared = Settings()
    
    private init(){
        self.lightBgImage = UIImage(named:  lightBgName)!
        self.darkBgImage = UIImage(named: darkBgName)!
        bgImage = lightBgImage
    }
    
    public func switchToDarkMode(){
        UserDefaults.standard.set(darkBgName, forKey: "bgName")
        bgImage = darkBgImage
    }
    public func switchToLightMode(){
        UserDefaults.standard.set(lightBgName, forKey: "bgName")
        bgImage = lightBgImage
    }
    
    public func getBgImage() -> UIImage{
        if let bgName = UserDefaults.standard.object(forKey: "bgName") as? String{
            self.bgImage = (bgName == darkBgName) ? darkBgImage : lightBgImage
        }
        return bgImage
    }
    public func isDarkMode() -> Bool{
        var answer = false
        if let bgName = UserDefaults.standard.object(forKey: "bgName") as? String{
            answer = (bgName == darkBgName) ? true : false
        }
        return answer
    }
    
}
