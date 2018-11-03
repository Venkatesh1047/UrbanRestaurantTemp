//
//  OrderHistoryTableViewCell.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 23/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var orderIDLbl: UILabel!
    @IBOutlet weak var orderAmountLbl: UILabel!
    @IBOutlet weak var noOfItemsLbl: UILabel!
    @IBOutlet weak var orderStatusLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        orderStatusLbl.layer.cornerRadius = 3.0
        orderStatusLbl.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
