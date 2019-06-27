//
//  LeftCommunicationTableViewCell.swift
//  precastr
//
//  Created by Macbook on 14/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class LeftCommunicationTableViewCell: UITableViewCell {
 var communicationViewControllerDelegate : CommunicationViewController!;
    
            
    @IBOutlet weak var commentorPic: UIImageView!
    
    @IBOutlet weak var descriptionView: UIView!

    @IBOutlet weak var commentedDate: UILabel!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imagesArray = [String]();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commentorPic.roundImageView();
        self.descriptionView.layer.cornerRadius = 4;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupSlideScrollView() {
        imageScrollView.isPagingEnabled = true
        for view in imageScrollView.subviews {
            view.removeFromSuperview();
        }
        imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(imagesArray.count);
        
        for i in 0 ..< imagesArray.count {
            
            let setupSlideScrollView = UIImageView();
            
            let xposition = self.imageScrollView.frame.width * CGFloat(i);
            setupSlideScrollView.frame = CGRect.init(x: xposition, y: 0, width: imageScrollView.frame.width, height: imageScrollView.frame.height);
            
            setupSlideScrollView.sd_setImage(with: URL(string: imagesArray[i]), placeholderImage: UIImage.init(named: "post-image-placeholder"));
            setupSlideScrollView.contentMode = .scaleAspectFit;
            setupSlideScrollView.clipsToBounds = true
            
            print("X Position : ", xposition, "width", imageScrollView.frame.width * CGFloat(i + 1));
            
            imageScrollView.addSubview(setupSlideScrollView)
            //self.currentCount = i as! Int
        }
        
        //imageGalleryScrollView.addSubview(imageCounterView);
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let pageIndex = round(scrollView.contentOffset.x/contentView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        print(pageIndex)
        //self.currentCountImageLbl.text = "\(Int(pageIndex+1))"
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
    }
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1);
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
}
