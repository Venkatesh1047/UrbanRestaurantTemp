//
//  HomeViewController.swift
//  DriverReadyToEat
//
//  Created by casperonios on 10/11/17.
//  Copyright © 2017 CasperonTechnologies. All rights reserved.
//

import UIKit
import JSSAlertView

class HomeViewController: UIViewController,SlideToOpenDelegate{
    
    //After Designed Changed Outlets
    @IBOutlet weak var lastPaidEarningsLbl: UILabel!
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bookTblCollectionView: UICollectionView!
    @IBOutlet weak var earningsViewInView: UIView!
    @IBOutlet weak var onlineSwitch: UISwitch!
    @IBOutlet weak var slidetoOpenView: UIView!
    
    var mainTheme:Themes = Themes()
    var isInitialUpdate = true
    var daysArr:[String]!
    var datesArr:[String]!
    
    @IBOutlet weak var tblBookingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var earningViewHightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        daysArr = ["Today","Friday","Saturday","Sunday","Monday"]
        datesArr = ["29-11-2018","30-11-2018","01-12-2018","02-12-2018","03-12-2018"]
        
        collectionView.register(UINib(nibName: "EarningsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EarningsCollectionViewCell")
        collectionView.register(UINib(nibName: "EarningsSeeAllACollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EarningsSeeAllACollectionViewCell")
        
        bookTblCollectionView.register(UINib(nibName: "DateCell", bundle: nil), forCellWithReuseIdentifier: "DateCell")
        bookTblCollectionView.register(UINib(nibName: "DateSeeAll", bundle: nil), forCellWithReuseIdentifier: "DateSeeAll")

        updateUI()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let _ = GlobalClass.restModel {
            self.updateMenuUI()
            
        }else{
            getRestarentProfile()
        }
    }
    
    func SlideToOpenDelegateDidFinish(switchStatus: Bool) {
        if switchStatus {
            print("on---->>>")
        }else{
            print("off---->>>")
        }
    }
    //MARK:- Update UI
    func updateUI(){
        
        let slide = SlideToOpenView(frame: CGRect(x: 0, y: 0, width: self.slidetoOpenView.frame.size.width, height: self.slidetoOpenView.frame.size.height))
        slide.sliderViewTopDistance = 0
        slide.sliderCornerRadious = self.slidetoOpenView.frame.size.height/2.0
        slide.defaultLabelText = "Swipe right to come Online"
        slide.thumnailImageView.image = #imageLiteral(resourceName: "Slider_holder")
        slide.thumnailImageView.backgroundColor = .clear
        slide.draggedView.backgroundColor = .greenColor
        slide.draggedView.alpha = 0.8
        slide.delegate = self
        self.slidetoOpenView.addSubview(slide)
        self.slidetoOpenView.layer.cornerRadius = self.slidetoOpenView.frame.size.height/2.0
       // self.slidetoOpenView.backgroundColor = .clear

        onlineSwitch.layer.cornerRadius = 16
        TheGlobalPoolManager.cornerAndBorder(self.earningsViewInView, cornerRadius: 8, borderWidth: 0.5, borderColor: .lightGray)
        TheGlobalPoolManager.cornerRadiusForParticularCornerr(self.earningsViewInView, corners: [.bottomRight,.topRight], size: CGSize(width: 8, height: 0))
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 100, height: self.collectionView.frame.height)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        collectionView!.collectionViewLayout = layout
        collectionView.tag = 111
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layoutBookTbl: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutBookTbl.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutBookTbl.itemSize = CGSize(width: 100, height: 55)
        layoutBookTbl.minimumInteritemSpacing = 5
        layoutBookTbl.minimumLineSpacing = 5
        layoutBookTbl.scrollDirection = .horizontal
        bookTblCollectionView!.collectionViewLayout = layoutBookTbl

        bookTblCollectionView.tag = 222
        bookTblCollectionView.delegate = self
        bookTblCollectionView.dataSource = self
    }
 

    //MARK:- IB Action Outlets
    @IBAction func supportBtn(_ sender: UIButton) {
        
    }
    
    func getRestarentProfile(){
        Themes.sharedInstance.activityView(View: self.view)
        let restarentInfo = UserDefaults.standard.object(forKey: "restaurantInfo") as! NSDictionary
        let data = restarentInfo.object(forKey: "data") as! NSDictionary
        
        let param = [
            "id": data.object(forKey: "subId"),
            ]
        
        print("getProfileURl ----->>> ", Constants.urls.getProfileURl)
        print("param  ----->>> ", param)
        
        URLhandler.postUrlSession(urlString: Constants.urls.getProfileURl, params: param as [String : AnyObject], header: [:]) { (dataResponse) in
            print("Profile response ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                GlobalClass.restModel = RestaurantModel(fromJson: dataResponse.json)
                // print("rest name ----->>>",GlobalClass.restModel.data.userName)
                self.updateMenuUI()
            }
        }
    }
    
    func updateMenuUI(){
        let restarent = GlobalClass.restModel!
        
        if isInitialUpdate {
            if restarent.data.available == 0 {
                self.onlineSwitch.isOn = false
                self.earningViewHightConstraint.constant = 299
                self.tblBookingViewHeightConstraint.constant = 150
            }else{
                self.onlineSwitch.isOn = true
                self.earningViewHightConstraint.constant = 0
                self.tblBookingViewHeightConstraint.constant = 0
            }
            
            changeRestarentStatusWebHit(status: restarent.data.available)
            isInitialUpdate = false
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func onlineOfflineSwitchValueChanged(sender: UISwitch) {
        var titleText : String = "Are you sure you want to Go"
        if sender.isOn {
            titleText = titleText + " Online?"
        }else{
            titleText = titleText + " Offline?"
        }
        
        let alertView = JSSAlertView().showAlert(self,title: titleText ,text:nil,buttonText: "CANCEL" ,cancelButtonText:"CONFIRM",color:.themeColor)
        
        alertView.addAction{
            if self.onlineSwitch.isOn == true {
                self.onlineSwitch.isOn = false
            }else{
                self.onlineSwitch.isOn = true
            }
            print("cancel --->>>")
        }
        alertView.addCancelAction({
            print("confirm --->>>")
            if !self.onlineSwitch.isOn == true {
                self.onlineSwitch.isOn = false
                self.changeRestarentStatusWebHit(status: 0)
                UIView.performWithoutAnimation {
                    self.earningViewHightConstraint.constant = 299
                    self.tblBookingViewHeightConstraint.constant = 150
                }
            }else{
                self.onlineSwitch.isOn = true
                self.changeRestarentStatusWebHit(status: 1)
                UIView.performWithoutAnimation {
                    self.earningViewHightConstraint.constant = 0
                    self.tblBookingViewHeightConstraint.constant = 0
                }
            }
        })
    }
    
    func changeRestarentStatusWebHit(status:Int){
        let param =     [
            "id": "5beeb77309c2a91c6b4814fb",
            "available": status] as  [String:AnyObject]
        
        URLhandler.postUrlSession(urlString: Constants.urls.businessHourUrl, params: param, header: [:]) { (dataResponse) in
            print("Response ----->>> ", dataResponse.json)
            Themes.sharedInstance.removeActivityView(View: self.view)
            if dataResponse.json.exists(){
                let dict = dataResponse.dictionaryFromJson! as NSDictionary
                Themes.sharedInstance.showToastView(dict.object(forKey: "message") as! String)
                // self.getRestarentProfile()
            }
        }
        
    }
}
extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension HomeViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  collectionView.tag == 111 {
            return 8
        }
        return daysArr.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //
        if collectionView.tag == 111 {
            if indexPath.row == 7{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EarningsSeeAllACollectionViewCell", for: indexPath as IndexPath) as! EarningsSeeAllACollectionViewCell
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EarningsCollectionViewCell", for: indexPath as IndexPath) as! EarningsCollectionViewCell
            if indexPath.row % 2 == 0 {
                cell.paidStatusLbl.backgroundColor = .greenColor
            }
            return cell
        }else {
            if indexPath.row == daysArr.count{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateSeeAll", for: indexPath) as! DateSeeAll
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
            cell.daylbl.text = daysArr[indexPath.row]
            cell.dateLbl.text = datesArr[indexPath.row]
            
            return cell
        }

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
    }
}


//@IBAction func earningsBtnClicked(_ sender: Any) {
//    let earningsVC = self.storyboard?.instantiateViewController(withIdentifier: "YourEarningsViewControllerID") as! YourEarningsViewController
//    self.navigationController?.pushViewController(earningsVC, animated: true)
//}
//@IBAction func supportBtnClicked(_ sender: Any) {
//    let helpVC = self.storyboard?.instantiateViewController(withIdentifier: "HelpSupportViewControllerID") as! HelpSupportViewController
//    self.navigationController?.pushViewController(helpVC, animated: true)
//}
