//
//  TermsPageViewController.swift
//  precastr
//
//  Created by mandeep singh on 05/07/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import WebKit

class TermsPageViewController: UIViewController {

    enum WebViewRequest {case FQA, TermsAndConds}

    var webViewRequest: WebViewRequest!;

    @IBOutlet weak var termsWebView: UIView!

    // instance of WKWebView
    let wkWebView: WKWebView = {
        let v = WKWebView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false

        // add the WKWebView to the "holder" UIView
        termsWebView.addSubview(wkWebView)
        // pin to all 4 edges
        wkWebView.frame = termsWebView.bounds;


        var webViewUr: String = "";
        
        if (webViewRequest == WebViewRequest.FQA) {
            webViewUr = "http://precastr.com/faq-mobile.html";
            self.navigationItem.title = "FAQ"
            self.title = "FAQ"
        } else {
            webViewUr = "http://precastr.com/terms-and-conditions-mobile.html";
            self.navigationItem.title = "Terms and Conditions"
        }
        // Do any additional setup after loading the view.
        let url = NSURL (string: webViewUr);
        let request = NSURLRequest(url: url! as URL);
        wkWebView.load(request as URLRequest);
        
    }
     override func viewWillAppear(_ animated: Bool) {
        let backButton = UIButton();
        backButton.setImage(UIImage.init(named: "left-arrow"), for: .normal);
        backButton.addTarget(self, action: #selector(backButtonPressed), for: UIControl.Event.touchUpInside)
        backButton.frame = CGRect.init(x: 0, y:0, width: 20, height: 15);
        
        let barBackButton = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = barBackButton;
        //self.navigationItem.title = "Terms and Conditions";
        
        
        if let user_id = setting.value(forKey: "user_id") {
            let homeButton = UIButton();
            homeButton.setImage(UIImage.init(named: "top-home"), for: .normal);
            homeButton.addTarget(self, action: #selector(homeButtonPressed), for: UIControl.Event.touchUpInside)
            homeButton.frame = CGRect.init(x: 0, y:0, width: 20, height: 20);
            
            let homeBarButton = UIBarButtonItem(customView: homeButton)
            
            navigationItem.rightBarButtonItem = homeBarButton;
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true);
        //dismiss(animated: true, completion: nil)
    }
    @objc func homeButtonPressed() {
        UIApplication.shared.keyWindow?.rootViewController = HomeV2ViewController.MainViewController();
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
