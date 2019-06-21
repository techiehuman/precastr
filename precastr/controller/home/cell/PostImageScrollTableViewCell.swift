//
//  PostImageScrollTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 19/06/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class PostImageScrollTableViewCell: UITableViewCell, UIScrollViewDelegate {

    
    @IBOutlet weak var imageGalleryScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var imageCounterView: UIView!
    
    @IBOutlet weak var currentCountImageLbl : UILabel!
    
    @IBOutlet weak var totalCountImageLbl : UILabel!
    
    var currentCount : Int!

    var imagesArray : [String] = [String]();

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupSlideScrollView() {
        imageGalleryScrollView.isPagingEnabled = true
        for view in imageGalleryScrollView.subviews {
            view.removeFromSuperview();
        }
        self.imageGalleryScrollView.contentSize.width = imageGalleryScrollView.frame.width * CGFloat(self.imagesArray.count);
        
        for i in 0 ..< self.imagesArray.count {
            
            let setupSlideScrollView = UIImageView();
            
            let xposition = self.imageGalleryScrollView.frame.width * CGFloat(i);
            setupSlideScrollView.frame = CGRect.init(x: xposition, y: 0, width: contentView.bounds.width, height: imageGalleryScrollView.frame.height);
            
            setupSlideScrollView.contentMode = .scaleAspectFill;
            setupSlideScrollView.clipsToBounds = true
            setupSlideScrollView.sd_setImage(with: URL(string: imagesArray[i]), placeholderImage: UIImage.init(named: "post-image-placeholder"));
            
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
}
