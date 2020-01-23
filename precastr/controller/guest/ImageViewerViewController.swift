//
//  ImageViewerViewController.swift
//  precastr
//
//  Created by mandeep singh on 02/01/20.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageGalleryScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imagesArray : [String] = [String]();

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageGalleryScrollView.delegate = self
        // Do any additional setup after loading the view.
        self.setupSlideScrollView();
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
           
        }
        
        //imageGalleryScrollView.addSubview(imageCounterView);
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
    }
}
