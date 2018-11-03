//
//  NewOrderTableViewCell.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class NewOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var orderAmountLbl: UILabel!
    @IBOutlet weak var noOfItemsLbl: UILabel!
    
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rejectBtn.layer.cornerRadius = 5.0
        acceptBtn.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
