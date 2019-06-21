//
//  PostTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 19/06/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postCellTableView: UITableView!
    
    var homeViewControllerDelegate: HomeViewController!;
    var post: Post!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postCellTableView.register(UINib.init(nibName: "CasterPostStatusTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CasterPostStatusTableViewCell");
        //postCellTableView.register(UINib.init(nibName: "PostDescriptionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostDescriptionTableViewCell");
        postCellTableView.register(UINib.init(nibName: "SinleLineDescTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SinleLineDescTableViewCell");
        postCellTableView.register(UINib.init(nibName: "DoubleLineDescTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DoubleLineDescTableViewCell");
        postCellTableView.register(UINib.init(nibName: "ThreeLineTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ThreeLineTableViewCell");
        postCellTableView.register(UINib.init(nibName: "FourLineTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FourLineTableViewCell");
        postCellTableView.register(UINib.init(nibName: "PostImageScrollTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostImageScrollTableViewCell");

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension PostTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CasterPostStatusTableViewCell") as! CasterPostStatusTableViewCell;
            cell.sourceImageFacebook.isHidden = false;
            cell.sourceImageTwitter.isHidden = false;
            
            var facebookIconHidden = true;
            var twitterIconHidden = true;
            if (self.post.socialMediaIds.count > 0) {
                
                for sourcePlatformId in self.post.socialMediaIds {
                    if(Int(sourcePlatformId) == homeViewControllerDelegate.social.socialPlatformId["Facebook"]){
                        facebookIconHidden = false;
                    }  else if(Int(sourcePlatformId) == homeViewControllerDelegate.social.socialPlatformId["Twitter"]) {
                        twitterIconHidden = false;
                    }
                }
            }
            
            if (twitterIconHidden == false && facebookIconHidden == false) {
                cell.sourceImageTwitter.isHidden = false;
                cell.sourceImageFacebook.isHidden = false;
            } else if (facebookIconHidden == false && twitterIconHidden == true) {
                //If twitter is not present then we will replace sourceImageTwitter image with facebook
                cell.sourceImageTwitter.isHidden = false;
                cell.sourceImageFacebook.isHidden = true;
                cell.sourceImageTwitter.image = UIImage.init(named: "facebook-group");
            } else if (twitterIconHidden == false && facebookIconHidden == true) {
                cell.sourceImageTwitter.isHidden = false;
                cell.sourceImageFacebook.isHidden = true;
                cell.sourceImageTwitter.image = UIImage.init(named: "twitter-group");
            }
            
            var imageStatus = ""
            var status = "";
            if(post.status == "Pending"){
                imageStatus = "pending-review"
                status = "Pending review"
            }else if(post.status == "Approved by moderator"){
                imageStatus = "approved"
                status = "Approved"
            }else if (post.status == "Rejected by moderator"){
                imageStatus = "rejected"
                status = "Rejected"
            }else if(post.status == "Pending with caster"){
                imageStatus = "under-review"
                status = "Under review"
            }
            else if(post.status == "Pending with moderator"){
                imageStatus = "under-review"
                status = "Under review"
            }        else if(status == ""){
                imageStatus = ""
            }
            // status = "dfsdf fdsdfs dsfsdfsdf"
            cell.statusImage.image = UIImage.init(named: imageStatus)
            let pipe = " |"
            cell.profileLabel.text = "\((status))\(pipe)"
            cell.dateLabel.text = Date().ddspEEEEcmyyyy(dateStr: post.createdOn)
            
            // Lets add ui labels in width.
            let totalWidthOfUIView = cell.statusImage.frame.width + cell.profileLabel.intrinsicContentSize.width + cell.dateLabel.intrinsicContentSize.width + 10;
            cell.postStatusDateView.frame = CGRect.init(x: cell.frame.width - (totalWidthOfUIView + 15), y: cell.postStatusDateView.frame.origin.y, width: totalWidthOfUIView, height: cell.postStatusDateView.frame.height);
            
            cell.statusImage.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20);
            cell.profileLabel.frame = CGRect.init(x: 25, y: 0, width: cell.profileLabel.intrinsicContentSize.width, height: 20);
            cell.dateLabel.frame = CGRect.init(x: (cell.profileLabel.intrinsicContentSize.width + cell.profileLabel.frame.origin.x + 5), y: 0, width: cell.dateLabel.intrinsicContentSize.width, height: 20);
            
            //Call this function
            let height = homeViewControllerDelegate.heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: cell.contentView.frame.width - 30)

            //This is your label
            for view in cell.labelView.subviews {
                view.removeFromSuperview();
            }
            let proNameLbl = UILabel(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.width - 30, height: height))
            var lblToShow = "\(post.postDescription)"
            
            if (height > 100) {
                proNameLbl.numberOfLines = 4
            } else {
                proNameLbl.numberOfLines = 0
            }
            
            proNameLbl.lineBreakMode = .byTruncatingTail
            let paragraphStyle = NSMutableParagraphStyle()
            //line height size
            paragraphStyle.lineSpacing = 2
            
            let attributes = [
                NSAttributedStringKey.font : UIFont(name: "VisbyCF-Regular", size: 16.0)!,
                NSAttributedStringKey.foregroundColor : UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1),
                NSAttributedStringKey.paragraphStyle: paragraphStyle]
            
            let attrString = NSMutableAttributedString(string: lblToShow)
            attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length));
            proNameLbl.attributedText = attrString;
            
            cell.labelView.addSubview(proNameLbl)
            
            return cell;
            
            /*case 1:
                
                let postHeight = homeViewControllerDelegate.heightForView(text: post.postDescription);
                if (postHeight < 20) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SinleLineDescTableViewCell") as! SinleLineDescTableViewCell;
                    cell.postDescription.text = self.post.postDescription;
                    return cell;
                } else if (postHeight > 20 && postHeight < 40) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleLineDescTableViewCell") as! DoubleLineDescTableViewCell;
                    cell.postDescription.text = self.post.postDescription;
                    return cell;
                } else if (postHeight > 40 && postHeight < 60) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ThreeLineTableViewCell") as! ThreeLineTableViewCell;
                    cell.postDescription.text = self.post.postDescription;
                    return cell;
                } else if (postHeight > 60) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FourLineTableViewCell") as! FourLineTableViewCell;
                    cell.postDescription.text = self.post.postDescription;
                    return cell;
                }
            */
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageScrollTableViewCell") as! PostImageScrollTableViewCell;
                
                if (self.post.postImages.count > 0) {
                    cell.imageGalleryScrollView.isHidden = false;
                    cell.imagesArray = [String]();
                    for postImg in post.postImages {
                        cell.imagesArray.append(postImg);
                    }
                } else {
                    cell.imageGalleryScrollView.isHidden = true;
                    cell.imagesArray = [String]();
                }
                
                cell.imageGalleryScrollView.frame = CGRect.init(x: cell.imageGalleryScrollView.frame.origin.x, y: 0, width: contentView.frame.width, height: cell.imageGalleryScrollView.frame.height)

                cell.setupSlideScrollView()
                cell.pageControl.numberOfPages = cell.imagesArray.count
                cell.pageControl.currentPage = 0
                cell.contentView.bringSubview(toFront: cell.pageControl)
                if(cell.imagesArray.count > 1){
                    cell.imageCounterView.isHidden = true // false
                    cell.totalCountImageLbl.text = " \(cell.imagesArray.count)";
                    cell.currentCountImageLbl.text = "1"
                } else {
                    cell.imageCounterView.isHidden = true
                }
                return cell;
        default:
            return UITableViewCell();
        }
        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            //return 50;
            
            let height = homeViewControllerDelegate.heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: contentView.frame.width - 30)
            
            return (50 + height)

         /*case 1:
           let postHeight = homeViewControllerDelegate.heightForView(text: self.post.postDescription) + 10;
            if (postHeight < 20) {
                return 25;
            } else if (postHeight > 20 && postHeight < 40) {
                return 50;
            } else if (postHeight > 40 && postHeight < 60) {
                return 75;
            } else if (postHeight > 60) {
                return 100;
            }
            return 100;*/
            
            //Call this function
            
        case 2:
            if (self.post.postImages.count > 0) {
                if (self.post.postImages.count == 1) {
                    return 440;
                }
                return (470);
            }
            return 0;
        default:
            return 0;
        }
    }
}
