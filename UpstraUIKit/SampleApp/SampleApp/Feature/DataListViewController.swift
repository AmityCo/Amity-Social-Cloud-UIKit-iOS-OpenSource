//
//  DataListViewController.swift
//  SampleApp
//
//  Created by Hamlet on 24.02.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

class DataListViewController: UIViewController {

    enum DataList: CaseIterable {
        case post

        var text: String {
            switch self {
            case .post: return "Post Data Preview"
            }
        }
    }

    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Data List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

extension DataListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch DataList.allCases[indexPath.row] {
        case .post:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserPostsFeedViewController") as! GlobalPostsFeedViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension DataListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataList.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        cell.textLabel?.text = DataList.allCases[indexPath.row].text
        return cell
    }
}
