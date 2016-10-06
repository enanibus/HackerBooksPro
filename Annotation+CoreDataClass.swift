//
//  Annotation+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 18/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import Foundation
import CoreData

public class Annotation: NSManagedObject {
    static let entityName = "Annotation"
    
    //MARK: - Init
    convenience init(withBook book: Book, inContext context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Annotation.entityName, in: context)!
        
        self.init(entity: entity, insertInto: context)

        self.book = book
        self.title = book.title
        self.text = "Nueva Nota"
        self.creationDate = NSDate()
        self.modificationDate = NSDate()
        
    }
}
//MARK: - KVO
extension Annotation{
    static func observableKeys()->[String]{return ["title","text","photo.photoData"]};
    
    func setupKVO(){
        for key in Annotation.observableKeys(){
            self.addObserver(self,
                             forKeyPath: key,
                             options: [],
                             context: nil)
        }
    }
    func tearDownKVO(){
        for key in Annotation.observableKeys(){
            self.removeObserver(self, forKeyPath: key)
        }
    }
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.modificationDate = NSDate()
    }
}

//MARK: - Lifecycle
extension Annotation{
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setupKVO()
    }
    public override func awakeFromFetch() {
        super.awakeFromFetch()
        setupKVO()
    }
    public override func willTurnIntoFault() {
        super.willTurnIntoFault()
        tearDownKVO()
    }
}

