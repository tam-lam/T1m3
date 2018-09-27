//
//  UIViewControllerExt.swift
//  T1M3
//
//  Created by Graphene on 27/9/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//Core data function related extension
extension UIViewController{
    func saveToCoreData(record: Recording){
        guard let managedContext =  appDelegate?.persistentContainer.viewContext else { return }
        let entity = CoreDataRecord(context: managedContext)
        entity.notes = record.notes
        do{
            try managedContext.save()
        }catch{
            debugPrint("Could not save record")
        }
    }
    
}
