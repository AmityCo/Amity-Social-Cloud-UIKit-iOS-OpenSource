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
        
        

        let urlString = "https://cpvp6wy03k.execute-api.ap-southeast-1.amazonaws.com/discovery/getDiscovery?page=\(page_number)&region=\(region)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        
        let url = URL(string: urlString ?? "")!
        var tempDiscoveryData: [DiscoveryDataModel] = []
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
        
//        var region: String {
//            switch AmityUIKitManagerInternal.shared.envByApiKey {
//            case .staging:
//                return "staging"
//            case .production:
//                return "th"
//            case .indonesia:
//                return "id"
//            case .cambodia:
//                return "kh"
//            case .philippin:
//                return "ph"
//            case .vietnam:
//                return "vn"
//            case .myanmar:
//                return "mm"
//            default:
//                return "th"
//            }
//        }
//        
//        //Original
//        let urlString = "https://qojeq6vaa8.execute-api.ap-southeast-1.amazonaws.com/discovery/getDiscovery?page=\(page_number)&region=\(region)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        
//        let url = URL(string: urlString ?? "")!
//        var badge: Int = 0
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = [
//            "Content-Type" : "application/json"
//        ]
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data.")
//                completion(.failure(error!))
//                return
//            }
//            
//            guard let jsonDecode = try? JSONDecoder().decode(Int.self, from: data) else { return }
//            badge = jsonDecode
//            
//            completion(.success(badge))
//        }
//        
//        task.resume()
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
        
        let url = URL(string: "https://cpvp6wy03k.execute-api.ap-southeast-1.amazonaws.com/getPinPost?region=\(region)")!

        var tempData: AmityNewsFeedDataModel = AmityNewsFeedDataModel(posts: [])
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
        
        //Original
        let url = URL(string: "https://cpvp6wy03k.execute-api.ap-southeast-1.amazonaws.com/discovery/getPopularFeed?region=\(region)")!
        //New Endpoint
//        let url = URL(string: "https://9g5o0eiyh9.execute-api.ap-southeast-1.amazonaws.com/newsfeed/getNewsfeedNoUCG?region=\(region)")!
        
        var tempData: AmityTodayNewsFeedDataModel = AmityTodayNewsFeedDataModel(post: [])
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
                guard let jsonDecode = try? JSONDecoder().decode(AmityTodayNewsFeedDataModel.self, from: data) else {
                    completion(tempData)
                    return
                }
                tempData = jsonDecode
                
            } catch let response {
                print("Error: \(response)")
            }
            print("Popular feed: \(tempData)")
            completion(tempData)
        }
        task.resume()
    }
    
    static func syncContact(userId: String, phoneList: [String], completion: @escaping(_ completion:Result<[String],Error>) -> () ) {
        
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
        
        let urlString = "https://cpvp6wy03k.execute-api.ap-southeast-1.amazonaws.com/syncContact".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlString ?? "")!
        
        var tempData: [String] = []
        
        let userToken = AmityUIKitManagerInternal.shared.currentUserToken
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(userToken)",
            "client_id" : "3608"
        ]
        let json: [String:Any] = [
            "userId" : userId,
            "phoneList" : phoneList,
            "region" : region
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        //Get Request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data.")
                completion(.failure(error!))
                return
            }
            do {
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
                print("Sync Contact: \(jsonResponse)")
                guard let jsonDecode = try? JSONDecoder().decode([String].self, from: data) else {
                    completion(.success(tempData))
                    return
                }
                tempData = jsonDecode
            } catch let response {
                print("Error: \(response)")
            }
            
            completion(.success(tempData))
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
    
    static func updateHasReadTray(completion: @escaping(_ value: String) -> () ) {
        
        var urlString = ""
        
        switch AmityUIKitManagerInternal.shared.envByApiKey {
        case .staging:
            urlString = "https://staging.amity.services/notifications/last-read"
        default:
            urlString = "https://beta.amity.services/notifications/last-read"
        }
        let url = URL(string: urlString)!
                
        let userToken = AmityUIKitManagerInternal.shared.currentUserToken

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(userToken)"
        ]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data.")
                completion(error?.localizedDescription ?? "No data.")
                return
            }

            guard let jsonDecode = try? JSONDecoder().decode(String.self, from: data) else { return }
            completion("Success")
        }
        
        task.resume()
    }
    
    static func updateHasReadItem(verb: String, targetId: String, targetGroup: String, completion: @escaping(_ value: String) -> () ) {
        
        var urlString = ""
        
        switch AmityUIKitManagerInternal.shared.envByApiKey {
        case .staging:
            urlString = "https://staging.amity.services/notifications/read"
        default:
            urlString = "https://beta.amity.services/notifications/read"
        }
        let url = URL(string: urlString)!
        let userToken = AmityUIKitManagerInternal.shared.currentUserToken
        
        let params: [String:Any?] = [
            "verb": verb,
            "targetId": targetId,
            "targetGroup": targetGroup
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(userToken)"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data.")
                completion(error?.localizedDescription ?? "No data.")
                return
            }

            guard let jsonDecode = try? JSONDecoder().decode(String.self, from: data) else { return }
            completion("Success")
        }
        
        task.resume()
    }
}
