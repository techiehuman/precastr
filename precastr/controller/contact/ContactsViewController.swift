//
//  ContactsViewController.swift
//  precastr
//
//  Created by mandeep singh on 30/09/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import ContactsUI

protocol ModeratorViewControllerDelegate {
    func contactsDoneButtonPressed(userContactItems: [UserContactItem]);
}
class ContactsViewController: UIViewController, UITextFieldDelegate {

    private var userContactItems: [UserContactItem] = [UserContactItem]();
    private var filteredContacts: [UserContactItem] = [UserContactItem]();
    private var userContactSelected = [String: UserContactItem]();
    var moderatorViewControllerDelegte: ModeratorViewControllerDelegate!;
    
    @IBOutlet weak var contactUITableView: UITableView!

    @IBOutlet weak var txtSearchBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contactUITableView.register(UINib.init(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell");
        txtSearchBox.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setUpNavigationBarItems();
        getContacts();
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func getContacts() {
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: Error?) -> Void in
                if authorized {
                    self.retrieveContactsWithStore(contactStore: store);
                }
            });
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.retrieveContactsWithStore(contactStore: store);
        }
    }

    func retrieveContactsWithStore(contactStore: CNContactStore) {
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey
            ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                //contacts.append(contact)
                let userContactItem = UserContactItem();
                for phoneNumber in contact.phoneNumbers {
                    
                    if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
                        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                        print("\(contact.givenName) \(contact.familyName) tel:\(localizedLabel) -- \(number.stringValue), email: \(contact.emailAddresses)")
                        
                        userContactItem.name = contact.givenName;
                        userContactItem.phone = number.stringValue;
                    }
                }
                if(userContactItem.phone != nil){
                    self.userContactItems.append(userContactItem);
                    self.filteredContacts.append(userContactItem);
                }
                //print(contacts)
                DispatchQueue.main.async{
                    self.contactUITableView.reloadData();
                }
            }
        } catch {
            print("unable to fetch contacts")
        }
    }
    
    func getFilteredContacts(searchtext: String) {
        
        if (searchtext == "") {
            self.filteredContacts = self.userContactItems;
        } else {
            self.filteredContacts = [UserContactItem]();
            for userContactItem in self.userContactItems {
                
                if (userContactItem.name.contains(searchtext)) {
                    self.filteredContacts.append(userContactItem);
                }
            }
        }
        self.contactUITableView.reloadData();
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        getFilteredContacts(searchtext: textField.text!)
    }
    
    @objc func contactItemPressed(sender: MyGestureListener) {
        if (userContactSelected[sender.userContactItem.phone] != nil) {
            userContactSelected.removeValue(forKey: sender.userContactItem.phone);
        } else {
            userContactSelected[sender.userContactItem.phone] = sender.userContactItem;
        }
        self.contactUITableView.reloadData();
    }
    func setUpNavigationBarItems() {
        
        let cancelButton = UIButton();
   
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: UIControlEvents.touchUpInside)
        cancelButton.frame = CGRect.init(x: 0, y:0, width: 16.73, height: 10.89);
        
        let barButton = UIBarButtonItem(customView: cancelButton)
        navigationItem.leftBarButtonItem = barButton;
        
        
        let doneButton = UIButton();
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonPressed), for: UIControlEvents.touchUpInside)
        doneButton.frame = CGRect.init(x: 0, y:0, width: 20, height: 20);
        
        let homeBarButton = UIBarButtonItem(customView: doneButton)
        
        navigationItem.rightBarButtonItem = homeBarButton;
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
    }
    @objc func cancelButtonPressed(){
        self.navigationController?.popViewController(animated: true);
    }
    @objc func doneButtonPressed(){
        
        var contactsList = [UserContactItem]();
        for phoneKey in userContactSelected.keys {
            contactsList.append(userContactSelected[phoneKey]!)
        }
        moderatorViewControllerDelegte.contactsDoneButtonPressed(userContactItems: contactsList);
        
        self.navigationController?.popViewController(animated: true);
    }
    class MyGestureListener: UITapGestureRecognizer {
        var userContactItem: UserContactItem!;
    }
}
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredContacts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell;
        
        let userContactItem = self.filteredContacts[indexPath.row];
        
        cell.contactNameLbl.text = userContactItem.name;
        cell.contactPhoneLbl.text = userContactItem.phone;
        
        if (userContactItem.phone != nil && userContactSelected[userContactItem.phone] != nil) {
            cell.checkBox.backgroundColor = UIColor.green;
        } else {
            cell.checkBox.backgroundColor = UIColor.gray;
        }
        
        var tapGesture = MyGestureListener.init(target: self, action: #selector(contactItemPressed(sender:)));
        tapGesture.userContactItem = userContactItem;
        cell.contactItemView.addGestureRecognizer(tapGesture);
        //cell.checkBox.addGestureRecognizer(tapGesture);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
}
