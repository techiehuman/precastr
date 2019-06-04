//
//  SignupScreenViewController.swift
//  precastr
//
//  Created by Cenes_Dev on 04/06/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

protocol ImageLibProtocol {
    func takePicture(viewC : UIViewController, cameraView : UIImageView);
    func selectPicture(viewC : UIViewController, cameraView : UIImageView);
}
class SignupScreenViewController: UIViewController {

    @IBOutlet weak var signupTableView: UITableView!
    var uploadImage: UIImageView!

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    var uploadImageStatus = false
    var imageDelegate : ImageLibProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signupTableView.register(UINib.init(nibName: "SignupScreenTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SignupScreenTableViewCell");
        self.hideKeyboadOnTapOutside();
    }
    

    func imageUploadClicked(){
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
            self.imageDelegate.takePicture(viewC: self, cameraView: self.uploadImage);
            self.uploadImage.isHidden = false
            self.uploadImageStatus = true
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
    
    func validateSignupForm(user: User) -> Bool{
        
        var isValid = true;
        var message = "";
        if (user.name == "") {
            message = "Name cannot be empty"
            isValid = false
        }
        else if (user.username == "") {
            message = "Username cannot be empty"
            isValid = false
        } else if (user.password == "") {
            message = "Password cannot be empty"
            isValid = false
        }
        /*else if(uploadImageStatus == false){
         message = "Please upload profile picture"
         isValid = false
         }*/
        if(isValid==false){
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true)
        }
        return isValid;
        
    }
    func userManage(jsonURL:String,user : User)->Void{
        //iPhone or iPad
        //let model = UIDevice.current.model;
        user.userDevice = 2;//
        let userDefaults = UserDefaults.standard
        if let tokenDataStr = userDefaults.value(forKey: "tokenData") as? String {
            user.deviceToken = tokenDataStr;
        } else {
            user.deviceToken = "test";
        }
        
        
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
        
        if (uploadImageStatus == true) {
            UserService().postMultipartImageDataMethod(jsonURL: jsonURL,image : uploadImage.image!, postData:user.toDictionary(user: user),complete:{(response) in
                self.signUpSuccessCallback(response: response);
            })
        } else {
            UserService().postDataMethod(jsonURL: jsonURL, postData: user.toDictionary(user: user), complete: {(response) in
                self.signUpSuccessCallback(response: response);
                
            })
        }
        
    }
    
    func signUpSuccessCallback(response: NSDictionary) {
        
        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
        
        print(response);
        SocialPlatform().fetchSocialPlatformData();
        
        if (Int(response.value(forKey: "status") as! String)! == 1) {
            
            let userDict = response.value(forKey: "data") as! NSDictionary;
            
            print(userDict)
            let user = User().getUserData(userDataDict: userDict);
            user.loadUserDefaults();
            
            let viewController: UserTypeActionViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserTypeActionViewController") as! UserTypeActionViewController;
            self.navigationController?.pushViewController(viewController, animated: true);
            
        } else {
            let message = response.value(forKey: "message") as! String;
            
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true)
        }

}

}
extension SignupScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SignupScreenTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SignupScreenTableViewCell") as! SignupScreenTableViewCell;
        
        cell.signupScreenViewDelegate = self;
        activityIndicator.center = cell.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        cell.addSubview(activityIndicator);
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height + 120);
    }
}
