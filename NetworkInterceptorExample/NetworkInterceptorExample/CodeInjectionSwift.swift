//
//  CodeInjectionSwift.swift
//  NetworkInterceptorExample
//
//  Created by Kenneth Poon on 23/7/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation
import NetworkInterceptor

@objc class CodeInjectionSwift: NSObject {
    @objc public static let shared = CodeInjectionSwift()
    
    override private init(){}
    
    @objc func performTask(){
        let networkConfig = NetworkInterceptorConfig(interceptors: [
            Interceptor(requestInterceptor: AnyHttpRequestInterceptor(), handlers: [InterceptedRequestHandlerRegistrable.console(logginMode: .nslog).requestHandler()])
        ])
        NetworkInterceptor.shared.setup(config: networkConfig)
        NetworkInterceptor.shared.startRecording()
    }
}
