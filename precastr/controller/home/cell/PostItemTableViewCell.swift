//
//  PostItemTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 16/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit

class PostItemTableViewCell: UITableViewCell {

    @IBOutlet weak var postItemsTableView: UITableView!
    var pushViewController: UIViewController!;
    var post: Post!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Do any additional setup after loading the view.
        postItemsTableView.register(UINib(nibName: "CasterPostStatusTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CasterPostStatusTableViewCell");
        postItemsTableView.register(UINib(nibName: "BeforeApprovedTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BeforeApprovedTableViewCell");
        postItemsTableView.register(UINib(nibName: "PostDescriptionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostDescriptionTableViewCell");
        postItemsTableView.register(UINib(nibName: "PostGalleryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PostGalleryTableViewCell");

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func postDescriptionPressed(sender: MyTapRecognizer){
    
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunicationViewController") as! CommunicationViewController;
        viewController.post = sender.post;
         pushViewController.navigationController?.pushViewController(viewController, animated: true);
    }
    
    @objc func deleteButtonPressed(sender: MyTapRecognizer){
    
        (pushViewController as! HomeViewController).deleteButtonPresses(post: sender.post);
    }
    
    @objc func callInfoButtonPressed(sender: MyTapRecognizer) {
        let post = sender.post;
        let viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CastContactsViewController") as! CastContactsViewController;
        
        var contacts = [User]();
        for userP in post!.castModerators {
            if (userP.phoneNumber != "" && userP.phoneNumber != nil) {
                contacts.append(userP);
            }
        }
        viewController.castContacts = contacts;
        viewController.postDescription = post?.postDescription;
        pushViewController.navigationController!.pushViewController(viewController, animated: true);
    }
    
    func populateCasterTopView(cell: CasterPostStatusTableViewCell) {
        
        let editButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(postDescriptionPressed(sender:)));
        editButtonTapRecognizer.post = post;
        
        cell.viewDetailsBtn.layer.cornerRadius = 4;
        cell.viewDetailsBtn.backgroundColor = blueLinkColor;
        
        //Setting Date of Post
        cell.postDateLbl.text = Date().ddspEEEEcmyyyy(dateStr: post.createdOn);
        cell.postDateLbl.frame = CGRect.init(x: (self.contentView.frame.width -  cell.postDateLbl.intrinsicContentSize.width - 15), y: cell.postDateLbl.frame.origin.y, width: cell.postDateLbl.intrinsicContentSize.width, height: cell.postDateLbl.frame.height);
        
        //Setting Status of Post
        var status = "";
        for postStatus in postStatusList {
            if (postStatus.postStatusId == post.postStatusId) {
                status = postStatus.title;
                break;
            }
        }
        
        let pipe = " |"
        cell.postStatusLbl.text = "\((status))\(pipe)"
        cell.postStatusLbl.frame = CGRect.init(x: cell.postDateLbl.frame.origin.x - (cell.postStatusLbl.intrinsicContentSize.width + 5), y: cell.postStatusLbl.frame.origin.y, width: cell.postStatusLbl.intrinsicContentSize.width, height: cell.postStatusLbl.frame.height);
        
        //Setting Status Image of Post
        var imageStatus = "";
        if (pushViewController is HomeViewController) {
            imageStatus = (pushViewController as! HomeViewController).adapterCasterGetPostStatusImage(status: status);
        } else if (pushViewController is ArchieveViewController) {
            imageStatus = (pushViewController as! ArchieveViewController).adapterCasterGetPostStatusImage(status: status);
        }
        cell.postStatusImg.image = UIImage.init(named: imageStatus)
        cell.postStatusImg.frame = CGRect.init(x: cell.postStatusLbl.frame.origin.x - ( cell.postStatusImg.frame.width + 10), y: cell.postStatusImg.frame.origin.y, width: cell.postStatusImg.frame.width, height: cell.postStatusImg.frame.height)
        
        cell.viewDetailsBtn.addGestureRecognizer(editButtonTapRecognizer);
    }
    
    func populateCastActionsCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        //Setting Status of Post
        var status = "";
        for postStatus in postStatusList {
            if (postStatus.postStatusId == post.postStatusId) {
                status = postStatus.title;
                break;
            }
        }
        
        if (status == "Pending") {
            
            let cell: BeforeApprovedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BeforeApprovedTableViewCell", for: indexPath) as! BeforeApprovedTableViewCell;
            
            let deleteButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(deleteButtonPressed(sender:)));
            deleteButtonTapRecognizer.post = post;
            cell.deleteBtn.addGestureRecognizer(deleteButtonTapRecognizer);
            
            let callButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(callInfoButtonPressed(sender:)));
                       callButtonTapRecognizer.post = post;
            cell.callButtonBtn.addGestureRecognizer(callButtonTapRecognizer);
            return cell;
            
        } else {
            
            let cell: BeforeApprovedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BeforeApprovedTableViewCell", for: indexPath) as! BeforeApprovedTableViewCell;
            
            let deleteButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(deleteButtonPressed(sender:)));
            deleteButtonTapRecognizer.post = post;
            cell.deleteBtn.addGestureRecognizer(deleteButtonTapRecognizer);
            
            let callButtonTapRecognizer = MyTapRecognizer.init(target: self, action: #selector(callInfoButtonPressed(sender:)));
                       callButtonTapRecognizer.post = post;
            cell.callButtonBtn.addGestureRecognizer(callButtonTapRecognizer);
            return cell;
        }
        
        return UITableViewCell();
    }
    
}

extension PostItemTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == PostRows.Post_Status_Row) {
                
                let cell: CasterPostStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CasterPostStatusTableViewCell", for: indexPath) as! CasterPostStatusTableViewCell;
            
                    //Populating Status
                    populateCasterTopView(cell: cell);
                return cell;

                
            } else if (indexPath.row == PostRows.Post_Action_Row) {
            
                return populateCastActionsCell(indexPath: indexPath, tableView: tableView)
            
            } else if (indexPath.row == PostRows.Post_Description_Row) {
                    
                let cell: PostDescriptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostDescriptionTableViewCell", for: indexPath) as! PostDescriptionTableViewCell;
                    cell.pushViewController = pushViewController;
                    cell.addLabelToPost(post: post);
                    return cell;
            }  else if (indexPath.row == PostRows.Post_Gallery_Row) {
                               
                   let cell: PostGalleryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostGalleryTableViewCell", for: indexPath) as! PostGalleryTableViewCell;
                       cell.createGalleryScrollView(post: post);
            
                    return cell;
            }

        return UITableViewCell();
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (PostRows.Post_Status_Row == indexPath.row) {
            return CGFloat(PostRowsHeight.Post_Status_Row_Height);
        } else if (PostRows.Post_Action_Row == indexPath.row) {
            return CGFloat(PostRowsHeight.Post_Action_Row_Height);
        } else if (PostRows.Post_Description_Row == indexPath.row) {
            let height =  pushViewController.heightForView(text: post.postDescription, font: UIFont.init(name: "VisbyCF-Regular", size: 16.0)!, width: self.pushViewController.view.frame.width - 30) + CGFloat(PostRowsHeight.Post_Description_Row_Height);
            return height;
        } else if (PostRows.Post_Gallery_Row == indexPath.row) {
                   return CGFloat(PostRowsHeight.Post_Gallery_Row_Height);
               }
        return 0;
    }
}
