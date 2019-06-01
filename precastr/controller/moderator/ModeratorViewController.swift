//
//  ModeratorViewController.swift
//  precastr
//
//  Created by Macbook on 22/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI

class ModeratorViewController: UIViewController, CNContactPickerDelegate, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var moderatorList: UITableView!
    var moderatorBool : Bool!
    var loggedInUser : User!
    var moderatorDto : [ModeratorsDto] = [ModeratorsDto]()
    var userListApproved : [User] = [User]()
    var userListPending : [User] = [User]()
    var contactsSelected = [String]();
    
    @IBAction func inviteModeratorBtnClicked(_ sender: Any) {
        
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
        
        /*let viewController: CastModeratorViewController = self.storyboard?.instantiateViewController(withIdentifier: "CastModeratorViewController") as! CastModeratorViewController;
        self.navigationController?.pushViewController(viewController, animated: true); */
    }
    //MARK:- CNContactPickerDelegate Method
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        contacts.forEach { contact in
            for number in contact.phoneNumbers {
                let phoneNumber = number.value
                print("number is = \(phoneNumber)")
                self.contactsSelected.append(phoneNumber.stringValue);
            }
        }
        self.addSelectedContsctsBtnPressed();
       
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
    func addSelectedContsctsBtnPressed() {
        
        var postData = [String : Any]()
        postData["caster_user_id"] = loggedInUser.userId
        let joiner = ","
        let elements = contactsSelected
        var joinedStrings = elements.joined(separator: joiner)
        
        joinedStrings = joinedStrings.replacingOccurrences(of: "(", with: "")
        joinedStrings = joinedStrings.replacingOccurrences(of: ")", with: "-")
        print(joinedStrings)
        postData["moderator_phone_number"] =  joinedStrings;
        let jsonURL = "user/select_moderator/format/json";
        
        UserService().postDataMethod(jsonURL:jsonURL,postData: postData, complete:{(response) in
            
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "Hey! I’m using a cool app called preCastr and I’d like you to be my moderator cick on this link to download he free app and get going \n https://www.precastr.com"
                controller.recipients = self.contactsSelected
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            } else {
                let message = "Request to moderators sent!"
                let alert = UIAlertController.init(title: "Success", message: message, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(response) in
                    //self.navigationController?.popToRootViewController(animated: false);
                    let homePageViewController: HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController;
                    //self.window?.rootViewController = homePageViewController
                    self.navigationController?.pushViewController(homePageViewController, animated: true);
                }));
                self.present(alert, animated: true)
                
            }        });
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
         loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        moderatorList.register(UINib(nibName: "moderatorTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "moderatorTableViewCell")
        
        moderatorList.register(UINib(nibName: "HeaderViewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HeaderViewTableViewCell")
        // Do any additional setup after loading the view.
        self.loadModeratorData();
        
        
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Moderators";
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

extension ModeratorViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        print(String(moderatorObject.username))
        cell.profileLabel.text = String(moderatorObject.username);
        cell.profileImageView.sd_setImage(with: URL(string: moderatorObject.profilePic), placeholderImage: UIImage(named: "profile"));
       
        cell.profileImageView.roundImageView();
        cell.profileImageView.clipsToBounds = true
        
        if(moderatorObject.miscStatus == 1){
            cell.acceptActionBtn.isHidden = true
            cell.removeActionBtn.isHidden = false
            cell.removeActionBtn.tag = Int(moderatorObject.userId);
            cell.removeActionBtn.addTarget(self, action: #selector(removeActionPressed), for: .touchUpInside)
            
        }else{
            cell.acceptActionBtn.isHidden = false
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
            self.loadModeratorData();
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
            self.loadModeratorData();
        });
        print(sender.tag)
    }
    func loadModeratorData(){
     
         self.moderatorDto = [ModeratorsDto]()
         self.userListApproved = [User]()
         self.userListPending  = [User]()
        var jsonURL = "";
        print(String(loggedInUser.userId))
        if(Bool(moderatorBool)==true){
            jsonURL = "user/get_caster_moderator/format/json?user_id=\(String(loggedInUser.userId))&submit=1";
        }else{
            jsonURL = "user/get_moderator_casters/format/json?moderator_id=\(String(loggedInUser.userId))&submit=1";
        }
        UserService().getDataMethod(jsonURL: jsonURL,complete:{(response) in
            print(response);
            let modeArray = response.value(forKey: "data") as! NSArray;
            var moderatorDtoPending : ModeratorsDto = ModeratorsDto()
            var moderatorDtoApproved : ModeratorsDto = ModeratorsDto()
            for mode in modeArray{
                
                var user : User = User()
                var modeDict = mode as! NSDictionary;
                // self.moderators.append(String((modeDict.value(forKey: "username") as! NSString) as String)!);
                user.username = modeDict.value(forKey: "username") as! String
                user.profilePic = modeDict.value(forKey: "profile_pic") as! String
                user.userId = Int32(((modeDict.value(forKey: "moderator_id") as? NSString)?.doubleValue)!)
                let statusModerator = Int(((modeDict.value(forKey: "is_approved")as? NSString)?.doubleValue)!)
                user.miscStatus = statusModerator as! Int
                if(statusModerator == 0){
                    
                    self.userListPending.append(user)
                }else{
                    self.userListApproved.append(user)
                }
                
            }
            if(self.userListPending.count > 0 ){
                moderatorDtoPending.sectionKey = "Pending Approval"
                moderatorDtoPending.sectionObjects = self.userListPending
                self.moderatorDto.append(moderatorDtoPending)
            }
            if(self.userListApproved.count > 0 ){
                moderatorDtoApproved.sectionKey = "Approved Moderators"
                moderatorDtoApproved.sectionObjects = self.userListApproved
                self.moderatorDto.append(moderatorDtoApproved)
            }
            self.moderatorList.reloadData();
        });
    }
}


