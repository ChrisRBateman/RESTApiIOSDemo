//
//  ProductViewCell.swift
//  BestBuyDemo
//
//  Created by Chris Bateman on 2015-10-19.
//  Copyright © 2015 Chris Bateman. All rights reserved.
//

import UIKit

class ProductViewCell: UITableViewCell {

    @IBOutlet weak var placeHolderImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
