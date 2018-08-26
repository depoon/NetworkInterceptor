//
//  NetworkRequestSniffableUrlProtocol.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 26/8/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

class NetworkRequestSniffableUrlProtocol: URLProtocol {
    
    open override class func canInit(with request: URLRequest) -> Bool {
        if NetworkInterceptor.shared.isRequestRedirectable(urlRequest: request) {
            return false
        }
        if let httpHeaders = request.allHTTPHeaderFields, httpHeaders.isEmpty {
            return false
        }
        if let httpHeaders = request.allHTTPHeaderFields, let refiredValue = httpHeaders["Refired"], refiredValue == "true" {
            return false
        }
        if let _ = URLProtocol.property(forKey: "NetworkRequestSniffableUrlProtocol", in: request) {
            return false
        }
        NetworkInterceptor.shared.sniffRequest(urlRequest: request)
        return false
    }
    
    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        let mutableRequest: NSMutableURLRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty("YES", forKey: "NetworkRequestSniffableUrlProtocol", in: mutableRequest)
        return mutableRequest.copy() as! URLRequest
    }
}
