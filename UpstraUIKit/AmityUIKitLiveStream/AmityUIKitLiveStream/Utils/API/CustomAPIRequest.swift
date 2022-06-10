//
//  CustomAPI.swift
//  AmityUIKitLiveStream
//
//  Created by Jiratin Teean on 9/5/2565 BE.
//

import Foundation

final class customAPIRequest {
    
    static func getLiveStreamViewerData(page_number: Int, liveStreamId: String, type: String, completion: @escaping(_ value: StreamViewerDataModel) -> () ) {
        
        let url = URL(string: "https://qojeq6vaa8.execute-api.ap-southeast-1.amazonaws.com/getStreamViewer?liveStreamId=\(liveStreamId)&page=\(page_number)&type=\(type)")!
        
        var tempData: StreamViewerDataModel = StreamViewerDataModel(count: 0, maxPage: 1)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/json"
        ]
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data.")
                return
            }
            do {
                let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDecode = try? JSONDecoder().decode(StreamViewerDataModel.self, from: data) else { return }
                tempData = jsonDecode
            } catch let error {
                print("Error: \(error)")
            }
            
            completion(tempData)
            
        }
        
        task.resume()
    }
    
    static func saveLiveStreamViewerData(postId: String, liveStreamId: String, userId: String, action: String, completion: @escaping(_ value: String) -> () ) {
        
        let url = URL(string: "https://qojeq6vaa8.execute-api.ap-southeast-1.amazonaws.com/saveStreamViewer")!
        
        let params: [String:Any?] = [
            "postId": postId,
            "userId": userId,
            "liveId": liveStreamId,
            "action": action
        ]
                
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/json"
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
