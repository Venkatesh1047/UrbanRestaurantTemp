//
//  ExtensionClass.swift
//  UrbanEats
//
//  Created by Venkat@Hexadots on 06/11/18.
//  Copyright © 2018 Hexadots. All rights reserved.
//

/**
    * This class was written according to the app recuriment, these are the extension of an existing Types.
 */

import Foundation
import UIKit
let APP_FONT = "Roboto"
enum AppFonts {
    case Bold, Medium, Regular, Black, BlackItalic, BoldItalic, ExtraBold, ExtraBoldItalic, ExtraLight, Italic, Light, LightItalic, MediumItalic, SemiBold, SemiBoldItalic, Thin, ThinItalic
    var fonts:String{
        switch self {
        case .Bold:
            return "\(APP_FONT)-Bold"
        case .Medium:
            return "\(APP_FONT)-Medium"
        case .Regular:
            return "\(APP_FONT)-Regular"
        case .Black:
            return "\(APP_FONT)-Black"
        case .BlackItalic:
            return "\(APP_FONT)-BlackItalic"
        case .BoldItalic:
            return "\(APP_FONT)-BoldItalic"
        case .ExtraBold:
            return "\(APP_FONT)-ExtraBold"
        case .ExtraBoldItalic:
            return "\(APP_FONT)-ExtraBoldItalic"
        case .ExtraLight:
            return "\(APP_FONT)-ExtraLight"
        case .Italic:
            return "\(APP_FONT)-Italic"
        case .Light:
            return "\(APP_FONT)-Light"
        case .LightItalic:
            return "\(APP_FONT)-LightItalic"
        case .MediumItalic:
            return "\(APP_FONT)-MediumItalic"
        case .SemiBold:
            return "\(APP_FONT)-SemiBold"
        case .SemiBoldItalic:
            return "\(APP_FONT)-SemiBoldItalic"
        case .Thin:
            return "\(APP_FONT)-Thin"
        case .ThinItalic:
            return "\(APP_FONT)-ThinItalic"
        }
    }
}

extension UITextField{
    func placeholderColor(_ placeholder:String, color:UIColor){
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor : color])
    }
    
    func leftViewImage(_ image:UIImage){
        self.leftViewMode = UITextFieldViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        self.leftView = view
    }
    
    func rightViewImage(_ image:UIImage){
        self.rightViewMode = UITextFieldViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        self.rightView = view
    }
    
}

extension UIColor{
    static var themeColor:UIColor{
        return #colorLiteral(red: 0.9529411765, green: 0.7529411765, blue: 0.1843137255, alpha: 1)
    }
    static var themeDisableColor:UIColor{
        return #colorLiteral(red: 0.9529411765, green: 0.7529411765, blue: 0.1843137255, alpha: 0.5)
    }
    static var placeholderColor:UIColor{
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7980789812)
    }
    static var textFieldTintColor:UIColor{
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    static var buttonBGColor:UIColor{
        return #colorLiteral(red: 0.2509803922, green: 0.2901960784, blue: 0.4078431373, alpha: 0.2018942637)
    }
    static var whiteColor:UIColor{
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    static var blackColor:UIColor{
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    static var greyColor:UIColor{
        return #colorLiteral(red: 0.4987899065, green: 0.5029092431, blue: 0.5104134083, alpha: 1)
    }
    static var redColor:UIColor{
        return #colorLiteral(red: 1, green: 0.3607843137, blue: 0.4117647059, alpha: 1)
    }
}

extension UIFont{
    static func appFont(_ font:AppFonts, size:CGFloat) -> UIFont{
        return UIFont(name: font.fonts, size: size) ??  UIFont(name: AppFonts.Regular.fonts, size: size)!
    }
}

extension UIButton{
    func cornerRadius(_ radius:CGFloat = 5.0){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}

extension UILabel {
    ///Find the index of character (in the attributedText) at point
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}

extension NSRange{
    /**
     Used to check textfiled condition.
     ## Example:
     
     If mobile number textfiled lenght has 10 digits then need to enable button otherwise disable the button.
     ````
     let enableBtn = range.locAndLen >= 9
     button.isEnabled = enableBtn
     ````
     */
    var locAndLen:Int{
        let location = self.location
        let length = self.length == 1 ? (location - 1) : location
        return length
    }
}

extension UIViewController{
    func disableKeyBoardOnTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc func tapped(_ sender:UIGestureRecognizer){
        self.view.endEditing(true)
    }
}
