//
//  BirthdayPostComponent.swift
//  SampleApp
//
//  Created by sarawoot khunsri on 2/16/21.
//  Copyright © 2021 Eko. All rights reserved.
//

import UIKit
import UpstraUIKit

struct BirthdayPostComponent: EkoPostComposable {
    
    var post: EkoPostModel
    
    init(post: EkoPostModel) {
        self.post = post
    }
    
    
    func getComponentCount(for index: Int) -> Int {
        return 2
    }
    
    func getComponentCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EkoPostBirthdayTableViewCell", for: indexPath) as! EkoPostBirthdayTableViewCell
            cell.display(withPost: post)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EkoPostFooterTableViewCell", for: indexPath) as! EkoPostFooterTableViewCell
            cell.display(post: post)
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func getComponentHeight(indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
