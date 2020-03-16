//
//  RightCommunicationTableViewCell.swift
//  precastr
//
//  Created by Macbook on 14/06/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage

class RightCommunicationTableViewCell: UITableViewCell, UIScrollViewDelegate, ImageSlideshowDelegate {
 
    var communicationViewControllerDelegate : CommunicationViewController!;
    
    @IBOutlet weak var commentedDate: UILabel!
        
    @IBOutlet weak var commentorPic: UIImageView!
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageSlideShow : ImageSlideshow!

    @IBOutlet weak var pageControl: UIPageControl!
    
    var imagesArray = [String]();
    var currentCount: Int = 0;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commentorPic.roundImageView();
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func createGalleryScrollView() {
        
        if (imagesArray.count > 0) {
            self.imageSlideShow.isHidden = false;
            beginImageFunc(imagesArray: imagesArray);
        } else {
            self.imageSlideShow.isHidden = true;
        }
        
        /*imageScrollView.isPagingEnabled = true
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
            self.currentCount = i as! Int
        }*/
        
        //imageGalleryScrollView.addSubview(imageCounterView);
    }
    
    
    func beginImageFunc(imagesArray: [String]) {
        self.imageSlideShow.slideshowInterval = 0
        self.imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        self.imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.init(red: 12/255, green: 111/255, blue: 223/255, alpha: 1) //pageControl
        pageControl.pageIndicatorTintColor = UIColor.init(red: 146/255, green: 147/255, blue: 149/255, alpha: 1)
        self.imageSlideShow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        self.imageSlideShow.activityIndicator = DefaultActivityIndicator()
        self.imageSlideShow.delegate = self;
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        
        var inputSource = [InputSource]();
        for img in imagesArray {
            inputSource.append(SDWebImageSource(urlString: img)!);
        }
        
        self.imageSlideShow.setImageInputs(inputSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        self.imageSlideShow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        let fullScreenController = self.imageSlideShow.presentFullScreenController(from: communicationViewControllerDelegate)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1);
    }
    
}
