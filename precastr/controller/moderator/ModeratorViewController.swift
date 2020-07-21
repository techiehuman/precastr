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

class ModeratorViewController: UIViewController, CNContactPickerDelegate, MFMessageComposeViewControllerDelegate, ModeratorViewControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var moderatorList: UITableView!
    
    @IBOutlet weak var inviteModeratorButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    var moderatorBool : Bool!
    var loggedInUser : User!
    var moderatorDto : [ModeratorsDto] = [ModeratorsDto]()
    var userListApproved : [User] = [User]()
    var userListPending : [User] = [User]()
    var contactsSelected = [String]();
    var moderatorCategoriesMap = [Int: ModeratorCategory]();
    var moderatorCategories = [ModeratorCategory]();
    var assignModeratorCategoryView: AssignModeratorCategoryView!;
    var selectedModeratorCat: ModeratorCategory!;
    var selectedPendingModeratorId: Int!;
    var selectedModerator: User!;

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
        
        
        moderatorCategories = dbHelper.fetchAllModeratorCatrgories();
        for moderatorCat in moderatorCategories {
            moderatorCategoriesMap[moderatorCat.moderatorCategoryId] = moderatorCat;
        }

        // Do any additional setup after loading the view.
        self.inviteModeratorButton.layer.cornerRadius = 4;
        self.loadModeratorData();
        
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.style = UIActivityIndicatorView.Style.gray;
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
        menuButton.addTarget(self, action: #selector(backButtonPressed), for: UIControl.Event.touchUpInside)
        menuButton.frame = CGRect.init(x: 0, y:0, width: 20, height: 15);
        
        let barButton = UIBarButtonItem(customView: menuButton)
        
        navigationItem.leftBarButtonItem = barButton;
        
        let homeButton = UIButton();
        homeButton.setImage(UIImage.init(named: "top-home"), for: .normal);
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: UIControl.Event.touchUpInside)
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

    func loadModeratorData() {
        
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
                    user.categoryId = Int(modeDict.value(forKey: "category_id") as! String);
                    user.status = Int8(modeDict.value(forKey: "status") as! String);
                    
                    user.moderatorStatus = Int8(modeDict.value(forKey: "moderator_status") as! String);

                    user.userId = Int32(((modeDict.value(forKey: "moderator_id") as? NSString)?.doubleValue)!)
                    let statusModerator = Int(((modeDict.value(forKey: "is_approved")as? NSString)?.doubleValue)!)
                    user.miscStatus = statusModerator 
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
    
    func updateModeratorStatus(moderatorId: Int, status: Int8) {
        
        self.activityIndicator.startAnimating();
        
        let jsonUrl = "user/update_moderator_status/format/json";
        var postData = [String: Any]();
        postData["user_id"] = loggedInUser.userId;
        postData["moderator_id"] = moderatorId;
        postData["status"] = status;

        UserService().postDataMethod(jsonURL: jsonUrl, postData: postData, complete: {response in
            self.activityIndicator.stopAnimating();
        });
    }
    
    func openCategoryDropDown() {
        assignModeratorCategoryView = AssignModeratorCategoryView.instanceDropDownAlertFromNib() as! AssignModeratorCategoryView;
        
        let closePopUpGesture = UITapGestureRecognizer.init(target: self, action: #selector(closePopupBtnPressed))
        assignModeratorCategoryView.closePopupBtn.addGestureRecognizer(closePopUpGesture);
        
        let saveBtnTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(saveModeratorCatBtnPressed));
        assignModeratorCategoryView.btnSave.addGestureRecognizer(saveBtnTapGesture);
        
        let dropdownTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dropdownBarPressed));
    assignModeratorCategoryView.dropDownCategoryLabelView.addGestureRecognizer(dropdownTapGesture);

        let window = UIApplication.shared.keyWindow!
        assignModeratorCategoryView.frame = window.bounds;
        window.addSubview(assignModeratorCategoryView);
    }
}

class ModeratorSwitchGesture: UISwitch {
    var medratorSwitch: UISwitch!;
    var status: Int8!;
    var moedratorId: Int32!;
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
        
        //Setting name of user
        if(moderatorObject.name != nil) {
            let nameArr = moderatorObject.name.split(separator: " ");
            cell.profileLabel.text = String(nameArr[0]);
        } else {
            cell.profileLabel.text = String(moderatorObject.username);
        }
        
        //lets show category of moderator
        if (moderatorObject.categoryId == 0 || moderatorObject.miscStatus == 0) {
            cell.moderatorCategory.isHidden = true
        } else {
            cell.moderatorCategory.isHidden = false
           
            let nameWidth = cell.profileLabel.intrinsicContentSize.width;
            cell.moderatorCategory.setTitle(moderatorCategoriesMap[moderatorObject.categoryId]!.title, for: .normal);
            
            cell.moderatorCategory.frame = CGRect.init(x: cell.moderatorCategory.frame.origin.x, y: cell.moderatorCategory.frame.origin.y, width: cell.moderatorCategory.intrinsicContentSize.width, height: cell.moderatorCategory.frame.height);
            
            if (moderatorTitleColors[moderatorCategoriesMap[moderatorObject.categoryId]!.title] != nil) {
                
                cell.moderatorCategory.backgroundColor =  moderatorTitleColors[moderatorCategoriesMap[moderatorObject.categoryId]!.title]
            }
            
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
        } else {
             cell.emailLabel.text = ""
        }
        
        if (moderatorObject.phoneNumber != nil) {
            cell.phoneNumberLabel.text = String(moderatorObject.phoneNumber)
        } else{
            cell.phoneNumberLabel.text = "";
        }
        
        //User is Accepted
        if(moderatorObject.miscStatus == 1) {
            cell.acceptActionBtn.isHidden = true
            cell.removeActionBtn.isHidden = false
            cell.enableDisableModSwitch.isHidden = false
            
            cell.enableDisableModSwitch.tag = Int(moderatorObject.userId);
            cell.enableDisableModSwitch.addTarget(self, action: #selector(moderatorSwitchPressed), for: .valueChanged);
            
            if (moderatorObject.status == 0) {
                cell.enableDisableModSwitch.setOn(false, animated: false);
            } else {
                cell.enableDisableModSwitch.setOn(true, animated: false);
            }
            
            cell.removeActionBtn.tag = Int(moderatorObject.userId);
            cell.removeActionBtn.addTarget(self, action: #selector(removeActionPressed), for: .touchUpInside)
            
            let nameTapGestureRecognizer = UserNameTapGesture.init(target: self, action: #selector(moderatorNamePressed(sender:)));
            nameTapGestureRecognizer.user = moderatorObject;
            cell.moderatorProfileContainerView.addGestureRecognizer(nameTapGestureRecognizer)
        } else {
            cell.acceptActionBtn.isHidden = false
            cell.removeActionBtn.isHidden = true
            cell.enableDisableModSwitch.isHidden = true
            cell.acceptActionBtn.tag = Int(moderatorObject.userId)
            cell.acceptActionBtn.addTarget(self, action: #selector(acceptActionPressed), for: .touchUpInside)
        }
        
        if (moderatorObject.moderatorStatus == 1) {
            cell.enableDisableModSwitch.isOn = true;
        } else {
            cell.enableDisableModSwitch.isOn = false;
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

    func updateModeratorCategory() {
        var postData = [String: Any]();
        postData["user_id"] = self.loggedInUser.userId
        postData["moderator_id"] = selectedModerator.userId;
        postData["category_id"] = selectedModeratorCat.moderatorCategoryId
        postData["timestamp"] = Int64(Date().timeIntervalSince1970 * 1000.0)
        let jsonURL = "user/update_moderator_category/format/json";
        
        self.activityIndicator.startAnimating();

        UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
            print(response)
            self.activityIndicator.stopAnimating();
            let window = UIApplication.shared.keyWindow!
            for uiview in window.subviews {
                if (uiview is AssignModeratorCategoryView) {
                    uiview.removeFromSuperview();
                    break;
                }
            }
            self.selectedModeratorCat = nil;
            self.loadModeratorData();
        });
    }
    @objc func removeActionPressed(sender: UIButton) {
        
        let alert = UIAlertController.init(title: "Delete this moderator.", message: "", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil));
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(response) in
        
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
            
        }));
        self.present(alert, animated: true)
    }
    
    @objc func acceptActionPressed(sender: UIButton) {
        
        selectedPendingModeratorId = sender.tag;
        openCategoryDropDown();
        /*var postData = [String: Any]();
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
            print(sender.tag)*/
    }
    
    @objc func closePopupBtnPressed() {
        let window = UIApplication.shared.keyWindow!
        for uiview in window.subviews {
            if (uiview is AssignModeratorCategoryView) {
                uiview.removeFromSuperview();
                break;
            }
        }
        selectedModeratorCat = nil;
    }
    
    @objc func moderatorSwitchPressed(sender: UISwitch) {
        
        var status: Int8 = 0;
        if (sender.isOn) {
            status = 1;
        }
        updateModeratorStatus(moderatorId: sender.tag, status: status);
    }
    
    @objc func saveModeratorCatBtnPressed() {
        
        if (selectedModeratorCat != nil) {
            
            if (selectedModerator != nil) {
                
                updateModeratorCategory();
                
            } else {
                var approvePostData = [String: Any]();
                approvePostData["user_id"] = self.loggedInUser.userId
                approvePostData["moderator_id"] = selectedPendingModeratorId
                approvePostData["is_approved"] = "1"
                approvePostData["timestamp"] = Int64(Date().timeIntervalSince1970 * 1000.0)
                approvePostData["category_id"] = selectedModeratorCat.moderatorCategoryId;
                let jsonURL = "user/approve_moderator/format/json";
                
                self.activityIndicator.startAnimating();

                let window = UIApplication.shared.keyWindow!
                for uiview in window.subviews {
                    if (uiview is AssignModeratorCategoryView) {
                        uiview.removeFromSuperview();
                        break;
                    }
                }
                selectedModeratorCat = nil;
                UserService().postDataMethod(jsonURL: jsonURL,postData:approvePostData,complete:{(response) in
                    print(response)
                    self.activityIndicator.stopAnimating();
                    self.loadModeratorData();
                });
            }
        } else {
            showAlert(title: "Alert", message: "Please choose category from the dropdown")
        }
    }
    
    @objc func dropdownBarPressed() {
        
        var height = 0;
        for subView in assignModeratorCategoryView.categoryScrollView.subviews {
            subView.removeFromSuperview();
        }
        if (assignModeratorCategoryView.categoryScrollView.isHidden == false) {
            assignModeratorCategoryView.categoryScrollView.isHidden = true;
        } else {
            for moderatorCat in moderatorCategories {
                let assignModeratorCategoryItemView = AssignModeratorCategoryView.instanceDropDownItemAlertFromNib() as! AssignModeratorCategoryView;
                assignModeratorCategoryItemView.frame = CGRect.init(x: 0, y: height, width: 245, height: 35);
                assignModeratorCategoryItemView.dropDownCategoryLabel.text = moderatorCat.title!;
               
                let dropDownTapGesture = DropDownTapGesture.init(target: self, action: #selector(dropDownItemPressed(sender:)))
                dropDownTapGesture.moderatorCategory = moderatorCat; assignModeratorCategoryItemView.addGestureRecognizer(dropDownTapGesture);
                assignModeratorCategoryView.categoryScrollView.addSubview(assignModeratorCategoryItemView);
                
                height = height +  35;
            }
            //assignModeratorCategoryView.categoryScrollView.frame = CGRect.init(x: assignModeratorCategoryView.categoryScrollView.frame.origin.x, y: self.view.frame.height/2 + 20
                //, width: assignModeratorCategoryView.categoryScrollView.frame.width, height: assignModeratorCategoryView.categoryScrollView.frame.height);
            assignModeratorCategoryView.categoryScrollView.contentSize.height = CGFloat(height);
            assignModeratorCategoryView.categoryScrollView.isHidden = false;
        }
    }
    
    @objc func dropDownItemPressed(sender: DropDownTapGesture) {
        selectedModeratorCat = sender.moderatorCategory;
        assignModeratorCategoryView.dropDownCategoryLabel.text = selectedModeratorCat?.title;
        assignModeratorCategoryView.categoryScrollView.isHidden = true;
    }
    
    @objc func moderatorNamePressed(sender: UserNameTapGesture) {
        selectedModerator = sender.user;
        selectedPendingModeratorId = Int(selectedModerator.userId);
        openCategoryDropDown();
        
    }
    
}

class DropDownTapGesture : UITapGestureRecognizer {
    var moderatorCategory: ModeratorCategory!;
}

class UserNameTapGesture : UITapGestureRecognizer {
    var user: User!;
}


