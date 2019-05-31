//
//  ModeratorViewController.swift
//  precastr
//
//  Created by Macbook on 22/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class ModeratorViewController: UIViewController {
  
    @IBOutlet weak var moderatorList: UITableView!
    var moderatorBool : Bool!
    var loggedInUser : User!
    var moderatorDto : [ModeratorsDto] = [ModeratorsDto]()
    var userListApproved : [User] = [User]()
    var userListPending : [User] = [User]()
    
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


