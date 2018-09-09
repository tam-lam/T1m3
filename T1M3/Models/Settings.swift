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
    private var bgImage :UIImage
    
    public static let shared = Settings()
    
    private init(){
        self.lightBgImage = UIImage(named: "bg")!
        self.darkBgImage = UIImage(named: "darkbg")!
        bgImage = lightBgImage
    }
    
    public func switchToDarkMode(){
        bgImage = darkBgImage
    }
    public func switchToLightMode(){
        bgImage = lightBgImage
    }
    public func getBgImage() -> UIImage{
        return bgImage
    }
    
    
}
