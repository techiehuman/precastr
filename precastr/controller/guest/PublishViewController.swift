//
//  PublishViewController.swift
//  precastr
//
//  Created by Macbook on 03/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

import FBSDKShareKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKPlacesKit

class PublishViewController: UIViewController {

    @IBOutlet weak var sharingTitle: UITextField!
    
    @IBOutlet weak var sharingLink: UITextField!
    
    @IBAction func publishOnFB(_ sender: Any) {
        let urlImage = NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/0/0e/THSR_700T_Modern_High_Speed_Train.jpg")
        
       
        
       
       
        
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

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
