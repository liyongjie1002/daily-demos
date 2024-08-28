//
//  LAWishWellCell.swift
//  SwiftDemo1
//
//  Created by xdf on 2024/8/27.
//

import UIKit

class LAWishWellCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    var title = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
