//
//  ModeratorCastsTableViewCell.swift
//  precastr
//
//  Created by Macbook on 06/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class ModeratorCastsTableViewCell: UITableViewCell, UIScrollViewDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.postImageCollectionView.register(UINib.init(nibName: "PostImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PostImageCollectionViewCell")
        self.imageGalleryScrollView.delegate = self
        self.imageCounterView.layer.cornerRadius = 10
        
        self.descriptionView.backgroundColor = UIColor.white;
        
    }
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var socialIconsView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var sourceImageTwitter: UIImageView!
    
    @IBOutlet weak var sourceImageFacebook: UIImageView!
    
    @IBOutlet weak var statusImage: UIImageView!
    
    var imagesArray : [String] = [String]();
    
    @IBOutlet weak var imageGalleryScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var imageCounterView: UIView!
    
    @IBOutlet weak var currentCountImageLbl : UILabel!
    
    @IBOutlet weak var totalCountImageLbl : UILabel!
    
    @IBOutlet weak var postStatusViewCell: UIView!
    
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var castPaginationArrow: UIImageView!

    var currentCount : Int!
    
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
        
        for i in 0 ..< imagesArray.count {
            
            let setupSlideScrollView = UIImageView();
            setupSlideScrollView.sd_setImage(with: URL(string: imagesArray[i]), placeholderImage: UIImage.init(named: "post-image-placeholder"));
            setupSlideScrollView.contentMode = .scaleAspectFill;
            setupSlideScrollView.clipsToBounds = true

            let xposition = self.contentView.frame.width * CGFloat(i);
            setupSlideScrollView.frame = CGRect.init(x: xposition, y: 0, width: imageGalleryScrollView.frame.width, height: imageGalleryScrollView.frame.height);
            
            imageGalleryScrollView.contentSize.width = imageGalleryScrollView.frame.width * CGFloat(i + 1);
            
            imageGalleryScrollView.addSubview(setupSlideScrollView)
            self.currentCount = i 
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
}
