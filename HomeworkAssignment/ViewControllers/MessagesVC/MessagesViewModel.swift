//
//  MessagesViewModel.swift
//  HomeworkAssignment
//
//  Created by Greg Hughes on 12/9/20.
//

import UIKit
import Combine

class MessagesViewData {
    
    @Published var userMessagesToShow : [User] = []
    @Published var titleLabel = "ALL MESSAGES"
    var cancellable : AnyCancellable?
    
    init() {
        // when UserController.shared.$currentUsers updates, it will update userMessagesToShow
        cancellable = UserController.shared.$currentUsers.sink {[weak self] users in
            self?.userMessagesToShow = users.sorted(by: {$0.name < $1.name})
        }
        fetchAllMessages()
    }
    
    func numberOfSections() -> Int{
        return userMessagesToShow.count
    }
    
    func titleForHeaderInSection(section: Int) -> String? {
        return userMessagesToShow[section].name
    }
    
    func cellForRowAt(cell: UITableViewCell, indexPath: IndexPath) -> UITableViewCell {
        
        let message = userMessagesToShow[indexPath.section].messages[indexPath.row]
        cell.textLabel?.text = message.subject
        cell.detailTextLabel?.text = message.message
        return cell
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return userMessagesToShow[section].messages.count
    }
    
    func fetchAllMessages() {
        UserController.shared.fetchAllMessages { _ in}
    }
    
    func fetchUserMessages(user: User) {
        UserController.shared.fetchUserMessagesa(user: user) {}
    }
    
    func postNewMessage(user: String?, subject: String?, message: String?) {
        if user != "", subject != "", message != "" {
            UserController.shared.postMessages(user: user ?? "", subject: subject ?? "", message: message ?? "") {}
        }else {
            allMustContainValuesAlert()
        }
    }
    
    func newMessageAlert() {
        let alertController = UIAlertController(title: "New Message", message: "Please enter your username, subject, and message", preferredStyle: .alert)
        
        var usernameTextField = UITextField()
        var subjectTextField = UITextField()
        var messageTextField = UITextField()
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Please Enter Your Username"
            usernameTextField = textField
            usernameTextField.accessibilityLabel = "usernameTextField"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Please Enter The Subject"
            subjectTextField = textField
            subjectTextField.accessibilityLabel = "subjectTextField"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Please Enter Your Message"
            messageTextField = textField
            messageTextField.accessibilityLabel = "messageTextField"
        }
        let okButton = UIAlertAction(title: "Ok", style: .default) {[weak self] (action) in
            if ((usernameTextField.text ?? "").contains(" ")) {
                self?.noNameAlert()
            }else {
                self?.postNewMessage(user: usernameTextField.text, subject: subjectTextField.text, message: messageTextField.text)
            }
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        alertController.show()
    }
    
    private func noNameAlert() {
        let alertController = UIAlertController(title: "No Spaces", message: "usernames cannot have spaces", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        alertController.show()
    }
    
    private func allMustContainValuesAlert() {
        let alertController = UIAlertController(title: "Error", message: "All fields must contain values", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        alertController.show()
    }
}
