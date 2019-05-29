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
import BSImagePicker


class Reusable : UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageLibProtocol,ImageLibProtocolT{
    
    let picController = UIImagePickerController();
    var imageView = UIImageView()
    var selectedAssets = [PHAsset]()
    var photoArray = [UIImage]()
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
            self.picController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.picController.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            self.picController.allowsEditing = true
            self.picController.mediaTypes = [kUTTypeImage as String]
            viewC.present(picController, animated: true, completion: nil)
            imageView = cameraView
        }
    }
    func selectMultipleImages(viewC : UIViewController, cameraView : [UIImageView]){
     
        // create an instance
        let vc = BSImagePickerViewController()
        
        //display picture gallery
        self.bs_presentImagePickerController(vc, animated: true,
                                             select: { (asset: PHAsset) -> Void in
                                                
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
                
            }
            
            self.convertAssetToImages()
            
        }, completion: nil)
        
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
    
    func convertAssetToImages() -> Void {
        
        if SelectedAssets.count != 0{
            
            
            for i in 0..<SelectedAssets.count{
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                
                
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                    thumbnail = result!
                    
                })
                
                let data = UIImageJPEGRepresentation(thumbnail, 0.7)
                let newImage = UIImage(data: data!)
                
                
                self.PhotoArray.append(newImage! as UIImage)
                
            }
            
            self.imgView.animationImages = self.PhotoArray
            self.imgView.animationDuration = 3.0
            self.imgView.startAnimating()
            
        }
        
        
        print("complete photo array \(self.PhotoArray)")
    }
}
