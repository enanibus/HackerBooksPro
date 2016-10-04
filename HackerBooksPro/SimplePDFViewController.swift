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

    @IBOutlet weak var pdfViewer: UIWebView!
    
//    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    init(model: Book){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        pdfViewer.delegate = self
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
    
//        activityView.startAnimating()
//        activityView.isHidden = false
        self.pdfViewer.load(self.downloadPdf(ofBook: model) as Data,
                          mimeType: "application/pdf",
                          textEncodingName: "utf8",
                          baseURL: URL(string: "www.google.es")!)
    }


//    //MARK: - UIWebViewDelegate
//    func webViewDidFinishLoad(webView: UIWebView) {
//        
//        // Parar el activity view
//        activityView.stopAnimating()
//        
//        // Ocultarlo
//        activityView.isHidden = true
//        
//    }
//    
//    
//    //MARK: - UIWebView & rendering of pdf 
//    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest,
//                 navigationType: UIWebViewNavigationType) -> Bool {
//        
//        if navigationType == .linkClicked || navigationType == .formSubmitted{
//            return false
//        }else{
//            return true
//        }
//    }
    
//    func renderContentOfPDF(){
//        let  download = dispatch_get_global_queue(DispatchQueue.GlobalQueuePriority.default,0)
//        let bloque : dispatch_block_t = {
//            guard let pdf = self.model.pdf else{
//                self.pdfViewer.loadHTMLString("NO PDF AVAILABLE FOR BOOK!, SORRY FOR THE INCONVENIENCE", baseURL: NSURL())
//                return
//            }
//            self.pdfViewer.loadData(pdf,
//                                    MIMEType: "application/pdf",
//                                    textEncodingName: "UTF-8",
//                                    baseURL: NSURL())
//        }
//        dispatch_async(download, bloque)
//    }
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
                        // Create the pdfEntity
                        let thePdf = Pdf(withData: pdfData!,
                                         inContext: book.managedObjectContext!)
                        // Create the link
                        book.pdf = thePdf
                        try! book.managedObjectContext?.save()
                        
                    }
                }
            }
            // Hay que mandar que descargue en segundo plano
            return theDefaultData as NSData
        }
        else{
            return (book.pdf?.pdfData)!
        }
    }
    
    
}



