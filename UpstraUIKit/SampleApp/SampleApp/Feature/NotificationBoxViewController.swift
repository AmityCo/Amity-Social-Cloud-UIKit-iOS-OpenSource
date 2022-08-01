//
//  NotificationBoxViewController.swift
//  SampleApp
//
//  Created by Jiratin Teean on 1/8/2565 BE.
//  Copyright © 2565 BE Eko. All rights reserved.
//

import UIKit
import AmityUIKit

class NotificationBoxViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    
    var dataList: [NotificationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notification Box"
        tableView.tableFooterView = UIView()
    }
}

extension NotificationBoxViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableCell", for: indexPath)
        cell.textLabel?.text = dataList[indexPath.row].description
        return cell
    }
}
