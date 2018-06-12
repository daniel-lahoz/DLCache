//
//  DLCache.swift
//
//  Created by Daniel Lahoz on 16/1/18.
//  Copyright © 2018 Daniel Lahoz. All rights reserved.
//

import Foundation
import SwiftHash

//Blockes
public typealias JSONBlock = (Data) -> Void
public typealias ErrorBlock = (Error?) -> Void

public struct DLCache {
    
    public var cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
    
    public init() {}
    
    /// Returns a data object with JSON to we parsed as you wish.
    ///
    /// - Parameters:
    ///     - from: The URL you want to call
    ///     - param: An a array of POST parameters, if its nil the the petition is created as a GET call.
    ///     - removeCacheData: If its set to **true** the cached data get removed form device
    ///     - success: Completion block with data response from the server ready for we parsed with **JSONDecoder** or **JSONSerialization**
    ///     - fail: Completion block called when something gone wrong
    public func getJSON(from: URL, param: [String : String]? = nil, removeCacheData: Bool = false, success: @escaping JSONBlock, fail: @escaping ErrorBlock) {
        
        let request = NSMutableURLRequest(url: from, cachePolicy: cachePolicy, timeoutInterval: 10.0)
        request.setValue("application/json", forHTTPHeaderField:"Accept")
        
        var urlString = from.absoluteString
        
        if param != nil{
            request.httpMethod = "POST"
            let boundary = self.generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = self.createBodyWithParameters(boundary: boundary, parameters: param!, imagePathKey: nil, imageDataKey: nil)
            let json = try! JSONSerialization.data(withJSONObject: param!)
            let jsonString = String(data: json, encoding: .utf8)
            urlString.append(jsonString!)
        }else{
            request.httpMethod = "GET"
        }
        
        
        let hash = MD5(urlString)
        
        
        if removeCacheData {
            UserDefaults.standard.removeObject(forKey: hash)
            UserDefaults.standard.synchronize()
        }else{
            if let cachedData = UserDefaults.standard.object(forKey: hash) as? Data{
                DispatchQueue.main.async{
                    success(cachedData)
                }
            }
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async{
                    fail(error)
                }
                return
            }
            
            let fixedData = self.fixedJSONData(data)
            
            DispatchQueue.main.async{
                UserDefaults.standard.set(fixedData, forKey: hash)
                UserDefaults.standard.synchronize()
                success(fixedData)
            }
        }
        
        dataTask.resume()
    }
    
    
    
    //MARK:- JSON
    private func fixedJSONData(_ data: Data) -> Data {
        guard let jsonString = String(data: data, encoding: String.Encoding.utf8) else { return data }
        let fixedString = jsonString.replacingOccurrences(of: "\\'", with: "'")
        if let fixedData = fixedString.data(using: String.Encoding.utf8) {
            return fixedData
        } else {
            return data
        }
    }
    
    private func fixedJSONString(_ jsonString: String) -> Data? {
        let fixedString = jsonString.replacingOccurrences(of: "\\'", with: "'")
        if let fixedData = fixedString.data(using: String.Encoding.utf8) {
            return fixedData
        }else{
            return nil
        }
    }
    
    //MARK:- Body Maker
    private func createBodyWithParameters(boundary: String, parameters: [String: String]?, imagePathKey: String?, imageDataKey: Data?) -> Data {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            }
        }
        
        if imagePathKey != nil || imageDataKey != nil{
            let filename = imagePathKey!
            let mimetype = "image/jpg"
            
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(imagePathKey!)\"; filename=\"\(filename)\"\r\n".utf8))
            body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
            body.append(imageDataKey!)
            body.append(Data("\r\n".utf8))
        }
        
        body.append(Data("--\(boundary)--\r\n".utf8))
        
        return body
    }
    
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}


