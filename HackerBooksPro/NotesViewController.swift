//
//  NotesViewController.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 5/10/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import UIKit
import CoreLocation

class NotesViewController: UIViewController {
    @IBAction func shareNote(_ sender: AnyObject) {
        // Hay que compartir la nota por email
        let objectsToShare: [AnyObject] = [model.title as AnyObject,model.text as AnyObject,(model.photo?.image)!]
        let uiAct = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        uiAct.popoverPresentationController?.sourceView = self.view
        
        self.present(uiAct, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var gpsStatus: UIImageView!
    let locationManager = CLLocationManager()
    
    @IBAction func guardarPosicionGps(_ sender: AnyObject) {
        
        
//        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    @IBOutlet weak var noteImageView: UIImageView!
    
    @IBAction func takePhoto(_ sender: AnyObject) {

        let picker = UIImagePickerController()
        
        if UIImagePickerController.isCameraDeviceAvailable(.rear){
            picker.sourceType = .camera
        } else{
            picker.sourceType = .photoLibrary
        }
        
        picker.delegate = self
        self.present(picker, animated: true){

        }

    }
    //MARK: - Init
    var model: Annotation
    
    @IBOutlet weak var titleNote: UITextField!
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var titleView: UITextField!
    
    init(model: Annotation){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Utils
    func syncModelWithView(){
        self.titleView.text = model.book?.title
        self.titleNote.text = model.title
        self.noteTextView.text = model.text
        if (model.photo?.image != nil){
            let w = self.noteImageView.bounds.width
            let imgResize = model.photo?.image!.resizeWith(width: w)
            self.noteImageView.image = imgResize
            
        }
        
//        if (_model.localization != nil){
//            self.gpsStatus.image = UIImage(named: "posicion_gps.png")
//        }
    }
    
    func syncViewWithModel(){
        model.title = self.titleNote.text
        model.text = self.noteTextView.text

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncModelWithView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nota"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.model.managedObjectContext?.processPendingChanges()
        syncViewWithModel()
    }
    
}


//MARK: - Image Picker
extension NotesViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true){}
        let auxFoto = info[UIImagePickerControllerOriginalImage] as!  UIImage?
        if (auxFoto != nil){
            let laFoto = Photo(image: auxFoto!, inContext: model.managedObjectContext!)
            model.photo = laFoto
            syncViewWithModel()
        }
    }
}

//MARK: - LocationManager
//extension NotesViewController: CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        // Se para, que no consume
//        locationManager.stopUpdatingLocation()
//        // Pillamos la ultima posicion
//        let posicion = locations.last
//        
//        // Lo metemos en CoreData
//        var savePosition = Localization.exists(position: posicion!, inContext: _model.managedObjectContext)
//        if (savePosition == nil){
//            // No existe creamos 
//            savePosition = Localization(withPosition: posicion!, inContext: _model.managedObjectContext!)
//        }
//        // Asignamos a la nota
//        savePosition?.addToAnnotation(_model)
//        syncModelWithView()
//        
//    }
//}
