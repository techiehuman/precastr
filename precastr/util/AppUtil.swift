//
//  AppUtil.swift
//  precastr
//
//  Created by Macbook on 11/04/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit


    let ApiUrl = "http://lyonsdemoz.website/pre-caster/api/"
    let ApiToken = "82haf8kklm3fotpr23-f4gh2-vq587-32ky"
    let siteURL = "http://lyonsdemoz.website/pre-caster/"
    let castTextAreaPlaceholder = "Communicate with your Moderator.\nTo edit post click on the \"Edit Post\" button at top."


let blueLinkColor = UIColor.init(red: 100/255, green: 166/255, blue: 247/255, alpha: 1);//#64A6F7

let moderatorTitleColors: [String: UIColor] = ["Agents": PrecasterColors.modAgentBg, "Manager": PrecasterColors.modManagerBg, "Colleague": PrecasterColors.modColleagueBg, "Guardian": PrecasterColors.modGuardianBg, "Friend": PrecasterColors.modFriendBg, "Parent": PrecasterColors.modParentBg, "Other": PrecasterColors.modOtherBg]
class PrecasterColors {
    
    static var themeColor: UIColor = UIColor.init(red: 12/255, green: 101/255, blue: 233/255, alpha: 1); //#0C65E9
    static var darkBlueButtonColor: UIColor = UIColor.init(red: 10/255, green: 88/255, blue: 184/255, alpha: 1); //#0a58b8
    static var modAgentBg: UIColor = UIColor.init(red: 165/255, green: 154/255, blue: 102/255, alpha: 1); //#0a58b8
    static var modManagerBg: UIColor = UIColor.init(red: 54/255, green: 76/255, blue: 133/255, alpha: 1); //#364C85
    static var modColleagueBg: UIColor = UIColor.init(red: 0/255, green: 211/255, blue: 5/255, alpha: 1); //#00D305
    static var modGuardianBg: UIColor = UIColor.init(red: 249/255, green: 141/255, blue: 2/255, alpha: 1); //#F98D02
    static var modFriendBg: UIColor = UIColor.init(red: 64/255, green: 129/255, blue: 255/255, alpha: 1); //#4081ff
    static var modParentBg: UIColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1); //#000000
    static var modOtherBg: UIColor = UIColor.init(red: 143/255, green: 82/255, blue: 187/255, alpha: 1); //#8f52bb

}

class AlertMessages {
    static var POST_NOT_AVAILABLE = "Post Not Availble.";
}
