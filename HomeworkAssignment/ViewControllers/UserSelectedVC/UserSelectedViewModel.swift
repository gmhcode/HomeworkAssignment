//
//  UserSelectedViewModel.swift
//  HomeworkAssignment
//
//  Created by Greg Hughes on 12/9/20.
//

import Foundation
import UIKit

class UserTVCData {
    
    @Published var users = [User]()

    init() {
        UserController.shared.fetchAllUserNames { [weak self] (users) in
            guard let users = users else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            self?.users = users
        }
    }
    
    
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
