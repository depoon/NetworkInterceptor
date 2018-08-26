//
//  SlackSniffableRequestHandler.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 26/5/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

public class SlackSniffableRequestHandler: SniffableRequestHandler {
    
    let slackToken: String
    let channel: String
    let username: String
    
    init(slackToken: String, channel: String, username: String){
        self.slackToken = slackToken
        self.channel = channel
        self.username = username
    }
    
    public func sniffRequest(urlRequest: URLRequest) {
        NetworkInterceptor.shared.refireURLRequest(urlRequest: self.generateSlackPayloadFromRequest(originalRequest: urlRequest))
    }
}

extension SlackSniffableRequestHandler {
    
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
