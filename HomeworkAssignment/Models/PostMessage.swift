//
//  PostMessage.swift
//  HomeworkAssignment
//
//  Created by Greg Hughes on 12/9/20.
//

import Foundation
class PostMessage: Codable {
    
    let user: String
    let operation : String
    let subject: String
    let message: String
    
    internal init(user: String, subject: String, message: String) {
        self.user = user
        self.operation = "add_message"
        self.subject = subject
        self.message = message
    }
}
