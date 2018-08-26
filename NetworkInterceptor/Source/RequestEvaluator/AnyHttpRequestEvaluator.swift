//
//  AnyHttpRequestEvaluator.swift
//  NetworkInterceptor
//
//  Created by Kenneth Poon on 20/8/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import Foundation

public class AnyHttpRequestEvaluator: RequestEvaluator {
    
    public init(){}
    
    public func isActionAllowed(urlRequest: URLRequest) -> Bool {
        guard let scheme = urlRequest.url?.scheme else {
            return false
        }
        if ["https", "http"].contains(scheme) {
            return true
        }
        return false
    }
}
