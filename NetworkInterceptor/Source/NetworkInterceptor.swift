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
    func startRecording()
    func stopRecording()
}

public protocol RequestLogger: class {
    func excludedDomain() -> [String]
    func logRequest(urlRequest: URLRequest)
}



@objc public class NetworkInterceptor: NSObject {
    
    @objc public static let shared = NetworkInterceptor()
    
    let loggers: [RequestLogger]
    let interceptors: [RequestInterceptor]
    
    
    private override init(){        
        interceptors = [ CustomUrlProtocolRequestInterceptor() ]
        loggers = [ SlackRequestLogger() ]
    }
    
}

extension NetworkInterceptor: RequestInterceptor {
    @objc public func startRecording(){
        for interceptor in interceptors {
            NSLog("** Interceptor: \(interceptor.self) startRecording")
            interceptor.startRecording()
        }
    }
    
    @objc public func stopRecording(){
        for interceptor in interceptors {
            interceptor.stopRecording()
        }
    }
}


extension NetworkInterceptor: RequestRefirer {
    func refireUrlRequest(urlRequest: URLRequest) {
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
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

extension NetworkInterceptor {
    
    func shouldIgnoreLogging(url: URL) -> Bool {
        var excludedDomains = [String]()
        for logger in self.loggers {
            excludedDomains.append(contentsOf: logger.excludedDomain())
        }
        
        if let host = url.host {
            for excludedDomain in excludedDomains {
                if host.range(of: excludedDomain) != nil {
                    return true
                }
            }
        }
        return false
        
    }
    
    func logRequest(urlRequest: URLRequest){
        for logger in self.loggers {
            logger.logRequest(urlRequest: urlRequest)
        }
    }
}
