//
//  CastContactsViewController.swift
//  precastr
//
//  Created by mandeep singh on 19/10/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class CastContactsViewController: UIViewController {

    @IBOutlet weak var moderatorContactsTableView: UITableView!
    
    @IBOutlet weak var postDescriptionLabel: UILabel!
    var postDescription : String!;
    var castContacts: [User]!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moderatorContactsTableView.register(UINib.init(nibName: "CastContactTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CastContactTableViewCell");
        print(postDescription)
        let descriptionText : String = (postDescription.count < 40) ? postDescription : String(postDescription.prefix(40)) + "..."
        print(descriptionText)
        postDescriptionLabel.text =  descriptionText as! String;
        moderatorContactsTableView.reloadData();
        setUpNavigationBarItems();
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    func setUpNavigationBarItems() {
        
        let cancelButton = UIButton();
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: UIControlEvents.touchUpInside)
        cancelButton.frame = CGRect.init(x: 0, y:0, width: 16.73, height: 10.89);
        
        let barButton = UIBarButtonItem(customView: cancelButton)
        navigationItem.leftBarButtonItem = barButton;
        
        self.navigationController?.navigationItem.title = "Cast Moderators"
    }
    @objc func cancelButtonPressed(){
        self.navigationController?.popViewController(animated: true);
    }


}

extension CastContactsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return castContacts.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let castContact = castContacts[indexPath.row];
        
        let cell: CastContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CastContactTableViewCell", for: indexPath) as! CastContactTableViewCell;
        
        if (castContact.profilePic == nil) {
            cell.moderatorProfilePic.image = UIImage.init(named: "Moderate Casts");
        } else {
            cell.moderatorProfilePic.sd_setImage(with: URL.init(string: castContact.profilePic), placeholderImage: UIImage.init(named: "Moderate Casts"),  completed: nil);
        }
        
        cell.moderatorName.text = castContact.name;
        if (castContact.phoneNumber == nil || castContact.phoneNumber == "") {
            cell.moderatorPhone.text = "Not Available"
        } else {
            cell.moderatorPhone.text = "\(castContact.countryCode!) \(castContact.phoneNumber!)";
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let castContact = castContacts[indexPath.row];
        print(indexPath.row)
        print(castContact.phoneNumber!)
        if let url = URL(string: "tel://"+castContact.countryCode+castContact.phoneNumber! ?? "0"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
}
