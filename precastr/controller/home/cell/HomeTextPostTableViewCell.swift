//
//  HomeTextPostTableViewCell.swift
//  precastr
//
//  Created by Macbook on 25/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class HomeTextPostTableViewCell: UITableViewCell,UIScrollViewDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.postImageCollectionView.register(UINib.init(nibName: "PostImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PostImageCollectionViewCell")
        self.imageGalleryScrollView.delegate = self
    }

    @IBOutlet weak var postTextLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var profileLabel: UILabel!
    
    
    @IBOutlet weak var sourceImageTwitter: UIImageView!
    
    @IBOutlet weak var sourceImageFacebook: UIImageView!
    
    @IBOutlet weak var statusImage: UIImageView!
    
    var imagesArray : [String] = [String]();
    
    
    @IBOutlet weak var imageGalleryScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createSlides() -> [SlideUIView] {
        
        
        var slide = [SlideUIView]();
        
        for image in imagesArray{
            
            let slideView:SlideUIView = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! SlideUIView
            slideView.frame = CGRect.init(x: 0, y: 0, width: contentView.frame.width, height: 218);
            
            slideView.imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: "post-image-placeholder"));
            slide.append(slideView);
        }
        return slide;
    }
    func setupSlideScrollView(slides : [SlideUIView]) {
        imageGalleryScrollView.frame = CGRect(x: 0, y: 110, width: contentView.frame.width, height: 218)
        imageGalleryScrollView.contentSize = CGSize(width: contentView.frame.width * CGFloat(slides.count), height: contentView.frame.height)
        imageGalleryScrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: contentView.frame.width * CGFloat(i), y: 0, width: contentView.frame.width, height: 218)
            imageGalleryScrollView.addSubview(slides[i])
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/contentView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
    }
}
