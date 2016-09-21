//
//  Pdf+CoreDataProperties.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 21/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import Foundation
import CoreData

extension Pdf {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pdf> {
        return NSFetchRequest<Pdf>(entityName: "Pdf");
    }

    @NSManaged public var pdfData: NSData?
    @NSManaged public var book: Book?

}
