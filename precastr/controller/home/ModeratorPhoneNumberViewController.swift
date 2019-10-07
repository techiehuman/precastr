//
//  ModeratorPhoneNumberViewController.swift
//  precastr
//
//  Created by Cenes_Dev on 06/10/2019.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit

class ModeratorPhoneNumberViewController: UIViewController {
    
    @IBOutlet weak var moderatorPhoneListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}

extension ModeratorPhoneNumberViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell();
    }

}
