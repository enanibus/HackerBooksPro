//
//  Book+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 18/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
    
    class func filterByTitle(title t: String, inContext context: NSManagedObjectContext) -> [Book]? {
        
        let query = NSFetchRequest<Book>(entityName: Book.entityName)
        
        query.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        query.predicate = NSPredicate(format: "title CONTAINS [cd] %@", t)
        
        do {
            let res = try context.fetch(query) as [Book]
            return res
            
        } catch {
            return nil
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
            let arrayOfTagName = arrayOfTags.map({$0.tagName!}).sorted()
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

//MARK: -- Favorite management
extension Book{
    func favoriteSwitch(){
        if (self.isFavorite == false){
            // Mark favorite the model
            self.isFavorite = true
            // Create a "favorite" tag
            
            var favTag = Tag.tagForString("favorites", inContext: self.managedObjectContext)
            if (favTag==nil){
                // No existe el tag hay que crearlo
                favTag = Tag(tag: "favorites", inContext: self.managedObjectContext!)
            }
            // Associate Book
            _ = BookTag(theBook: self,
                        theTag: favTag!,
                        inContext: self.managedObjectContext!)
            
            try! self.managedObjectContext?.save()
            
            
        }else{
            self.isFavorite=false
            
            let theBookTag = BookTag.favoriteBookTag(ofBook: self,inContext: self.managedObjectContext)
            
            self.managedObjectContext?.delete(theBookTag!)
            
            try! self.managedObjectContext?.save()
            
            
        }
    }
}

