//
//  APIManager.swift
//  iLinX
//
//  Created by Vikas Ninawe on 02/02/19.
//  Copyright © 2019 Redbytes Software. All rights reserved.
//

import Foundation

class APIManager{
    
    static let shared = APIManager()
    init(){}
    
    func getData(urlStr:String, completion: @escaping (_ response : Data?, _ success : Bool)-> Void){
        var request = URLRequest(url: URL(string: urlStr)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error != nil {
                //print("Error: \(String(describing: error))")
                completion(nil, false)
            } else {
                //print("Response: \(String(describing: response))")
                completion(data,true)
            }
        })
        task.resume()
    }
    
}
