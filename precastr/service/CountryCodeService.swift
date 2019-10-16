//
//  CountryCodeService.swift
//  Cenes
//
//  Created by Macbook on 29/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class CountryCodeService {
    
    var DEFAULT_FLAG_RES: NSNumber = -99;
    var phoneCode: String = "";
    var nameCode: String = "";
    var name: String = "";
    var flagResID: NSNumber = 0;
    
    func getPhoneCode() -> String {
    return phoneCode;
    }
    
    func setPhoneCode(phoneCode: String) {
        self.phoneCode = phoneCode;
    }
    
    func getNameCode() -> String {
        return self.nameCode;
    }
    
    func setNameCode(nameCode: String) {
        self.nameCode = nameCode;
    }
    
    func getName() -> String {
        return self.name;
    }
    
    func setName(name: String) {
        self.name = name;
    }
    
    /*func getFlagResID() -> NSNumber {
        return self.flagResID;
    }
    
    func setFlagResID(flagResID: NSNumber) {
        self.flagResID = flagResID;
    }*/
    
    func getCountryCodeService(nameCode: String, phoneCode: String, name: String, flagResID: NSNumber) -> CountryCodeService {
        let countryCodeService: CountryCodeService = CountryCodeService();
        countryCodeService.nameCode = nameCode;
        countryCodeService.phoneCode = phoneCode;
        countryCodeService.name = name;
        countryCodeService.flagResID = flagResID;
        return countryCodeService;
    }
    
    /**
     * Returns image res based on country name code
     *
     * @param
     * @return
     */
    
    func getLibraryMasterCountriesEnglish() -> [CountryCodeService] {
    var countries: [CountryCodeService] = [];
        countries.append(getCountryCodeService(nameCode: "ad", phoneCode: "+376", name: "Andorra", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ae", phoneCode: "+971", name: "United Arab Emirates (UAE)", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "af", phoneCode: "+93", name: "Afghanistan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ag", phoneCode: "+1", name: "Antigua and Barbuda", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ai", phoneCode: "+1", name: "Anguilla", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "al", phoneCode: "+355", name: "Albania", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "am", phoneCode: "+374", name: "Armenia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ao", phoneCode: "+244", name: "Angola", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "aq", phoneCode: "+672", name: "Antarctica", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ar", phoneCode: "+54", name: "Argentina", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "as", phoneCode: "+1", name: "American Samoa", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "at", phoneCode: "+43", name: "Austria", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "au", phoneCode: "+61", name: "Australia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "aw", phoneCode: "+297", name: "Aruba", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "az", phoneCode: "+358", name: "Aland Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "az", phoneCode: "+994", name: "Azerbaijan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ba", phoneCode: "+387", name: "Bosnia And Herzegovina", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bb", phoneCode: "+1", name: "Barbados", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bd", phoneCode: "+880", name: "Bangladesh", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "be", phoneCode: "+32", name: "Belgium", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bf", phoneCode: "+226", name: "Burkina Faso", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bg", phoneCode: "+359", name: "Bulgaria", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bh", phoneCode: "+973", name: "Bahrain", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bi", phoneCode: "+257", name: "Burundi", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bj", phoneCode: "+229", name: "Benin", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bl", phoneCode: "+590", name: "Saint Barthélemy", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bm", phoneCode: "+1", name: "Bermuda", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bn", phoneCode: "+673", name: "Brunei Darussalam", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bo", phoneCode: "+591", name: "Bolivia, Plurinational State Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "br", phoneCode: "+55", name: "Brazil", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bs", phoneCode: "+1", name: "Bahamas", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bt", phoneCode: "+975", name: "Bhutan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bw", phoneCode: "+267", name: "Botswana", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "by", phoneCode: "+375", name: "Belarus", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "bz", phoneCode: "+501", name: "Belize", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ca", phoneCode: "+1", name: "Canada", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cc", phoneCode: "+61", name: "Cocos (keeling) Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cd", phoneCode: "+243", name: "Congo, The Democratic Republic Of The", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cf", phoneCode: "+236", name: "Central African Republic", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cg", phoneCode: "+242", name: "Congo", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ch", phoneCode: "+41", name: "Switzerland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ci", phoneCode: "+225", name: "Côte D'ivoire", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ck", phoneCode: "+682", name: "Cook Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cl", phoneCode: "+56", name: "Chile", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cm", phoneCode: "+237", name: "Cameroon", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cn", phoneCode: "+86", name: "China", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "co", phoneCode: "+57", name: "Colombia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cr", phoneCode: "+506", name: "Costa Rica", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cu", phoneCode: "+53", name: "Cuba", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cv", phoneCode: "+238", name: "Cape Verde", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cx", phoneCode: "+61", name: "Christmas Island", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cy", phoneCode: "+357", name: "Cyprus", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "cz", phoneCode: "+420", name: "Czech Republic", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "de", phoneCode: "+49", name: "Germany", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "dj", phoneCode: "+253", name: "Djibouti", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "dk", phoneCode: "+45", name: "Denmark", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "dm", phoneCode: "+1", name: "Dominica", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "do", phoneCode: "+1", name: "Dominican Republic", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "dz", phoneCode: "+213", name: "Algeria", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ec", phoneCode: "+593", name: "Ecuador", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ee", phoneCode: "+372", name: "Estonia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "eg", phoneCode: "+20", name: "Egypt", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "er", phoneCode: "+291", name: "Eritrea", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "es", phoneCode: "+34", name: "Spain", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "et", phoneCode: "+251", name: "Ethiopia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "fi", phoneCode: "+358", name: "Finland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "fj", phoneCode: "+679", name: "Fiji", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "fk", phoneCode: "+500", name: "Falkland Islands (malvinas)", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "fm", phoneCode: "+691", name: "Micronesia, Federated States Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "fo", phoneCode: "+298", name: "Faroe Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "fr", phoneCode: "+33", name: "France", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ga", phoneCode: "+241", name: "Gabon", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gb", phoneCode: "+44", name: "United Kingdom", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gd", phoneCode: "+1", name: "Grenada", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ge", phoneCode: "+995", name: "Georgia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gf", phoneCode: "+594", name: "French Guyana", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gh", phoneCode: "+233", name: "Ghana", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gi", phoneCode: "+350", name: "Gibraltar", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gl", phoneCode: "+299", name: "Greenland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gm", phoneCode: "+220", name: "Gambia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gn", phoneCode: "+224", name: "Guinea", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gp", phoneCode: "+450", name: "Guadeloupe", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gq", phoneCode: "+240", name: "Equatorial Guinea", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gr", phoneCode: "+30", name: "Greece", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gt", phoneCode: "+502", name: "Guatemala", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gu", phoneCode: "+1", name: "Guam", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gw", phoneCode: "+245", name: "Guinea-bissau", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "gy", phoneCode: "+592", name: "Guyana", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "hk", phoneCode: "+852", name: "Hong Kong", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "hn", phoneCode: "+504", name: "Honduras", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "hr", phoneCode: "+385", name: "Croatia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ht", phoneCode: "+509", name: "Haiti", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "hu", phoneCode: "+36", name: "Hungary", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "id", phoneCode: "+62", name: "Indonesia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ie", phoneCode: "+353", name: "Ireland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "il", phoneCode: "+972", name: "Israel", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "im", phoneCode: "+44", name: "Isle Of Man", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "is", phoneCode: "+354", name: "Iceland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "in", phoneCode: "+91", name: "India", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "io", phoneCode: "+246", name: "British Indian Ocean Territory", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "iq", phoneCode: "+964", name: "Iraq", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ir", phoneCode: "+98", name: "Iran, Islamic Republic Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "it", phoneCode: "+39", name: "Italy", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "je", phoneCode: "+44", name: "Jersey ", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "jm", phoneCode: "+1", name: "Jamaica", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "jo", phoneCode: "+962", name: "Jordan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "jp", phoneCode: "+81", name: "Japan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ke", phoneCode: "+254", name: "Kenya", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kg", phoneCode: "+996", name: "Kyrgyzstan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kh", phoneCode: "+855", name: "Cambodia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ki", phoneCode: "+686", name: "Kiribati", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "km", phoneCode: "+269", name: "Comoros", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kn", phoneCode: "+1", name: "Saint Kitts and Nevis", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kp", phoneCode: "+850", name: "North Korea", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kr", phoneCode: "+82", name: "South Korea", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kw", phoneCode: "+965", name: "Kuwait", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ky", phoneCode: "+1", name: "Cayman Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "kz", phoneCode: "+7", name: "Kazakhstan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "la", phoneCode: "+856", name: "Lao People's Democratic Republic", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lb", phoneCode: "+961", name: "Lebanon", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lc", phoneCode: "+1", name: "Saint Lucia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "li", phoneCode: "+423", name: "Liechtenstein", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lk", phoneCode: "+94", name: "Sri Lanka", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lr", phoneCode: "+231", name: "Liberia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ls", phoneCode: "+266", name: "Lesotho", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lt", phoneCode: "+370", name: "Lithuania", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lu", phoneCode: "+352", name: "Luxembourg", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "lv", phoneCode: "+371", name: "Latvia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ly", phoneCode: "+218", name: "Libya", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ma", phoneCode: "+212", name: "Morocco", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mc", phoneCode: "+377", name: "Monaco", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "md", phoneCode: "+373", name: "Moldova, Republic Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "me", phoneCode: "+382", name: "Montenegro", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mf", phoneCode: "+590", name: "Saint Martin", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mg", phoneCode: "+261", name: "Madagascar", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mh", phoneCode: "+692", name: "Marshall Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mk", phoneCode: "+389", name: "Macedonia, The Former Yugoslav Republic Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ml", phoneCode: "+223", name: "Mali", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mm", phoneCode: "+95", name: "Myanmar", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mn", phoneCode: "+976", name: "Mongolia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mo", phoneCode: "+853", name: "Macao", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mp", phoneCode: "+1", name: "Northern Mariana Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mq", phoneCode: "+596", name: "Martinique", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mr", phoneCode: "+222", name: "Mauritania", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ms", phoneCode: "+1", name: "Montserrat", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mt", phoneCode: "+356", name: "Malta", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mu", phoneCode: "+230", name: "Mauritius", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mv", phoneCode: "+960", name: "Maldives", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mw", phoneCode: "+265", name: "Malawi", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mx", phoneCode: "+52", name: "Mexico", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "my", phoneCode: "+60", name: "Malaysia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "mz", phoneCode: "+258", name: "Mozambique", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "na", phoneCode: "+264", name: "Namibia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "nc", phoneCode: "+687", name: "New Caledonia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ne", phoneCode: "+227", name: "Niger", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "nf", phoneCode: "+672", name: "Norfolk Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ng", phoneCode: "+234", name: "Nigeria", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ni", phoneCode: "+505", name: "Nicaragua", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "nl", phoneCode: "+31", name: "Netherlands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "no", phoneCode: "+47", name: "Norway", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "np", phoneCode: "+977", name: "Nepal", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "nr", phoneCode: "+674", name: "Nauru", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "nu", phoneCode: "+683", name: "Niue", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "nz", phoneCode: "+64", name: "New Zealand", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "om", phoneCode: "+968", name: "Oman", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pa", phoneCode: "+507", name: "Panama", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pe", phoneCode: "+51", name: "Peru", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pf", phoneCode: "+689", name: "French Polynesia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pg", phoneCode: "+675", name: "Papua New Guinea", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ph", phoneCode: "+63", name: "Philippines", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pk", phoneCode: "+92", name: "Pakistan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pl", phoneCode: "+48", name: "Poland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pm", phoneCode: "+508", name: "Saint Pierre And Miquelon", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pn", phoneCode: "+870", name: "Pitcairn", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pr", phoneCode: "+1", name: "Puerto Rico", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ps", phoneCode: "+970", name: "Palestine", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pt", phoneCode: "+351", name: "Portugal", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "pw", phoneCode: "+680", name: "Palau", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "py", phoneCode: "+595", name: "Paraguay", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "qa", phoneCode: "+974", name: "Qatar", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "re", phoneCode: "+262", name: "Réunion", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ro", phoneCode: "+40", name: "Romania", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "rs", phoneCode: "+381", name: "Serbia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ru", phoneCode: "+7", name: "Russian Federation", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "rw", phoneCode: "+250", name: "Rwanda", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sa", phoneCode: "+966", name: "Saudi Arabia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sb", phoneCode: "+677", name: "Solomon Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sc", phoneCode: "+248", name: "Seychelles", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sd", phoneCode: "+249", name: "Sudan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "se", phoneCode: "+46", name: "Sweden", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sg", phoneCode: "+65", name: "Singapore", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sh", phoneCode: "+290", name: "Saint Helena, Ascension And Tristan Da Cunha", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "si", phoneCode: "+386", name: "Slovenia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sk", phoneCode: "+421", name: "Slovakia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sl", phoneCode: "+232", name: "Sierra Leone", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sm", phoneCode: "+378", name: "San Marino", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sn", phoneCode: "+221", name: "Senegal", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "so", phoneCode: "+252", name: "Somalia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sr", phoneCode: "+597", name: "Suriname", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "st", phoneCode: "+239", name: "Sao Tome And Principe", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sv", phoneCode: "+503", name: "El Salvador", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sx", phoneCode: "+1", name: "Sint Maarten", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sy", phoneCode: "+963", name: "Syrian Arab Republic", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "sz", phoneCode: "+268", name: "Swaziland", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tc", phoneCode: "+1", name: "Turks and Caicos Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "td", phoneCode: "+235", name: "Chad", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tg", phoneCode: "+228", name: "Togo", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "th", phoneCode: "+66", name: "Thailand", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tj", phoneCode: "+992", name: "Tajikistan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tk", phoneCode: "+690", name: "Tokelau", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tl", phoneCode: "+670", name: "Timor-leste", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tm", phoneCode: "+993", name: "Turkmenistan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tn", phoneCode: "+216", name: "Tunisia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "to", phoneCode: "+676", name: "Tonga", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tr", phoneCode: "+90", name: "Turkey", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tt", phoneCode: "+1", name: "Trinidad &amp; Tobago", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tv", phoneCode: "+688", name: "Tuvalu", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tw", phoneCode: "+886", name: "Taiwan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "tz", phoneCode: "+255", name: "Tanzania, United Republic Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ua", phoneCode: "+380", name: "Ukraine", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ug", phoneCode: "+256", name: "Uganda", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "us", phoneCode: "+1", name: "United States", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "uy", phoneCode: "+598", name: "Uruguay", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "uz", phoneCode: "+998", name: "Uzbekistan", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "va", phoneCode: "+379", name: "Holy See (vatican City State)", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "vc", phoneCode: "+1", name: "Saint Vincent &amp; The Grenadines", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ve", phoneCode: "+58", name: "Venezuela, Bolivarian Republic Of", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "vg", phoneCode: "+1", name: "British Virgin Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "vi", phoneCode: "+1", name: "US Virgin Islands", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "vn", phoneCode: "+84", name: "Viet Nam", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "vu", phoneCode: "+678", name: "Vanuatu", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "wf", phoneCode: "+681", name: "Wallis And Futuna", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ws", phoneCode: "+685", name: "Samoa", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "xk", phoneCode: "+383", name: "Kosovo", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "ye", phoneCode: "+967", name: "Yemen", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "yt", phoneCode: "+262", name: "Mayotte", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "za", phoneCode: "+27", name: "South Africa", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "zm", phoneCode: "+260", name: "Zambia", flagResID: DEFAULT_FLAG_RES));
        countries.append(getCountryCodeService(nameCode: "zw", phoneCode: "+263", name: "Zimbabwe", flagResID: DEFAULT_FLAG_RES));
        return countries;
    }
}
