//
//  DLParserCache.swift
//  ComplementTalks
//
//  Created by Daniel Lahoz on 16/1/18.
//  Copyright © 2018 Daniel Lahoz. All rights reserved.
//
/*
import Foundation
import SipHash

//Blockes
typealias ArrayCodableBlock<C : Codable> = ([C]) -> Void
typealias ErrorBlock = (Error) -> Void


struct DLParserCache {
    
    public var cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
    
    //MARK:- Llamadas al servidor

    public func getCachedArray<T : Codable>(from: URL, param:[String : String]?, success: @escaping ArrayCodableBlock<T>, fail: @escaping ErrorBlock) {
        
        let request = NSMutableURLRequest(url: from, cachePolicy: cachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        let boundary = self.generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var hasher = SipHasher()
        hasher.append(from.absoluteString)
        
        if param != nil{
            request.httpBody = self.createBodyWithParameters(parameters: param!, imagePathKey: nil, imageDataKey: nil)
            let json = try! JSONSerialization.data(withJSONObject: param!)
            hasher.append(json)
        }
        
        let hash = String(hasher.finalize())
        
        let decoder = PropertyListDecoder()
        if let cachedData = UserDefaults.standard.object(forKey: hash) as? Data{
            do{
                let array = try decoder.decode([T].self, from: cachedData)
                OperationQueue.main.addOperation {
                    success(array)
                }

            }catch{
                print("error \(error)")
                OperationQueue.main.addOperation {
                    fail(error)
                }
            }
        }
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            let fixedData = self.fixedJSONData(data)
            
            do{
                let arrayList = try JSONDecoder().decode([T].self, from: fixedData)
            
                let encoder = PropertyListEncoder()
                let encodedArray = try encoder.encode(arrayList)
                
                DispatchQueue.main.async{
                    UserDefaults.standard.set(encodedArray, forKey: hash)
                    UserDefaults.standard.synchronize()
                    success(arrayList)
                }
            }catch{
                print("error")
                DispatchQueue.main.async{
                    fail(error)
                }
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
    func createBodyWithParameters(parameters: [String: String]?, imagePathKey: String?, imageDataKey: Data?) -> Data {
        var body = Data()
        let boundary = generateBoundaryString()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
            }
        }
        
        if imagePathKey != nil && imageDataKey != nil{
            let filename = imagePathKey!
            let mimetype = "image/jpg"
            
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(imagePathKey!)\"; filename=\"\(filename)\"\r\n".utf8))
            body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
            body.append(imageDataKey as Data!)
            body.append(Data("\r\n".utf8))
        }
        
        body.append(Data("--\(boundary)--\r\n".utf8))
        
        return body
    }
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
 */
