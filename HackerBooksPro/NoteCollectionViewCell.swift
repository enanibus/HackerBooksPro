//
//  NoteCollectionViewCell.swift
//  HackerBooksPro
//
//  Created by Jacobo Enriquez Gabeiras on 6/10/16.
//  Copyright © 2016 enanibus. All rights reserved.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.darkGray
//        self. .backgroundColor = UIColor.darkGray
//        self. .backgroundColor = UIColor.darkGray
    }
    
    class func cellId() -> String{
        return "NoteCollectionCell"
    }
    
    class func cellSize() -> CGSize {
        return CGSize(width: 150, height: 100)
    }

}
