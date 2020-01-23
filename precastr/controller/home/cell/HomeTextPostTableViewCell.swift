//
//  HomeTextPostTableViewCell.swift
//  precastr
//
//  Created by Macbook on 25/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import EasyTipView

class HomeTextPostTableViewCell: UITableViewCell,UIScrollViewDelegate {

    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var socialIconsView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var sourceImageTwitter: UIImageView!
    
    @IBOutlet weak var sourceImageFacebook: UIImageView!
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var postStatusDateView: UIView!
    
    @IBOutlet weak var postPrePublishView: UIView!
    
    @IBOutlet weak var pendingInfoView: UIView!
    
    @IBOutlet weak var publishInfoButton: UIButton!
    @IBOutlet weak var pushToFacebookView: UIView!
    @IBOutlet weak var pushToTwitterView: UIView!

    @IBOutlet weak var pushtoSmsView: UIView!
    
    @IBOutlet weak var publishToTwitterImage: UIImageView!
    @IBOutlet weak var publishToFacebookImage: UIImageView!
    @IBOutlet weak var pushToSmsImage: UIImageView!
    
    @IBOutlet weak var pushToFacebookText: UILabel!
    @IBOutlet weak var pushToTwitterText: UILabel!
    @IBOutlet weak var pushToSmsText: UILabel!
    
    @IBOutlet weak var editPostbutton: UIButton!;
    @IBOutlet weak var deletePostButton: UIButton!
    @IBOutlet weak var deletePostButtonFirst: UIButton!
    var imagesArray : [String] = [String]();
    
    @IBOutlet weak var imageGalleryScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var imageCounterView: UIView!
    
    @IBOutlet weak var currentCountImageLbl : UILabel!
    
    @IBOutlet weak var totalCountImageLbl : UILabel!
    
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var castPaginationArrow: UIImageView!
    
    @IBOutlet weak var castContactsIcon: UIButton!
    @IBOutlet weak var castContactsIconFirst: UIButton!
    @IBOutlet weak var sharePostButton: UIButton!
    var currentCount : Int!
    var homeViewControllerDelegate: HomeViewController!;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.postImageCollectionView.register(UINib.init(nibName: "PostImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PostImageCollectionViewCell")
        self.imageGalleryScrollView.delegate = self
        self.imageCounterView.layer.cornerRadius = 10
        self.editPostbutton.layer.cornerRadius = 4;
        
        self.publishInfoButton.roundBtn();
        self.castContactsIcon.roundBtn();
        self.castContactsIconFirst.roundBtn();
        self.deletePostButton.roundBtn();
        self.deletePostButtonFirst.roundBtn();
        self.sharePostButton.roundBtn();
        var predictiveIconTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(publishInfoIconPressed))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createSlides() -> [SlideUIView] {
        
        
        var slide = [SlideUIView]();
        
        for image in imagesArray{
            
            let slideView:SlideUIView = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! SlideUIView
            slideView.frame = CGRect.init(x: 0, y: 0, width: contentView.frame.width, height: 418);
            
            slideView.imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: "post-image-placeholder"));
            slide.append(slideView);
        }
        return slide;
    }
    func setupSlideScrollView() {
        imageGalleryScrollView.isPagingEnabled = true
        for view in imageGalleryScrollView.subviews {
            view.removeFromSuperview();
        }
        imageGalleryScrollView.contentSize.width = imageGalleryScrollView.frame.width * CGFloat(imagesArray.count);

        for i in 0 ..< imagesArray.count {
            
            let setupSlideScrollView = UIImageView();
            
            let xposition = self.imageGalleryScrollView.frame.width * CGFloat(i);
            setupSlideScrollView.frame = CGRect.init(x: xposition, y: 0, width: imageGalleryScrollView.frame.width, height: imageGalleryScrollView.frame.height);

            setupSlideScrollView.sd_setImage(with: URL(string: imagesArray[i]), placeholderImage: UIImage.init(named: "post-image-placeholder"));
            setupSlideScrollView.contentMode = .scaleAspectFill;
            setupSlideScrollView.clipsToBounds = true
            print("imageGalleryScrollView", imageGalleryScrollView.frame.width)
            
            print("X Position : ", xposition, "width", imageGalleryScrollView.frame.width * CGFloat(i + 1));
            /* code for double tapping */
            
            
            
            let tapGesture = ImageTapRecognizer.init(target: self, action: #selector(doubleTapped(sender:)));
            tapGesture.imageView = imagesArray
            tapGesture.imagePosition = i;
            tapGesture.numberOfTapsRequired = 2
            setupSlideScrollView.isUserInteractionEnabled = true
            setupSlideScrollView.addGestureRecognizer(tapGesture)
        
            
            /* code for double tapping */
            imageGalleryScrollView.addSubview(setupSlideScrollView)
            self.currentCount = i as! Int
        }
        
        //imageGalleryScrollView.addSubview(imageCounterView);
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let pageIndex = round(scrollView.contentOffset.x/contentView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        print(pageIndex)
        self.currentCountImageLbl.text = "\(Int(pageIndex+1))"
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
    }
    
    @IBAction func publishInfoButtonPressed(_ sender: Any) {
        
        if (self.homeViewControllerDelegate.easyToolTip == nil) {
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = UIFont(name: "VisbyCF-Regular", size: 14)!
            preferences.drawing.textAlignment  = .left;
            preferences.drawing.foregroundColor = UIColor.white
            preferences.drawing.backgroundColor = UIColor.init(red: 12/255, green: 111/255, blue: 233/255, alpha: 1);
            
            preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top;
            preferences.drawing.cornerRadius = 4;
            let text = "\u{2022} If you are posting to FB and your post contains images & content, hit the \"Push to FB\" button, a window opens --> tap in the text box --> select \"Paste\" option -->  follow the on screen instructions to publish.\n\n\u{2022} And if your post contains only images OR only content, simply hit the \"Push to FB\" button --> follow the on screen instructions";
            
            self.homeViewControllerDelegate.easyToolTip = EasyTipView(text: text, preferences: preferences, delegate: homeViewControllerDelegate.self)
            self.homeViewControllerDelegate.easyToolTip.show(animated: true, forView: publishInfoButton, withinSuperview: self.homeViewControllerDelegate.view)
        } else {
            self.homeViewControllerDelegate.easyToolTip.dismiss();
            self.homeViewControllerDelegate.easyToolTip = nil;
        }
        
    }
    @objc func publishInfoIconPressed() {
        print("clicked");
    }
    @objc func doubleTapped(sender: ImageTapRecognizer) {
        // do something here
       print("i ma here")
        print(sender.imagePosition)
        
    }
    class ImageTapRecognizer : UITapGestureRecognizer {
        var imageView: [String]!;
        var imagePosition: Int!;
    }
}
