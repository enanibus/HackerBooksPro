//
//  CoreDataStack.swift
//
//
//  Created by Fernando Rodríguez Romero on 21/02/16.
//

import CoreData

struct CoreDataStack {
    
    // MARK:  - Properties
    
    fileprivate let model : NSManagedObjectModel
    fileprivate let coordinator : NSPersistentStoreCoordinator
    fileprivate let modelURL : URL
    fileprivate let dbURL : URL
    fileprivate let persistingContext : NSManagedObjectContext
    fileprivate let backgroundContext : NSManagedObjectContext
    let context : NSManagedObjectContext
    fileprivate var inMemory: Bool = false
 
    
   

    
    
    // MARK:  - Initializers
    init?(modelName: String, inMemory: Bool = false){
        
        self.inMemory = inMemory
        
        // Assumes the model is in the main bundle
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            print("Unable to find \(modelName)in the main bundle")
            return nil}
        
        self.modelURL = modelURL
        
        // Try to create the model from the URL
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else{
            print("unable to create a model from \(modelURL)")
            return nil
        }
        self.model = model
        
        
        
        // Create the store coordinator
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        // Create a persistingContext (private queue) and a child one (main queue)
        // create a context and add connect it to the coordinator
        persistingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        persistingContext.persistentStoreCoordinator = coordinator
        
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = persistingContext
        
        // Create a background context child of main context
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.parent = context
        
        
        // Add a SQLite store located in the documents folder
        let fm = FileManager.default
        
        guard let  docUrl = fm.urls(for: .documentDirectory, in: .userDomainMask).first else{
            print("Unable to reach the documents folder")
            return nil
        }
        
        self.dbURL = docUrl.appendingPathComponent("model.sqlite")
        
        
        do{
            // Meto aqui el que este en memoria o no, no se si esta bien
            if inMemory == false {
                try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: nil)
            }else{
                try addStoreCoordinatorInMemory()
            }
            
        }catch{
            print("unable to add store at \(dbURL)")
        }
        
        
        
        
        
    }
    
    
    // MARK:  - Utils
    func addStoreCoordinator(_ storeType: String,
                             configuration: String?,
                             storeURL: URL,
                             options : [NSObject : AnyObject]?) throws{
        
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
        
    }
}


// MARK:  - Removing data
extension CoreDataStack  {
    
    func dropAllData() throws{
        // delete all the objects in the db. This won't delete the files, it will
        // just leave empty tables.
        try coordinator.destroyPersistentStore(at: dbURL, ofType:NSSQLiteStoreType , options: nil)
        
        try addStoreCoordinator(NSSQLiteStoreType, configuration: nil, storeURL: dbURL, options: nil)
        
        
    }
}

// MARK:  - Batch processing in the background
extension CoreDataStack{
    typealias Batch=(_ workerContext: NSManagedObjectContext) -> ()
    
    func performBackgroundBatchOperation(_ batch:  @escaping Batch){
        
        backgroundContext.perform(){
            batch(self.backgroundContext)
            
            // Save it to the parent context, so normal saving
            // can work
            do{
                try self.backgroundContext.save()
            }catch{
                fatalError("Error while saving backgroundContext: \(error)")
            }
        }
    }
}
// MARK:  - Save
extension CoreDataStack {
    
    func save() {
        // We call this synchronously, but it's a very fast
        // operation (it doesn't hit the disk). We need to know
        // when it ends so we can call the next save (on the persisting
        // context). This last one might take some time and is done
        // in a background queue
        context.performAndWait(){
            
            if self.context.hasChanges{
                do{
                    try self.context.save()
                }catch{
                    fatalError("Error while saving main context: \(error)")
                }
                
                // now we save in the background
                self.persistingContext.perform(){
                    do{
                        try self.persistingContext.save()
                    }catch{
                        fatalError("Error while saving persisting context: \(error)")
                    }
                }
                
                
            }
        }
        
        
        
    }
    
    
    func autoSave(_ delayInSeconds : Int){
        
        if delayInSeconds > 0 {
            print("Autosaving")
            save()
            
            let delayInNanoSeconds = UInt64(delayInSeconds) * NSEC_PER_SEC
            let time = DispatchTime.now() + Double(Int64(delayInNanoSeconds)) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                self.autoSave(delayInSeconds)
            })
            
        }
    }
}

//MARK: - CoreData in Memory for testing
extension CoreDataStack{
    func addStoreCoordinatorInMemory() throws {
         try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
    }
}













