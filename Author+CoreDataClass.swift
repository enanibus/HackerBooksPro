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
    
//    class func filterByAuthor(author a:String, inContext context: NSManagedObjectContext) -> [Book]? {
//        
//        let query = NSFetchRequest<Author>(entityName: Author.entityName)
//        
//        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        query.predicate = NSPredicate(format: "name contains [cd] %@", a)
//        
//        do {
//            //primero busco todos los autores que encajen con lo puesto en el search
//            let aut = try context.fetch(query as! NSFetchRequest<NSFetchRequestResult>) as? [Author]
//            
//            //ahora con todos estos autores, he de sacar los libros que han escrito, se pueden repetir, asi que lo meto en un NSSet
//            //creo el conjunto de libros vacio
//            var booksSet = Set<Book>()
//            
//            for each in aut! {
//                //inserto los libros que tenga en el conjunto
//                _ = each.books.map({booksSet.insert($0 as! Book)})
//            }
//            //tengo un nsset de BookModel, he de obtener un array ordenado
//            let arr = booksSet.map({$0})
//            return arr
//            
//        } catch {
//            return nil
//        }
//        
//    }
    
    
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
    
    static func authorForString(_ author: String, inContext context: NSManagedObjectContext?) -> Author?{
        let fr = NSFetchRequest<Author>(entityName: Author.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "name == [c] %@", author)
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
            return nil
        }
        
    }
}

