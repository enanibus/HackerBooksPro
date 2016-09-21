//
//  Cover+CoreDataProperties.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 21/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import Foundation
import CoreData

extension Cover {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cover> {
        return NSFetchRequest<Cover>(entityName: "Cover");
    }

    @NSManaged public var photoData: NSData?
    @NSManaged public var book: Book?

}
