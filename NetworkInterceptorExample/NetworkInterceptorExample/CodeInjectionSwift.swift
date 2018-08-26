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
        let requestSniffers: [RequestSniffer] = [
            RequestSniffer(requestEvaluator: AnyHttpRequestEvaluator(), handlers: [
                SniffableRequestHandlerRegistrable.console(logginMode: .nslog).requestHandler()
                ])
        ]

        let requestRedirectors: [RequestRedirector] = [
            RequestRedirector(requestEvaluator: DomainHttpRequestEvaluator(domain: "www.antennahouse.com"), redirectableRequestHandler: AlternateUrlRequestRedirector(url: URL(string: "https://www.rhodeshouse.ox.ac.uk/media/1002/sample-pdf-file.pdf")!))
        ]
        
        let networkConfig = NetworkInterceptorConfig(requestSniffers: requestSniffers,
                                                     requestRedirectors: requestRedirectors)
        NetworkInterceptor.shared.setup(config: networkConfig)
        NetworkInterceptor.shared.startRecording()
    }
}
