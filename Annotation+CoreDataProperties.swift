//
//  Annotation+CoreDataProperties.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 21/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import Foundation
import CoreData

extension Annotation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Annotation> {
        return NSFetchRequest<Annotation>(entityName: "Annotation");
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var modificationDate: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var book: Book?
    @NSManaged public var localization: Localization?
    @NSManaged public var photo: Photo?

}
