//
//  PostDescriptionTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 16/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class PostDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var castPaginationArrow: UIImageView!
    
    var pushViewController: UIViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func paginationArrowTapped(sender: MyTapRecognizer) {
        
        var indexPath = IndexPath.init(row: (sender.rowId + 1), section: 0);
        if (pushViewController is HomeV2ViewController) {
            (pushViewController as! HomeV2ViewController).scrollTableToPosition(indexPath: indexPath,postsTableView: (pushViewController as! HomeV2ViewController).postsTableView);
        } else if (pushViewController is ArchieveViewController) {
            (pushViewController as! ArchieveViewController).scrollTableToPosition(indexPath: indexPath, postsTableView: (pushViewController as! ArchieveViewController).postsTableView);
        }
        
    }
    
    func addLabelToPost(post: Post) {
        
        //Call this function
        var height = pushViewController.getHeightOfPostDescripiton(contentView: self.contentView, postDescription: post.postDescription);
        
        var heightOflabel = height;
        if (height > 100) {
               postDescription.numberOfLines = 4
                heightOflabel = 100;
           } else {
               postDescription.numberOfLines = 0
           }
           
        //   proNameLbl.lineBreakMode = .byTruncatingTail
           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.lineBreakMode = .byTruncatingTail
           //line height size
           paragraphStyle.lineSpacing = 2
           let attributes = [
               NSAttributedStringKey.font : UIFont(name: "VisbyCF-Regular", size: 16.0)!,
               NSAttributedStringKey.foregroundColor : UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1),
               NSAttributedStringKey.paragraphStyle: paragraphStyle]
           
        let attrString = NSMutableAttributedString(string: post.postDescription)
           attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length));
           postDescription.attributedText = attrString;
        postDescription.frame = CGRect.init(x: postDescription.frame.origin.x, y: postDescription.frame.origin.y, width: postDescription.frame.width, height: heightOflabel)
    }
    
    func addTapGestureToArrow(rowId: Int) {
        let paginationArrowTapGuesture = MyTapRecognizer.init(target: self, action: #selector(paginationArrowTapped(sender: )));
        paginationArrowTapGuesture.rowId = rowId;
        castPaginationArrow.addGestureRecognizer(paginationArrowTapGuesture)
    }
}
