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
    
    var model = CoreDataStack(modelName: "HackerBooksPro", inMemory: false)
    
}

//MARK: - DataSource
extension LibraryTableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBooksPro"
        registerNib()
        
        // Fetch request por BookTag
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchBatchSize = 50
        fr.sortDescriptors = [(NSSortDescriptor(key: "tag.proxyForSorting",ascending: true)),
                              (NSSortDescriptor(key: "book.title",ascending: true))]
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: (model?.context)!, sectionNameKeyPath: "tag.tagName", cacheName: nil)
        self.fetchedResultsController? = fc as! NSFetchedResultsController<NSFetchRequestResult>
        
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Tipo de celda
//        let cellId = "BookCell"
        
/*
        // Look for the tag section
        let tagList = Tag.allTags(fetchedResultsController?.managedObjectContext)
        let tagSection = tagList?[indexPath.section]
        
        // Book list del tag en cuestión
        let bookList = BookTag.booksForTag(theTag: tagSection!, inContext: fetchedResultsController?.managedObjectContext)
        
        // Identificamos el book
        let item = bookList?[indexPath.row].book
*/
        
        // Celda personalizada
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellID, for: indexPath) as! BookTableViewCell

        var booktag : BookTag
        var item : Book
       
        booktag = self.fetchedResultsController?.object(at: indexPath) as! BookTag
        item = booktag.book!
        
        // Sincronizar book -> celda
        cell.titleView.text = item.title
        cell.authorsView.text = item.listOfAuthors()
        cell.tagsView.text = item.listOfTags()
        
        UIView.transition(with: cell.coverView,
                          duration: 0.3,
                          options: [.curveEaseOut],
                          animations: { cell.coverView.image = self.getCover(ofBook: item)},
                          completion: nil)

        // Mostrar condición de favorito en las listas
//        if item.isFavorite {
//            cell.isFavorite.setTitle("🌟", forState: .Normal)
//        }
//        else{
//            cell.isFavorite.setTitle("", forState: .Normal)
//        }
        
        return cell
    }


    
    //MARK: - Cell registration
    private func registerNib(){
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: BookTableViewCell.cellID)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookTableViewCell.cellHeight
    }

/*
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
*/
    
}
    //MARK: - Utils
    extension LibraryTableViewController {
        func getCover(ofBook item:Book)->UIImage{
            
            let mainBundle = Bundle.main
            let defaultImageUrl = mainBundle.url(forResource: "emptyBookCover", withExtension: "png")!
            let data = try! Data(contentsOf: defaultImageUrl)
            let img = UIImage(data: data as Data)!
            
            if let img = item.cover?.image {
                return img
            }
            else {
                DispatchQueue.global(qos: .default).async { () -> Void in
                    
                    if let url = NSURL(string:(item.imageURL!)) {
                        if let data = NSData(contentsOf: url as URL) {
                            print("Downloading... \(url)")
                            if let image = UIImage(data: data as Data) {
                                print("Finish of downloading \(url)")
                                DispatchQueue.main.async {
                                    item.cover?.image = image
                                    self.tableView.reloadData()
                                    try! item.managedObjectContext?.save()
                                }
                                    
                            }
                        }
                    }
                }
            }
            return img
        }

        func downloadCover(ofBook book:Book)->UIImage{
            if (book.cover?.photoData==nil){
                let mainBundle = Bundle.main
                let defaultImage = mainBundle.url(forResource: "emptyBookCover", withExtension: "png")!
                
                // AsyncData
                let theDefaultData = try! Data(contentsOf: defaultImage)
                
                DispatchQueue.global(qos: .default).async {
                    let theUrlImage = URL(string: book.imageURL!)
                    let imageData = try? Data(contentsOf: theUrlImage!)
                    DispatchQueue.main.async {
                        if (imageData==nil){
                            book.cover?.photoData = nil
                        }
                        else{
                            book.cover?.photoData = imageData as NSData?
                            
                            self.tableView.reloadData()
                            
                            try! book.managedObjectContext?.save()
                            
                        }
                    }
                }
                // Hay que mandar que descargue en segundo plano
                return UIImage(data: theDefaultData)!
            }
            else{
                return (book.cover?.image!)!
            }
        }
        
}
