//
//  WebsiteInfoTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 23/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit
import ReadabilityKit
class WebsiteInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var websiteTitle: UILabel!;
    @IBOutlet weak var websiteDescription: UILabel!;
    @IBOutlet weak var websiteImg: UIImageView!;
    var pushViewController: UIViewController!;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fetchWebsiteLinkFromUrl(desc: String) {
        var finalUrl = "";
        if (pushViewController is HomeV2ViewController)  {
            finalUrl = (pushViewController as! HomeV2ViewController).extractWebsiteFromText(text: desc);
        } else if (pushViewController is CommunicationViewController)  {
            finalUrl = (pushViewController as! CommunicationViewController).extractWebsiteFromText(text: desc);
        } else if (pushViewController is ArchieveViewController)  {
            finalUrl = (pushViewController as! ArchieveViewController).extractWebsiteFromText(text: desc);
        } else if (pushViewController is CastContactsViewController)  {
            finalUrl = (pushViewController as! CastContactsViewController).extractWebsiteFromText(text: desc);
        }
        if (finalUrl != "") {
            let articleUrl = URL(string: finalUrl)!
            Readability.parse(url: articleUrl, completion: { data in
                let title = data?.title
                let description = data?.description
                let keywords = data?.keywords
                let imageUrl = data?.topImage
                let videoUrl = data?.topVideo
                let datePublished = data?.datePublished;
                
                if (title != nil) {
                    self.websiteTitle.text = title;
                } else {
                    self.websiteTitle.text = "";
                }
                
                if (description != nil) {
                    self.websiteDescription.text = description;
                } else {
                    self.websiteDescription.text = "";
                }
                if (imageUrl != nil) {
                    self.websiteImg.sd_setImage(with: URL.init(string: imageUrl!), placeholderImage: UIImage.init(named: "post-image-placeholder"));
                } else {
                    self.websiteImg.image = UIImage.init(named: "post-image-placeholder");
                }
            })
        }
    }
    
}
