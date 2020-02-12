//
//  CasterViewTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 12/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class CasterViewTableViewCell: UITableViewCell {

    @IBOutlet weak var postTopView: UIView!
    
    var pushViewController: UIViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func postDescriptionPressed(sender: MyTapRecognizer){
    
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunicationViewController") as! CommunicationViewController;
        viewController.post = sender.post;
         pushViewController.navigationController?.pushViewController(viewController, animated: true);
    }
    
    func populateCasterTopView(post: Post) -> CasterPostTopView {
        
        let editButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(postDescriptionPressed(sender:)));
        editButtonTapRecognizer.post = post;

        let casterPostTopView:CasterPostTopView = Bundle.main.loadNibNamed("CasterPostTopView", owner: self, options: nil)?.first as! CasterPostTopView;
        
        casterPostTopView.viewDetailsBtn.layer.cornerRadius = 4;
        casterPostTopView.viewDetailsBtn.backgroundColor = blueLinkColor;
        
        //Setting Date of Post
        casterPostTopView.postDateLbl.text = Date().ddspEEEEcmyyyy(dateStr: post.createdOn);
        casterPostTopView.postDateLbl.frame = CGRect.init(x: (self.contentView.frame.width -  casterPostTopView.postDateLbl.intrinsicContentSize.width - 15), y: casterPostTopView.postDateLbl.frame.origin.y, width: casterPostTopView.postDateLbl.intrinsicContentSize.width, height: casterPostTopView.postDateLbl.frame.height);
        
        //Setting Status of Post
        var status = "";
        for postStatus in postStatusList {
            if (postStatus.postStatusId == post.postStatusId) {
                status = postStatus.title;
            }
        }
        
        let pipe = " |"
        casterPostTopView.postStatusLbl.text = "\((status))\(pipe)"
        casterPostTopView.postStatusLbl.frame = CGRect.init(x: casterPostTopView.postDateLbl.frame.origin.x - (casterPostTopView.postStatusLbl.intrinsicContentSize.width + 5), y: casterPostTopView.postStatusLbl.frame.origin.y, width: casterPostTopView.postStatusLbl.intrinsicContentSize.width, height: casterPostTopView.postStatusLbl.frame.height);
        
        //Setting Status Image of Post
        var imageStatus = "";
        if (pushViewController is HomeViewController) {
            imageStatus = (pushViewController as! HomeViewController).adapterCasterGetPostStatusImage(status: status);
        } else if (pushViewController is ArchieveViewController) {
            imageStatus = (pushViewController as! ArchieveViewController).adapterCasterGetPostStatusImage(status: status);
        }
        casterPostTopView.postStatusImg.image = UIImage.init(named: imageStatus)
        casterPostTopView.postStatusImg.frame = CGRect.init(x: casterPostTopView.postStatusLbl.frame.origin.x - ( casterPostTopView.postStatusImg.frame.width + 10), y: casterPostTopView.postStatusImg.frame.origin.y, width: casterPostTopView.postStatusImg.frame.width, height: casterPostTopView.postStatusImg.frame.height)
        
        casterPostTopView.viewDetailsBtn.addGestureRecognizer(editButtonTapRecognizer);
        return casterPostTopView;
    }
    
}
