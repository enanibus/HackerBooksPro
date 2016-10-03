//
//  AppDelegate.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 6/9/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let model = CoreDataStack(modelName: DATABASE, inMemory: false)!
    let defaults = UserDefaults.standard


    func rootViewControllerForPhone(withModel model: CoreDataStack) -> UIViewController{
        
        
        let fr = NSFetchRequest<Book>(entityName: Book.entityName)
        fr.fetchBatchSize = 50
        fr.sortDescriptors = [NSSortDescriptor(key: "title",ascending: true)]
        
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: model.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Create LibraryTableViewController
        let libVC = LibraryTableViewController(fetchedResultsController: fc as! NSFetchedResultsController<NSFetchRequestResult>, style: .plain)
        
        // Crear un Library VC de Favoritos
//        let libVC = LibraryTableViewController(withModel: self.model, style: .plain)
        
        // Se mete Library VC en un Library Nav
        let libNav = UINavigationController(rootViewController: libVC)
        
        // Asignar delegados
        libVC.delegate = libVC
        
        return libNav
        
    }
    
    func rootViewControllerForPad(withModel model: CoreDataStack) -> UIViewController {
        
        let fr = NSFetchRequest<Book>(entityName: Book.entityName)
        fr.fetchBatchSize = 50
        fr.sortDescriptors = [NSSortDescriptor(key: "title",ascending: true)]
        
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: model.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Create LibraryTableViewController
        let libVC = LibraryTableViewController(fetchedResultsController: fc as! NSFetchedResultsController<NSFetchRequestResult>, style: .plain)
        
        // Crear un Library VC de Favoritos
//        let libVC = LibraryTableViewController(withModel: self.model, style: .plain)
        
        // Se mete Library VC en un Library Nav
        let libNav = UINavigationController(rootViewController: libVC)
        
        // Crear un Book VC
        let book = Book(title: "Book", imgURL: "", pdfURL: "", inContext: model.context)
        let bookVC = BookViewController(model: book)
        
        // Se mete BookVC en un Book Nav
        let bookNav = UINavigationController(rootViewController: bookVC)
        
        // Crear el Split View Controller
        let splitVC = UISplitViewController()
        splitVC.viewControllers = [libNav, bookNav]
        
        //poner el split como VC
        window?.rootViewController = splitVC
        
        // Asignar delegados
        libVC.delegate = bookVC
        
        return splitVC
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        
        // Clean up all local caches
//        AsyncData.removeAllLocalFiles()
        
        // Create the window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Borrar el modelo
        try! model.dropAllData()
        
        // Descarga JSON
        // Pendiente realizar en background con GCD
        do{
            try downloadRemoteJSON()
        }catch{
            fatalError("Data couldn't be load")
        }
        
        // Carga del modelo Core Data
        // Pendiente realizar en background con GCD
        // y de hacerlo en una función auxiliar
//    if () {
        do{
            let jsonArray = try loadFromDocuments()
            
            for oneDict in jsonArray{
                do{
                    let bookValues =  try decodeForCoreData(book: oneDict)
                    let title = bookValues.4
                    let authors = bookValues.0
                    let imageURL = bookValues.1
                    let pdfURL = bookValues.2
                    let tags = bookValues.3
                    
                    // Add book to core data
                    let oneBook = Book(title: title, imgURL: imageURL.absoluteString, pdfURL: pdfURL.absoluteString, inContext: model.context)
                    // Add tags to core data
                    for sTag in tags{
                        var theTag : Tag?
                        
                        theTag = Tag.tagForString(sTag, inContext: model.context)
                        if (theTag == nil){
                            theTag = Tag(tag: sTag, inContext: model.context)
                        }
                        // Add the relation between tags and books
                        _ = BookTag(theBook: oneBook, theTag: theTag!, inContext: model.context)
                    }
                    for sAuthor in authors{
                        var theAuthor : Author?
                        
                        theAuthor = Author.authorForString(sAuthor, inContext: model.context)
                        
                        if (theAuthor == nil){
                            theAuthor = Author(author: sAuthor, inContext: model.context)
                        }
                        // Add the relation between author and book
                        theAuthor?.addToBooks(oneBook)
                        // Save to defaults
                        saveIdObjectInDefaults(withModel: oneBook)
                    }
                }catch{
                    fatalError("Error while loading model")
                }
            }
        }catch{
            fatalError("Error while loading JSON")
        }
        model.save()
//    }
        // Fetch request

//        let fr = NSFetchRequest<Book>(entityName: Book.entityName)
//        fr.fetchBatchSize = 50
//        fr.sortDescriptors = [NSSortDescriptor(key: "title",ascending: true)]
//        
//        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: model.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Create LibraryTableViewController
        
//        let nVC = LibraryTableViewController(fetchedResultsController: fc as! NSFetchedResultsController<NSFetchRequestResult>, style: .plain)
        
        // iPhone - iPad
//        if (IS_IPHONE) {
//            libNav = UINavigationController(rootViewController: nVC)
//        }
//        else {
//            libNav = UINavigationController(rootViewController: nVC)
//        }
        
        var rootVC = UIViewController()
        
        if (!(IS_IPHONE)) {
            // Tableta
            rootVC = self.rootViewControllerForPad(withModel: model)
        } else {
            rootVC = self.rootViewControllerForPhone(withModel: model)
        }
        
        self.window?.rootViewController = rootVC
        
        
        
        
        
        
        
        
        // Creamos el navegador
//        let navVC = UINavigationController(rootViewController: nVC)
 
        // La window
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = libNav
        window?.makeKeyAndVisible()

        model.autoSave(5)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

