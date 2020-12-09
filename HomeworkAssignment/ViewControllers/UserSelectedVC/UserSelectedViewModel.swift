//
//  UserSelectedViewModel.swift
//  HomeworkAssignment
//
//  Created by Greg Hughes on 12/9/20.
//

import Foundation
import UIKit

class UserTVCData {
    
    var users = UserController.shared.allUsers

    func numberOfSections() -> Int{
        return 1
    }
    
    func cellForRowAt(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
    
    func didSelectRowAt(row: Int) {
        UserController.shared.fetchUserMessagesa(user: users[row]) {}
    }
    
    func numberOfRowsInSection() -> Int {
        return users.count
    }
}
