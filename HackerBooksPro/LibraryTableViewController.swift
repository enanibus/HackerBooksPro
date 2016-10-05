//
//  LibraryTableViewController.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 24/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import UIKit
import CoreData

class LibraryTableViewController: CoreDataTableViewController, UISearchControllerDelegate, LibraryTableViewControllerDelegate {
    internal func libraryTableViewController(vc: LibraryTableViewController, didSelectBook book: Book) {
    }
    
    let sameOne = CoreDataStack.defaultStack(modelName:  DATABASE)!
    let searchController = UISearchController(searchResultsController: nil)
    var delegate : LibraryTableViewControllerDelegate?
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
        self.searchController.searchBar.delegate = self
        self.tableView.tableHeaderView = searchController.searchBar
        
        // Fetch request por BookTag
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchBatchSize = 50
        fr.sortDescriptors = [(NSSortDescriptor(key: "tag.proxyForSorting",ascending: true)),
                              (NSSortDescriptor(key: "book.title",ascending: true))]
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: (sameOne.context), sectionNameKeyPath: "tag.tagName", cacheName: nil)
        self.fetchedResultsController? = fc as! NSFetchedResultsController<NSFetchRequestResult>
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Celda personalizada
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellID, for: indexPath) as! BookTableViewCell

        let booktag = self.fetchedResultsController?.object(at: indexPath) as! BookTag
        let item = booktag.book
        
        // Sincronizar book -> celda
        cell.titleView.text = item?.title
        cell.authorsView.text = item?.listOfAuthors()
        cell.tagsView.text = item?.listOfTags()
        
        UIView.transition(with: cell.coverView,
                          duration: 0.7,
                          options: [.curveEaseOut],
                          animations: { cell.coverView.image = self.getCover(ofBook: item!)},
                          completion: nil)

        // Mostrar condición de favorito en las listas
        if (item?.isFavorite == true){
            cell.isFavorite.setTitle("🌟", for: .normal)
        }
        else{
            cell.isFavorite.setTitle("", for: .normal)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookTag = fetchedResultsController?.object(at: indexPath) as! BookTag
        let book = bookTag.book!
        let bookVC = BookViewController(model: book)
        saveBookInDefaults(withModel: book)
        
        if (IS_IPHONE) {
            navigationController?.pushViewController(bookVC, animated: true)
        }
        else{
            delegate?.libraryTableViewController(vc: self, didSelectBook: book)
        }
        
        // Avisar al delegado
        delegate?.libraryTableViewController(vc: self, didSelectBook: book)
        
        // Enviamos la misma info via notificaciones
        self.notifySelectedBookDidChange(withBookSelected: book)
        
    }
    
    func libraryTableViewController(viewController: LibraryTableViewController, didSelectBook book: Book) {
        
        let bookVC = BookViewController(model: book)
        navigationController?.pushViewController(bookVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Alta en notificaciones de cambios en los modelos
        self.suscribeNotificationsFavoritesDidChange()
        // Sincronizar vista y modelo
        self.tableView.reloadData()
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
    
}
    //MARK: - Utils
    extension LibraryTableViewController {
        func getCover(ofBook item:Book)->UIImage{
            
            let mainBundle = Bundle.main
            let defaultImageUrl = mainBundle.url(forResource: "PlaceholderBook", withExtension: "png")!
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
        
    //MARK: - Notificaciones
        
    func notifySelectedBookDidChange(withBookSelected: Book){
        let nc = NotificationCenter.default
        let notif = NSNotification(name: NSNotification.Name(rawValue: BOOK_DID_CHANGE_NOTIFICATION),
                                       object: self,
                                       userInfo: [BOOK_KEY:withBookSelected])
        nc.post(notif as Notification)
    }
        
    func suscribeNotificationsFavoritesDidChange(){
        // Alta en notificación
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(favoriteDidChange),
                        name: NSNotification.Name(rawValue:FAVORITES_DID_CHANGE_NOTIFICATION),
                        object: nil)
    }
        
    func favoriteDidChange(notification: NSNotification){
        self.tableView.reloadData()
    }
        
}

extension LibraryTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController){
        
        // Hay que cambiar el fetch request
        let search = searchController.searchBar.text
        
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchBatchSize = 50
        fr.sortDescriptors = [NSSortDescriptor(key: "tag.proxyForSorting",ascending: true),
                              NSSortDescriptor(key: "book.title",ascending: true)]
        if (search! != ""){
            let bookPredicate = NSPredicate(format: "book.title CONTAINS [cd] %@",search!)
            let tagPredicate = NSPredicate(format: "tag.tagName CONTAINS [cd] %@",search!)
            let tagAuthor = NSPredicate(format: "book.authors.name CONTAINS [cd] %@",search!)
            
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [bookPredicate,tagPredicate,tagAuthor])
            
            fr.predicate = predicate
        }
        
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: (sameOne.context), sectionNameKeyPath: "tag.tagName", cacheName: nil)
        self.fetchedResultsController? = fc as!
            NSFetchedResultsController<NSFetchRequestResult>
        self.tableView.reloadData()
        
    }
}

extension LibraryTableViewController: UISearchBarDelegate {
    private func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
}

//MARK: - Delegate
protocol LibraryTableViewControllerDelegate {
    
    func libraryTableViewController(vc : LibraryTableViewController, didSelectBook book: Book)
}


