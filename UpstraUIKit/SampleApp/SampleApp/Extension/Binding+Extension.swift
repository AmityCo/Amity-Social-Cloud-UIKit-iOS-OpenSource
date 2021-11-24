//
//  Binding+Extension.swift
//  SampleApp
//
//  Created by Nontapat Siengsanor on 11/11/2564 BE.
//  Copyright © 2564 BE Eko. All rights reserved.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
