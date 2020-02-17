//
//  CastersViewController.swift
//  precastr
//
//  Created by mandeep singh on 05/07/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class CastersViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var casterList: UITableView!
    @IBOutlet weak var inviteCodeSubmitButton : UIButton!
    
    @IBOutlet weak var verifyCode1: UITextField!
    
    @IBOutlet weak var verifyCode2: UITextField!
    
    @IBOutlet weak var verifyCode3: UITextField!
    @IBOutlet weak var verifyCode4: UITextField!
    var moderatorBool : Bool!
    var loggedInUser : User!
    var moderatorDto : [ModeratorsDto] = [ModeratorsDto]()
    var userListApproved : [User] = [User]()
    var userListPending : [User] = [User]()
    var contactsSelected = [String]();
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyCode1.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        verifyCode1.layer.borderWidth = 0.5
        verifyCode2.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        verifyCode2.layer.borderWidth = 0.5
        verifyCode3.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        verifyCode3.layer.borderWidth = 0.5
        verifyCode4.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        verifyCode4.layer.borderWidth = 0.5
        verifyCode1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged);
        verifyCode2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged);
        verifyCode3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged);
        verifyCode4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged);
        
       // verifyCode1.becomeFirstResponder();
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        casterList.register(UINib(nibName: "moderatorTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "moderatorTableViewCell")
        
        casterList.register(UINib(nibName: "HeaderViewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HeaderViewTableViewCell")
        // Do any additional setup after loading the view.
        self.inviteCodeSubmitButton.layer.cornerRadius = 4;
        self.loadCasterData();
        // Do any additional setup after loading the view.
        self.hideKeyboadOnTapOutside();
    }
    @objc func textFieldDidChange(textField: UITextField) {
        
        let text = textField.text;
        
        if (text!.count == 1) {
            
            switch textField {
            case verifyCode1:
                verifyCode2.text = "";
                verifyCode2.becomeFirstResponder();
                
            case verifyCode2:
                verifyCode3.text = "";
                verifyCode3.becomeFirstResponder();
                
            case verifyCode3:
                verifyCode4.text = "";
                verifyCode4.becomeFirstResponder();
                
            case verifyCode4:
                verifyCode4.resignFirstResponder();
                
            default:
                break;
            }
            
        }
    }
    @IBAction func inviteCodeBtnClicked(_ sender: Any) {
        
        var postData = [String: Any]();
        postData["user_id"] = self.loggedInUser.userId
        let otp = "\(self.verifyCode1.text!)\(self.verifyCode2.text!)\(self.verifyCode3.text!)\(self.verifyCode4.text!)";
        if (otp.count < 4) {
            let alert = UIAlertController.init(title: "Error", message: "Please enter the code", preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true)
        } else {
            postData["otp"] = String(otp)
            let jsonURL = "user/verify_user_otp/format/json";
            UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
                print(response)
                if (Int(response.value(forKey: "status") as! String)! == 0) {
                    let message = response.value(forKey: "message") as! String;
                    
                    let alert = UIAlertController.init(title: "Error", message: message, preferredStyle: .alert);
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
                    self.present(alert, animated: true)
                    
                }else{
                   // UIApplication.shared.keyWindow?.rootViewController = HomeViewController.MainViewController();
                    self.loadCasterData();
                }
            });
        }
        
        /*let viewController: CastModeratorViewController = self.storyboard?.instantiateViewController(withIdentifier: "CastModeratorViewController") as! CastModeratorViewController;
         self.navigationController?.pushViewController(viewController, animated: true); */
    }
    func setUpNavigationBarItems() {
        
        let menuButton = UIButton();
        menuButton.setImage(UIImage.init(named: "left-arrow"), for: .normal);
        menuButton.addTarget(self, action: #selector(backButtonPressed), for: UIControlEvents.touchUpInside)
        menuButton.frame = CGRect.init(x: 0, y:0, width: 20, height: 15);
        
        let barButton = UIBarButtonItem(customView: menuButton)
        
        navigationItem.leftBarButtonItem = barButton;
        
        let homeButton = UIButton();
        homeButton.setImage(UIImage.init(named: "top-home"), for: .normal);
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: UIControlEvents.touchUpInside)
        homeButton.frame = CGRect.init(x: 0, y:0, width: 24, height: 24);
        
        let homeBarButton = UIBarButtonItem(customView: homeButton)
        
        navigationItem.rightBarButtonItem = homeBarButton;
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
    }
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true);
    }
    
    @objc func homeButtonPressed() {
        UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController();
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Casters";
        
        setUpNavigationBarItems();
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CastersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.moderatorDto.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moderatorDto[section].sectionObjects.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let moderatorObject = self.moderatorDto[indexPath.section].sectionObjects[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moderatorTableViewCell", for: indexPath) as! moderatorTableViewCell;
        print("******")
        print(String(moderatorObject.name))
        if(moderatorObject.name != nil) {
            cell.profileLabel.text = String(moderatorObject.name);
        } else {
            cell.profileLabel.text = String(moderatorObject.username);
        }
        cell.profileImageView.sd_setImage(with: URL(string: moderatorObject.profilePic), placeholderImage: UIImage(named: "Moderate Casts"));
        
        cell.profileImageView.roundImageView();
        cell.profileImageView.clipsToBounds = true
        
        if(moderatorObject.miscStatus == 1){
            cell.acceptActionBtn.isHidden = true
          //  cell.removeActionBtn.isHidden = false
            cell.removeActionBtn.tag = Int(moderatorObject.userId);
            cell.removeActionBtn.addTarget(self, action: #selector(removeActionPressed), for: .touchUpInside)
            
        }else{
          //  cell.acceptActionBtn.isHidden = false
            cell.removeActionBtn.isHidden = true
            cell.acceptActionBtn.tag = Int(moderatorObject.userId)
            cell.acceptActionBtn.addTarget(self, action: #selector(acceptActionPressed), for: .touchUpInside)
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderViewTableViewCell") as!  HeaderViewTableViewCell;
        headerCell.headerTitleLabel.text = self.moderatorDto[section].sectionKey;
        return headerCell;
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45;
    }
    
    
    @objc func removeActionPressed(sender: UIButton) {
        var postData = [String: Any]();
        postData["user_id"] = self.loggedInUser.userId
        postData["moderator_id"] = sender.tag
        let jsonURL = "user/remove_moderator/format/json";
        UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
            print(response)
            self.loadCasterData();
        });
        print(sender.tag)
    }
    @objc func acceptActionPressed(sender: UIButton) {
        var postData = [String: Any]();
        postData["user_id"] = self.loggedInUser.userId
        postData["moderator_id"] = sender.tag
        postData["is_approved"] = "1"
        let jsonURL = "user/approve_moderator/format/json";
        UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
            print(response)
            self.loadCasterData();
        });
        print(sender.tag)
    }
    func loadCasterData(){
        
        self.moderatorDto = [ModeratorsDto]()
        self.userListApproved = [User]()
        self.userListPending  = [User]()
        var jsonURL = "";
        print(String(loggedInUser.userId))
        //  if(Bool(moderatorBool)==true){
        if(self.loggedInUser.isCastr == 1){
            jsonURL = "user/get_caster_moderator/format/json?user_id=\(String(loggedInUser.userId))&submit=1";
        }else{
            jsonURL = "user/get_moderator_casters/format/json?moderator_id=\(String(loggedInUser.userId))&submit=1";
        }
        UserService().getDataMethod(jsonURL: jsonURL,complete:{(response) in
            print(response);
            let status = Int(response.value(forKey: "status") as! String)!
            if(status == 0){
                let message = response.value(forKey: "message") as! String;
                self.showAlert(title: "Error", message: message);
            }else{
                let modeArray = response.value(forKey: "data") as! NSArray;
                var moderatorDtoPending : ModeratorsDto = ModeratorsDto()
                var moderatorDtoApproved : ModeratorsDto = ModeratorsDto()
                for mode in modeArray{
                    
                    var user : User = User()
                    var modeDict = mode as! NSDictionary;
                    // self.moderators.append(String((modeDict.value(forKey: "username") as! NSString) as String)!);
                    user.name = modeDict.value(forKey: "name") as! String
                    user.username = modeDict.value(forKey: "username") as! String
                    user.profilePic = modeDict.value(forKey: "profile_pic") as! String
                    user.userId = Int32(((modeDict.value(forKey: "caster_id") as? NSString)?.doubleValue)!)
                   // let statusModerator = Int(((modeDict.value(forKey: "is_approved")as? NSString)?.doubleValue)!)
                    let statusCaster = Int(((modeDict.value(forKey: "is_approved")as? NSString)?.doubleValue)!)
                    user.miscStatus = statusCaster as! Int
                    if(statusCaster == 0){
                        
                        self.userListPending.append(user)
                    }else{
                        self.userListApproved.append(user)
                    }
                }
                if(self.userListApproved.count > 0 ){
                    moderatorDtoApproved.sectionKey = "Approved Casters"
                    moderatorDtoApproved.sectionObjects = self.userListApproved
                    self.moderatorDto.append(moderatorDtoApproved)
                }
                if(self.userListPending.count > 0 ){
                    moderatorDtoPending.sectionKey = "Pending Approval"
                    moderatorDtoPending.sectionObjects = self.userListPending
                    self.moderatorDto.append(moderatorDtoPending)
                }
               
                
                if (self.userListPending.count == 0 && self.userListApproved.count == 0) {
                    self.casterList.isHidden = true
                } else {
                    
                    self.casterList.isHidden = false
                    self.casterList.reloadData();

                }
            }
        });
    }
}
