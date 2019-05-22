//
//  TwitterPostViewController.swift
//  precastr
//
//  Created by Macbook on 26/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit


protocol ImageLibProtocolT {
    func takePicture(viewC : UIViewController);
    func selectPicture(viewC : UIViewController,cameraView : UIImageView);
}
class TwitterPostViewController: UIViewController,UITextViewDelegate {

     @IBOutlet weak var postTextField: UITextView!
    var loggedInUser : User!
    var social : SocialPlatform!
    var uploadImage : UIImageView!
    var imageDelegate : ImageLibProtocolT!
    var socialMediaPlatform : [Int]!
    var uploadImageStatus = false
    var facebookStatus = false
    var twitterStatus = false
    @IBOutlet weak var sendViewArea: UIView!
    @IBOutlet weak var inputViewArea: UIView!
    var postArray : [String:Any] = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
            self.postTextField.delegate = self
            //self.postTextField.text = "Please add text to be posted ..."
           // self.postTextField.textColor = UIColor.lightGray
        self.postTextField.layer.borderColor =  UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor;
        self.postTextField.layer.borderWidth = 1
             loggedInUser =  User().loadUserDataFromUserDefaults(userDataDict : setting);
            self.social = SocialPlatform().loadSocialDataFromUserDefaults();
            imageDelegate = Reusable()
        let imageTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(imageUploadClicked))
        //uploadImage.addGestureRecognizer(imageTapGesture);
        // Do any additional setup after loading the view.
        self.socialMediaPlatform = [Int]();
        
        let jsonURL = "user/get_user_details/format/json";
         postArray["user_id"] = String(loggedInUser.userId)
        UserService().postDataMethod(jsonURL: jsonURL, postData: postArray, complete: {(response) in
           // print(response);
           let modeArray = response.value(forKey: "data") as! NSDictionary;
            var tokens  = modeArray.value(forKey: "tokens") as! NSArray
            for mode in tokens{
                var type = [String : Any]()
                var modeDict = mode as! NSDictionary;
                // self.moderators.append(String((modeDict.value(forKey: "username") as! NSString) as String)!);
                print(modeDict.value(forKey: "type") as! String);
                if(modeDict.value(forKey: "type") as! String == "Facebook") {
                    self.facebookStatus = true
                }
                if(modeDict.value(forKey: "type") as! String == "Twitter") {
                    self.twitterStatus = true
                }
                
            }
            
        });
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        print("A")
        if self.postTextField.textColor == UIColor.lightGray {
            self.postTextField.text = ""
            self.postTextField.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("B")
        if self.postTextField.text == "" {
            
            self.postTextField.text = "Placeholder text ..."
            self.postTextField.textColor = UIColor.lightGray
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func facebookBtnClicked(_ sender: Any) {
        //self.socialMediaPlatform.append((social.socialPlatformId["facebook"])!)
        for obj in social.socialPlatformId {
            if (obj.key == "facebook") {
                self.socialMediaPlatform.append(obj.value);
                break;
            }
        }
    
    }
    
    
    @IBAction func twitterBtnClicked(_ sender: Any) {
        for obj in social.socialPlatformId {
            if (obj.key == "twitter") {
                self.socialMediaPlatform.append(obj.value);
                break;
            }
        }
        
    }
    @IBAction func AddSocialMedia(_ sender: Any) {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let uploadPhotoAction: UIAlertAction = UIAlertAction(title: "Upload Photo", style: .default) { action -> Void in
            self.imageDelegate.selectPicture(viewC: self,cameraView: self.uploadImage);
        }
        //uploadPhotoAction.setValue(selectedColor, forKey: "titleTextColor")
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            self.imageDelegate.takePicture(viewC: self);
        }
        //takePhotoAction.setValue(cenesLabelBlue, forKey: "titleTextColor")
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        actionSheetController.addAction(uploadPhotoAction)
        actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
   
    
   
    @IBAction func postOnSocialPlatform(_ sender: Any) {
        let jsonURL = "posts/create_new_caster_posts/format/json"
        var postData : [String : Any] = [String : Any]()
        postData["post_description"] = self.postTextField.text
        postData["user_id"] = self.loggedInUser.userId
        let joiner = ","
        let elements = (self.socialMediaPlatform);
        
        var joinedStrings = "";
        for elementItem in elements! {
            joinedStrings = joinedStrings + "\(elementItem),";
        }
        print(joinedStrings)
        postData["social_media_id"] = String(joinedStrings.suffix(joinedStrings.count-1));
        
        UserService().postMultipartImageDataSocialMethod(jsonURL: jsonURL,image : uploadImage.image!, postData:postData,complete:{(response) in
            print(response);
            })
    }
    @objc func imageUploadClicked(){
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let uploadPhotoAction: UIAlertAction = UIAlertAction(title: "Upload Photo", style: .default) { action -> Void in
            self.imageDelegate.selectPicture(viewC: self,cameraView: self.uploadImage);
            self.uploadImage.isHidden = false
            self.uploadImageStatus = true
        }
        //uploadPhotoAction.setValue(selectedColor, forKey: "titleTextColor")
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            self.imageDelegate.takePicture(viewC: self);
        }
        //takePhotoAction.setValue(cenesLabelBlue, forKey: "titleTextColor")
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        actionSheetController.addAction(uploadPhotoAction)
        actionSheetController.addAction(takePhotoAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
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
