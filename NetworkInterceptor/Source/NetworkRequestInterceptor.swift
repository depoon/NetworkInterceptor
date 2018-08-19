//
//  NetworkRequestInterceptor.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 26/5/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation


@objc public class NetworkRequestInterceptor: NSObject{

    func swizzleProtocolClasses(){
        let instance = URLSessionConfiguration.default
        let uRLSessionConfigurationClass: AnyClass = object_getClass(instance)!

        let method1: Method = class_getInstanceMethod(uRLSessionConfigurationClass, #selector(getter: uRLSessionConfigurationClass.protocolClasses))!
        let method2: Method = class_getInstanceMethod(URLSessionConfiguration.self, #selector(URLSessionConfiguration.fakeProcotolClasses))!

        method_exchangeImplementations(method1, method2)
    }
    
    public func startRecording() {
        URLProtocol.registerClass(NetworkRequestUrlProtocol.self)
        swizzleProtocolClasses()
    }
    
    public func stopRecording() {
        URLProtocol.unregisterClass(NetworkRequestUrlProtocol.self)
        swizzleProtocolClasses()
    }
}

extension URLSessionConfiguration {
    
    @objc func fakeProcotolClasses() -> [AnyClass]? {
        guard let fakeProcotolClasses = self.fakeProcotolClasses() else {
            return []
        }
        var originalProtocolClasses = fakeProcotolClasses.filter {
            return $0 != NetworkRequestUrlProtocol.self
        }
        originalProtocolClasses.insert(NetworkRequestUrlProtocol.self, at: 0)
        return originalProtocolClasses
    }
    
}

class NetworkRequestUrlProtocol: URLProtocol {
    
    var connection: NSURLConnection?
    var response: URLResponse?
    var data: NSMutableData?
    
    open override class func canInit(with request: URLRequest) -> Bool {
        if let httpHeaders = request.allHTTPHeaderFields, httpHeaders.isEmpty {
            return false
        }
        if let httpHeaders = request.allHTTPHeaderFields, let refiredValue = httpHeaders["Refired"], refiredValue == "true" {
            return false
        }
        if let _ = URLProtocol.property(forKey: "NetworkRequestUrlProtocol", in: request) {
            return false
        }
        NetworkInterceptor.shared.interceptRequest(urlRequest: request)
        return false
    }

    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        let mutableRequest: NSMutableURLRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty("YES", forKey: "NetworkRequestUrlProtocol", in: mutableRequest)
        return mutableRequest.copy() as! URLRequest
    }
}
