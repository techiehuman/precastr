//
//  EditProfileViewController.swift
//  precastr
//
//  Created by Macbook on 07/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

protocol EditProfileTableViewCellProtocol {
    func pictureSelected(selectedImage: UIImage)
}
class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var EditProfileTableView: UITableView!
    var loggedInUser : User!
    var uploadImageStatus: Bool = false;
    var uploadImage: UIImage!;
    let picController = UIImagePickerController();
    var editProfileTableViewCellProtocolDelegate: EditProfileTableViewCellProtocol!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        
        EditProfileTableView.register(UINib.init(nibName: "EditProfileTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "EditProfileTableViewCell");
        self.hideKeyboadOnTapOutside();
        
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        self.view.addSubview(activityIndicator);
        

    }

    override func viewWillAppear(_ animated: Bool) {
        let menuButton = UIButton();
        menuButton.setImage(UIImage.init(named: "menu"), for: .normal);
        menuButton.addTarget(self, action: #selector(menuButtonClicked), for: UIControlEvents.touchUpInside)
        menuButton.frame = CGRect.init(x: 0, y:0, width: 24, height: 24);
        
        let barButton = UIBarButtonItem(customView: menuButton)
        
        navigationItem.rightBarButtonItem = barButton;
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
        self.tabBarController?.tabBar.isHidden = false;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func menuButtonClicked() {
        let viewController: SideMenuTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuTableViewController") as! SideMenuTableViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    func updateNameProfilePic(postData: [String: Any]) {
        
        
        self.activityIndicator.startAnimating();
        
        let jsonURL = "/user/update_user_profile/format/json";
        
        if (self.uploadImageStatus == true) {
            UserService().postMultipartImageForUpdateProfile(jsonURL: jsonURL,image : self.uploadImage, postData:postData, complete:{(response) in
                
                self.activityIndicator.stopAnimating();
                
                let success = Int(response.value(forKey: "status") as! String)
                let message = response.value(forKey: "message") as! String;

                if (success == 0) {
                    self.showAlert(title: "Error", message: message);
                } else {
                    
                    self.showToast(message: message)
                    
                    let data = response.value(forKey: "data") as! NSDictionary;
                    
                    var dateToUpdate = [String: String]();
                    dateToUpdate["name"] = data.value(forKey: "name") as! String;
                    dateToUpdate["profile_pic"] = data.value(forKey: "profile_pic") as! String;
                    User().updateUserData(userData: dateToUpdate);
                }
            });
        } else {
            UserService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: {(response) in
                
                self.activityIndicator.stopAnimating();

                let success = Int(response.value(forKey: "status") as! String)
                let message = response.value(forKey: "message") as! String;

                if (success == 0) {
                    self.showAlert(title: "Error", message: message);
                } else {
                    
                    self.showToast(message: message)

                    let data = response.value(forKey: "data") as! NSDictionary;
                    
                    var dateToUpdate = [String: String]();
                    dateToUpdate["name"] = data.value(forKey: "name") as! String;
                    User().updateUserData(userData: dateToUpdate);
                }
                
            });
        }
    }
    
    func updatePassword(postData: [String: Any]) {
        
        self.activityIndicator.startAnimating();
        let jsonURL = "/user/change_password/format/json";
        
        UserService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: {(response) in
            
            self.activityIndicator.stopAnimating();
            
            let success = Int(response.value(forKey: "status") as! String)
            let message = response.value(forKey: "message") as! String;

            if (success == 0) {
                self.showAlert(title: "Error", message: message);
            } else {
                self.showToast(message: message)
            }
        });
    }

    func imageUploadClicked(){
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let uploadPhotoAction: UIAlertAction = UIAlertAction(title: "Upload Photo", style: .default) { action -> Void in
            self.selectPicture()
        }
        //uploadPhotoAction.setValue(selectedColor, forKey: "titleTextColor")
        let takePhotoAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            self.takePicture();
            
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
    
    func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            self.picController.sourceType = UIImagePickerControllerSourceType.camera
            self.picController.allowsEditing = true
            self.picController.delegate = self
            self.picController.mediaTypes = [kUTTypeImage as String]
            self.present(picController, animated: true, completion: nil)
        }
    }
    
    func selectPicture() {
        //self.checkPermission();
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            self.picController.delegate = self
            self.picController.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            self.picController.allowsEditing = true
            self.picController.mediaTypes = [kUTTypeImage as String]
            self.present(picController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.uploadImageStatus = true
            
            self.uploadImage = image;
            /* self.withoutimageView.isHidden = true;
             
             
             DispatchQueue.main.async {
             self.meTimeImageView.isHidden = false;
             self.meTimeImageView.image = image;
             }
             self.imageToUpload = image;
             let uploadImage = self.imageToUpload.compressImage(newSizeWidth: 212, newSizeHeight: 212, compressionQuality: 1.0) */
            self.editProfileTableViewCellProtocolDelegate.pictureSelected(selectedImage: image)
            
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
}
extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: EditProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell") as! EditProfileTableViewCell;
        
        cell.editProfileViewControllerDelegate = self;
        
        cell.emailTextLabel.text = loggedInUser.username!;
        cell.nameTextField.text = loggedInUser.name!;
        cell.invitationCodeLabel.text = loggedInUser.casterReferalCode!;
        
        if (loggedInUser.profilePic != nil) {
            cell.profileImageView.sd_setImage(with: URL(string: loggedInUser.profilePic!), placeholderImage: UIImage.init(named: "Profile-1"))
        }

        editProfileTableViewCellProtocolDelegate = cell;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height + 120);
    }
}