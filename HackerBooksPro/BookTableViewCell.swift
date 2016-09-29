//
//  BookTableViewCell.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 15/7/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    //MARK: - Static vars
    static let cellID = "BookTableViewCellId"
    static let cellHeight : CGFloat = 66.0

    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var authorsView: UILabel!
    @IBOutlet weak var tagsView: UILabel!
    
    @IBOutlet weak var isFavorite: UIButton!
    
    var coverImage : UIImage? {
        didSet {
            self.coverView.image = coverImage
        }
    }
    
    //MARK: - Utils
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.coverView.layer.masksToBounds = true
        self.coverView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
