//
//  User.swift : Сущность "Пользователь"
//  VKR
//  Created by Арина Нефёдова on 08.05.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.

import CoreLocation // Библиотека для обработки георграфического местоположения

enum AccountType: Int { // Пользовательские типы Личного кабинета
    case client
    case driver
}
struct User { // Атрибуты
    let fullname: String
    let email: String
    let phone: String
    var accountType: AccountType!
    var location: CLLocation?
    let uid: String
    var homeLocation: String?
    var workLocation: String?
    var firstInitial: String { return String(fullname.prefix(1)) }

    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.phone = dictionary["phone"] as? String ?? ""
        
        if let home = dictionary["homeLocation"] as? String {
            self.homeLocation = home
                //.replacingOccurrences(of: "Saint Petersburg,", with: "")
        }
        
        if let work = dictionary["workLocation"] as? String {
            self.workLocation = work
                //.replacingOccurrences(of: "Saint Petersburg,", with: "")
        }
        
        if let index = dictionary["accountType"] as? Int {
            self.accountType = AccountType(rawValue: index)
        }
    }
}
