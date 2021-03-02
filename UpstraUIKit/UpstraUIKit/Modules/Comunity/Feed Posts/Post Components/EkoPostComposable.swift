//
//  EkoPostComposable.swift
//  UpstraUIKit
//
//  Created by sarawoot khunsri on 2/11/21.
//  Copyright © 2021 Upstra. All rights reserved.
//

import UIKit

public protocol EkoPostComposable {
    
    var post: EkoPostModel { get }
    
    // Initialize
    init(post: EkoPostModel)
    
    // Number of components
    func getComponentCount(for index: Int) -> Int
    
    // Provide actual cell
    func getComponentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    
    // This can be optional
    func getComponentHeight(indexPath: IndexPath) -> CGFloat
}
