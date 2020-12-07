//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Sarawoot Khunsri on 15/7/2563 BE.
//  Copyright © 2563 Eko. All rights reserved.
//

import UIKit
import UpstraUIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UpstraUIKitManager.setup("b3bab95b3edbf9661a368518045b4481d35cdfeaec35677d")
        UpstraUIKit.set(eventHandler: CustomEventHandler())
        
        guard let preset = Preset(rawValue: UserDefaults.standard.theme ?? 0) else { return false }
        UpstraUIKitManager.set(theme: preset.theme)
        window = UIWindow()
        let registerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController")
        let nav = UINavigationController(rootViewController: registerVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

class CustomEventHandler: EkoEventHandler {
    
    override func userDidTap(from source: EkoViewController, userId: String) {

        let settings = EkoUserProfilePageSettings()
        settings.shouldChatButtonHide = false
        
        let viewController = EkoUserProfilePageViewController.make(withUserId: userId, settings: settings)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func communityDidTap(from source: EkoViewController, communityId: String) {
        
        let settings = EkoCommunityProfilePageSettings()
        settings.shouldChatButtonHide = false
        
        let viewController = EkoCommunityProfilePageViewController.make(withCommunityId: communityId, settings: settings)
        source.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func communityChannelDidTap(from source: EkoViewController, channelId: String) {
        print("Channel id: \(channelId)")
    }
    
    override func createPostDidTap(from source: EkoViewController, postTarget: EkoPostTarget) {
        
        let settings = EkoPostEditorSettings()
        settings.shouldFileButtonHide = true
        
        if source is EkoPostTargetSelectionViewController {
            let viewController = EkoPostCreateViewController.make(postTarget: postTarget, settings: settings)
            source.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = EkoPostCreateViewController.make(postTarget: postTarget, settings: settings)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overFullScreen
            source.present(navigationController, animated: true, completion: nil)
        }
    }
    
}
