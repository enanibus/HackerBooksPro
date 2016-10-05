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
        self.name = theBook.title! + "_" + theTag.tagName!
    }
}

extension BookTag{
    
    static func favoriteBookTag(ofBook book:Book,
                                inContext context: NSManagedObjectContext?)->BookTag?{
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.sortDescriptors = [NSSortDescriptor.init(key: "tag", ascending: true)]
        fr.predicate = NSPredicate(format: "book == %@ and tag.tagName == 'favorites'", book)
        
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return nil
            }
            return resp.first
        } catch{
            return nil;
        }
        
    }
}
