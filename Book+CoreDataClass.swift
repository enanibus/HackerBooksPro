//
//  Book+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 18/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import Foundation
import CoreData

public class Book: NSManagedObject {
    static let entityName = "Book"
    
    //MARK: - Initializers
    
    convenience init (title: String, imgURL: String, pdfURL: String, inContext context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Book.entityName, in: context)!
        if (Book.exists(title, inContext: context) == false){
            self.init(entity: entity, insertInto: context)
            self.title = title
            self.pdfURL = pdfURL
            self.imageURL = imgURL
            self.isFavorite = false
            // Imagen vacia
            self.cover = Cover(book: self, inContext: context)
        }
        else{
            self.init(entity: entity, insertInto: nil)
        }
    }
    
    //MARK: - Utils
    
    func listOfAuthors() -> String? {
        if let authors = self.authors?.allObjects as? [Author] {
            let arrayOfAuthorName = authors.map({$0.name!})
            return arrayOfAuthorName.joined(separator: ", ").capitalized
        }
        return nil
    }
    
    func listOfTags() -> String? {
        if let tags = self.bookTags?.allObjects as? [BookTag] {
            let arrayOfTags = tags.map({$0.tag!})
            let arrayOfTagName = arrayOfTags.map({$0.tagName!})
            return arrayOfTagName.joined(separator: ", ")
        }
        return nil
    }
    
}

extension Book{
    static func exists(_ title: String, inContext context: NSManagedObjectContext?) -> Bool {
        let fr = NSFetchRequest<Book>(entityName: Book.entityName)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "title CONTAINS [cd] %@", title)
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
