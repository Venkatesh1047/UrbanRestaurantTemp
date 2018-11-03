//
//  EditProfileViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 27/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var profilePicImgView: UIImageView!
    @IBOutlet weak var offerBtn: UIButton!
    @IBOutlet weak var offerTypeBtn: UIButton!
    @IBOutlet weak var offersViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollviewHeightConstraint: NSLayoutConstraint!
    var isOffersExpanded = false
    override func viewDidLoad() {
        super.viewDidLoad()

        offerTypeBtn.layer.cornerRadius = 5.0
        offerTypeBtn.layer.borderWidth = 1.0
        offerTypeBtn.layer.borderColor = #colorLiteral(red: 0.8723144531, green: 0.8723144531, blue: 0.8723144531, alpha: 1)
        
        offerBtn.layer.cornerRadius = 3.0
        offerBtn.layer.borderWidth = 1.0
        offerBtn.layer.borderColor = #colorLiteral(red: 0.7879231572, green: 0.7879231572, blue: 0.7879231572, alpha: 1)
        
        profilePicImgView.layer.borderWidth = 3
        profilePicImgView.layer.borderColor = #colorLiteral(red: 0.7879231572, green: 0.7879231572, blue: 0.7879231572, alpha: 1)
        // 990 - 310
    }
    
    @IBAction func profilePicButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func offersButtonClicked(_ sender: Any) {
        if isOffersExpanded {
            isOffersExpanded = false
            offersViewHeightConstraint.constant = 0
            scrollviewHeightConstraint.constant = 690
        }else{
            isOffersExpanded = true
            offersViewHeightConstraint.constant = 310
            scrollviewHeightConstraint.constant = 990
            
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.goNext(timer:)), userInfo: nil, repeats: false)
        }
    }
    
    @objc func goNext(timer:Timer){
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
