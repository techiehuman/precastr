//
//  UpdatePhoneNumberViewController.swift
//  precastr
//
//  Created by mandeep singh on 22/10/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import CoreTelephony

protocol UpdatePhoneNumberTableViewCellProtocol {
    func countryCodeValueSelected(country : CountryCodeService);
}
class UpdatePhoneNumberViewController: UIViewController, UpdatePhoneNumberViewControllerDelegate {    

    @IBOutlet weak var UpdatePhoneNumberTableView: UITableView!
   
    var updatePhoneNumberProtocol: UpdatePhoneNumberTableViewCellProtocol!;
    var loggedInUser : User!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    var countryPhoneCode: String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        activityIndicator.center = view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge;
        view.addSubview(activityIndicator);
        
        
        UpdatePhoneNumberTableView.register(UINib.init(nibName: "UpdatePhoneNumberTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UpdatePhoneNumberTableViewCell");
        
        loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.subscriberCellularProvider {
            print("country code is: " + carrier.mobileCountryCode!);
            //will return the actual country code
            print("ISO country code is: " + carrier.isoCountryCode!);

            let countries = CountryCodeService().getLibraryMasterCountriesEnglish();
            for countryCodeService in countries {
                if (countryCodeService.getNameCode().lowercased() == carrier.isoCountryCode?.lowercased()) {
                    countryPhoneCode = countryCodeService.getPhoneCode();
                    break;
                }
            }
            UpdatePhoneNumberTableView.reloadData();
        }
    }
    
    func updatePhoneNumber(postData: [String: Any]) {
        
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
        let jsonURL = "user/update_user_profile/format/json";
        UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
            print(response)
            let status = Int(response.value(forKey: "status") as! String)!
            if (status == 0) {
                let message = response.value(forKey: "message") as! String;
                self.showAlert(title: "Error", message: message);
                
            } else {
                self.activityIndicator.stopAnimating();
                UIApplication.shared.endIgnoringInteractionEvents();
                
                let userDict = response.value(forKey: "data") as! NSDictionary;
                print(userDict)
                let user = User().getUserData(userDataDict: userDict);
                user.loadUserDefaults();
                let data = response.value(forKey: "data") as! NSDictionary;
                let allStepsDone = Int32(data.value(forKey: "user_cast_setting_id") as! String)
                let userDefaultRole = Int8((data.value(forKey: "default_role") as? String)!) ?? nil
                if (userDefaultRole == 0) {
                    
                    let viewController: UserTypeActionViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserTypeActionViewController") as! UserTypeActionViewController;
                    self.navigationController?.pushViewController(viewController, animated: true);
                    print(self.navigationController);
                    
                } else if(userDefaultRole == 1){//If user type is casetr then we will let him choose the
                    // Posts cast type
                    if (allStepsDone == 0) {
                        let viewController: PrecastTypeSectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "PrecastTypeSectionViewController") as! PrecastTypeSectionViewController;
                        self.navigationController?.pushViewController(viewController, animated: true);
                    } else {
                        UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController()
                    }
                    
                } else if (userDefaultRole == 2){//If user is moderator
                    //Then we will be sending him to home screen.
                    UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController()
                }
            }
            
        });
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func countriesDoneButtonPressed(country : CountryCodeService){
        countryPhoneCode = country.getPhoneCode();
        UpdatePhoneNumberTableView.reloadData();
    }

    func openCountryCodeList() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "CountryViewController") as! CountryViewController;
        viewController.updatePhoneNumberViewControllerDelegate = self;
        self.navigationController?.pushViewController(viewController, animated: true);
    }
}

extension UpdatePhoneNumberViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdatePhoneNumberTableViewCell") as! UpdatePhoneNumberTableViewCell;
        
        cell.updatePhoneNumberViewControllerDelegate = self;
        
        cell.countryCodelabel.text = countryPhoneCode;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height + 120);
    }
}
