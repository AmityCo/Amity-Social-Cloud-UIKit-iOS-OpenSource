//
//  CustomAPIRequest.swift
//  AmityUIKit
//
//  Created by Mono TheForestcat on 22/2/2565 BE.
//  Copyright © 2565 BE Amity. All rights reserved.
//

import UIKit
import Foundation

final class customAPIRequest {
    static func getDiscoveryData(page_number: Int, completion: @escaping(_ discoveryArray: [DiscoveryDataModel]) -> () ) {
        
        var region: String {
            switch AmityUIKitManagerInternal.shared.amityLanguage {
            case "th", "en":
                return "th"
            case "id":
                return "id"
            case "km":
                return "kh"
            case "ph":
                return "ph"
            case "vn":
                return "vn"
            case "mm":
                return "mm"
            default:
                return "staging"
            }
        }
        
        let url = URL(string: "https://qojeq6vaa8.execute-api.ap-southeast-1.amazonaws.com/media?page=\(page_number)&region=\(region)")!
        
        var tempDiscoveryData: [DiscoveryDataModel] = []
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/json"
        ]
        
//        let parameter: [String:Any] = [:]
//
//        let jsonParameter = try? JSONSerialization.data(withJSONObject: parameter, options: [])
//        request.httpBody = jsonParameter!
        
        //Get Request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data.")
                return
            }

            do {
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDecode = try? JSONDecoder().decode([DiscoveryDataModel].self, from: data) else { return }
                tempDiscoveryData = jsonDecode
            } catch let error {
                print("Error: \(error)")
            }
            
            completion(tempDiscoveryData)
            
        }

        task.resume()
    }
    
    static func getChatBadgeCount(userId: String, completion: @escaping(_ completion:Result<Int,Error>) -> () ) {
        
        var region: String {
            switch AmityUIKitManagerInternal.shared.amityLanguage {
            case "th", "en":
                return "th"
            case "id":
                return "id"
            case "km":
                return "kh"
            case "ph":
                return "ph"
            case "vn":
                return "vn"
            case "mm":
                return "mm"
            default:
                return "staging"
            }
        }
        
        let url = URL(string: "https://qojeq6vaa8.execute-api.ap-southeast-1.amazonaws.com/getRedNoseTrueId?userId=\(userId)&region=\(region)")!
        var badge: Int = 0
        print("URL:::::: ", url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/json"
        ]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data.")
                completion(.failure(error!))
                return
            }

            guard let jsonDecode = try? JSONDecoder().decode(Int.self, from: data) else { return }
            badge = jsonDecode
            
            completion(.success(badge))
            
        }

        task.resume()
    }
}
