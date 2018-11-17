//
//  BusinessHoursViewController.swift
//  DinedooRestaurant
//
//  Created by Nagaraju on 24/10/18.
//  Copyright © 2018 casperonIOS. All rights reserved.
//

import UIKit

class BusinessHoursViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var weekDaysView: UIView!
    @IBOutlet weak var weekEndsView: UIView!
    @IBOutlet weak var dateView1: UIView!
    @IBOutlet weak var dateView2: UIView!
    @IBOutlet weak var dateView3: UIView!
    @IBOutlet weak var dateView4: UIView!
    @IBOutlet weak var minutesBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var weekDayFromLbl: UILabel!
    @IBOutlet weak var weekDayToLbl: UILabel!
    @IBOutlet weak var weekEndFromLbl: UILabel!
    @IBOutlet weak var weekEndToLbl: UILabel!
    
    @IBOutlet weak var dateContainerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var minutesPicker: UIPickerView!
    @IBOutlet weak var minutesContainerView: UIView!
    
    var btnTag = 0
    var gradePickerValues = [String]()
    var dateSelectedString = ""
    var minutesSelectedString = ""
    let dateFormatter = DateFormatter()
    var commonUtlity:Utilities = Utilities()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 0 ..< 10
        for i in 0..<60 {
            gradePickerValues.append(String(i))
        }

        weekDaysView.layer.cornerRadius = 2.0
        weekEndsView.layer.cornerRadius = 2.0
        
        dateView1.customiseView()
        dateView2.customiseView()
        dateView3.customiseView()
        dateView4.customiseView()
        
        minutesBtn.layer.cornerRadius = 2.0
        minutesBtn.layer.borderWidth = 1
        minutesBtn.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        minutesBtn.clipsToBounds = true
        minutesBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        saveBtn.layer.cornerRadius = 5.0
        
        datePicker.datePickerMode = UIDatePickerMode.time
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        dateFormatter.dateFormat = "hh:mm a"
        
        minutesPicker.dataSource = self
        minutesPicker.delegate = self
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateSelectedString = dateFormatter.string(from: sender.date)
        //print("dateSelectedString ---->>> \(dateSelectedString)")
    }
    
    @IBAction func timeChangeBtnClicked(_ sender: UIButton) {
        btnTag = sender.tag
        dateContainerView.isHidden = false
        blurView.isHidden = false
    }
    
    @IBAction func datePickDoneClicked(_ sender: Any) {
        dateContainerView.isHidden = true
        blurView.isHidden = true
        let date = Date()
       // print("dateSelectedString ---->>> \(dateSelectedString)")
        if dateSelectedString.count == 0 {
            dateSelectedString =  dateFormatter.string(from: date)
        }
        
        dateSelectedString = commonUtlity.removeMeridiansfromTime(string: dateSelectedString)

        if btnTag == 1 {
            weekDayFromLbl.text = dateSelectedString
            weekDayFromLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else if btnTag == 2 {
            weekDayToLbl.text = dateSelectedString
            weekDayToLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else if btnTag == 3 {
            weekEndFromLbl.text = dateSelectedString
            weekEndFromLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else if btnTag == 4 {
            weekEndToLbl.text = dateSelectedString
            weekEndToLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        dateSelectedString = ""
    }
    
    @IBAction func datePickCancelClicked(_ sender: Any) {
        blurView.isHidden = true
        dateContainerView.isHidden = true
    }
    
    @IBAction func minutesBtnClicked(_ sender: Any) {
        minutesContainerView.isHidden = false
        blurView.isHidden = false
    }
    
    @IBAction func minutesPickDoneClicked(_ sender: Any) {
        minutesContainerView.isHidden = true
        blurView.isHidden = true
        if (minutesSelectedString ).isEmpty {
            minutesSelectedString =  "0"
        }
        minutesBtn.setTitle(minutesSelectedString, for: .normal)
        minutesBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    }
    
    @IBAction func minutesPickCancelClicked(_ sender: Any) {
        minutesContainerView.isHidden = true
        blurView.isHidden = true
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return gradePickerValues.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gradePickerValues[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        minutesSelectedString = gradePickerValues[row]
        self.view.endEditing(true)
    }
}

extension UIView {
    func customiseView(){
        self.layer.cornerRadius = 2.0
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.clipsToBounds = true
    }
}
