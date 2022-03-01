//
//  ChatFromCommunityViewController.swift
//  SampleApp
//
//  Created by Mono TheForestcat on 8/2/2565 BE.
//  Copyright © 2565 BE Eko. All rights reserved.
//

import UIKit
import AmityUIKit

class ChatFromCommunityViewController: UIViewController {

    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToChannel(){
        
        if userNameTextField.text == "" || userNameTextField.text == nil {
            let alert  = UIAlertController(title: "Error !!", message: "Please enter username before test na ka.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let user = TrueUser(userId: userNameTextField.text!)
            AmityCreateChannelHandler.shared.createChannel(trueUser: user) { result in
                switch result{
                case .success(let channelId):
                    let vc = AmityMessageListViewController.make(channelId: channelId)
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
//                    self.navigationController?.present(vc, animated: true, completion: nil)
                    self.present(vc, animated: true, completion: nil)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        
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
