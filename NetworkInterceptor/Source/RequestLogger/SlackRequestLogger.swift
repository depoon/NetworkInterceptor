//
//  SlackRequestLogger.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 26/5/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

public class SlackRequestLogger: RequestLogger {
    
    let slackToken = "<< YOUR SLACK TOKEN >>"
    let channel = "<< YOUR SLACK CHANNEL ID>>"
    let username = "NetworkInterceptor"
    
    public func excludedDomain() -> [String]{
        return ["slack.com"]
    }
    
    public func logRequest(urlRequest: URLRequest) {
        NetworkInterceptor.shared.refireUrlRequest(urlRequest: self.generateSlackPayloadFromRequest(originalRequest: urlRequest))
        
        
    }
    
}

extension SlackRequestLogger {
    
    fileprivate func generateSlackForwardingRequest() -> NSMutableURLRequest{
        let request = NSMutableURLRequest()
        request.url = URL(string: "https://slack.com/api/chat.postMessage")
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(slackToken)"
        ]
        request.httpMethod = "POST"
        return request
    }
    
    fileprivate func generateForwardingJsonBody() -> [String: String] {
        let json: [String: String] = [
            "channel": channel,
            "username": username,
            "pretty": "1",
            ]
        return json
    }
    
    fileprivate func generateSlackPayloadFromRequest(originalRequest: URLRequest) -> URLRequest{
        let request = self.generateSlackForwardingRequest()
        var json = self.generateForwardingJsonBody()
        
        let bundleName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        let text: String  = originalRequest.cURL
        json["text"] = "```[\(bundleName)] \(text)```"
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        return request as URLRequest
    }
    
}
