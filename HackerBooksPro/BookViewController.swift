//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 30/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var authorsView: UILabel!
    
    @IBOutlet weak var tagsView: UILabel!
    
    @IBOutlet weak var favorites: UIBarButtonItem!
    
    var model : Book{
        didSet {
            self.syncModelWithView()
            saveBookInDefaults(withModel: model)
        }
    }


    //MARK: - Initialization
    init(model: Book){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    func syncModelWithView(){
        
        // Photo
        self.photoView.image = getCover(ofBook: model)
        
        // Title
        self.title = model.title
        
        // Authors
        self.authorsView.text = model.listOfAuthors()
        
        // Tags
        self.tagsView.text = model.listOfTags()
        
        if (self.model.isFavorite  == true) {
            self.favorites.title = "🌟"
        }else{
            self.favorites.title = "⭐️"
        }
        
    }

    @IBAction func readPDF(_ sender: AnyObject) {
        
        // Guardar en Defaults
        saveBookInDefaults(withModel: model)
        
        // Crear un ReadVC
        let readVC = SimplePDFViewController(model: model)
        
        // Hacer un push sobre NavigationController
        navigationController?.pushViewController(readVC, animated: true)
    }
    
    
    @IBAction func markAsFavorite(_ sender: AnyObject) {
        
        // Provoca notificacion de cambio favorito/no favorito
        self.model.markUnmarkAsFavorite()

        // Refresca los datos
         syncModelWithView()
        
        // Notifica al modelo del cambio
        self.notifySuscriptorsBookTagDidChange(withBookSelected: model)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Antes de que la vista tenga sus dimensiones
        // Una sola vez
        self.edgesForExtendedLayout = []
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Sincronizar vista y modelo
        syncModelWithView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func notifySuscriptorsBookTagDidChange(withBookSelected: Book){
        let nc = NotificationCenter.default
        let notif = NSNotification(name: NSNotification.Name(rawValue: FAVORITES_DID_CHANGE_NOTIFICATION),
                                   object: model,
                                   userInfo: [BOOK_KEY:withBookSelected])
        nc.post(notif as Notification)
    }

}

extension BookViewController: LibraryTableViewControllerDelegate{
    
    func libraryTableViewController(vc:LibraryTableViewController, didSelectBook book: Book) {
        
        
        // Actualizar el modelo
        model = book
        
        // Sincronizar las vistas con el nuevo modelo
        syncModelWithView()
        
    }
}

extension BookViewController {
    func getCover(ofBook book:Book)->UIImage{
        if (book.cover?.photoData==nil){
            let mainBundle = Bundle.main
            let defaultImage = mainBundle.url(forResource: "PlaceholderBook", withExtension: "png")!
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
                        
                        
//                        try! book.managedObjectContext?.save()
                        self.photoView.image = book.cover?.image
                        
                    }
                }
            }
            return UIImage(data: theDefaultData)!
        }
        else{
            let w = self.photoView.bounds.width
            let imgResize = book.cover?.image?.resizeWith(width: w)
            return imgResize!
//            return (book.cover?.image!)!
        }
    }
    
    
}



