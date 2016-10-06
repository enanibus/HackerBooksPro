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
    
    let sameOne = CoreDataStack.defaultStack(modelName: DATABASE)!
    
    @IBAction func shareNote(_ sender: AnyObject) {
        
        // Ojo, tiene que haber foto asignada para compartir
        if (model.photo?.image != nil) {
            let objectsToShare: [AnyObject] = [model.title as AnyObject,model.text as AnyObject,(model.photo?.image)!]
            let uiAct = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
            uiAct.popoverPresentationController?.sourceView = self.view
        
            self.present(uiAct, animated: true, completion: nil)
        }
        
        else {
            let alert = UIAlertController(title: "Compartir nota", message: "Haz una foto o escoge una de la galería de fotos para compartir", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func deleteNote(_ sender: AnyObject) {
        let nota = self.model
        nota.setupKVO()
        sameOne.context.delete(nota)
        _ = navigationController?.popViewController(animated: true)
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

