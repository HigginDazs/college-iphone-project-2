//
//  Wishlist+CoreDataProperties.swift
//  Shopping List
//
//  Created by Conor Thomas Higgins on 08/04/2017.
//  Copyright © 2017 Conor Thomas Higgins. All rights reserved.
//

import Foundation
import CoreData


extension Wishlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wishlist> {
        return NSFetchRequest<Wishlist>(entityName: "Wishlist");
    }

    @NSManaged public var brand: String?
    @NSManaged public var genre: String?
    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var rating: Double
    @NSManaged public var instrument: String?

}
