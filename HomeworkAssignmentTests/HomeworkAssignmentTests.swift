//
//  HomeworkAssignmentTests.swift
//  HomeworkAssignmentTests
//
//  Created by Greg Hughes on 12/7/20.
//

import XCTest
@testable import HomeworkAssignment

class HomeworkAssignmentTests: XCTestCase {
    
    var messagesViewData = MessagesViewData()
    
    override func setUpWithError() throws {
        fetchAllMessages()
    }
    
    func fetchAllMessages() {
        let str = "{\"john\": [{\"subject\": \"pets\", \"message\": \"cats are grumpy\"}, {\"subject\": \"pets\", \"message\": \"cats are grumpy\"}, {\"subject\": \"pets\", \"message\": \"cats are grumpy\"}], \"bob\": [{\"subject\": \"bob stuffaa\", \"message\": \"bob bob bobaa\"}], \"asd\": [{\"subject\": \"bob stuffaa\", \"message\": \"222\"}]}"
        
        let b = str.data(using: .utf8)!
        
        do {
            let jsonDecoder = JSONDecoder()
            let m = try jsonDecoder.decode(UserController.AllMessagesData.self, from: b)
            print(m.array)
            UserController.shared.currentUsers = m.array
            UserController.shared.allUsers = UserController.shared.currentUsers
            UserController.shared.state = .all
        }catch let er{
            
            print("❌ There was an error in \(#function) \(er) : \(er.localizedDescription) : \(#file) \(#line)")
        }
    }
    
    func testMessageViewDataMessages() throws {
        let theBool = messagesViewData.userMessagesToShow.count == UserController.shared.allUsers.count
        
        XCTAssertTrue(theBool)
    }
    
    func testMVDNumberOfSections() throws {
        let theBool = messagesViewData.numberOfSections() == UserController.shared.allUsers.count
        
        XCTAssertTrue(theBool)
    }
    
    func testMVDTitleForHeaderInSection() throws {
        let theBool = messagesViewData.titleForHeaderInSection(section: 0) == messagesViewData.userMessagesToShow[0].name
        
        XCTAssertTrue(theBool)
    }
    func testMVDCellForRowAt() throws {
        let cell = UITableViewCell()
        let indexPath = IndexPath(row: 0, section: 0)
        
        let theBool = messagesViewData.cellForRowAt(cell: cell, indexPath: indexPath).textLabel?.text == messagesViewData.userMessagesToShow[0].messages[0].subject
        
        XCTAssertTrue(theBool)
    }
    
    func testMVDNumberOfRowsInSection() throws {
        let theBool = messagesViewData.numberOfRowsInSection(section: 0) == messagesViewData.userMessagesToShow[0].messages.count
        
        XCTAssertTrue(theBool)
    }
    
    func testMVDPostNewMessage() throws {
        
        let newMessageText = "1"
        
        messagesViewData.postNewMessage(user: newMessageText, subject: newMessageText, message: newMessageText)
        sleep(3)
        
        let theBool = messagesViewData.userMessagesToShow.contains(where: {$0.name == newMessageText})
        
        XCTAssertTrue(theBool)
    }
    
}
