//
//  ItemModel.swift
//  ItemSelector
//
//  Created by Amzad Khan on 19/10/19.
//  Copyright © 2019 Amzad Khan. All rights reserved.
//

import Foundation

public struct SearchUser: Codable {
    
    public let name, jid: String
    public let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case jid
        case avatar
    }
    
    public init(name: String, jid: String, image: String) {
        self.name = name
        self.jid = jid
        self.avatar = image
    }
}

extension SearchUser : Selectable {
    
    var id: String { return self.jid }
    var title: String { return self.name }
    var avatarURL:String? { return self.avatar }
    
}

