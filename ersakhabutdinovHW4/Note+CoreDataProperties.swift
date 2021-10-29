//
//  Note+CoreDataProperties.swift
//  ersakhabutdinovHW4
//
//  Created by Эрнест Сахабутдинов on 29.10.2021.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var title: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var creationDate: Date

}

extension Note : Identifiable {

}
