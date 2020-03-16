//
//  PostGalleryTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 16/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage

class PostGalleryTableViewCell: UITableViewCell, ImageSlideshowDelegate {
    
    @IBOutlet weak var imageGalleryScrollView: UIScrollView!
    @IBOutlet weak var imageSlideShow : ImageSlideshow!

    var pushViewController: UIViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createGalleryScrollView(post: Post) {
        
        if (post.postImages.count > 0) {
            self.imageSlideShow.isHidden = false;
            beginImageFunc(imagesArray: post.postImages);
        } else {
            
            self.imageSlideShow.isHidden = true;
            
        }
    }
    
    @objc func doubleTapped(sender: ImageTapRecognizer) {
        // do something here
       print("i ma here")
        print(sender.imagePosition);
        
        let imageViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewerViewController") as! ImageViewerViewController
        imageViewController.imagesArray = sender.imageView;
        pushViewController.navigationController?.pushViewController(imageViewController, animated: false);
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
        let fullScreenController = self.imageSlideShow.presentFullScreenController(from: pushViewController)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}
extension ViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
    
}
