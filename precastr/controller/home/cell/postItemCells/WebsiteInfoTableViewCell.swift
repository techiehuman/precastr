//
//  WebsiteInfoTableViewCell.swift
//  precastr
//
//  Created by Cenes_Dev on 23/02/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import UIKit
import ReadabilityKit
import URLEmbeddedView

class WebsiteInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var websiteTitle: UILabel!;
    @IBOutlet weak var websiteDescription: UILabel!;
    @IBOutlet weak var websiteImg: UIImageView!;
    var pushViewController: UIViewController!;
    var postItemTableViewCellDelegate: PostItemTableViewCell!
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
            
            //let embeddedView = URLEmbeddedView()
            //embeddedView.load(urlString: finalUrl) { data in
                
                OGDataProvider.shared.fetchOGData(withURLString: finalUrl) { [weak self] ogData, error in
                    
                        if let _ = error {
                            return
                        }
                    
                    if (ogData == nil) {
                        return;
                    }
                    if (ogData.pageTitle != nil) {
                        
                        let linkInfoData = LinkInfoData();
                        linkInfoData.title = ogData.pageTitle;
                        DispatchQueue.main.async { // Correct
                            self!.websiteTitle.text = ogData.pageTitle;
                        }
                        
                        if (ogData.pageDescription != nil) {
                             DispatchQueue.main.async { // Correct
                                self!.websiteDescription.text = ogData.pageDescription;
                            }
                            linkInfoData.description = ogData.pageDescription;
                        } else {
                            self!.websiteDescription.text = "";
                        }
                        if (ogData.imageUrl != nil) {
                            DispatchQueue.main.async { // Correct
                                self!.websiteImg.sd_setImage(with: ogData.imageUrl as! URL, placeholderImage: UIImage.init(named: "post-image-placeholder"));
                            }
                            
                            linkInfoData.image = ogData.imageUrl;

                        } else {
                            DispatchQueue.main.async { // Correct
                                self!.websiteImg.image = UIImage.init(named: "post-image-placeholder");
                            }
                        }
                                                
                        if (self!.pushViewController is HomeV2ViewController) {
                            
                            print((self!.pushViewController as! HomeV2ViewController).postLinkInfoFetched);
                                
                            (self!.pushViewController as! HomeV2ViewController).postLinkInfoFetched[finalUrl] = linkInfoData;
                            
                        }
                        

                    } else {
                        //self!.websiteTitle.text = "";
                        Readability.parse(url: articleUrl, completion: { data in
                            if (data == nil) {
                                return;
                            }
                            let linkInfoData = LinkInfoData();
                            
                            let title = data?.title
                            let description = data?.description
                            let keywords = data?.keywords
                            let imageUrl = data?.topImage
                            let videoUrl = data?.topVideo
                            let datePublished = data?.datePublished;
                            
                            if (title != nil) {
                                DispatchQueue.main.async { // Correct
                                    self!.websiteTitle.text = title;
                                }
                                linkInfoData.title = title;
                            } else {
                                self!.websiteTitle.text = "";
                            }
                            //linkInfoData.title = self!.websiteTitle.text!;

                            if (description != nil) {
                                DispatchQueue.main.async { // Correct
                                    self!.websiteDescription.text = description;
                                }
                                linkInfoData.description = description;

                            } else {
                                self!.websiteDescription.text = "";
                            }

                            if (imageUrl != nil) {
                                
                                DispatchQueue.main.async { // Correct
                                    self!.websiteImg.sd_setImage(with: URL.init(string: imageUrl!), placeholderImage: UIImage.init(named: "post-image-placeholder"));
                                }
                                linkInfoData.image = URL.init(string: imageUrl!);
                            } else {
                                
                                DispatchQueue.main.async { // Correct
                                    self!.websiteImg.image = UIImage.init(named: "post-image-placeholder");
                                }
                            }
                            

                            if (self!.pushViewController is HomeV2ViewController) {
                                (self!.pushViewController as! HomeV2ViewController).postLinkInfoFetched[articleUrl.absoluteString] = linkInfoData;
                            }
                            
                        });
                    }
                }
            //};

        }
    }
    
}
