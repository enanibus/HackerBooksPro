//
//  NotesCollectionViewController.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 5/10/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import UIKit

class NotesCollectionViewController: CoreDataCollectionViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notas"
        registerNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Cell registration
    func registerNib(){
        let nib = UINib(nibName: "NoteCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: NoteCollectionViewCell.cellID)
    }
    
    
    //MARK: - Data source
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Obtener nota
        let note = self.fetchedResultsController?.object(at: indexPath) as! Annotation
        
        // Celda personalizada
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.cellID, for: indexPath) as! NoteCollectionViewCell
        
        // Configurar la celda
        cell.layer.cornerRadius = 8
        cell.textView.text = note.title
        cell.textView.isUserInteractionEnabled = false
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        cell.date.text = fmt.string(from: note.modificationDate as! Date)

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nota = self.fetchedResultsController?.object(at: indexPath) as! Annotation
        let notaVc = NotesViewController(model: nota)
        self.navigationController?.pushViewController(notaVc, animated: true)
        
    }

}
