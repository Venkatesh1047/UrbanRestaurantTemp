//
//  TableCurrentBookingCell.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class TableCurrentBookingCell: UITableViewCell {

    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var noofPersonLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var orderID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rejectBtn.layer.cornerRadius = 8.0
        confirmBtn.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
