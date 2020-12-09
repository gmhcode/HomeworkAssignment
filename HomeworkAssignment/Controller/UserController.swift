//
//  MessageController.swift
//  HomeworkAssignment
//
//  Created by Greg Hughes on 12/8/20.
//

import Foundation
import UIKit
import Combine


// MARK: - UserController
class UserController: ObservableObject {
    
    static var shared = UserController()
    private let url = URL(string: "https://abraxvasbh.execute-api.us-east-2.amazonaws.com/proto/messages")
    @Published var state = MessagesState.all
    @Published var currentUsers = [User]()
    @Published var allUsers = [User]()
    
    enum MessagesState {
        case all
        case individual
    }
    
    // MARK: - UserMessagesData
    /// Used when fetched messages from individual users
    struct UserMessagesData: DecodableResponse {
        typealias MyType = AllMessagesData
        
        typealias ArrayType = User
        
        var array: [User]
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: BackEndUtils.DynamicCodingKeys.self)
            
            let userKeyString = BackEndUtils.DynamicCodingKeys(stringValue: "user")
            let messageKeyString = BackEndUtils.DynamicCodingKeys(stringValue: "message")
            let username = try container.decode(String.self, forKey: userKeyString)
            let messages = try container.decode([Message].self, forKey: messageKeyString)
            
            array = [User(name: username, message: messages)]
        }
    }
    /// fetchUserMessages - fetches the provided user's messages
    func fetchUserMessagesa(user:User, completion:@escaping ()->()) {
        
        guard let url = URL(string: "https://abraxvasbh.execute-api.us-east-2.amazonaws.com/proto/messages/\(user.name)") else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {[weak self] (data, res, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription) : \(#file) \(#line)")
                self?.errorAlertController(error: error)
                completion()
                return
            }
            let data = data ?? Data()
            
            do {
                let jsonDecoder = JSONDecoder()
                let userContainer = try jsonDecoder.decode(BackendResponse<UserMessagesData>.self, from: data)
                self?.currentUsers = userContainer.users
                self?.state = .individual
                completion()
            }catch let er{
                print("❌ There was an error in \(#function) \(er) : \(er.localizedDescription) : \(#file) \(#line)")
                self?.errorAlertController(error: er)
                completion()
            }
        }.resume()
    }
    
    // MARK: - fetchAllMessages
    func fetchAllMessages(completion:@escaping ([User]?)->()) {
        
        guard let url = url else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<");completion(nil); return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
            if let error = err {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription) : \(#file) \(#line)")
                self?.errorAlertController(error: error)
                return
            }
            guard let data = data else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); completion(nil); return}
            
            
            do {
                let jsonDecoder = JSONDecoder()
                let topLvlDict = try jsonDecoder.decode(BackendResponse<AllMessagesData>.self, from: data)
                
                self?.currentUsers = topLvlDict.users
                self?.allUsers = topLvlDict.users
                self?.state = .all
                completion(topLvlDict.users)
                
            } catch let er{
                
                print("❌ There was an error in \(#function) \(er) : \(er.localizedDescription) : \(#file) \(#line)")
                self?.errorAlertController(error: er)
                completion(nil)
            }
        }.resume()
    }
    
    func fetchAllUserNames(completion:@escaping ([User]?)->()) {
        
        guard let url = url else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<");completion(nil); return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
            if let error = err {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription) : \(#file) \(#line)")
                self?.errorAlertController(error: error)
                return
            }
            guard let data = data else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); completion(nil); return}
            
            
            do {
                let jsonDecoder = JSONDecoder()
                let topLvlDict = try jsonDecoder.decode(BackendResponse<AllMessagesData>.self, from: data)
                
                self?.allUsers = topLvlDict.users
                completion(topLvlDict.users)
                
            } catch let er{
                
                print("❌ There was an error in \(#function) \(er) : \(er.localizedDescription) : \(#file) \(#line)")
                self?.errorAlertController(error: er)
                completion(nil)
            }
        }.resume()
    }
    
    ///posts a user and their message
    func postMessages(user: String, subject: String, message: String, completion:@escaping ()->()) {
        
        guard let url = url else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        let params = getParams(postMessage: PostMessage(user: user, subject: subject, message: message))
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = (try? JSONSerialization.data(withJSONObject: params, options: .init())) ?? Data()
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        URLSession.shared.dataTask(with: request) {[weak self] (data, res, er) in
            if let er = er {
                print("❌ There was an error in \(#function) \(er) : \(er.localizedDescription) : \(#file) \(#line)")
                self?.errorAlertController(error: er)
                completion()
            }
            
            if data != nil  {
                if self?.state == .all {
                    self?.fetchAllMessages(completion: {_ in
                        completion()
                    })
                } else {
                    if (self?.currentUsers.contains(where: {$0.name == user}) != false) {
                        let currentUser = self?.currentUsers.filter({$0.name == user}) ?? []
                        
                        self?.fetchUserMessagesa(user: currentUser[0], completion: {
                            completion()
                        })
                    }
                }
                
            }
        }.resume()
    }
    
    func errorAlertController(error: Error) {
        let alertController = UIAlertController(title: "ERROR", message: "We are experiencing connection issues... or the guy who coded this did something wrong", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        alertController.show()
    }
    
    
    struct BackendResponse<T:DecodableResponse>: Decodable {
        var users = [T.ArrayType]()
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: BackEndUtils.DynamicCodingKeys.self)
            
            let bodyKey = BackEndUtils.DynamicCodingKeys(stringValue: "body")
            let mesDataString = try container.decode(String.self, forKey: bodyKey)
            let mesData = mesDataString.data(using: .utf8) ?? Data()
            let messageData = try JSONDecoder().decode(T.self, from: mesData)
            
            users = messageData.array
            
        }
    }
    
    // MARK: - AllMessagesData
    struct AllMessagesData: DecodableResponse {
        
        typealias MyType = AllMessagesData
        
        typealias ArrayType = User
        
        var array: [User]
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: BackEndUtils.DynamicCodingKeys.self)
            
            var tempArray = [User]()
            
            for key in container.allKeys {
                let keyString = BackEndUtils.DynamicCodingKeys(stringValue: key.stringValue)
                
                let messages = try container.decode([Message].self, forKey: keyString)
                
                tempArray.append(User(name: key.stringValue, message: messages))
                
            }
            array = tempArray
        }
    }
    
    /// prepares the parameters of the PostMessage to be sent in the url
    private func getParams(postMessage: PostMessage?) -> [String:Any] {
        
        guard let postMessage = postMessage else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return [:]}
        
        let params : [String:Any] = ["user":postMessage.user,"operation":postMessage.operation,"subject":postMessage.subject,"message":postMessage.message]
        return params
    }
}

protocol DecodableResponse: Decodable {
    associatedtype  MyType
    associatedtype ArrayType
    var array : [ArrayType]{ get set }
}


