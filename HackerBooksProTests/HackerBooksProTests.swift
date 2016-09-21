//
//  HackerBooksProTests.swift
//  HackerBooksProTests
//
//  Created by Jacobo Enriquez Gabeiras on 6/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import XCTest
@testable import HackerBooksPro
import CoreData

let model = CoreDataStack(modelName: "HackerBooksPro", inMemory: true)!



class HackerBooksProTests: XCTestCase {
    
    
    override func setUp() {
        do{
            try model.dropAllData()
            
        }
        catch{
            print("Test Setup: Error deleting data")
        }
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInsertAuthor(){
        _ = Author(author: "prueba", inContext: model.context)
        _ = Author(author: "pepito", inContext: model.context)
        _ = Author(author: "prueba", inContext: model.context)
        
        
        
        XCTAssert(Author.exists("prueba",inContext: model.context)==true,"Prueba must exist!")
        XCTAssert(Author.exists("Juanito",inContext: model.context)==false,"Prueba must exist!")
        XCTAssert(Author.exists("Prueba",inContext: model.context)==true,"Prueba must exist!")
        
    }
    
    func testTagSort(){
        _ = Tag(tag: "Favorite", inContext: model.context)
        _ = Tag(tag: "Programming", inContext: model.context)
        _ = Tag(tag: "CoreData",inContext: model.context)
        _ = Tag(tag: "coredata",inContext: model.context)
        
        // Hago una busqueda ordenada
        
        let fr = NSFetchRequest<Tag>(entityName: Tag.entityName)
        fr.fetchLimit = 10
        fr.fetchBatchSize = 10
        
        fr.sortDescriptors = [NSSortDescriptor.init(key: "tagName", ascending: true)]
        
        
        let result = try! model.context.fetch(fr)
        
        XCTAssertNotNil(result)
        
        XCTAssertEqual(result.count,3,"Tag count should be 3")
        
        let ns = NSFetchedResultsController(fetchRequest: fr,
                                            managedObjectContext: model.context,
                                            sectionNameKeyPath: nil, cacheName: nil)
        try! ns.performFetch()
        
        let f = ns.object(at: IndexPath(row: 0, section: 0)).realTagName
        let c = ns.object(at: IndexPath(row: 1, section: 0)).realTagName
        let p = ns.object(at: IndexPath(row: 2, section: 0)).realTagName
        
        XCTAssertEqual(f, "favorite","First tag should be favorite")
        XCTAssertEqual(c, "coredata","Second tag should be coredata")
        XCTAssertEqual(p, "programming","Third tag should be programming")
    }
    func testBookAndTags(){
        // Quiero cargarme todos los datos
        try! model.dropAllData()
        
        let tag1 = Tag(tag: "Favorite", inContext: model.context)
        let tag2 = Tag(tag: "Programming", inContext: model.context)
        let tag3 = Tag(tag: "CoreData",inContext: model.context)
        
        let pb = Book(title: "Programing in CoreData", inContext: model.context)
        let pb1 = Book(title: "Programing in CoreData1", inContext: model.context)
        
        // Se supone que el libro tiene los dos tags
        
        _ = BookTag(theBook: pb, theTag: tag1, inContext: model.context)
        _ = BookTag(theBook: pb, theTag: tag2, inContext: model.context)
        _ = BookTag(theBook: pb1, theTag: tag3, inContext: model.context)
        
        // El proceso es hago un fetch de todos los tags
        let fr = NSFetchRequest<Tag>(entityName: Tag.entityName)
        fr.fetchLimit = 10
        fr.fetchBatchSize = 10
        fr.sortDescriptors = [NSSortDescriptor.init(key: "tagName", ascending: true)]
        
        _ = try! model.context.fetch(fr)
        let ns = NSFetchedResultsController(fetchRequest: fr,
                                            managedObjectContext: model.context,
                                            sectionNameKeyPath: nil, cacheName: nil)
        try! ns.performFetch()
        
        let losTags = ns.fetchedObjects!
        for oneTag in losTags{
            // Dentro de BookTag busco los que tenga ese "tag" y me quedo con el libro
            let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
            fr.fetchLimit = 10
            fr.fetchBatchSize = 10
            fr.sortDescriptors = [NSSortDescriptor.init(key: "book", ascending: true)]
            fr.predicate = NSPredicate(format: "tag == %@", oneTag)
            let result = try! model.context.fetch(fr)
            let ns = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: model.context, sectionNameKeyPath: nil, cacheName: nil)
            try! ns.performFetch()
            XCTAssertEqual(result.count, 1,"There is only one book in all tags")
            let p = ns.object(at: IndexPath(row: 0 , section: 0)).book?.title
            
            XCTAssertEqual(p, "Programing in CoreData","The book is programming in 'Programming in Core Data' ")
            
        }
        
        
        
    }
    
}
