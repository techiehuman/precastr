//
//  PostGalleryTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 16/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class PostGalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var imageGalleryScrollView: UIScrollView!

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
            imageGalleryScrollView.isHidden = false;
            
            imageGalleryScrollView.isPagingEnabled = true
            for view in imageGalleryScrollView.subviews {
                view.removeFromSuperview();
            }
            imageGalleryScrollView.contentSize.width = imageGalleryScrollView.frame.width * CGFloat(post.postImages.count);

            var countIdx = 0
            for image in post.postImages {
                
                let slideView:SlideUIView = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! SlideUIView
                
                let xposition = self.imageGalleryScrollView.frame.width * CGFloat(countIdx);
                slideView.frame = CGRect.init(x: xposition, y: 0, width: imageGalleryScrollView.frame.width, height: imageGalleryScrollView.frame.height);
                
                slideView.imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage.init(named: "post-image-placeholder"));

                let tapGesture = ImageTapRecognizer.init(target: self, action: #selector(doubleTapped(sender:)));
                tapGesture.imageView = post.postImages;
                tapGesture.imagePosition = countIdx;
                tapGesture.numberOfTapsRequired = 2
                slideView.isUserInteractionEnabled = true
                slideView.addGestureRecognizer(tapGesture);
                
                imageGalleryScrollView.addSubview(slideView);
                countIdx = countIdx + 1;
            }
            
        } else {
            
            imageGalleryScrollView.isHidden = true;
            
        }
    }
    
    @objc func doubleTapped(sender: ImageTapRecognizer) {
        // do something here
       print("i ma here")
        print(sender.imagePosition)
        
    }
}
