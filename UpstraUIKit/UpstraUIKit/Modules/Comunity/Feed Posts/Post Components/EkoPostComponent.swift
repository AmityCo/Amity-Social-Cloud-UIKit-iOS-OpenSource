//
//  EkoPostComponent.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/11/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

enum EkoPostConstant {
    static let defaultNumberComponent = 3
}

struct EkoPostComponent {
    
    let _composable: EkoPostComposable
    
    init(component: EkoPostComposable) {
        _composable = component
    }
    
    func getComponentCount(for index: Int) -> Int {
        return _composable.getComponentCount(for: index)
    }
    
    // Provide actual cell
    func getComponentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        return _composable.getComponentCell(tableView, at: indexPath)
    }
    
    // This can be optional
    func getComponentHeight(indexPath: IndexPath) -> CGFloat {
        return _composable.getComponentHeight(indexPath: indexPath)
    }
}
