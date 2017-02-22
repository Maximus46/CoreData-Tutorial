//
//  Phone+CoreDataClass.swift
//  CoreData-Lesson
//
//  Created by Riccardo Arnone on 21/02/17.
//  Copyright © 2017 Riccardo Arnone. All rights reserved.
//

import Foundation
import CoreData

@objc(Phone)
public class Phone: NSManagedObject {
    func delete(){
        CoreDataStack.shared.managedContext.delete(self)
        CoreDataStack.shared.saveContext()
    }
}
