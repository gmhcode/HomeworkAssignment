//
//  Message.swift
//  HomeworkAssignment
//
//  Created by Greg Hughes on 12/8/20.
//

import Foundation
struct Message: Codable {
    let subject: String
    let message: String

    enum CodingKeys: CodingKey {
        case subject
        case message
    }
}
