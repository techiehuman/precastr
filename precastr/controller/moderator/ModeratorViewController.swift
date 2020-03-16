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

class ModeratorViewController: UIViewController, CNContactPickerDelegate, MFMessageComposeViewControllerDelegate, ModeratorViewControllerDelegate {

    @IBOutlet weak var moderatorList: UITableView!
    
    @IBOutlet weak var inviteModeratorButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    var moderatorBool : Bool!
    var loggedInUser : User!
    var moderatorDto : [ModeratorsDto] = [ModeratorsDto]()
    var userListApproved : [User] = [User]()
    var userListPending : [User] = [User]()
    var contactsSelected = [String]();
    
    @IBAction func inviteModeratorBtnClicked(_ sender: Any) {
        
        /*let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)*/
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController;
        viewController.moderatorViewControllerDelegte = self;
        self.navigationController?.pushViewController(viewController, animated: true);

        
        /*let viewController: CastModeratorViewController = self.storyboard?.instantiateViewController(withIdentifier: "CastModeratorViewController") as! CastModeratorViewController;
        self.navigationController?.pushViewController(viewController, animated: true); */
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent");
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
                UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController();
            });
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        moderatorList.register(UINib(nibName: "moderatorTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "moderatorTableViewCell")
        
        moderatorList.register(UINib(nibName: "HeaderViewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "HeaderViewTableViewCell")
        // Do any additional setup after loading the view.
        self.inviteModeratorButton.layer.cornerRadius = 4;
        self.loadModeratorData();
        
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        view.addSubview(activityIndicator);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Moderators";
        
        setUpNavigationBarItems();
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
    func contactsDoneButtonPressed(userContactItems: [UserContactItem]) {
        
        if (userContactItems.count > 0) {
            self.contactsSelected = [String]();
            for userContactItem in userContactItems {
                self.contactsSelected.append(userContactItem.phone);
            }
            print("Selected Numbers : ",self.contactsSelected)
            self.addSelectedContsctsBtnPressed();
        }
    }

    func addSelectedContsctsBtnPressed() {
        
        //self.dismiss(animated: false, completion: nil);
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Hey! \r\nI'm using a cool app called preCastr and I'd like you to be my moderator click on this link to download the free app and get going \r\n\r\nhttps://www.precastr.com. \r\n\r\nUse the 4 digit code \(self.loggedInUser.casterReferalCode!) to be a moderator."
            controller.recipients = self.contactsSelected
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        
    }

    func loadModeratorData(){
        
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
                    user.phoneNumber = modeDict.value(forKey: "phone_number") as! String
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
            }
        });
    }
}

extension ModeratorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.moderatorDto.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moderatorDto[section].sectionObjects.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65;
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
        
        for uiTextNameView in cell.subviews {
            if (uiTextNameView is AlphabetInitialsView) {
                uiTextNameView.removeFromSuperview();
            }
        }
        if (moderatorObject.profilePic == nil || moderatorObject.profilePic == "") {
            cell.profileImageView.image = UIImage.init(named: "Moderate Casts");
            cell.profileImageView.isHidden = true;
            cell.addSubview(self.showAlphabetsView(frame: cell.profileImageView.frame, userContact: moderatorObject, rowId: indexPath.row));
        } else {
            cell.profileImageView.isHidden = false;
            cell.profileImageView.sd_setImage(with: URL.init(string: moderatorObject.profilePic), placeholderImage: UIImage.init(named: "Moderate Casts"),  completed: nil);
        }
       
        cell.profileImageView.roundImageView();
        cell.profileImageView.clipsToBounds = true
        if(moderatorObject.username != nil) {
        cell.emailLabel.text = String(moderatorObject.username)
        }else{
             cell.emailLabel.text = ""
        }
        if(moderatorObject.phoneNumber != nil) {
        cell.phoneNumberLabel.text = String(moderatorObject.phoneNumber)
        }else{
            cell.phoneNumberLabel.text = "";
        }
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
        postData["timestamp"] = Int64(Date().timeIntervalSince1970 * 1000.0)
        let jsonURL = "user/remove_moderator/format/json";
        
        
        self.activityIndicator.startAnimating();
        UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
            print(response)
            self.activityIndicator.stopAnimating();
            self.loadModeratorData();
        });
        print(sender.tag)
    }
    @objc func acceptActionPressed(sender: UIButton) {
        var postData = [String: Any]();
        postData["user_id"] = self.loggedInUser.userId
        postData["moderator_id"] = sender.tag
        postData["is_approved"] = "1"
        postData["timestamp"] = Int64(Date().timeIntervalSince1970 * 1000.0)
        let jsonURL = "user/approve_moderator/format/json";
        
        self.activityIndicator.startAnimating();

        UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
            print(response)
            self.activityIndicator.stopAnimating();
            self.loadModeratorData();
        });
        print(sender.tag)
    }
}


