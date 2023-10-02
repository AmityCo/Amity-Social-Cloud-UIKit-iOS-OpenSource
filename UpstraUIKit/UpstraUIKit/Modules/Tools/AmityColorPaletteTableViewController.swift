//
//  AmityColorPaletteTableViewController.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 28/8/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit

public class AmityColorPaletteTableViewController: UITableViewController {

    private var providedColors: [UIColor] = [
        AmityColorSet.primary,
        AmityColorSet.secondary,
        AmityColorSet.alert,
        AmityColorSet.highlight,
        AmityColorSet.base,
        AmityColorSet.baseInverse,
        AmityColorSet.messageBubble,
        AmityColorSet.messageBubbleInverse
    ]
    
    private var colorTitles: [String] = [
        "Primary",
        "Secondary",
        "Alert",
        "Highlight",
        "Base",
        "BaseInverse",
        "MessageBubble",
        "MessageBubbleInverse"
    ]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ColorPaletteCell.self, forCellReuseIdentifier: "ColorPaletteCell")
    }

    // MARK: - Table view data source

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return providedColors.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColorPaletteCell", for: indexPath) as! ColorPaletteCell
        cell.configure(with: providedColors[indexPath.row], title: colorTitles[indexPath.row])
        return cell
    }
    
     // MARK: - Table view delegate
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

class ColorPaletteCell: UITableViewCell {
    
    private let stackView = UIStackView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)]
        )
    }
    
    func configure(with color: UIColor, title: String) {
        let view = UIView()
        view.backgroundColor = color
        stackView.addArrangedSubview(view)
        textLabel?.text = title
        textLabel?.textColor = .lightGray
        for option in ColorBlendingOption.allCases {
            let view = UIView()
            view.backgroundColor = color.blend(option)
            stackView.addArrangedSubview(view)
        }
    }
    
}
