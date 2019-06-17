//
//  CommunicationViewController.swift
//  precastr
//
//  Created by Macbook on 14/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class CommunicationViewController: UIViewController {

    var post: Post!;
    @IBOutlet weak var communicationTableView: UITableView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
    override func viewDidLoad() {
        super.viewDidLoad()

          communicationTableView.register(UINib.init(nibName: "LeftCommunicationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "LeftCommunicationTableViewCell");
          communicationTableView.register(UINib.init(nibName: "RightCommunicationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "RightCommunicationTableViewCell");
        // Do any additional setup after loading the view.
        self.pendingUIView.roundView()
        self.approvedUIView.roundView()
        self.rejectedUIView.roundView()
        self.underUIView.roundView()
        
        
        self.pendingUIView.layer.borderWidth  = 1
        self.pendingUIView.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        
        self.approvedUIView.layer.borderWidth  = 1
        self.approvedUIView.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        
        self.rejectedUIView.layer.borderWidth  = 1
        self.rejectedUIView.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        
        self.underUIView.layer.borderWidth  = 1
        self.underUIView.layer.borderColor = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        self.twitterBtn.layer.borderWidth = 1
        self.facebookBtn.layer.borderWidth = 1
        self.twitterBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor
        self.facebookBtn.layer.borderColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1).cgColor
    }

    @IBOutlet weak var pendingUIView : UIView!
    @IBOutlet weak var approvedUIView : UIView!
    @IBOutlet weak var underUIView : UIView!
    @IBOutlet weak var rejectedUIView : UIView!
    
    @IBOutlet weak var twitterBtn: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var facebookBtn: UIButton!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CommunicationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: LeftCommunicationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LeftCommunicationTableViewCell") as! LeftCommunicationTableViewCell;
        
        cell.communicationViewControllerDelegate = self;
        
        activityIndicator.center = cell.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge;
        cell.addSubview(activityIndicator);
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.height + 120);
    }
}
