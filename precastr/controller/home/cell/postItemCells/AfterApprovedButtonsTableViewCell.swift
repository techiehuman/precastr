//
//  AfterApprovedButtonsTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 16/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit
import EasyTipView

class AfterApprovedButtonsTableViewCell: UITableViewCell, EasyTipViewDelegate {

    @IBOutlet weak var postModeratorsBtn: UIButton!;
    @IBOutlet weak var deleteBtn: UIButton!;
    @IBOutlet weak var callButtonBtn: UIButton!;
    @IBOutlet weak var facebookInfoBtn: UIButton!;
    @IBOutlet weak var sharePostBtn: UIButton!;
    
    var viewController : UIViewController!;
    var easyToolTip: EasyTipView!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        deleteBtn.roundBtn();
        callButtonBtn.roundBtn();
        facebookInfoBtn.roundBtn();
        sharePostBtn.roundBtn();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func publishInfoButtonPressed(_ sender: Any) {
        
        if (self.easyToolTip == nil) {
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = UIFont(name: "VisbyCF-Regular", size: 14)!
            preferences.drawing.textAlignment  = .left;
            preferences.drawing.foregroundColor = UIColor.white
            preferences.drawing.backgroundColor = UIColor.init(red: 12/255, green: 111/255, blue: 233/255, alpha: 1);
            
            preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top;
            preferences.drawing.cornerRadius = 4;
            let text = "\u{2022} If you are posting to FB and your post contains images & content, hit the \"Push to FB\" button, a window opens --> tap in the text box --> select \"Paste\" option -->  follow the on screen instructions to publish.\n\n\u{2022} And if your post contains only images OR only content, simply hit the \"Push to FB\" button --> follow the on screen instructions";
            
            self.easyToolTip = EasyTipView(text: text, preferences: preferences, delegate: self)
            self.easyToolTip.show(animated: true, forView: facebookInfoBtn, withinSuperview: self.viewController.view)
            
            if (viewController is HomeV2ViewController) {
                //(viewController as! HomeV2ViewController).postsTableView.isScrollEnabled = false;
                 (viewController as! HomeV2ViewController).postsTableView.alwaysBounceVertical = false;
            }
        } else {
            self.easyToolTip.dismiss();
            self.easyToolTip = nil;
            if (viewController is HomeV2ViewController) {
                //(viewController as! HomeV2ViewController).postsTableView.isScrollEnabled = true;
                if (viewController is HomeV2ViewController) {
                    (viewController as! HomeV2ViewController).postsTableView.alwaysBounceVertical = true;
                }
            }
        }
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        tipView.dismiss();
        
        if (viewController is HomeV2ViewController) {
            (viewController as! HomeV2ViewController).postsTableView.alwaysBounceVertical = true;
        }
    }
    
}
