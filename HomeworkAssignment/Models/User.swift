//
//  User.swift
//  HomeworkAssignment
//
//  Created by Greg Hughes on 12/8/20.
//

import Foundation

class User: Codable, Equatable {
    
    let name: String
    let messages: [Message]
    
    init(name: String, message: [Message]) {
        self.name = name
        self.messages = message
    }
    enum CodingKeys: CodingKey {
        case name
        case messages
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name
    }
}
