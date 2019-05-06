//
//  TwitterPostViewController.swift
//  precastr
//
//  Created by Macbook on 26/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class TwitterPostViewController: UIViewController,UITextViewDelegate {

     @IBOutlet weak var postTextField: UITextView!
    var loggedInUser : User!
    override func viewDidLoad() {
        super.viewDidLoad()
       
            self.postTextField.delegate = self
            self.postTextField.text = "Please add text to be posted ..."
            self.postTextField.textColor = UIColor.lightGray
             loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        
        // Do any additional setup after loading the view.
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        print("A")
        if self.postTextField.textColor == UIColor.lightGray {
            self.postTextField.text = ""
            self.postTextField.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("B")
        if self.postTextField.text == "" {
            
            self.postTextField.text = "Placeholder text ..."
            self.postTextField.textColor = UIColor.lightGray
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBAction func facebookBtnClicked(_ sender: Any) {
    }
    
    @IBOutlet weak var twitterBtnClicked: UIButton!
    
    @IBAction func AddSocialMedia(_ sender: Any) {
    }
    
    
   
    @IBAction func postOnSocialPlatform(_ sender: Any) {
        let jsonURL = "posts/post_twitter_newpost/format/json"
        var postData : [String : Any] = [String : Any]()
        postData["post_text"] = self.postTextField.text
        postData["user_id"] = self.loggedInUser.userId
         UserService().postDataMethod(jsonURL: jsonURL,postData:postData,complete:{(response) in
            print(response)
            })
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
