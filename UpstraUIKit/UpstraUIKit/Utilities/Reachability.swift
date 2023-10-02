//
//  Reachability.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 26/3/2564 BE.
//  Copyright © 2564 BE Amity. All rights reserved.
//

import Network
import SystemConfiguration

final class Reachability: NSObject {

    static let shared = Reachability()
    private let monitor = NWPathMonitor()
    @objc private(set) dynamic var isConnectedToNetwork: Bool = true
    
    private override init() {
        super.init()
        monitor.pathUpdateHandler = { path in
            switch path.status {
            case .satisfied:
                self.isConnectedToNetwork = true
            case .unsatisfied, .requiresConnection:
                self.isConnectedToNetwork = false
            @unknown default:
                self.isConnectedToNetwork = false
            }
        }
        let queue = DispatchQueue(label: "Reachability.Monitor")
        monitor.start(queue: queue)
    }
    
}
