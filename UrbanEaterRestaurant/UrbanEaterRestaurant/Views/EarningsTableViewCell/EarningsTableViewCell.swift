//
//  EarningsTableViewCell.swift
//  DriverReadyToEat
//
//  Created by Nagaraju on 16/10/18.
//  Copyright © 2018 CasperonTechnologies. All rights reserved.
//

import UIKit

class EarningsTableViewCell: UITableViewCell {

    @IBOutlet var orderID_Lbl: UILabel!
    @IBOutlet var amount_Lbl: UILabel!
    @IBOutlet var restaurantname_Lbl: UILabel!
    @IBOutlet var orederStatus_Lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
