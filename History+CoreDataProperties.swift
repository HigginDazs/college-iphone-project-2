//
//  History+CoreDataProperties.swift
//  Shopping List
//
//  Created by Conor Thomas Higgins on 04/04/2017.
//  Copyright © 2017 Conor Thomas Higgins. All rights reserved.
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History");
    }

    @NSManaged public var brand: String?
    @NSManaged public var genre: String?
    @NSManaged public var groupName: String?
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var rating: Double

}
