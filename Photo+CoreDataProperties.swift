//
//  Photo+CoreDataProperties.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 21/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var photoData: NSData?
    @NSManaged public var annotation: Annotation?

}
