//
//  Contact+CoreDataClass.swift
//  CoreData-Lesson
//
//  Created by Riccardo Arnone on 21/02/17.
//  Copyright © 2017 Riccardo Arnone. All rights reserved.
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    
    //Create a method to initialize and save a contact with all the info
    
    static func save(firstName: String?, lastName: String?, email: String?) -> Contact?{
        let contact = Contact(context: CoreDataStack.shared.managedContext)
        
        contact.name = firstName
        contact.surname = lastName
        contact.email = email
        
        CoreDataStack.shared.saveContext()
        return contact
    }
    
    //Create a method to delete a contact and save
    
    func delete() {
        CoreDataStack.shared.managedContext.delete(self)
        CoreDataStack.shared.saveContext()
    }

}
