//
//  CommunicationViewController.swift
//  precastr
//
//  Created by Macbook on 14/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class CommunicationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.pendingUIView.roundView()
        self.approvedUIView.roundView()
        self.rejectedUIView.roundView()
        self.underUIView.roundView()
    }

    @IBOutlet weak var pendingUIView : UIView!
    @IBOutlet weak var approvedUIView : UIView!
    @IBOutlet weak var underUIView : UIView!
    @IBOutlet weak var rejectedUIView : UIView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
