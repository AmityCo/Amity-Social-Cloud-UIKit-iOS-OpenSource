//
//  MainViewController.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 22/6/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import UIKit
import EkoUIKit

enum MainViewMenu: String, CaseIterable {
    case navigation = "EkoNavigation"
    case customUI = "EkoCustomUI"
    case postUI = "AmityPostFeed"
}

class MainViewController: AmityViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let menus: [MainViewMenu] = MainViewMenu.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        navigateToPost()
    }
    
    private func setupNavigationBar() {
        title = "HOME"
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func navigateToPost() {
        let feedViewController = AmityPostFeedViewController()
        let items: [AmityPostModel] = [
            AmityPostModel(content: "\na\nb\nc\nd\ne\nf\nhttps://www.google.com\na\nb\nc\nd\ne\nf\ng\nh", images: [UIImage(named: "sample_feed_image", in: EkoUIKit.bundle, compatibleWith: nil)!,UIImage(named: "sample_feed_image", in: EkoUIKit.bundle, compatibleWith: nil)!,UIImage(named: "sample_feed_image", in: EkoUIKit.bundle, compatibleWith: nil)!], documents: []),
            AmityPostModel(content: "a\nb\nc\nd\ne https://www.hackingwithswift.com to be detected", images: [UIImage(named: "sample_feed_image", in: EkoUIKit.bundle, compatibleWith: nil)!, UIImage(named: "sample_feed_image", in: EkoUIKit.bundle, compatibleWith: nil)!], documents: []),
            AmityPostModel(content: "a\nb\nc\nd\ne\nf", images: [UIImage(named: "sample_feed_image", in: EkoUIKit.bundle, compatibleWith: nil)!], documents: []),
            AmityPostModel(content: "afsdfsdf\nbsdfsdfsdf\ncsdfsfsfsf\ndfsdfsdf\ne\nf", images: [UIImage(named: "sample_feed_image", in: EkoUIKit.bundle, compatibleWith: nil)!], documents: []),
            AmityPostModel(content: "กนกคนตลกชวนดวงกมลคนผอมรอชมภมรดมดอมดอกขจรสองคนชอบจอดรถตรงตรอกยอมทนอดนอนอดกรนรอยลภมรดมดอกหอมบนขอนตรงคลองมอญลมบนหวนสอบจนปอยผมปรกคอสองสมรสมพรคนจรพบสองอรชรสมพรปองสองสมรยอมลงคลองลอยคอมองสองอรชรมองอกมองคอมองผมมองจนสองคนฉงนสมพรบอกชวนสองคนถอนสมอลงชลลองวอนสองหนสองอรชรถอยหลบสมพรวอนจนพลพรรคสดสวยหมดสนกรกนกชวนดวงกมลชงนมผงรอชมภมรบนดอนฝนตกตลอดจนถนนปอนจอมปลวกตรงตรอกจอดรถถลอกปอกลงสองสมรมองนกปรอทจกมดจกปลวกจกหนอนลงคอสมพรคงลอยคอลอยวนบอกสอพลอคนสวยผสมบทสวดของขอมคนหนอคนสมพรสวดวนจนอรชรสองคนฉงนฉงวยงวยงงคอตกยอมนอนลงบนบกสมพรยกซองผงทองปลอมผสมลงนมชงของสองสมรสมพรถอนผมนวลลออสองคนปนผสมตอนหลอมรวมนมชงสมพรสวดบทขอมถอยวกวนหกหนขอวรรคตอนวอนผองชนจงอวยพร", images: [UIImage(named: "sample_feed_image", in: EkoUIKit.bundle, compatibleWith: nil)!,UIImage(named: "sample_feed_image", in: EkoUIKit.bundle, compatibleWith: nil)!,UIImage(named: "sample_feed_image", in: EkoUIKit.bundle, compatibleWith: nil)!,UIImage(named: "sample_feed_image", in: EkoUIKit.bundle, compatibleWith: nil)!], documents: []),
            AmityPostModel(content: "s dflsdjf sdfjk sdnf jksdf ", images: [], documents: []),
            AmityPostModel(content: "sdfaskdfs jdlfj skjdf sdf as;ldaflasj dflajsjkdf sldkf sjkd fskdjfl sdzfk jsd f", images: [UIImage(named: "sample_feed_image", in: EkoUIKit.bundle, compatibleWith: nil)!], documents: []),
            AmityPostModel(content: "hello wpsdfk sdf; sldf ;lsd fpsld ;lfs;df ;l sdf sfs;ldf23operi ru oi34ur ois  io4r oeis  oru goirugoi fugo idufgo idufoig udofig dfg sdfaskdfs jdlfj skjdf sdf as;ldaflasj dflajsjkdf sldkf sjkd fskdjfl sdzfk jsd f\na\na\n111\n123123123123", images: [], documents: []),
            AmityPostModel(content: "ahello world this is your captain speaking sdf; sldf ;lsd fpsld ;lfs;df ;l sdf sfs;ldf23operi ru oi34ur ois  io4r oeis  oru goirugoi fugo idufgo idufoig udofig dfg sdfaskdfs jdlfj skjdf sdf as;ldaflasj dflajsjkdf sldkf sjkd fskdjfl sdzfk jsd f\na\na\n111\n12312312312 sdkflk sdf lksdjf lksdjf lksdjf klsdjflksdj flskd jflskdsdkfmsdkfjskdfjksld f\n\n3", images: [], documents: [])
        ]
        feedViewController.configure(items: items)
        navigationController?.pushViewController(feedViewController, animated: true)
    }
    
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menus[indexPath.row].rawValue
        return cell
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menus[indexPath.row] {
        case .navigation:
            let sampleNavigationViewController = SampleNavigationViewController()
            navigationController?.pushViewController(sampleNavigationViewController, animated: true)
        case .customUI:
            let channelHeaderViewController = ChannelHeaderViewController()
            navigationController?.pushViewController(channelHeaderViewController, animated: true)
        case .postUI:
            navigateToPost()
        }
    }
    
}
