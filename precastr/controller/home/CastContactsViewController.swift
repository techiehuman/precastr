//
//  CastContactsViewController.swift
//  precastr
//
//  Created by mandeep singh on 19/10/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

enum CastContactListType {case CallList,ModeratorList}

class CastContactsViewController: UIViewController {

    @IBOutlet weak var moderatorContactsTableView: UITableView!
    
    var post : Post!;
    var castContacts: [User]!;
    var castContactListType: CastContactListType!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moderatorContactsTableView.register(UINib.init(nibName: "PostItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostItemTableViewCell");
        moderatorContactsTableView.register(UINib.init(nibName: "CastContactTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CastContactTableViewCell");
        moderatorContactsTableView.register(UINib.init(nibName: "CastModeratorTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CastModeratorTableViewCell");
        
        moderatorContactsTableView.reloadData();
        setUpNavigationBarItems();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBarItems();
    }
    func setUpNavigationBarItems() {
        
        let backButton = UIButton();
        backButton.setImage(UIImage.init(named: "left-arrow"), for: .normal);
        backButton.addTarget(self, action: #selector(backButtonPressed), for: UIControlEvents.touchUpInside)
        backButton.frame = CGRect.init(x: 0, y:0, width: 20, height: 15);
        
        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton;
        
        if (castContactListType == CastContactListType.CallList) {
            self.title = "Contact Moderator";
        } else {
            self.title = "Moderator List";
        }
    }
    @objc func backButtonPressed(){
        self.navigationController?.popViewController(animated: true);
    }
}

extension CastContactsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (castContactListType == CastContactListType.CallList) {
            return castContacts.count + 1;
        } else {
            return castContacts.count;
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (castContactListType == CastContactListType.CallList) {
            if (indexPath.row == 0) {
                let cell: PostItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostItemTableViewCell", for: indexPath) as! PostItemTableViewCell;
                cell.post = post;
                cell.pushViewController = self;
                cell.post = post
                cell.postRowIndex = indexPath.row;
                cell.totalPosts = 1;
                return cell;
            }
            let castContact = castContacts[indexPath.row - 1];
            let cell: CastContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CastContactTableViewCell", for: indexPath) as! CastContactTableViewCell;
            
            for uiTextNameView in cell.subviews {
                if (uiTextNameView.tag == indexPath.row) {
                    uiTextNameView.removeFromSuperview();
                }
            }
            if (castContact.profilePic == nil || castContact.profilePic == "") {
                cell.moderatorProfilePic.image = UIImage.init(named: "Moderate Casts");
                cell.moderatorProfilePic.isHidden = true;
                cell.addSubview(self.showAlphabetsView(frame: cell.moderatorProfilePic.frame, name: castContact.name, rowId: indexPath.row));
            } else {
                cell.moderatorProfilePic.isHidden = false;
                cell.moderatorProfilePic.sd_setImage(with: URL.init(string: castContact.profilePic), placeholderImage: UIImage.init(named: "Moderate Casts"),  completed: nil);
            }
            
            cell.moderatorName.text = castContact.name;
            if (castContact.phoneNumber == nil || castContact.phoneNumber == "") {
                cell.moderatorPhone.text = "Not Available"
            } else {
                cell.moderatorPhone.text = "\(castContact.countryCode!) \(castContact.phoneNumber!)";
            }
            return cell;
            
        } else {
            
            let castContact = castContacts[indexPath.row];

            let cell: CastModeratorTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CastModeratorTableViewCell", for: indexPath) as! CastModeratorTableViewCell;
            
            for uiTextNameView in cell.subviews {
                if (uiTextNameView.tag == indexPath.row) {
                    uiTextNameView.removeFromSuperview();
                }
            }
            
            var isApprovedByModerator = false;
            
            if (castContact.userId == post.approvedByUserId) {
                isApprovedByModerator = true;
            }
            if (!isApprovedByModerator) {
                if (castContact.profilePic == nil || castContact.profilePic == "") {
                    cell.moderatorProfilePic.isHidden = true;
                    cell.addSubview(self.showAlphabetsView(frame: cell.moderatorProfilePic.frame, name: castContact.name, rowId: indexPath.row));
                } else {
                    cell.moderatorProfilePic.isHidden = false;
                    cell.moderatorProfilePic.sd_setImage(with: URL.init(string: castContact.profilePic), placeholderImage: UIImage.init(named: "Moderate Casts"),  completed: nil);
                }
            } else {
                if (castContact.profilePic == nil || castContact.profilePic == "") {
                    cell.moderatorProfilePic.isHidden = true;
                    let aphabetView = self.showAlphabetsView(frame: cell.moderatorProfilePic.frame, name: castContact.name, rowId: indexPath.row);
                    aphabetView.layer.borderColor = PrecasterColors.themeColor.cgColor;
                    aphabetView.layer.borderWidth = 2;
                    aphabetView.layer.masksToBounds = true;
                    aphabetView.layer.cornerRadius = aphabetView.bounds.width / 2
                    cell.addSubview(aphabetView);
                    
                } else {
                    
                    cell.moderatorProfilePic.isHidden = false;
                    cell.moderatorProfilePic.sd_setImage(with: URL.init(string: castContact.profilePic), placeholderImage: UIImage.init(named: "Moderate Casts"),  completed: nil);
                    cell.moderatorProfilePic.layer.borderColor = PrecasterColors.themeColor.cgColor;
                    cell.moderatorProfilePic.layer.borderWidth = 2;
                    cell.moderatorProfilePic.layer.masksToBounds = true;
                    cell.moderatorProfilePic.layer.cornerRadius = cell.moderatorProfilePic.bounds.width / 2
                }
            }
            
            print("Moderator Name : \(castContact.name!)")
            cell.moderatorName.text = castContact.name;
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (castContactListType == CastContactListType.CallList) {
            let castContact = castContacts[indexPath.row];
            print(indexPath.row)
            print(castContact.phoneNumber!)
            if let url = URL(string: "tel://"+castContact.countryCode!+castContact.phoneNumber! ?? "0"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (castContactListType == CastContactListType.CallList) {
            if (indexPath.row == 0) {
                var height: CGFloat = 0;
                height = height + getHeightOfPostDescripiton(contentView: self.view, postDescription: post.postDescription) + CGFloat(PostRowsHeight.Post_Description_Row_Height);
                if (post.postImages.count != 0) {
                    height = height + CGFloat(PostRowsHeight.Post_Gallery_Row_Height);
                }
                
                return CGFloat(height);
            }
        }
        return 60;
    }
}
