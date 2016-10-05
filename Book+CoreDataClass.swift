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
    
    let sameOne = CoreDataStack.defaultStack(modelName:  DATABASE)!
    
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
            let arrayOfTagName = arrayOfTags.map({$0.tagName!}).sorted()
            return arrayOfTagName.joined(separator: ", ")
        }
        return nil
    }
    
    func archiveURIRepresentation() -> NSData? {
        let uri = self.objectID.uriRepresentation()
        return NSKeyedArchiver.archivedData(withRootObject: uri) as NSData?
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
    func markUnmarkAsFavorite(){
        if (self.isFavorite == false){
            // Mark favorite the model
            self.isFavorite = true
            
            var favTag = Tag.tagForString("favorites", inContext: self.managedObjectContext)
            if (favTag==nil){

                favTag = Tag(tag: "favorites", inContext: self.managedObjectContext!)
            }

            _ = BookTag(theBook: self,
                        theTag: favTag!,
                        inContext: self.managedObjectContext!)
            
            sameOne.save()
            
            
        }else{
            self.isFavorite=false
            
            let theBookTag = BookTag.favoriteBookTag(ofBook: self,inContext: self.managedObjectContext)
            
            self.managedObjectContext?.delete(theBookTag!)
            sameOne.save()
            
            
        }
    }
}

//MARK: - KVO
extension Book{
    static func observableKeys() -> [String] {return ["isFavorite"]};
    func setupKVO(){
        for key in Book.observableKeys(){
            self.addObserver(self,
                             forKeyPath: key,
                             options: [],
                             context: nil)
        }
    }
    
    func tearDownKVO(){
        for key in Book.observableKeys(){
            self.removeObserver(self, forKeyPath: key)
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        
        self.markUnmarkAsFavorite()
    }
    
}


