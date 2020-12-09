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
    var cancellable = Set<AnyCancellable>()
    
    init() {
        testPosts()
        // when UserController.shared.$currentUsers updates, it will update userMessagesToShow
        UserController.shared.$currentUsers.sink {[weak self] users in
            self?.userMessagesToShow = users.sorted(by: {$0.name < $1.name})
            
        }.store(in: &cancellable)
        
        UserController.shared.$state.sink { [weak self] state in
            guard let strongSelf = self else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

            if state == .all {
                strongSelf.titleLabel = "ALL MESSAGES"
            }else {
                strongSelf.titleLabel = strongSelf.userMessagesToShow.count > 0 ? strongSelf.userMessagesToShow[0].name : "no users to show"
            }
        }.store(in: &cancellable)
        
        fetchAllMessages()
    }
    func testPosts() {
        let semaphore = DispatchSemaphore(value: 0)
        postNewMessage(user: "john", subject: "bob", message: "Hi bob") {
            self.postNewMessage(user: "bob", subject: "john", message: "Hi John", completion: {
                semaphore.signal()
            })
        }
        semaphore.wait()
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
    
    func postNewMessage(user: String?, subject: String?, message: String?, completion: (()->())?) {
        if user != "", subject != "", message != "" {
            UserController.shared.postMessages(user: user ?? "", subject: subject ?? "", message: message ?? "") {
                completion?()
            }
        }else {
            allMustContainValuesAlert()
            completion?()
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
                self?.postNewMessage(user: usernameTextField.text, subject: subjectTextField.text, message: messageTextField.text, completion: nil)
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
