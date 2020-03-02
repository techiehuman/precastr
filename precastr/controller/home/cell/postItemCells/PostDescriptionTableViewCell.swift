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
    
    var postItemTableViewCellDelegate: PostItemTableViewCell!
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
    
    @objc func postDescPressed(sender: MyTapRecognizer) {
    
        //Call this function
        if (pushViewController is HomeV2ViewController) {
            if ((postItemTableViewCellDelegate.pushViewController as! HomeV2ViewController).postIdDescExpansionMap[postItemTableViewCellDelegate.post.postId] != nil && (postItemTableViewCellDelegate.pushViewController as! HomeV2ViewController).postIdDescExpansionMap[postItemTableViewCellDelegate.post.postId] == true) {
                
                //postItemTableViewCellDelegate.isDescriptionFullView = false;
                    (postItemTableViewCellDelegate.pushViewController as! HomeV2ViewController).postIdDescExpansionMap[postItemTableViewCellDelegate.post.postId] = false
            
            } else {
                //postItemTableViewCellDelegate.isDescriptionFullView = true;
                (postItemTableViewCellDelegate.pushViewController as! HomeV2ViewController).postIdDescExpansionMap[postItemTableViewCellDelegate.post.postId] = true
            
            }
        }
        
        var height = pushViewController.getHeightOfPostDescripiton(contentView: self.contentView, postDescription: sender.post.postDescription);
               
               var heightOflabel = height;
               if (height > 100) {
                   if (postItemTableViewCellDelegate.isDescriptionFullView == true) {
                       postDescription.numberOfLines = 0
                   } else {
                       postDescription.numberOfLines = 4
                        heightOflabel = 100;
                   }
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
           
        let attrString = NSMutableAttributedString(string: sender.post.postDescription)
           attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length));
            postDescription.attributedText = attrString;
        //self.postItemTableViewCellDelegate.postItemsTableView.reloadData();
        //self.postItemTableViewCellDelegate.postItemsTableView.beginUpdates()
        //self.postItemTableViewCellDelegate.postItemsTableView.endUpdates()
       
        self.postItemTableViewCellDelegate.contentChanged();
        //postItemTableViewCellDelegate.postItemsTableView.reloadData();
        if (postItemTableViewCellDelegate.pushViewController is HomeV2ViewController) {
            //(postItemTableViewCellDelegate.pushViewController as! HomeV2ViewController).postsTableView.reloadData();
        }
    }
    
    func addLabelToPost(post: Post) {
        postDescription.isUserInteractionEnabled = true;
        //Call this function
        var height = pushViewController.getHeightOfPostDescripiton(contentView: self.contentView, postDescription: post.postDescription);
        
        var heightOflabel = height;
        if (heightOflabel > 100) {
            if (pushViewController is HomeV2ViewController) {
                if ((postItemTableViewCellDelegate.pushViewController as! HomeV2ViewController).postIdDescExpansionMap[postItemTableViewCellDelegate.post.postId] != nil && (postItemTableViewCellDelegate.pushViewController as! HomeV2ViewController).postIdDescExpansionMap[postItemTableViewCellDelegate.post.postId] == true) {
                               postDescription.numberOfLines = 0
                           } else {
                               postDescription.numberOfLines = 4
                                heightOflabel = 100;
                           }
            }
           
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
        postDescription.frame = CGRect.init(x: postDescription.frame.origin.x, y: postDescription.frame.origin.y, width: postDescription.frame.width, height: heightOflabel);
        
        if (pushViewController is HomeV2ViewController) {
            let descTapGesture = MyTapRecognizer.init(target: self, action: #selector(postDescPressed(sender:)));
            descTapGesture.post = post;
            postDescription.addGestureRecognizer(descTapGesture);
        } else if (pushViewController is ArchieveViewController) {
            let descTapGesture = MyTapRecognizer.init(target: self, action: #selector(postDescPressed(sender:)));
            descTapGesture.post = post;
            postDescription.addGestureRecognizer(descTapGesture);

        }
        
        print(post.postDescription);
    }
    
    func addTapGestureToArrow(rowId: Int) {
        let paginationArrowTapGuesture = MyTapRecognizer.init(target: self, action: #selector(paginationArrowTapped(sender: )));
        paginationArrowTapGuesture.rowId = rowId;
        castPaginationArrow.addGestureRecognizer(paginationArrowTapGuesture)
    }
}
