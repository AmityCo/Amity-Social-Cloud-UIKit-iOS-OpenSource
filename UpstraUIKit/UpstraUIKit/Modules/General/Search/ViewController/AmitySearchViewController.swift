//
//  AmitySearchViewController.swift
//  AmityUIKit
//
//  Created by Hamlet on 11.05.21.
//  Copyright © 2021 Amity. All rights reserved.
//

import UIKit

public class AmitySearchViewController: AmityPageViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var searchStackView: UIStackView!
    @IBOutlet private weak var searchIcon: UIImageView!
    
    // MARK: - Child ViewController
    private var communitiesVC = AmityCommunitySearchViewController.make(title: AmityLocalizedStringSet.communities.localizedString)
    private var membersVC = AmityMemberSearchViewController.make(title: AmityLocalizedStringSet.accounts.localizedString)

    private init() {
        super.init(nibName: AmitySearchViewController.identifier, bundle: AmityUIKitManager.bundle)
        title = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchController()
        
        setButtonBarHidden(hidden: true)
        
        searchTextField.becomeFirstResponder()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    public static func make() -> AmitySearchViewController {
        return AmitySearchViewController()
    }
    
    override func viewControllers(for pagerTabStripController: AmityPagerTabViewController) -> [UIViewController] {
        return [communitiesVC, membersVC]
    }
    
    override func moveToViewController(at index: Int, animated: Bool = true) {
        super.moveToViewController(at: index, animated: animated)
        
        viewControllerWillMove()
    }
    
    // MARK: - Setup views
    private func setupNavigationBar() {
        navigationBarType = .custom
    }
    
    private func setupSearchController() {
        searchTextField.delegate = self
        searchTextField.placeholder = AmityLocalizedStringSet.General.search.localizedString
        searchTextField.returnKeyType = .search
        searchTextField.clearButtonMode = .always
        
        searchTextField.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        searchTextField.tintColor = AmityColorSet.base
        searchTextField.textColor = AmityColorSet.base
        searchTextField.font = AmityFontSet.body
        searchTextField.leftView?.tintColor = AmityColorSet.base.blend(.shade2)
        
        cancelButton.setTitleColor(AmityColorSet.base, for: .normal)
        cancelButton.titleLabel?.font = AmityFontSet.body
        
        searchIcon.image = AmityIconSet.iconSearch?.withRenderingMode(.alwaysTemplate)
        searchIcon.tintColor = AmityColorSet.base.blend(.shade1)
        
        searchView.backgroundColor = AmityColorSet.secondary.blend(.shade4)
        searchView.layer.cornerRadius = 4
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        handelSearch(with: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        setButtonBarHidden(hidden: false)
        handelSearch(with: sender.text)
    }
}

private extension AmitySearchViewController {
    func handelSearch(with key: String?) {
        if viewControllers[currentIndex] == communitiesVC {
            communitiesVC.search(with: key)
        } else {
            membersVC.search(with: key)
        }
    }
    
    func viewControllerWillMove() {
        if currentIndex == 1 {
            communitiesVC.search(with: searchTextField.text)
        } else {
            membersVC.search(with: searchTextField.text)
        }
    }
}

extension AmitySearchViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setButtonBarHidden(hidden: false)
        handelSearch(with: textField.text)
        textField.resignFirstResponder()
        return true
    }
}

protocol AmitySearchViewControllerAction: AnyObject {
    func search(with text: String?)
}
