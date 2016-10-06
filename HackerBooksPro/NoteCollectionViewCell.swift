//
//  NoteCollectionViewCell.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 6/10/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Static vars
    static let cellID = "NoteCollectionViewCellId"
    static let cellHeight : CGFloat = 150.0
    static let cellWidth  : CGFloat = 200.0
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.darkGray
        self.textView.backgroundColor = UIColor.darkGray
        self.date.backgroundColor = UIColor.darkGray
    }
    
    class func cellSize() -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }

}
