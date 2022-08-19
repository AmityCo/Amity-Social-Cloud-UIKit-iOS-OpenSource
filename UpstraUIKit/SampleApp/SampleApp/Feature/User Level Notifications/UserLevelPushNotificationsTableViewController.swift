//
//  UserLevelPushNotificationsTableViewController.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 23/4/2564 BE.
//  Copyright © 2564 BE Eko. All rights reserved.
//

import AmitySDK
import AmityUIKit
import UIKit

struct UserNotificationModuleViewModel {

    let type: AmityNotificationModuleType
    var isEnabled: Bool
    var acceptOnlyModerator: Bool

    var title: String {
        switch type {
        case .chat:
            return "Chat Notification"
        case .social:
            return "Social Notification"
        case .videoStreaming:
            return "Video-Streaming Notification"
        @unknown default:
            fatalError()
        }
    }
}

final class UserLevelPushNotificationsTableViewController: UITableViewController {
    
    private var isEnabled: Bool = false
    private var modules: [UserNotificationModuleViewModel] = []
    
    private var copyDeviceTokenButtonItem: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "User Notifications"
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchTableViewCell")
        tableView.register(NotificationModuleTableViewCell.self, forCellReuseIdentifier: "NotificationModuleTableViewCell")
        
        copyDeviceTokenButtonItem = UIBarButtonItem(title: "Copy Device ID", style: .plain, target: self, action: #selector(copyDeviceToken))
        navigationItem.rightBarButtonItem = copyDeviceTokenButtonItem
    }
    
    @objc private func copyDeviceToken() {
        UIPasteboard.general.string = AppManager.shared.getDeviceToken()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return modules.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell") as! SwitchTableViewCell
            
            cell.configure(title: "Notification", isEnabled: isEnabled)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationModuleTableViewCell") as! NotificationModuleTableViewCell
            
            let module = modules[indexPath.row]
            cell.configure(title: module.title, isEnabled: module.isEnabled, isModerator: module.acceptOnlyModerator)
            cell.delegate = self
            return cell
        }
    }

    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 44 : 80
    }
    
    // MARK: - Private methods
    
    private func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))

        present(alertController, animated: true, completion: nil)
    }
    
    private func fetchUserNotification() {
        let notificationManager = AmityUIKitManager.client.notificationManager
        notificationManager.getSettingsWithCompletion { [weak self] (notification, error) in
            guard let strongSelf = self,
                  let notification = notification else { return }
            strongSelf.isEnabled = notification.isEnabled
            strongSelf.modules = notification.modules.map { UserNotificationModuleViewModel(type: $0.moduleType, isEnabled: $0.isEnabled, acceptOnlyModerator: $0.roleFilter?.roleIds?.contains("moderator") ?? false ) }
            strongSelf.tableView.reloadData()
        }
    }

    private func updateNotification() {
        let notificationManager = AmityUIKitManager.client.notificationManager
        if isEnabled {
            let _modules = modules.map { module -> AmityUserNotificationModule in
                let roleIds: [String] = module.acceptOnlyModerator ? ["moderator"] : []
                return AmityUserNotificationModule(moduleType: module.type, isEnabled: module.isEnabled, roleFilter: .onlyFilter(withRoleIds: roleIds))
            }
            notificationManager.enable(for: _modules, completion: nil)
        } else {
            notificationManager.disable(completion: nil)
        }
    }
    
    
}

extension UserLevelPushNotificationsTableViewController: NotificationModuleTableViewCellDelegate {
    
    func cellRoleButtonDidTap(_ cell: NotificationModuleTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        var updatedModule = modules[indexPath.row]
        updatedModule.acceptOnlyModerator = cell.acceptOnlyModerator
        modules[indexPath.row] = updatedModule
        updateNotification()
    }
    
    func cell(_ cell: NotificationModuleTableViewCell, valueDidChange isEnabled: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        var updatedModule = modules[indexPath.row]
        updatedModule.isEnabled = isEnabled
        modules[indexPath.row] = updatedModule
        updateNotification()
    }
    
}

extension UserLevelPushNotificationsTableViewController: SwitchTableViewCellDelegate {
    
    func cell(_ cell: SwitchTableViewCell, valueDidChange isEnabled: Bool) {
        guard tableView.indexPath(for: cell) != nil else { return }
        self.isEnabled = isEnabled
        updateNotification()
    }
    
}
