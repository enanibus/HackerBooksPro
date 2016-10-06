//
//  NoteViewController.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 6/10/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func takePhoto(_ sender: AnyObject) {
    }
    
    
    @IBAction func share(_ sender: AnyObject) {
    }
    
    
    @IBAction func trash(_ sender: AnyObject) {
    }
    
    
    //MARK: - Init
    var model: Annotation
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var titleView: UITextField!
    
    init(model: Annotation){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    func syncModelWithView(){
        titleView?.text = model.title
        noteTextView?.text = model.text
        if (model.photo?.image != nil){
            let w = imageView.bounds.width
            let imgResize = model.photo?.image!.resizeWith(width: w)
            imageView?.image = imgResize
        }
        
    }
    
    func syncViewWithModel(){
        model.title = titleView?.text
        model.text = noteTextView?.text
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isTranslucent=false
        self.title = "Nota"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncModelWithView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.model.managedObjectContext?.processPendingChanges()
        syncViewWithModel()
    }
    
    
    
}
