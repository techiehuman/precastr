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
    
    @IBOutlet weak var publishInfoButton: UIButton!
    @IBOutlet weak var pushToFacebookView: UIView!
    @IBOutlet weak var pushToTwitterView: UIView!
    
    
    var imagesArray : [String] = [String]();
    
    @IBOutlet weak var imageGalleryScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet weak var imageCounterView: UIView!
    
    @IBOutlet weak var currentCountImageLbl : UILabel!
    
    @IBOutlet weak var totalCountImageLbl : UILabel!
    
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var separator: UIView!
    
    var currentCount : Int!
    var homeViewControllerDelegate: HomeViewController!;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.postImageCollectionView.register(UINib.init(nibName: "PostImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PostImageCollectionViewCell")
        self.imageGalleryScrollView.delegate = self
        self.imageCounterView.layer.cornerRadius = 10
        
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
        
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "VisbyCF-Regular", size: 14)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor.black;
        
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top;
        preferences.drawing.cornerRadius = 4;
        
        EasyTipView.show(forView: publishInfoButton,
                         withinSuperview: self.contentView,
                         text: "Tip view inside the navigation controller's view. Tap to dismiss!",
                         preferences: preferences,
                         delegate: homeViewControllerDelegate.self)
    }
    @objc func publishInfoIconPressed() {
        print("clicked");
    }
}
