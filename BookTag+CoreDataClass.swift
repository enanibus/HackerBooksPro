//
//  BookTag+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 18/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import Foundation
import CoreData

public class BookTag: NSManagedObject {
    static let entityName = "BookTag"
    
    convenience init (theBook :Book, theTag: Tag, inContext context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: BookTag.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
        self.book = theBook
        self.tag = theTag
    }
}
