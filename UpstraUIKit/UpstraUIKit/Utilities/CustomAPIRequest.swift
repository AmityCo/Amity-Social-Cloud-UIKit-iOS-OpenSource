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
            switch AmityUIKitManagerInternal.shared.envByApiKey {
            case .staging:
                return "staging"
            case .production:
                return "th"
            case .indonesia:
                return "id"
            case .cambodia:
                return "kh"
            case .philippin:
                return "ph"
            case .vietnam:
                return "vn"
            case .myanmar:
                return "mm"
            default:
                return "th"
            }
        }
        
        let urlString = "https://qojeq6vaa8.execute-api.ap-southeast-1.amazonaws.com/media?page=\(page_number)&region=\(region)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString ?? "")!
        
        var tempDiscoveryData: [DiscoveryDataModel] = []
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/json"
        ]
        
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
            switch AmityUIKitManagerInternal.shared.envByApiKey {
            case .staging:
                return "staging"
            case .production:
                return "th"
            case .indonesia:
                return "id"
            case .cambodia:
                return "kh"
            case .philippin:
                return "ph"
            case .vietnam:
                return "vn"
            case .myanmar:
                return "mm"
            default:
                return "th"
            }
        }
        
        let urlString = "https://qojeq6vaa8.execute-api.ap-southeast-1.amazonaws.com/getRedNoseTrueId?userId=\(userId)&region=\(region)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString ?? "")!
        var badge: Int = 0
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
    
    static func getPinPostData(completion: @escaping(_ postArray: AmityNewsFeedDataModel?) -> () ) {
        
        var region: String {
            switch AmityUIKitManagerInternal.shared.envByApiKey {
            case .staging:
                return "staging"
            case .production:
                return "th"
            case .indonesia:
                return "id"
            case .cambodia:
                return "kh"
            case .philippin:
                return "ph"
            case .vietnam:
                return "vn"
            case .myanmar:
                return "mm"
            default:
                return ""
            }
        }
        
        let url = URL(string: "https://qojeq6vaa8.execute-api.ap-southeast-1.amazonaws.com/getPinPost?region=\(region)")!
        
        var tempData: AmityNewsFeedDataModel = AmityNewsFeedDataModel(posts: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/json"
        ]
        
        //Get Request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data.")
                return
            }
            do {
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDecode = try? JSONDecoder().decode(AmityNewsFeedDataModel.self, from: data) else {
                    completion(tempData)
                    return
                }
                tempData = jsonDecode
            } catch let response {
                print("Error: \(response)")
            }
            
            completion(tempData)
        }
        
        task.resume()
    }
    
    static func getTodayPostData(completion: @escaping(_ postArray: AmityTodayNewsFeedDataModel?) -> () ) {
        
        var region: String {
            switch AmityUIKitManagerInternal.shared.envByApiKey {
            case .staging:
                return "staging"
            case .production:
                return "th"
            case .indonesia:
                return "id"
            case .cambodia:
                return "kh"
            case .philippin:
                return "ph"
            case .vietnam:
                return "vn"
            case .myanmar:
                return "mm"
            default:
                return ""
            }
        }
        
        let url = URL(string: "https://cpvp6wy03k.execute-api.ap-southeast-1.amazonaws.com/newsfeed/getNewsfeedNoUCG?region=\(region)")!
        var tempData: AmityTodayNewsFeedDataModel = AmityTodayNewsFeedDataModel(post: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/json"
        ]
        
        //Get Request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data.")
                return
            }
            do {
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDecode = try? JSONDecoder().decode(AmityTodayNewsFeedDataModel.self, from: data) else {
                    completion(tempData)
                    return
                }
                tempData = jsonDecode
                
            } catch let response {
                print("Error: \(response)")
            }
            completion(tempData)
        }
        task.resume()
    }
    
    static func getNotificationHistory(completion: @escaping(_ postArray: NotificationHistory?) -> () ) {
        var urlString = ""
        
        switch AmityUIKitManagerInternal.shared.envByApiKey {
        case .staging:
            urlString = "https://staging.amity.services/notifications/history"
        default:
            urlString = "https://beta.amity.services/notifications/history"
        }
        
        let url = URL(string: urlString)!
        
        var tempData: NotificationHistory?
        
        let userToken = AmityUIKitManagerInternal.shared.currentUserToken
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(userToken)"
        ]
        
        //Get Request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data.")
                return
            }
            do {
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
                print("Noti History JSon: \(jsonResponse)")
                guard let jsonDecode = try? JSONDecoder().decode(NotificationHistory.self, from: data) else {
                    completion(tempData)
                    return
                }
                tempData = jsonDecode
            } catch let response {
                print("Error: \(response)")
            }
            
            completion(tempData)
        }
        
        task.resume()
    }
}
