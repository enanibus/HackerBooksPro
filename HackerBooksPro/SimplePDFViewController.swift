//
//  SimplePDFViewController.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 30/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class SimplePDFViewController: UIViewController {
    
    //MARK: Properties
    var model : Book

    @IBAction func viewNotes(_ sender: AnyObject) {
    }
    
    @IBAction func addNote(_ sender: AnyObject) {
    }
    
    @IBOutlet weak var pdfViewer: UIWebView!
    
    init(model: Book){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Alta en notificación
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(bookDidChange),
                       name: NSNotification.Name(rawValue: BOOK_DID_CHANGE_NOTIFICATION), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Baja en las notificaciones
        let nc = NotificationCenter.default
        nc.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        syncModelWithView()
    }
    
    
    //MARK: Utils
    func bookDidChange(notification: NSNotification){
        
        // Sacar el userInfo
        let info = notification.userInfo!
        
        // Sacar el libro
        let book = info[BOOK_KEY] as? Book
        
        // Actualizar el modelo
        model = book!
        
        // Sincronizar las vistas
        syncModelWithView()
        
    }
    
    func syncModelWithView(){

        self.pdfViewer.load(self.downloadPdf(ofBook: model) as Data,
                          mimeType: "application/pdf",
                          textEncodingName: "utf8",
                          baseURL: URL(string: "www.google.es")!)
    }

}

extension SimplePDFViewController {
    func downloadPdf(ofBook book:Book)->NSData{
        if (book.pdf?.pdfData == nil){
            let mainBundle = Bundle.main
            let defaultPdf = mainBundle.url(forResource: "emptyPdf", withExtension: "pdf")!
            
            let theDefaultData = try! Data(contentsOf: defaultPdf)
            
            DispatchQueue.global(qos: .default).async {
                let theUrlImage = URL(string: book.pdfURL!)
                let pdfData = try? Data(contentsOf: theUrlImage!)
                DispatchQueue.main.async {
                    if (pdfData==nil){
                        book.pdf?.pdfData = nil
                    }
                    else{
                        let thePdf = Pdf(withData: pdfData!,
                                         inContext: book.managedObjectContext!)
                        book.pdf = thePdf
                        try! book.managedObjectContext?.save()
                        
                    }
                }
            }
            return theDefaultData as NSData
        }
        else{
            return (book.pdf?.pdfData)!
        }
    }
    
    
}



