//
//  ImageViewerViewController.swift
//  precastr
//
//  Created by mandeep singh on 02/01/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage

class ImageViewerViewController: UIViewController, UIScrollViewDelegate, ImageSlideshowDelegate {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    var imagesArray : [String] = [String]();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //let localSource = [BundleImageSource(imageString: "img1"), BundleImageSource(imageString: "img2"), BundleImageSource(imageString: "img3"), BundleImageSource(imageString: "img4")]
        beginImage();
      
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func beginImage() {
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self;
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        
        var inputSource = [InputSource]();
        for img in imagesArray {
            inputSource.append(SDWebImageSource(urlString: img)!);
        }
        
        slideshow.setImageInputs(inputSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ImageViewerViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
  
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }

}

