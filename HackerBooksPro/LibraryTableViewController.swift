//
//  LibraryTableViewController.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 24/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import UIKit


class LibraryTableViewController: CoreDataTableViewController {

}

//MARK: - DataSource
extension LibraryTableViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBooksPro"
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "BookCell"
        
        
        let book = fetchedResultsController?.object(at: indexPath) as! Book
        
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = book.title
        cell?.detailTextLabel?.text = book.listOfAuthors()
        
        
        return cell!
    }
    
    
    
    
}
