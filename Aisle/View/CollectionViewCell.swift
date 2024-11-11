//
//  CollectionViewCell.swift
//  Aisle
//
//  Created by Chandra Kiran Reddy Yeduguri on 10/11/24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var detailsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailsView.layer.cornerRadius = 10
        detailsView.layer.maskedCorners  = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

}
