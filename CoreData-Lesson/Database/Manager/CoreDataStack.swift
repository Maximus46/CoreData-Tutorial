//
//  CoreDataStack.swift
//  CoreData-Lesson
//
//  Created by Riccardo Arnone on 21/02/17.
//  Copyright © 2017 Riccardo Arnone. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
// MARK: - Properties
    static var shared = CoreDataStack()
    
    private let modelName: String
    
    private init(){
        self.modelName = "Contacts"
    }
    
// MARK: - Lazy Properties
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
// MARK: - Functions
    func saveContext(){
        
        guard managedContext.hasChanges else{
            return
        }
        
        do{
            try managedContext.save()
        }
        catch let error as NSError{
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
