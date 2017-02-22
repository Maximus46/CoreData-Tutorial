//
//  Contact+CoreDataProperties.swift
//  CoreData-Lesson
//
//  Created by Riccardo Arnone on 21/02/17.
//  Copyright © 2017 Riccardo Arnone. All rights reserved.
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact");
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var email: String?
    @NSManaged public var phoneNumbers: NSOrderedSet?

}

// MARK: Generated accessors for phoneNumbers
extension Contact {

    @objc(insertObject:inPhoneNumbersAtIndex:)
    @NSManaged public func insertIntoPhoneNumbers(_ value: Phone, at idx: Int)

    @objc(removeObjectFromPhoneNumbersAtIndex:)
    @NSManaged public func removeFromPhoneNumbers(at idx: Int)

    @objc(insertPhoneNumbers:atIndexes:)
    @NSManaged public func insertIntoPhoneNumbers(_ values: [Phone], at indexes: NSIndexSet)

    @objc(removePhoneNumbersAtIndexes:)
    @NSManaged public func removeFromPhoneNumbers(at indexes: NSIndexSet)

    @objc(replaceObjectInPhoneNumbersAtIndex:withObject:)
    @NSManaged public func replacePhoneNumbers(at idx: Int, with value: Phone)

    @objc(replacePhoneNumbersAtIndexes:withPhoneNumbers:)
    @NSManaged public func replacePhoneNumbers(at indexes: NSIndexSet, with values: [Phone])

    @objc(addPhoneNumbersObject:)
    @NSManaged public func addToPhoneNumbers(_ value: Phone)

    @objc(removePhoneNumbersObject:)
    @NSManaged public func removeFromPhoneNumbers(_ value: Phone)

    @objc(addPhoneNumbers:)
    @NSManaged public func addToPhoneNumbers(_ values: NSOrderedSet)

    @objc(removePhoneNumbers:)
    @NSManaged public func removeFromPhoneNumbers(_ values: NSOrderedSet)

}
