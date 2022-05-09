//
//  CustomAPI.swift
//  AmityUIKitLiveStream
//
//  Created by Jiratin Teean on 9/5/2565 BE.
//

import Foundation

final class customAPIRequest {
    
    static func getLiveStreamViewerData(page_number: Int, liveStreamId: String, type: String, completion: @escaping(_ value: StreamViewerDataModel) -> () ) {
        
        let url = URL(string: "https://qojeq6vaa8.execute-api.ap-southeast-1.amazonaws.com/media?liveStreamId=\(liveStreamId)&page=\(page_number)&type=\(type)")!
        
        var tempData: StreamViewerDataModel = StreamViewerDataModel(count: 0, maxPage: "")
        
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
}
