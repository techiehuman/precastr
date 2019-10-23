//
//  CountryViewController.swift
//  precastr
//
//  Created by mandeep singh on 15/10/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

protocol SignupScreenViewControllerDelegate {
    func countriesDoneButtonPressed(country: CountryCodeService);
}
protocol EditProfileViewControllerDelegate {
    func countriesDoneButtonPressed(country: CountryCodeService);
}
protocol UpdatePhoneNumberViewControllerDelegate {
    func countriesDoneButtonPressed(country: CountryCodeService);
}
class CountryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var countryListTableView : UITableView!
    @IBOutlet weak var countryCancelLabel : UILabel!
    @IBOutlet weak var txtSearchBox: UITextField!

    var countries =  [CountryCodeService]();
    var allCountries = [CountryCodeService]();
    var signupScreenViewControllerDelegate : SignupScreenViewController!
    var editProfileViewControllerDelegate : EditProfileViewController!
    var updatePhoneNumberViewControllerDelegate : UpdatePhoneNumberViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.countryListTableView.register(UINib.init(nibName: "CountryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CountryTableViewCell");
         let cancelButtonTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(canceltButtonPressed));
        self.countryCancelLabel.addGestureRecognizer(cancelButtonTapGesture);
        
        txtSearchBox.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.loadCountriesData();
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
   
    @objc func canceltButtonPressed(){
        self.navigationController?.popViewController(animated: true);
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        getFilteredCounties(searchtext: textField.text!)
    }

    func loadCountriesData() {
        
        self.countries = CountryCodeService().getLibraryMasterCountriesEnglish();
        self.allCountries = CountryCodeService().getLibraryMasterCountriesEnglish();
        countries = countries.sorted(by: { $0.getName() < $1.getName() })
        self.countryListTableView.reloadData();
        
    }
    
    func getFilteredCounties(searchtext: String) {
        self.countries = [CountryCodeService]();
        if (searchtext.count == 0) {
            self.countries = self.allCountries;
        } else {
            for countryCodeService in self.allCountries {
                if (countryCodeService.getName().lowercased().contains(searchtext)) {
                    self.countries.append(countryCodeService);
                }
            }
        }
        countries = countries.sorted(by: { $0.getName() < $1.getName() })
        self.countryListTableView.reloadData();
    }
}
extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.countries.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let countryCodeService = countries[indexPath.row] as! CountryCodeService;
        
        let cell: CountryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell") as! CountryTableViewCell;
        
        cell.codeLabel.text = countryCodeService.phoneCode;
        cell.countryLabel.text = countryCodeService.name;

        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryCodeService = countries[indexPath.row] as! CountryCodeService;
        if(self.signupScreenViewControllerDelegate != nil){
             self.signupScreenViewControllerDelegate.countriesDoneButtonPressed(country: countryCodeService);
        }
        if(self.editProfileViewControllerDelegate != nil){
            self.editProfileViewControllerDelegate.countriesDoneButtonPressed(country: countryCodeService);
        }
        if(self.updatePhoneNumberViewControllerDelegate != nil){
            self.updatePhoneNumberViewControllerDelegate.countriesDoneButtonPressed(country: countryCodeService);
        }
        self.navigationController?.popViewController(animated: true);
        
        
    }
}
