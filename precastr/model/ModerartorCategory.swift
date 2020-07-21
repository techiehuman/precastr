//
//  ModerartorCategory.swift
//  precastr
//
//  Created by Cenes_Dev on 31/05/2020.
//  Copyright © 2020 Macbook. All rights reserved.
//

import Foundation
class ModeratorCategory {

    var moderatorCategoryId: Int!;
    var title: String!;

    func loadModeratorCategoryFromDict(modCatDict: NSDictionary) -> ModeratorCategory {
        
        let moderatorCategory: ModeratorCategory = ModeratorCategory();
        moderatorCategory.moderatorCategoryId = Int(modCatDict.value(forKey: "id") as! String)
        moderatorCategory.title = modCatDict.value(forKey: "title") as! String;
        return moderatorCategory;
    }
    
    func loadModeratorCategoryFromNSArray(modCatArr: NSArray) -> [ModeratorCategory] {
        
        var moderatorCategories = [ModeratorCategory]();
        for modCatArrItem in modCatArr {
            var modCatArrItemDict = modCatArrItem as! NSDictionary;
            let moderatorCategory = loadModeratorCategoryFromDict(modCatDict: modCatArrItemDict);
            moderatorCategories.append(moderatorCategory);
        }
        return moderatorCategories;
    }
}
