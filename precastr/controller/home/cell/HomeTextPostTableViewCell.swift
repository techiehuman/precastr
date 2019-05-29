//
//  HomeTextPostTableViewCell.swift
//  precastr
//
//  Created by Macbook on 25/05/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class HomeTextPostTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.postImageCollectionView.register(UINib.init(nibName: "PostImageCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PostImageCollectionViewCell")
    }

    @IBOutlet weak var postTextLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var profileLabel: UILabel!
    
    
    @IBOutlet weak var sourceImageTwitter: UIImageView!
    
    @IBOutlet weak var sourceImageFacebook: UIImageView!
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var postImageCollectionView: UICollectionView!
    
    var imagesArray : [String] = [String]();
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageString : String = imagesArray[indexPath.row]
        print(imageString)
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCollectionViewCell", for: indexPath) as! PostImageCollectionViewCell
        collectionViewCell.postImageView.sd_setImage(with: URL(string: imageString)!, placeholderImage: UIImage.init(named: "approved"))
        return collectionViewCell;
    }
}
