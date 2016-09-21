//
//  CoreDataTableViewController.swift
//
//
//  Created by Fernando Rodríguez Romero on 22/02/16.
//  Copyright © 2016 
//

import UIKit
import CoreData

class CoreDataTableViewController: UITableViewController {
    
    // MARK:  - Properties
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?{
        didSet{
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
            executeSearch()
            tableView.reloadData()
        }
    }
    
    init(fetchedResultsController fc : NSFetchedResultsController<NSFetchRequestResult>,
        style : UITableViewStyle = .plain){
        
            super.init(style: style)
        
        defer{
            fetchedResultsController = fc
           
        }
            
    }
    
    // Do not worry about this initializer. I has to be implemented
    // because of the way Swift interfaces with an Objective C
    // protocol called NSArchiving. It's not relevant.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // -- Esto es una ñapa para que tire --
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}


// MARK:  - Subclass responsability
extension CoreDataTableViewController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        fatalError("This method MUST be implemented by a subclass of CoreDataTableViewController")
    }
}

// MARK:  - Table Data Source
extension CoreDataTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let fc = fetchedResultsController{
            guard let sections = fc.sections else{
                return 1
            }
            return sections.count
            
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fc = fetchedResultsController{
            return fc.sections![section].numberOfObjects;
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let fc = fetchedResultsController{
            
            return fc.sections?[section].name;
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if let fc = fetchedResultsController{
            return fc.section(forSectionIndexTitle: title, at: index)
        }else{
            return 0
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if let fc = fetchedResultsController{
            return  fc.sectionIndexTitles
        }else{
            return nil
        }
    }
    
    
}

// MARK:  - Fetches
extension CoreDataTableViewController{
    
    func executeSearch(){
        if let fc = fetchedResultsController{
            do{
                try fc.performFetch()
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
}


// MARK:  - Delegate
extension CoreDataTableViewController: NSFetchedResultsControllerDelegate{
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType) {
            
            let set = IndexSet(integer: sectionIndex)
            
            switch (type){
                
            case .insert:
                tableView.insertSections(set, with: .fade)
                
            case .delete:
                tableView.deleteSections(set, with: .fade)
                
            default:
                // irrelevant in our case
                break
                
            }
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
            
            
            
            switch(type){
                
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
                
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
                
            case .update:
                tableView.reloadRows(at: [indexPath!], with: .fade)
                
            case .move:
                tableView.deleteRows(at: [indexPath!], with: .fade)
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            }
            
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
















