//
//  ModeratorHomeTopTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 02/03/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class ModeratorHomeTopTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!;
    @IBOutlet weak var viewDetailsBtn: UIButton!;
    @IBOutlet weak var postOwnerName: UILabel!;
    @IBOutlet weak var postStatusView: UIView!;
    @IBOutlet weak var userNoImageView: UIView!;
    @IBOutlet weak var userNoImageViewLabel: UILabel!;

    var pushViewController: UIViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewDetailsBtn.roundEdgesBtn();
        profilePic.roundView();
        userNoImageView.roundView();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func populateModeratorTopView(cell: ModeratorHomeTopTableViewCell, post: Post) {
        
        cell.postOwnerName.text = post.name;
        if (post.profilePic == "") {
            cell.profilePic.isHidden = true;
            cell.userNoImageView.isHidden = false;
            let user = User();
            user.name = post.name;
            cell.userNoImageViewLabel.text = getNameInitials(name: user.name);

        } else {
            cell.profilePic.isHidden = false;
            cell.userNoImageView.isHidden = true;
            cell.profilePic.sd_setImage(with: URL.init(string: post.profilePic), placeholderImage: UIImage(named: "Moderate Casts"));
        }
        
        let editButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(postDescriptionPressed(sender:)));
               editButtonTapRecognizer.post = post;
        cell.viewDetailsBtn.addGestureRecognizer(editButtonTapRecognizer);
        
        createPostStatusView(cell: cell, post: post);
    }
    
    func createPostStatusView(cell: ModeratorHomeTopTableViewCell, post: Post) {
        
        for subView in cell.postStatusView.subviews {
            subView.removeFromSuperview();
        }
        
        let postDateLbl: UILabel = UILabel();
        let postStatusLbl: UILabel = UILabel();
        let postStatusImg: UIImageView = UIImageView();

         //Setting Status of Post
         var status = "";
         for postStatus in postStatusList {
             if (postStatus.postStatusId == post.postStatusId) {
                 status = postStatus.title;
                 break;
             }
         }
         
         
         //Setting Status Image of Post
         var imageStatus = "";
         if (pushViewController is HomeV2ViewController) {
             imageStatus = (pushViewController as! HomeV2ViewController).adapterCasterGetPostStatusImage(status: status);
         } else if (pushViewController is CommunicationViewController) {
            imageStatus = (pushViewController as! CommunicationViewController).adapterCasterGetPostStatusImage(status: status);
        } else if (pushViewController is ArchieveViewController) {
             imageStatus = (pushViewController as! ArchieveViewController).adapterCasterGetPostStatusImage(status: status);
        }
        
        postStatusImg.image = UIImage.init(named: imageStatus)
        postStatusImg.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20);
        cell.postStatusView.addSubview(postStatusImg);
        
        let pipe = " |"
        postStatusLbl.text = "\((status))\(pipe)"
        postStatusLbl.font = UIFont(name: "VisbyCF-Regular", size: 14.0);
        postStatusLbl.textColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1);     postStatusLbl.frame = CGRect.init(x: postStatusImg.frame.width + 5, y: 0, width: postStatusLbl.intrinsicContentSize.width, height: 20);
        cell.postStatusView.addSubview(postStatusLbl);

        //Setting Date of Post
         if (post.createdOnTimestamp == 0) {
             postDateLbl.text = Date().ddspEEEEcmyyyy(dateStr: post.createdOn);
         } else {
             var date = Date(timeIntervalSince1970: (Double(post.createdOnTimestamp) / 1000.0));
             var dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
             postDateLbl.text = Date().ddspEEEEcmyyyy(dateStr: dateFormatter.string(from: date));
         }
        postDateLbl.font = UIFont(name: "VisbyCF-Regular",
                                   size: 14.0)
        postDateLbl.textColor = UIColor(red: 12/255, green: 111/255, blue: 233/255, alpha: 1)

        postDateLbl.frame = CGRect.init(x: (postStatusLbl.frame.origin.x +   postStatusLbl.intrinsicContentSize.width + 10), y:0, width: postDateLbl.intrinsicContentSize.width, height: 20);
         cell.postStatusView.addSubview(postDateLbl);

    }
    
    @objc func postDescriptionPressed(sender: MyTapRecognizer) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunicationViewController") as! CommunicationViewController;
        viewController.post = sender.post;
         pushViewController.navigationController?.pushViewController(viewController, animated: true);
    }
}
