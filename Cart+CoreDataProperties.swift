//
//  Cart+CoreDataProperties.swift
//  Shopping List
//
//  Created by Conor Thomas Higgins on 31/03/2017.
//  Copyright © 2017 Conor Thomas Higgins. All rights reserved.
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart");
    }

    @NSManaged public var genre: String?
    @NSManaged public var groupName: String?
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var rating: Double
    @NSManaged public var brand: String?

}
