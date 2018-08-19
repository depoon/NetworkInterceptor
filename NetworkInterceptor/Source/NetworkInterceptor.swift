//
//  NetworkInterceptor.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 26/5/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

protocol RequestRefirer {
    func refireUrlRequest(urlRequest: URLRequest)
}

public protocol RequestInterceptor: class {
    func canInterceptRequest(urlRequest: URLRequest) -> Bool
}

public protocol InterceptedRequestHandler {
    func handleRequest(urlRequest: URLRequest)
}

public struct Interceptor {
    public let requestInterceptor: RequestInterceptor
    public let handlers: [InterceptedRequestHandler]
    public init(requestInterceptor: RequestInterceptor, handlers: [InterceptedRequestHandler]) {
        self.requestInterceptor = requestInterceptor
        self.handlers = handlers
    }
}

@objc public class NetworkInterceptor: NSObject {
    
    @objc public static let shared = NetworkInterceptor()
    let networkRequestInterceptor = NetworkRequestInterceptor()
    var config: NetworkInterceptorConfig?
    
    public func setup(config: NetworkInterceptorConfig){
        self.config = config
    }
    
    @objc public func startRecording(){
        self.networkRequestInterceptor.startRecording()
    }
    
    @objc public func stopRecording(){
        self.networkRequestInterceptor.stopRecording()
    }
    
    func interceptRequest(urlRequest: URLRequest){
        guard let config = self.config else {
            return
        }
        for interceptor in config.interceptors {
            if interceptor.requestInterceptor.canInterceptRequest(urlRequest: urlRequest) {
                for handler in interceptor.handlers {
                    handler.handleRequest(urlRequest: urlRequest)
                }
            }
        }
    }
    
}

extension NetworkInterceptor: RequestRefirer {
    func refireUrlRequest(urlRequest: URLRequest) {
        var request = urlRequest
        request.addValue("true", forHTTPHeaderField: "Refired")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            do {
                _ = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
            } catch _ as NSError {
            }
            if error != nil{
                return
            }
        }
        task.resume()
        
    }
}
