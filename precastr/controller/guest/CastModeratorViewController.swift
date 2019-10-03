//
//  CastModeratorViewController.swift
//  precastr
//
//  Created by Macbook on 13/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI

class CastModeratorViewController: UIViewController, CNContactPickerDelegate, MFMessageComposeViewControllerDelegate {
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    @IBOutlet weak var addSelectedContactsButton: UIButton!
    var loggedInUser : User!
    var contactsSelected = [String]();
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var browseContacts: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func browseContactsPressed(_ sender: Any) {
        /*let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)*/
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
    
    
    @IBAction func addSelectedContsctsBtnPressed(_ sender: Any) {
        
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
           
            print(response);
        });
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Hey! I'm using a cool app called preCastr and I’d like you to be my moderator cick on this link to download he free app and get going \n https://www.precastr.com"
            controller.recipients = self.contactsSelected
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            let message = "Requests to moderators sent!"
            let alert = UIAlertController.init(title: "Success", message: message, preferredStyle: .alert);
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
            self.present(alert, animated: true)
            //self.navigationController?.popToRootViewController(animated: false);
            let homePageViewController: HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController;
             //self.window?.rootViewController = homePageViewController
            self.navigationController?.pushViewController(homePageViewController, animated: true);
        }
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
        
        if (self.contactsSelected.count > 0) {
            self.addSelectedContactsButton.isHidden = false
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
}
