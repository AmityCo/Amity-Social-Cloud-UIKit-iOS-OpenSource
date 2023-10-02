//
//  NotificationModuleTableViewCell.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 23/4/2564 BE.
//  Copyright © 2564 BE Eko. All rights reserved.
//

import UIKit

protocol NotificationModuleTableViewCellDelegate: AnyObject {
    func cell(_ cell: NotificationModuleTableViewCell, valueDidChange isEnabled: Bool)
    func cellRoleButtonDidTap(_ cell: NotificationModuleTableViewCell)
}

class NotificationModuleTableViewCell: UITableViewCell {
    
    weak var delegate: NotificationModuleTableViewCellDelegate?

    private let titleLabel = UILabel(frame: .zero)
    private let toggleSwitch = UISwitch(frame: .zero)
    private let roleLabel = UILabel(frame: .zero)
    private var roleButton = UIButton(frame: .zero)
    
    private var isEnabled: Bool {
        return toggleSwitch.isOn
    }
    
    private(set) var acceptOnlyModerator: Bool = false {
        didSet {
            let title = acceptOnlyModerator ? "Only Moderator" : "Everyone"
            roleButton.setTitle(title, for: .normal)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        roleButton.translatesAutoresizingMaskIntoConstraints = false
        
        roleLabel.text = "Role: "
        toggleSwitch.addTarget(self, action: #selector(toggleValueChanged(_:)), for: .valueChanged)
        roleButton.backgroundColor = .systemBlue
        roleButton.addTarget(self, action: #selector(roleButtonTapped(_:)), for: .touchUpInside)
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)
        contentView.addSubview(roleLabel)
        contentView.addSubview(roleButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            toggleSwitch.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            roleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            roleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            roleButton.leadingAnchor.constraint(equalTo: roleLabel.trailingAnchor, constant: 12),
            roleButton.centerYAnchor.constraint(equalTo: roleLabel.centerYAnchor),
        ])
    }
    
    func configure(title: String, isEnabled: Bool, isModerator: Bool) {
        titleLabel.text = title
        toggleSwitch.isOn = isEnabled
        acceptOnlyModerator = isModerator
    }
    
    @objc private func roleButtonTapped(_ sender: UIButton) {
        acceptOnlyModerator.toggle()
        delegate?.cellRoleButtonDidTap(self)
    }
    
    @objc private func toggleValueChanged(_ sender: UISwitch) {
        delegate?.cell(self, valueDidChange: sender.isOn)
    }
}

