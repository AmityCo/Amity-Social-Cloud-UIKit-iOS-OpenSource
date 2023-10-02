//
//  RegisterViewController.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 21/7/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import AmityUIKit
import AmitySDK
import SwiftUI

class RegisterViewController: UIViewController {
    
    private let userDefault = UserDefaults.standard
    
    @IBOutlet private var versionLabel: UILabel!
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var endpointsButton: UIBarButtonItem!
    
    private let cellIdentifier = "cell"
    private let defaultUser = "victimIOS"
    private var users: [String] {
        get {
            return AppManager.shared.getUsers()
        } set {
            AppManager.shared.updateUsers(withUserIds: newValue)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if users.isEmpty {
            users.append(defaultUser)
        }
        textField.placeholder = "Type your name..."
        textField.returnKeyType = .done
        textField.delegate = self
        
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        
        versionLabel.text = "\(version) build \(build)"
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func addUserIDsTap() {
        addUser()
        
    }
    
    @IBAction func endpointsDidTap(_ sender: Any) {
        let endpointView = EndpointsView()
        let endpointVC = UIHostingController(rootView: endpointView)
        
        endpointVC.rootView.saveButtonDidTap = {
            endpointVC.dismiss(animated: true, completion: nil)
        }
        present(endpointVC, animated: true, completion: nil)
    }
    
    private func addUser() {
        guard let text = textField.text, !text.isEmpty else { return }
        users.append(text)
        textField.text = nil
        textField.resignFirstResponder()
    }
    
    private func register(index: Int) {
        let userId = users[index]
        AppManager.shared.register(withUserId: userId)
    }
    
}
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addUser()
        return true
    }
}
extension RegisterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        register(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        users.remove(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if users[indexPath.row] != defaultUser {
            return .delete
        }
        return .none
    }
}

extension RegisterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = users[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
