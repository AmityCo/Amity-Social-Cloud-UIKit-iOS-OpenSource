//
//  EkoPostPlaceHolderComponent.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/12/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

struct EkoPostPlaceHolderComponent: EkoPostComposable {
    
    private(set) public var post: EkoPostModel
    
    public init(post: EkoPostModel) {
        self.post = post
    }
    
    public func getComponentCount(for index: Int) -> Int {
        return 1
    }
    
    func getComponentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: EkoPostPlaceHolderTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    public func getComponentHeight(indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
