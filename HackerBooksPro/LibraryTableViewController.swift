//
//  LibraryTableViewController.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 24/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import UIKit
import CoreData

class LibraryTableViewController: CoreDataTableViewController, UISearchControllerDelegate {
    
    let model = CoreDataStack(modelName: "HackerBooksPro", inMemory: false)
    let searchController = UISearchController(searchResultsController: nil)
    var filteredBooks = [Book]()
    
}

extension LibraryTableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBooksPro"
        registerNib()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.definesPresentationContext = true
        
        self.searchController.searchBar.sizeToFit()
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.scopeButtonTitles = ["Titulo", "Tag", "Autor"]
        self.searchController.searchBar.delegate = self
        self.tableView.tableHeaderView = searchController.searchBar

        self.filteredBooks = [Book]()
        
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
       
        
        if  self.searchController.isActive && self.searchController.searchBar.text != "" {
            print(self.searchController.isActive)
            print(self.searchController.searchBar.text)
            //es busqueda, asi que el filter es un array de Book
            item = self.filteredBooks[indexPath.row] as Book
        }
        else {
            booktag = self.fetchedResultsController?.object(at: indexPath) as! BookTag
            item = booktag.book!
        }
        
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    
    //MARK: - Cell registration
    private func registerNib(){
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: BookTableViewCell.cellID)
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
    

    //MARK: - Search Controller Methods
    func filterContentForSearchText(searchText: String, scope: String = "All") {

        self.filteredBooks.removeAll()
        
        switch (scope){
            case "Titulo":
                if let booksByTitle = Book.filterByTitle(title: searchText, inContext: (self.model?.context)!) {
                    self.filteredBooks.append(contentsOf: booksByTitle)
                }
            break
        case "Tag":
                if let booksByTag = Tag.filterByTag(tag: searchText, inContext: (self.model?.context)!) {
                    self.filteredBooks.append(contentsOf: booksByTag)
                }
            break
//        case "Autor":
//            if let booksByAuthor = Author.filterByAuthor(author: searchText, inContext: (self.model?.context)!) {
//            }
//            break
        default:
            break
        }

        self.tableView.reloadData()
    }

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

extension LibraryTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController){
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        
        let scope = self.searchController.searchBar.scopeButtonTitles![searchController.searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}

extension LibraryTableViewController: UISearchBarDelegate {
    private func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
