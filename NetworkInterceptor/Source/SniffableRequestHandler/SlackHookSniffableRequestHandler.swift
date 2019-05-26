//
//  SlackHookSniffableRequestHandler.swift
//  NetworkInterceptor
//
//  Created by steven lee on 25/4/19.
//  Copyright © 2019 Kenneth Poon. All rights reserved.
//

import Foundation
import Foundation
public class SlackHookSniffableRequestHandler: SniffableRequestHandler {
    
    let hookUrl: String
    
    init(hookUrl: String){
        self.hookUrl = hookUrl
    }
    
    public func sniffRequest(urlRequest: URLRequest) {
        NetworkInterceptor.shared.refireURLRequest(urlRequest: self.generateSlackPayloadFromRequest(originalRequest: urlRequest))
    }
}

extension SlackHookSniffableRequestHandler {
    
    fileprivate func generateSlackForwardingRequest() -> NSMutableURLRequest{
        let request = NSMutableURLRequest()
        request.url = URL(string: hookUrl)
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
        ]
        request.httpMethod = "POST"
        return request
    }
    
    fileprivate func generateSlackPayloadFromRequest(originalRequest: URLRequest) -> URLRequest{
        let request = self.generateSlackForwardingRequest()
        var json: [String: String] = [:]
        
        let bundleName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let text: String  = originalRequest.cURL
        json["text"] = "```[\(bundleName)] \(text)```"
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        return request as URLRequest
    }
    
}
