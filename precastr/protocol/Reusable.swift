//
//  Reusable.swift
//  precastr
//
//  Created by Macbook on 09/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import Foundation
import MobileCoreServices
import Photos



class Reusable : UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageLibProtocol,ImageLibProtocolT{
    
    let picController = UIImagePickerController();
    var imageView = UIImageView()
    func takePicture(viewC : UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            self.picController.sourceType = UIImagePickerControllerSourceType.camera
            self.picController.allowsEditing = true
            self.picController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.picController.mediaTypes = [kUTTypeImage as String]
            viewC.present(picController, animated: true, completion: nil)
        }
    }
    
    func selectPicture(viewC : UIViewController, cameraView : UIImageView) {
        //self.checkPermission();
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            self.picController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.picController.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            self.picController.allowsEditing = true
            self.picController.mediaTypes = [kUTTypeImage as String]
            viewC.present(picController, animated: true, completion: nil)
            imageView = cameraView
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageView.image = image;
            /* self.withoutimageView.isHidden = true;
             
             
             DispatchQueue.main.async {
             self.meTimeImageView.isHidden = false;
             self.meTimeImageView.image = image;
             }
             self.imageToUpload = image;
             let uploadImage = self.imageToUpload.compressImage(newSizeWidth: 212, newSizeHeight: 212, compressionQuality: 1.0) */
           
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
}
