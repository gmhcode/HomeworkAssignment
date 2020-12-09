//
//  UserSelectTableVIewControllerTableViewController.swift
//  HomeworkAssignment
//
//  Created by Greg Hughes on 12/8/20.
//

import UIKit
import Combine
class UserSelectTableViewController: UITableViewController {

    let userTVCData = UserTVCData()
    var cancellable : AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancellable = userTVCData.$users.receive(on: RunLoop.main).sink(receiveValue: {[weak self] _ in
            self?.tableView.reloadData()
        })
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return userTVCData.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTVCData.numberOfRowsInSection()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTVCCell", for: indexPath)
        return userTVCData.cellForRowAt(cell: cell, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userTVCData.didSelectRowAt(row: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
}
