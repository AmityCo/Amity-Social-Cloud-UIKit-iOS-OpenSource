//
//  SwitchTableViewCell.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 23/4/2564 BE.
//  Copyright © 2564 BE Eko. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: AnyObject {
    func cell(_ cell: SwitchTableViewCell, valueDidChange isEnabled: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    
    weak var delegate: SwitchTableViewCellDelegate?

    private let titleLabel = UILabel(frame: .zero)
    private let toggleSwitch = UISwitch(frame: .zero)
    
    private var isEnabled: Bool {
        return toggleSwitch.isOn
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
        toggleSwitch.addTarget(self, action: #selector(toggleValueChanged(_:)), for: .valueChanged)
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(title: String, isEnabled: Bool) {
        titleLabel.text = title
        toggleSwitch.isOn = isEnabled
    }
    
    @objc private func toggleValueChanged(_ sender: UISwitch) {
        delegate?.cell(self, valueDidChange: sender.isOn)
    }
    
}
