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
    var _model: Annotation
    
//    var isFirstLoad : Bool = true
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var titleView: UITextField!
    
    init(model: Annotation){
        _model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    func syncModelWithView(){
        self.titleView?.text = _model.title
        self.noteTextView?.text = _model.text
//        if (_model.photo?.image != nil){
//            let w = self.imageView.bounds.width
//            let imgResize = _model.photo?.image!.resizeWith(width: w)
//            self.imageView.image = imgResize
//        }
        
    }
    
    func syncViewWithModel(){
        _model.title = self.titleView?.text
        _model.text = self.noteTextView?.text
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self._model.managedObjectContext?.processPendingChanges()
        syncViewWithModel()
    }
    
    
    
}
