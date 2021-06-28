//
//  AmityPostComposable.swift
//  AmityUIKit
//
//  Created by sarawoot khunsri on 2/11/21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

public protocol AmityPostComposable {
    
    var post: AmityPostModel { get }
    
    // Initialize
    init(post: AmityPostModel)
    
    // Number of components
    func getComponentCount(for index: Int) -> Int
    
    // Provide actual cell
    func getComponentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    
    // This can be optional
    func getComponentHeight(indexPath: IndexPath) -> CGFloat
}
