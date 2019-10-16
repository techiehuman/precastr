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

class CountryViewController: UIViewController {

    @IBOutlet weak var countryListTableView : UITableView!
    @IBOutlet weak var countryCancelLabel : UILabel!
    var countries =  [CountryCodeService]();
    var signupScreenViewControllerDelegate : SignupScreenViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.countryListTableView.register(UINib.init(nibName: "CountryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CountryTableViewCell");
         let cancelButtonTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(canceltButtonPressed));
        self.countryCancelLabel.addGestureRecognizer(cancelButtonTapGesture);
        self.loadCountriesData();
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
   
    @objc func canceltButtonPressed(){
        
       
    
        self.navigationController?.popViewController(animated: true);
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func loadCountriesData() {
        
        self.countries = CountryCodeService().getLibraryMasterCountriesEnglish();
        
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
        self.signupScreenViewControllerDelegate.countriesDoneButtonPressed(country: countryCodeService);
        self.navigationController?.popViewController(animated: true);
        
        
    }
}
