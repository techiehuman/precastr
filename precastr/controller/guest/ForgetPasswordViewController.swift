//
//  ForgetPasswordViewController.swift
//  precastr
//
//  Created by Cenes_Dev on 08/06/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var forgetPassTableView: UITableView!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        forgetPassTableView.register(UINib.init(nibName: "ForgetPasswordTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ForgetPasswordTableViewCell");

        
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
        self.view.addSubview(activityIndicator);
        
        self.hideKeyboadOnTapOutside();
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func forgotPasswordRequest(postData: [String: Any]) {
        
        self.activityIndicator.startAnimating();
        let jsonURL = "/user/forget_password/format/json";
        
        UserService().postDataMethod(jsonURL: jsonURL, postData: postData, complete: {(response) in
            
            self.activityIndicator.stopAnimating();
            print(response);
            let message = response.value(forKey: "message") as! String;

            let success = Int(response.value(forKey: "status") as! String)!
            
            if (success == 0) {
                self.showAlert(title: "Error", message: message);
            } else {
                let alert = UIAlertController.init(title: "Alert", message: message, preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(response) in
                    self.navigationController?.popViewController(animated: true);
                }));
                self.present(alert, animated: true)
            }
        });
    }
}

extension ForgetPasswordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ForgetPasswordTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ForgetPasswordTableViewCell") as! ForgetPasswordTableViewCell;
        cell.forgetPasswordCtrlDelegate = self;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height + 120);
    }
}
