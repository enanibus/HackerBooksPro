//
//  Pdf+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 18/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import Foundation
import CoreData

//public class Pdf: NSManagedObject {
//
//}

public class Pdf: NSManagedObject {
    static let entityName = "Pdf"
    convenience init (withData: Data,
                      inContext context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Pdf.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
        self.pdfData = withData as NSData?
    }
    
}
