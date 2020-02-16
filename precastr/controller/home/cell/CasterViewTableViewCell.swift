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
    @IBOutlet weak var castOptionsView: UIView!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var imageGalleryScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

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
    
    @objc func deleteButtonPressed(sender: MyTapRecognizer){
    
        (pushViewController as! HomeViewController).deleteButtonPresses(post: sender.post);
    }
    
    @objc func callInfoButtonPressed(sender: MyTapRecognizer) {
        let post = sender.post;
        let viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CastContactsViewController") as! CastContactsViewController;
        
        var contacts = [User]();
        for userP in post!.castModerators {
            if (userP.phoneNumber != "" && userP.phoneNumber != nil) {
                contacts.append(userP);
            }
        }
        viewController.castContacts = contacts;
        viewController.postDescription = post?.postDescription;
        pushViewController.navigationController!.pushViewController(viewController, animated: true);
    }
    
    @objc func doubleTapped(sender: ImageTapRecognizer) {
        // do something here
       print("i ma here")
        print(sender.imagePosition)
        
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
                break;
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
    
    
    func populateCastOptionsView(post: Post) -> UIView {
        //Setting Status of Post
        var status = "";
        for postStatus in postStatusList {
            if (postStatus.postStatusId == post.postStatusId) {
                status = postStatus.title;
                break;
            }
        }
        
        if (status == "Pending") {
            
            let castOptions:CastOptionsView = Bundle.main.loadNibNamed("CastOptionsView", owner: self, options: nil)![0] as! CastOptionsView;
            
            let deleteButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(deleteButtonPressed(sender:)));
            deleteButtonTapRecognizer.post = post;
            castOptions.deleteBtn.addGestureRecognizer(deleteButtonTapRecognizer);
            
            let callButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(callInfoButtonPressed(sender:)));
                       callButtonTapRecognizer.post = post;
            castOptions.callButtonBtn.addGestureRecognizer(callButtonTapRecognizer);
            return castOptions;
            
        } else {
            
            let castOptions:CastOptionApprovedView = Bundle.main.loadNibNamed("CastOptionsView", owner: self, options: nil)![1] as! CastOptionApprovedView;
                                   
               let deleteButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(deleteButtonPressed(sender:)));
               deleteButtonTapRecognizer.post = post;
               castOptions.deleteBtn.addGestureRecognizer(deleteButtonTapRecognizer);
         
            let callButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(callInfoButtonPressed(sender:)));
            callButtonTapRecognizer.post = post;
            castOptions.callButtonBtn.addGestureRecognizer(callButtonTapRecognizer);

            return castOptions;
        }
        
        return UIView();
    }
    
    func addLabelToPost(post: Post) {
        
        //Call this function
        var height = pushViewController.heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: self.frame.width - 30)
        //if (height > 100) {
            //postDescription.text = post.postDescription ;
        postDescription.addTrailing(with: post.postDescription, moreText: "Read More", moreTextFont: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, moreTextColor: blueLinkColor)
        //} else {
            
        //}
    }
    
    func createGalleryScrollView(post: Post) {
        
        if (post.postImages.count > 0) {
            imageGalleryScrollView.isHidden = false;
            
            imageGalleryScrollView.isPagingEnabled = true
            for view in imageGalleryScrollView.subviews {
                view.removeFromSuperview();
            }
            imageGalleryScrollView.contentSize.width = imageGalleryScrollView.frame.width * CGFloat(post.postImages.count);

            var countIdx = 0
            for image in post.postImages {
                
                let slideView:SlideUIView = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! SlideUIView
                
                let xposition = self.imageGalleryScrollView.frame.width * CGFloat(countIdx);
                slideView.frame = CGRect.init(x: xposition, y: 0, width: imageGalleryScrollView.frame.width, height: imageGalleryScrollView.frame.height);
                
                slideView.imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: "post-image-placeholder"));

                let tapGesture = ImageTapRecognizer.init(target: self, action: #selector(doubleTapped(sender:)));
                tapGesture.imageView = post.postImages;
                tapGesture.imagePosition = countIdx;
                tapGesture.numberOfTapsRequired = 2
                slideView.isUserInteractionEnabled = true
                slideView.addGestureRecognizer(tapGesture);
                
                imageGalleryScrollView.addSubview(slideView);
                countIdx = countIdx + 1;
            }
            
        } else {
            
            imageGalleryScrollView.isHidden = true;
            
        }
    }
}


extension CasterViewTableViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        /*let pageIndex = round(scrollView.contentOffset.x/contentView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        print(pageIndex)
        self.currentCountImageLbl.text = "\(Int(pageIndex+1))"
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset*/
    }
    
}
