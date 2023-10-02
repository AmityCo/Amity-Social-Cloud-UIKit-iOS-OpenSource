//
//  DispatchGroupWrapper.swift
//  AmityUIKit
//
//  Created by Nontapat Siengsanor on 1/10/2563 BE.
//  Copyright © 2563 Amity. All rights reserved.
//

import Foundation

class DispatchGroupWraper {
    
    private(set) var count = 0
    private let group = DispatchGroup()
    private var error: Error?
    
    func enter() {
        group.enter()
        count += 1
    }
    
    func leave() {
        group.leave()
        count -= 1
    }
    
    func leaveWithError(_ error: Error?) {
        group.leave()
        count -= 1
        self.error = error
    }
    
    func notify(qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], queue: DispatchQueue, execute work: @escaping @convention(block) (Error?) -> Void) {
        group.notify(qos: qos, flags: flags, queue: queue) { [weak self] in
            work(self?.error)
        }
    }
    
    var hasConcurentTask: Bool {
        return count > 0
    }
    
}
