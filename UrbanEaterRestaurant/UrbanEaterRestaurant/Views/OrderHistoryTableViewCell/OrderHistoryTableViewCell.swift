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
     @IBOutlet weak var itemsCollectionView: UICollectionView!
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        
        orderStatusLbl.layer.cornerRadius = 3.0
        orderStatusLbl.layer.masksToBounds = true
        
        self.itemsCollectionView.register(UINib.init(nibName: "ItemsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemsCollectionViewCell")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.itemsCollectionView.frame.width, height: 20)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        itemsCollectionView!.collectionViewLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
