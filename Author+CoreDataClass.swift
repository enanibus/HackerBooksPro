//
//  Author+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 18/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import Foundation
import CoreData

public class Author: NSManagedObject {
    
    static let entityName = "Author"
    
    convenience init(author: String, inContext context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: Author.entityName, in: context)!
        if (Author.exists(author, inContext: context)==false){
            self.init(entity: entity, insertInto: context)
            self.name = author
            self.books = nil
        }else{
            self.init(entity: entity, insertInto: nil)
        }
        
        
    }
    
    
    
}

//MARK - Static class
extension Author {
    static func exists(_ author: String, inContext context: NSManagedObjectContext?) -> Bool {
        let fr = NSFetchRequest<Author>(entityName: Author.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "name == [c] %@", author)
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return false
            }
            return ((resp.count)>0)
        } catch{
            return false;
        }
        
    }
}

