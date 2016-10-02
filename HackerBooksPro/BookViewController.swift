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
    
    let defaults = UserDefaults.standard
    let stack = CoreDataStack(modelName: DATABASE, inMemory: false)
    
    var model : Book{
        didSet {
            self.syncModelWithView()
            saveIdObjectInDefaults(withModel: model)
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
        self.photoView.image = model.cover?.image
        
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
        
//        // Crear un ReadVC
//        let readVC = SimplePDFViewController(model: model)
//        
//        // Hacer un push sobre NavigationController
//        navigationController?.pushViewController(readVC, animated: true)
    }
    
    
    @IBAction func markAsFavorite(_ sender: AnyObject) {
        
        // Provoca notificacion de cambio favorito/no favorito
        self.model.markUnmarkAsFavorite()

        // Refresca los datos
         syncModelWithView()
        
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

}

extension BookViewController: LibraryTableViewControllerDelegate{
    
    func libraryTableViewController(vc:LibraryTableViewController, didSelectBook book: Book) {
        
        
        // Actualizar el modelo
        model = book
        
        // Sincronizar las vistas con el nuevo modelo
        syncModelWithView()
        
    }
}



