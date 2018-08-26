//
//  NetworkInterceptorConfig.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 10/7/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

public struct NetworkInterceptorConfig {
    let requestSniffers: [RequestSniffer]
    let requestRedirectors: [RequestRedirector]
    
    public init(requestSniffers: [RequestSniffer] = [],
                requestRedirectors: [RequestRedirector] = []){
        self.requestSniffers = requestSniffers
        self.requestRedirectors = requestRedirectors
    }
}
