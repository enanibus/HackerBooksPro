//
//  Tag+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 18/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import Foundation
import CoreData

public class Tag: NSManagedObject {
    static let entityName = "Tag"
        
    
    convenience init(tag: String, inContext context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: Tag.entityName, in: context)!
        if (Tag.exists(tag, inContext: context)==false){
            self.init(entity: entity, insertInto: context)
            if (tag.lowercased()==FAVORITES){
                self.proxyForSorting = "__" + FAVORITES
            }else{
                self.proxyForSorting = tag
            }
            self.tagName = tag
            self.bookTags = nil
            
        }else{
            self.init(entity: entity, insertInto: nil)
        }
        
        
    }
    
 
    class func filterByTag(tag t: String, inContext context: NSManagedObjectContext) -> [Book]? {
      
        let query = NSFetchRequest<Tag>(entityName: Tag.entityName)
        
        //array de NSSortDescriptors, busco toos los tags que coincidan con lo seleccionado
        query.sortDescriptors = [NSSortDescriptor(key: "proxyForSorting", ascending: true)]
        query.predicate = NSPredicate(format: "tag CONTAINS [cd] %@", t)
        
        do {
            let res = try context.fetch(query) as [Tag]
            return nil
            
        } catch {
            return nil
        }
        
    }
    
    
    
    
}

//MARK: - Static class
extension Tag {
    static func exists(_ tag: String, inContext context: NSManagedObjectContext?) -> Bool {
        let fr = NSFetchRequest<Tag>(entityName: Tag.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "tagName CONTAINS [cd] %@", tag)
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
    
    static func tagForString(_ tag: String, inContext context: NSManagedObjectContext?)->Tag?{
        
        let fr = NSFetchRequest<Tag>(entityName: Tag.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "tagName CONTAINS [cd] %@", tag)
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return nil
            }
            if (resp.count>0){
                return resp.first
            }
            else{
                return nil
            }
        } catch{
            return nil;
        }
        
    }
    
    
    static func count(_ context: NSManagedObjectContext?) -> Int{
        let fr = NSFetchRequest<Tag>(entityName: Tag.entityName)
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return 0
            }
            return resp.count
        }catch{
            return 0
        }
        
    }
    
    static func allTags(_ context: NSManagedObjectContext?)->[Tag]? {
        let fr = NSFetchRequest<Tag>(entityName: Tag.entityName)
        fr.sortDescriptors = [NSSortDescriptor.init(key: "tagName", ascending: true)]
        
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return nil
            }
            return resp
        }catch{
            return nil
        }
        
    }
}

