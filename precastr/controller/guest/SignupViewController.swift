//
//  SignupViewController.swift
//  precastr
//
//  Created by Macbook on 07/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

protocol ImageLibProtocol {
    func takePicture(viewC : UIViewController);
    func selectPicture(viewC : UIViewController, cameraView : UIImageView);
  
}

class SignupViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var cameraUIView: UIView!
    
    @IBOutlet weak var agreecheckBoxBtn: UIButton!
    
    
    @IBOutlet weak var uploadImage: UIImageView!
    var agreeCheckBox = false
    var uploadImageStatus = false
    var imageDelegate : ImageLibProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.uploadImage.roundImageView()
        imageDelegate = Reusable()
        self.agreecheckBoxBtn.layer.borderWidth = 1
        self.agreecheckBoxBtn.layer.borderColor = UIColor.white.cgColor
         self.cameraUIView.layer.cornerRadius = self.cameraUIView.frame.height/2
         self.nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white ])
        
        self.nameTextField.layer.borderColor = UIColor.white.cgColor
        self.nameTextField.layer.borderWidth = 0.5
        let imageViewN = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let imageN = UIImage(named: "profile");
        imageViewN.image = imageN;
        self.nameTextField.leftView = imageViewN
        self.nameTextField.leftViewMode = .always
       // self.nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width:35, height: self.nameTextField.frame.height))
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white ])
        
        self.emailTextField.layer.borderColor = UIColor.white.cgColor
        self.emailTextField.layer.borderWidth = 0.5
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let image = UIImage(named: "email");
        imageView.image = image;
        self.emailTextField.leftView = imageView
        self.emailTextField.leftViewMode = .always
         // self.emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width:15, height: self.emailTextField.frame.height))
        
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white ])
        self.passwordTextField.layer.borderColor = UIColor.white.cgColor
        self.passwordTextField.layer.borderWidth = 0.5
        self.passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width:35, height: self.passwordTextField.frame.height))
        
        let imageViewP = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let imageP = UIImage(named: "password");
        imageViewP.image = imageP;
        self.passwordTextField.leftView = imageViewP
        self.passwordTextField.leftViewMode = .always

        let imageTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(imageUploadClicked))
        cameraUIView.addGestureRecognizer(imageTapGesture);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBAction func emailSignUpClicked(_ sender: Any) {
        
         let user = User();
         let registerationURL = "user/registration/format/json";
         user.username = emailTextField.text;
        user.name = nameTextField.text;
         user.password = passwordTextField.text;
         let isValid = self.validateSignupForm(user: user); //CALLING VALIDATION FUNCTION
        
         if(isValid==true && agreeCheckBox==true){
         self.userManage(jsonURL: registerationURL,user: user,requestType: "");
         }else if(agreeCheckBox==false){
            let alert = UIAlertController.init(title: "Error", message: "Please agree to terms and conditions", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true)
        }
    }
    
    
    @IBAction func agreeCheckboxBtnClicked(_ sender: Any) {
        if(agreeCheckBox==false){
            agreeCheckBox = true
            let image = UIImage(named: "checkbox")
            self.agreecheckBoxBtn.setImage(image, for : .normal)
        }else{
            agreeCheckBox = false
            self.agreecheckBoxBtn.setImage(nil, for: .normal)
            
        }
        
    }
    @IBAction func facebookSignupClicked(_ sender: Any) {
    }
    
    
    @IBAction func twitterSignupClicked(_ sender: Any) {
    }
    
    
    @IBAction func LoginBtnClicked(_ sender: Any) {
        let viewController: LoginStep1ViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginStep1ViewController") as! LoginStep1ViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
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
        else if(uploadImageStatus == false){
            message = "Please upload profile picture"
            isValid = false
        }
        if(isValid==false){
            let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true)
        }
        return isValid;
        
    }
    func userManage(jsonURL:String,user : User, requestType : String)->Void{
        //iPhone or iPad
        //let model = UIDevice.current.model;
        user.userDevice = 2;//
        let userDefaults = UserDefaults.standard
        if let tokenDataStr = userDefaults.value(forKey: "tokenData") as? String {
            user.deviceToken = tokenDataStr;
        } else {
            user.deviceToken = "test";
        }
        
        UserService().postMultipartImageDataMethod(jsonURL: jsonURL,image : uploadImage.image!, postData:user.toDictionary(user: user),complete:{(response) in
            print(response);
            if (Int(response.value(forKey: "status") as! String)! == 1) {
                
                let message = response.value(forKey: "message") as! String;
                
                let alert = UIAlertController.init(title: "Success", message: message, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(resp) in
                    let userDict = response.value(forKey: "data") as! NSDictionary;
                    print(userDict)
                    let user = User().getUserData(userDataDict: userDict);
                    user.loadUserDefaults();
                    if(requestType == ""){
                        
                        let viewController: UserTypeActionViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserTypeActionViewController") as! UserTypeActionViewController;
                        self.navigationController?.pushViewController(viewController, animated: true);
                        print(self.navigationController);
                        
                    }else if(requestType == "login"){
                        UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController()
                        //let viewController: HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController;
                        //self.navigationController?.pushViewController(viewController, animated: true);
                    }
                    
                    //let vc = UserTypeActionViewController(nibName: "UserTypeActionViewController", bundle: nil)
                    //self.navigationController?.pushViewController(vc, animated: true )
                    
                }));
                self.present(alert, animated: true)
                
                
                
            } else {
                let message = response.value(forKey: "message") as! String;
                
                let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                self.present(alert, animated: true)
            }
        })
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
