//
//  multiExtension.swift
//  precastr
//
//  Created by Macbook on 02/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
extension UIView{
    func roundView(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    func roundEdgesTopView(){
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 4.0, height: 4.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    func roundEdgesBottomView(){
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 4.0, height: 4.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
}

extension UIImageView{
    func roundImageView(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    
    override open var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
}
extension UIImage{
    func compressTo(_ expectedSizeInMb:Int) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = UIImageJPEGRepresentation(self, compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return UIImage(data: data)
            }
        }
        return nil
    }
}
extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

extension Date {
    
    func ddspEEEEcmyyyy(dateStr: String) -> String {
        
        let apiDateFormatter = DateFormatter();
        apiDateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss";
        let fDate = apiDateFormatter.date(from: dateStr)
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd MMMM, yyyy";
        if (fDate == nil) {
            return dateFormatter.string(from: Date());
        }
        return dateFormatter.string(from: fDate!);
    }
    
    func ddspEEEEcmyyyyspHHclmmclaa(dateStr: String) -> String {
        
        let apiDateFormatter = DateFormatter();
        apiDateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss";
        let fDate = apiDateFormatter.date(from: dateStr)
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd MMMM, yyyy";
        
        let hourDateFormatter = DateFormatter();
        hourDateFormatter.dateFormat = "h:mm a";

        if (fDate == nil) {
            return "\(dateFormatter.string(from: Date())) \(hourDateFormatter.string(from: Date()).uppercased())";
        }
        return "\(dateFormatter.string(from: fDate!)) \(hourDateFormatter.string(from: fDate!).uppercased())";
    }
    
    func timeIntervalMilliSeconds() -> Int {
        return Int(self.timeIntervalSince1970*1000);
    }
    
}
extension UIButton {
    func blueBorderWrap(){
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor
    self.setImage(nil, for: .normal)
    }
    func checkedBtnState(){
       // self.backgroundColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
        let image = UIImage(named: "checkbox")
        self.setImage(image, for : .normal)
       // self.layer.borderWidth = 0
    }
    func roundBtn(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    func roundEdgesBtn(){
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    func roundEdgesLeftBtn(){
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .topLeft], cornerRadii: CGSize(width: 4.0, height: 4.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    func roundEdgesRightBtn(){
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: 4.0, height: 4.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    func radioBtnDefault(){
        
        self.layer.borderWidth  = 1
        self.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
    func radioBtnSelect(){
        self.layer.backgroundColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        self.layer.borderWidth = 0
    }
}

extension UIViewController {
    
    func hideKeyboadOnTapOutside() {
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap);
    }
    //To calculate height for label based on text size and width
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        let paragraphStyle = NSMutableParagraphStyle()
        //line height size
        paragraphStyle.lineSpacing = 2
        let attributes = [
            NSAttributedStringKey.font : UIFont(name: "VisbyCF-Regular", size: 16.0)!,
            NSAttributedStringKey.paragraphStyle: paragraphStyle]
        
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length));
        label.attributedText = attrString;
        label.sizeToFit()
        
        return (label.frame.height)
    }
    
    func getHeightOfPostDescripiton(contentView: UIView, postDescription: String) -> CGFloat {
        let height =  heightForView(text: postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: contentView.frame.width - 40) + CGFloat(PostRowsHeight.Post_Description_Row_Height);
        return CGFloat(height);
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height-200, width: self.view.bounds.width - 40, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 5;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastMultipleLines(message : String) {
        
        if let subview = self.view.viewWithTag(999) {
            subview.removeFromSuperview()
        }
        
        let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height-300, width: self.view.bounds.width - 40, height: 100))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping;
        toastLabel.layer.cornerRadius = 5;
        toastLabel.clipsToBounds  =  true
        toastLabel.tag = 999;
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 15, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
        self.present(alert, animated: true)
    }
    
    func showAlphabetsView(frame: CGRect, name: String, rowId: Int) -> UIView {
        
        let uiLettersView = UIView();
        uiLettersView.frame = frame;
        uiLettersView.roundView();
        uiLettersView.backgroundColor = UIColor(red: 221/255, green: 223/255, blue: 226/255, alpha: 1);
        uiLettersView.tag = rowId;
        
        let textViewLabel = UITextView();
        textViewLabel.frame = CGRect.init(x: 0, y: (uiLettersView.frame.height/2 - 20), width: uiLettersView.frame.width, height: 32);
        textViewLabel.textAlignment = .center;
        textViewLabel.text = getNameInitials(name: name);
        textViewLabel.backgroundColor = .clear
        textViewLabel.font = UIFont(name: "VisbyCF-Bold", size: 18)
        
        uiLettersView.addSubview(textViewLabel);
        
        return uiLettersView;
    }
}

extension UITableViewCell {
    class MyTapRecognizer : UITapGestureRecognizer {
        var rowId: Int!;
        var post: Post!;
        var uiButton: UIButton!;

    }
    class ImageTapRecognizer : UITapGestureRecognizer {
        var imageView: [String]!;
        var imagePosition: Int!;
    }
}
// This syntax reflects changes made to the Swift language as of Aug. '16
extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}

/*extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            sizeThatFits.height = window.safeAreaInsets.bottom + 40
        } else {
            // Fallback on earlier versions
        }
        return sizeThatFits
    }
} */

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {

        let readMoreText: String = trailingText + moreText

        if self.visibleTextLength == 0 { return }

        let lengthForVisibleString: Int = self.visibleTextLength

        if let myText = self.text {

            let mutableString: String = myText

            let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: myText.count - lengthForVisibleString), with: "")

            let readMoreLength: Int = (readMoreText.count)

            guard let safeTrimmedString = trimmedString else { return }

            if safeTrimmedString.count <= readMoreLength { return }

            print("this number \(safeTrimmedString.count) should never be less\n")
            print("then this number \(readMoreLength)")

            // "safeTrimmedString.count - readMoreLength" should never be less then the readMoreLength because it'll be a negative value and will crash
            let trimmedForReadMore: String = (safeTrimmedString as NSString).replacingCharacters(in: NSRange(location: safeTrimmedString.count - readMoreLength, length: readMoreLength), with: "") + trailingText

            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
            let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
            answerAttributed.append(readMoreAttributed)
            self.attributedText = answerAttributed
        }
    }

    var visibleTextLength: Int {

        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        if let myText = self.text {

            let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: myText, attributes: attributes as? [NSAttributedString.Key : Any])
            let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

            if boundingRect.size.height > labelHeight {
                var index: Int = 0
                var prev: Int = 0
                let characterSet = CharacterSet.whitespacesAndNewlines
                repeat {
                    prev = index
                    if mode == NSLineBreakMode.byCharWrapping {
                        index += 1
                    } else {
                        index = (myText as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: myText.count - index - 1)).location
                    }
                } while index != NSNotFound && index < myText.count && (myText as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
                return prev
            }
        }

        if self.text == nil {
            return 0
        } else {
            return self.text!.count
        }
    }
}
extension UITabBar {
    
    /*override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 50// adjust your size here
        return sizeThatFits
    }*/
}

