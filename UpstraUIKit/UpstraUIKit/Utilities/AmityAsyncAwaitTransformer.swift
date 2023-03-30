//
//  AmityAsyncAwaitTransformer.swift
//  AmityUIKit
//
//  Created by Zay Yar Htun on 1/16/23.
//  Copyright © 2023 Amity. All rights reserved.
//

import Foundation

class AmityAsyncAwaitTransformer {
    static func toCompletionHandler<T, U>(asyncFunction: ((U) async throws -> T)?, parameters: U, completion: ((T?, Error?) -> Void)? = nil) {
        guard let asyncFunction = asyncFunction else {
            return
        }
        Task { @MainActor in
            do {
                let result = try await asyncFunction(parameters)
                completion?(result, nil)
            } catch {
                completion?(nil, error)
            }
        }
    }
}
