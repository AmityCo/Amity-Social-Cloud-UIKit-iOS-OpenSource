//
//  LivestreamWatcherListViewController.swift
//  AmityUIKitLiveStream
//
//  Created by Mono TheForestcat on 25/9/2565 BE.
//

import UIKit
import AmityUIKit
import AmitySDK

class LivestreamWatcherListViewController: AmityViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var whoWatchingTitle: UILabel!
    @IBOutlet weak var watcherTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    var pagination: Int = 1
    var watchingArray: [String] = []
    var currentLivestreamId: String = ""
    var isStreamer: Bool = false
    var streamerDisplayName: String = ""
    
    static func make() -> LivestreamWatcherListViewController {
        let vc = LivestreamWatcherListViewController()
        return vc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getWatchingList(page: pagination)
    }

    func setupView() {
        self.view.backgroundColor = .clear
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        headerTitle.font = AmityFontSet.title
        headerTitle.text = "\(streamerDisplayName)'s live video"
        
        whoWatchingTitle.font = AmityFontSet.title
        
        guard let nibName = NSStringFromClass(LivestreamWatchingTableViewCell.self).components(separatedBy: ".").last else {
            fatalError("Class name not found")
        }
        let bundle = Bundle(for: LivestreamWatchingTableViewCell.self)
        let uiNib = UINib(nibName: nibName, bundle: bundle)
        watcherTableView.register(uiNib, forCellReuseIdentifier: LivestreamWatchingTableViewCell.identifier)
        watcherTableView.dataSource = self
        watcherTableView.delegate = self
        watcherTableView.backgroundColor = .clear
        watcherTableView.separatorStyle = .none
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    func getWatchingList(page: Int) {
        customAPIRequest.getLiveStreamViewerData(page_number: page, liveStreamId: currentLivestreamId, type: "watching") { value in
            self.didFinishGetViewerList(value: value)
        }
    }
    
    func didFinishGetViewerList(value: StreamViewerDataModel) { 
        let tempArray = self.watchingArray + value.viewer
        self.watchingArray = tempArray.uniqued()
        DispatchQueue.main.async {
            self.watcherTableView.reloadData()
        }
    }
    
    @objc func avatarDidTap(userId: String) {
        AmityEventHandler.shared.userDidTap(from: self, userId: userId)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LivestreamWatcherListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LivestreamWatchingTableViewCell.identifier) as? LivestreamWatchingTableViewCell else { return UITableViewCell() }
        cell.display(userId: watchingArray[indexPath.row])
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 6.5
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isStreamer{
            avatarDidTap(userId: watchingArray[indexPath.row])
        }
    }
}

extension LivestreamWatcherListViewController: LivestreamWatchingProtocol {
    func didAvatarTap(userId: String) {
        avatarDidTap(userId: userId)
    }
    
}
