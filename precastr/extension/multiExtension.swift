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
}

extension UIImageView{
    func roundImageView(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
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
        dateFormatter.dateFormat = "dd EEEE, yyyy";
        if (fDate == nil) {
            return dateFormatter.string(from: Date());
        }
        return dateFormatter.string(from: fDate!);
    }
}