//
//  BackendUtils.swift
//  HomeworkAssignment
//
//  Created by Greg Hughes on 12/8/20.
//

import Foundation


class BackEndUtils {
    struct DynamicCodingKeys: CodingKey {
       var stringValue: String
       init?(stringValue: String) {
           self.stringValue = stringValue
       }
       init?(nestedString: String) {
           self.stringValue = nestedString
       }

       var intValue: Int?
       init?(intValue: Int) {
           return nil
       }
    }
}
