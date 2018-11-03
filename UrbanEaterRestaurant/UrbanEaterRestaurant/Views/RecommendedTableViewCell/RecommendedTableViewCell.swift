//
//  RecommendedTableViewCell.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 26/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class RecommendedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemImgView: UIImageView!
    
    @IBOutlet weak var itemDeleteBtn: UIButton!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        containerView.layer.cornerRadius = 3.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
