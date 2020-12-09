//
//  MessagesViewController.swift
//  HomeworkAssignment
//
//  Created by Greg Hughes on 12/8/20.
//

import UIKit
import Combine


class MessagesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postMessageButton: UIBarButtonItem!
    
    var messagesViewData = MessagesViewData()
    var reloadCancellable : AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        //reloads tableView when $userMessagesToShow changes its value, which changes its value when UserController.shared.currentUsers changes its value
        reloadCancellable = messagesViewData.$userMessagesToShow
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self](_) in
                self?.tableView.reloadData()
            })
        //For UI testing
        postMessageButton.accessibilityLabel = "postMessage"
    }
    
    @IBAction func allTapped(_ sender: Any) {
        messagesViewData.fetchAllMessages()
        navigationItem.title = "ALL MESSAGES"
    }
    
    @IBAction func individualTapped(_ sender: Any) {
        performSegue(withIdentifier: "userSelectionSegue", sender: nil)
        navigationItem.title = messagesViewData.userMessagesToShow.count > 0 ? messagesViewData.userMessagesToShow[0].name : "no users to show"
    }
    
    @IBAction func newMessageTapped(_ sender: Any) {
        messagesViewData.newMessageAlert()
    }
}

extension MessagesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesViewData.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainVCCell", for: indexPath)
        return messagesViewData.cellForRowAt(cell: cell, indexPath: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messagesViewData.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return messagesViewData.titleForHeaderInSection(section: section)
    }
}
