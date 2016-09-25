//
//  LibraryTableViewController.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 24/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import UIKit
import CoreData

class LibraryTableViewController: CoreDataTableViewController {

}

//MARK: - DataSource
extension LibraryTableViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBooksPro"
        
        registerNib()
        
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Tipo de celda
//        let cellId = "BookCell"
        
        // Look for the tag section
        let tagList = Tag.allTags(fetchedResultsController?.managedObjectContext)
        let tagSection = tagList?[indexPath.section]
        
        // Book list
        let bookList = BookTag.booksForTag(theTag: tagSection!, inContext: fetchedResultsController?.managedObjectContext)
        
        // Item con book(forIndexPath: indexPath), pendiente

        // Create cell
//        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
//        if cell == nil{
//            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
//        }
        
//        cell?.textLabel?.text = bookList?[indexPath.row].book?.title
//        cell?.detailTextLabel?.text = bookList?[indexPath.row].book?.listOfAuthors()
        
        let mainBundle = Bundle.main
        let defaultImageUrl = mainBundle.url(forResource: "emptyBookCover", withExtension: "png")!
        let data = try! Data(contentsOf: defaultImageUrl)
        let img = UIImage(data: data as Data)!
        
//        cell?.imageView?.image = img
        
        // Celda personalizada
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellID, for: indexPath) as! BookTableViewCell
        
        cell.coverView.image = img
        cell.titleView.text = bookList?[indexPath.row].book?.title
        cell.authorsView.text = bookList?[indexPath.row].book?.listOfAuthors()
        cell.tagsView.text = bookList?[indexPath.row].book?.listOfTags()
        
        // Sincronizar book -> celda
//        cell.imageView?.image = item.cover.getImage()
//        cell.bookTitle.text = item.title
        
        // Mostrar condición de favorito en las listas
//        if item.isFavorite {
//            cell.isFavorite.setTitle("🌟", forState: .Normal)
//        }
//        else{
//            cell.isFavorite.setTitle("", forState: .Normal)
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookTableViewCell.cellHeight
    }
    
    //MARK: - Cell registration
    private func registerNib(){
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: BookTableViewCell.cellID)
    }
    
    //MARK: - Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        let tagCount = Tag.count(fetchedResultsController?.managedObjectContext)
        return tagCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tagList = Tag.allTags(fetchedResultsController?.managedObjectContext)
        return tagList?[section].tagName?.capitalized
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Get the tag
        let tagList = Tag.allTags(fetchedResultsController?.managedObjectContext)
        let theTag = tagList?[section]
        
        // Obtain number of rows in section
        let bookTagList = BookTag.booksForTag(theTag: theTag!, inContext: fetchedResultsController?.managedObjectContext)
        return (bookTagList?.count)!
    }
    
    
}
