//
//  Chat.swift
//  TeleHealth
//
//  Created by Francis Jemuel Bergonia on 3/16/20.
//  Copyright © 2020 Xi Apps. All rights reserved.
//

import Foundation

struct Chat {
    var users: [String]
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension Chat {
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
}
