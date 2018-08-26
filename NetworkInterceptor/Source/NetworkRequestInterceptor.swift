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
        URLProtocol.registerClass(NetworkRedirectUrlProtocol.self)
        URLProtocol.registerClass(NetworkRequestSniffableUrlProtocol.self)
        swizzleProtocolClasses()
    }
    
    public func stopRecording() {
        URLProtocol.unregisterClass(NetworkRedirectUrlProtocol.self)
        URLProtocol.unregisterClass(NetworkRequestSniffableUrlProtocol.self)
        swizzleProtocolClasses()
    }
}

extension URLSessionConfiguration {
    
    @objc func fakeProcotolClasses() -> [AnyClass]? {
//        return [NetworkRedirectUrlProtocol.self]
        guard let fakeProcotolClasses = self.fakeProcotolClasses() else {
            return []
        }
        var originalProtocolClasses = fakeProcotolClasses.filter {
            return $0 != NetworkRequestSniffableUrlProtocol.self && $0 != NetworkRedirectUrlProtocol.self
        }
        originalProtocolClasses.insert(NetworkRequestSniffableUrlProtocol.self, at: 0)
        originalProtocolClasses.insert(NetworkRedirectUrlProtocol.self, at: 0)
        return originalProtocolClasses
    }
    
}


