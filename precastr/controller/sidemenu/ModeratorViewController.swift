//
//  ModeratorViewController.swift
//  precastr
//
//  Created by Macbook on 22/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class ModeratorViewController: UIViewController {
  
    @IBOutlet weak var moderatorList: UITableView!
     var loggedInUser : User!
    var moderators : [Int] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        
         loggedInUser = User().loadUserDataFromUserDefaults(userDataDict : setting);
        // Do any additional setup after loading the view.
        
        
        
      moderatorList.register(UINib(nibName: "ModeratorViewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ModeratorViewTableViewCell")
        
        
        let jsonURL = "user/get_caster_moderator/format/json?user_id=\(1))&submit=1";
        UserService().getDataMethod(jsonURL: jsonURL,complete:{(response) in
            print(response);
           let modeArray = response.value(forKey: "data") as! NSArray;
            for mode in modeArray{
                var modeDict = mode as! NSDictionary;
                self.moderators.append(Int((modeDict.value(forKey: "moderator_id") as! NSString) as String)!);
                
            }
            self.moderatorList.reloadData();
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ModeratorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moderators.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let moderatorObject = self.moderators[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModeratorViewTableViewCell", for: indexPath) as! ModeratorViewTableViewCell;
        print("******")
        print(String(moderatorObject))
        cell.moderatorLabel.text = String(moderatorObject);
        cell.moderatorImage.image = UIImage.init(named: "small")
       
        cell.moderatorImage.layer.masksToBounds = false
      
        cell.moderatorImage.layer.cornerRadius = cell.moderatorImage.frame.height/2
        cell.moderatorImage.clipsToBounds = true
        return cell;
    }
    
    

}


